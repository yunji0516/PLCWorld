PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    X20 : BOOL;
    start_edge : R_TRIG;
    operation_started : BOOL := FALSE;
    holding_confirmed : BOOL := FALSE;
    hold_timer : TON;
    completion_timer : TON;
END_VAR

(* Detect the rising edge for the start request. *)
start_edge(CLK := X10);

(* Start operation on a rising edge and if we have one product. *)
IF start_edge.Q AND D10 = 1 THEN
    operation_started := TRUE;
    Y20 := TRUE; // Initiate gripper to close.
END_IF

(* Confirm holding once physical observation indicates it. *)
IF X20 THEN
    holding_confirmed := TRUE;
END_IF

(* Manage the completion conditions. *)
IF operation_started AND holding_confirmed THEN
    Y2 := TRUE; // Completion claim.
    
    (* Start the completion hold timer. *)
    hold_timer(IN := TRUE, PT := T#500ms);
    
    (* Check if the hold timer expired and maintain grip. *)
    IF hold_timer.Q THEN
        (* Maintain the completion state and result. *)
        Y20 := TRUE;
        hold_timer(IN := FALSE); // Stop the timer after holding period.
    END_IF
END_IF

(* Complete by scan 1550, accounting for the 10ms scan period. *)
completion_timer(IN := operation_started, PT := T#15500ms); // 1550 scans

(* If completion conditions are met and time for completion has passed, shut down the operation. *)
IF completion_timer.Q THEN
    Y20 := FALSE; // Open the gripper as the operation lifecycle ends.
    Y2 := FALSE;  // Reset completion claim to prepare for the next cycle.
    operation_started := FALSE;
    holding_confirmed := FALSE;
END_IF

END_PROGRAM