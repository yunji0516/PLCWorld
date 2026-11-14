PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    start_triggered : BOOL := FALSE;
    grip_timer : TON;
END_VAR

(* Implement the control logic here. *)

(* Detect rising edge of the start request *)
IF NOT start_triggered THEN
    IF X10 THEN
        start_triggered := TRUE;
    END_IF
END_IF

(* If start was triggered and product is detected (D10=1), close the gripper *)
IF start_triggered AND (D10 = 1) THEN
    Y20 := TRUE;
    
    (* Use a timer to simulate the closing time (0.10-0.20s) *)
    grip_timer(IN := Y20, PT := T#200ms);  // max time
END_IF

(* Check the status of physical holding *)
IF grip_timer.Q AND X20 THEN
    Y2 := TRUE;  // Completion claim
END_IF

END_PROGRAM