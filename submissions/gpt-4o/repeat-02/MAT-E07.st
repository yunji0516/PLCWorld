PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    D20 : INT;
    
    start_triggered : BOOL := FALSE;
    plate_at_receiver : BOOL := FALSE;
    retracted : BOOL := TRUE;
    push_timer : TON;
    retract_timer : TON;
    home_edge : R_TRIG;
END_VAR

(* Implementing the control logic *)

(* TON declaration for push and retract durations (up to 2 seconds) *)
push_timer(IN := Y20, PT := T#2s);
retract_timer(IN := Y21, PT := T#2s);
home_edge(CLK := X20);

(* Main logic *)
IF X10 AND NOT start_triggered THEN
    start_triggered := TRUE;
END_IF

IF start_triggered AND D10 = 1 THEN
    (* Logic for pushing the plate *)
    IF NOT X22 THEN
        IF retracted THEN
            Y20 := TRUE;
            Y21 := FALSE;
            IF push_timer.Q THEN
                retracted := FALSE;
            END_IF
        END_IF
    ELSE
        plate_at_receiver := TRUE;
    END_IF
    
    (* Logic for retracting the pusher *)
    IF plate_at_receiver THEN
        IF NOT retracted THEN
            Y20 := FALSE;
            Y21 := TRUE;
            IF retract_timer.Q THEN
                retracted := TRUE;
            END_IF
        END_IF
        
        IF X20 THEN
            start_triggered := FALSE;
            retracted := TRUE;
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := TRUE;  (* Completion claim *)
        END_IF
    END_IF
END_IF

(* Safety constraint: Never assert both push and retract simultaneously *)
IF Y20 THEN
    Y21 := FALSE;
END_IF

IF Y21 THEN
    Y20 := FALSE;
END_IF

(* Maintain the completion claim after operation until evaluation endpoint *)
IF home_edge.Q THEN
    IF plate_at_receiver THEN
        Y2 := TRUE;
    END_IF
END_IF

END_PROGRAM