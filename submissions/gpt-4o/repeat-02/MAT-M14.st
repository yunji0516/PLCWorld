PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    start_triggered : BOOL := FALSE;
    supply_extended : BOOL := FALSE;
    launch_ready : BOOL := FALSE;
    launch_triggered : BOOL := FALSE;
    receive_confirmed : BOOL := FALSE;
    timer : TON;
    edge_start : R_TRIG;
    edge_received : R_TRIG;
END_VAR

(* Edge detection for X10 (Start Trigger) *)
edge_start(CLK := X10, Q => start_triggered);

(* Edge detection for X22 (Received Confirmation) *)
edge_received(CLK := X22, Q => receive_confirmed);

(* Control Logic *)
IF start_triggered THEN
    (* Supply product to the launch nest *)
    IF NOT supply_extended AND X20 THEN
        Y22 := TRUE;
        IF X24 THEN
            supply_extended := TRUE;
            Y22 := FALSE;
        END_IF
    END_IF
    
    (* Prepare for launch if the product is loaded and supply finger is home *)
    IF supply_extended AND X23 AND X24 THEN
        launch_ready := TRUE;
        supply_extended := FALSE;
    END_IF
    
    (* Launch the product at the correct time *)
    IF launch_ready AND NOT launch_triggered THEN
        (* Calculate the ideal firing time *)
        VAR
            time_to_contact : REAL;
        END_VAR

        time_to_contact := REAL(D20) / REAL(D21);

        (* Timer setup to match firing window *)
        timer(IN := TRUE, PT := TIME#1s);
        
        IF (timer.ET >= INT_TO_TIME(REAL_TO_INT(time_to_contact * 1000)) AND (D20 <= 30)) THEN
            Y20 := TRUE;
            launch_triggered := TRUE;
        END_IF
    ELSE
        timer(IN := FALSE);
    END_IF

    (* Complete the launch operation *)
    IF launch_triggered AND X21 THEN
        Y20 := FALSE;
    END_IF

    (* Retract after firing for exactly 1 second *)
    IF X21 AND NOT receive_confirmed THEN
        Y21 := TRUE;
    ELSIF receive_confirmed THEN
        Y21 := FALSE;
        Y2 := TRUE;
    END_IF
END_IF

(* Safety Conditions *)
IF Y20 AND Y21 THEN
    Y20 := FALSE; (* Safe-guard: Never fire and retract simultaneously *)
END_IF

(* Completion hold *)
IF receive_confirmed AND X20 AND X24 THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF

END_PROGRAM