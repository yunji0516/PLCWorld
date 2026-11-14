PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    start_edge : R_TRIG;
    operation_started : BOOL := FALSE;
    release_request : INT := 0;
    evaluation_timer : TON;
    holding_timer : TON;
    evaluation_complete : BOOL := FALSE;
END_VAR

(* Detect rising edge of Start request *)
start_edge(CLK := X10);

(* Main control logic *)
IF start_edge.Q AND NOT operation_started THEN
    (* Capture the release request and start the operation *)
    release_request := D10;
    operation_started := TRUE;

    (* Control the actuators based on the selection bit mask *)
    Y20 := (release_request AND 1) <> 0;
    Y21 := (release_request AND 2) <> 0;
    Y22 := (release_request AND 4) <> 0;

    (* Start the evaluation timer *)
    evaluation_timer(IN := TRUE, PT := T#15s); (* 1500 scans *)
END_IF

(* Completion condition check *)
IF operation_started AND NOT evaluation_complete THEN
    IF evaluation_timer.Q THEN
        (* Check holding state matches expectations *)
        IF ((D10 AND 1) = 0 OR NOT X20) AND
           ((D10 AND 2) = 0 OR NOT X21) AND
           ((D10 AND 4) = 0 OR NOT X22) THEN
               
            (* Check unselected grippers if properly holding products *)
            IF ((D10 AND 1) = 0 AND X20) AND
               ((D10 AND 2) = 0 AND X21) AND
               ((D10 AND 4) = 0 AND X22) THEN
                   
                (* Set completion output *)
                Y2 := TRUE;
                evaluation_complete := TRUE;
                
                (* Start the holding timer for 50 scans *)
                holding_timer(IN := TRUE, PT := T#500ms);
            END_IF
        END_IF
    END_IF
END_IF

(* Maintain result claim for at least 50 scans after successful evaluation *)
IF evaluation_complete THEN
    IF holding_timer.Q THEN
        (* End holding after 50 scans *)
        Y2 := FALSE;
    END_IF
ELSE
    (* Reset timers if evaluation is not complete *)
    evaluation_timer(IN := FALSE);
    holding_timer(IN := FALSE);
END_IF

(* Turn off release actuators if not in use *)
IF NOT operation_started THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF

END_PROGRAM