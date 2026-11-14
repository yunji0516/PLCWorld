PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    D20 : INT;
    
    start_edge : R_TRIG;
    started : BOOL := FALSE;
    transferring : BOOL := FALSE;
    returning : BOOL := FALSE;
    complete : BOOL := FALSE;
    timer : TON;
END_VAR

(* Implement the control logic here. *)

start_edge(CLK := X10);

IF start_edge.Q AND D10 = 1 AND NOT started THEN
    started := TRUE;
    transferring := TRUE;
END_IF

IF transferring THEN
    Y20 := TRUE;  (* Push forward *)
    Y21 := FALSE; (* Ensure retract is not active *)

    IF X21 OR D20 >= 700 THEN (* Front of plate received or approximated by position *)
        transferring := FALSE;
        Y20 := FALSE;
        IF X22 OR D20 >= 1500 THEN (* Whole plate received or approximated by position *)
            complete := TRUE;
        ELSE
            returning := TRUE;
        END_IF
    END_IF
END_IF

IF returning THEN
    Y20 := FALSE; (* Ensure push is not active *)
    Y21 := TRUE;  (* Retract pusher *)

    IF X20 THEN (* Pusher is home *)
        returning := FALSE;
        Y21 := FALSE;
        
        IF complete THEN
            Y2 := TRUE; (* Completion claim *)
        END_IF
    END_IF
END_IF

IF complete THEN
    timer(IN := TRUE, PT := T#500ms);
    
    IF timer.Q THEN
        (* Hold outputs off after completion signal is ensured *)
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF
END_IF

END_PROGRAM