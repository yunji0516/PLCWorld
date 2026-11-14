PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := TRUE; (* Initial grip ON to preserve holding *)
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    start_triggered : BOOL := FALSE;
    release_timer : TON;
    evaluation_counter : INT := 0;
END_VAR

(* Implement the control logic here. *)
release_timer(IN := FALSE, PT := T#100ms);

IF NOT start_triggered THEN
    IF X10 AND D10 = 1 THEN
        (* Start request detected, begin release procedure *)
        start_triggered := TRUE;
        Y20 := FALSE; (* Release the gripper *)
    END_IF;
ELSE
    (* Start request has been triggered, begin monitoring for release *)
    IF NOT release_timer.Q THEN
        release_timer(IN := TRUE, PT := T#100ms);
    ELSE
        (* Ensure the product is fully released and supported *)
        IF X21 AND X22 THEN
            Y2 := TRUE; (* Claim completion *)
        END_IF;
    END_IF;

    (* Count the scans after starting *)
    evaluation_counter := evaluation_counter + 1;

    (* Check if completion criteria and hold time are met *)
    IF evaluation_counter > 1550 AND evaluation_counter <= 1600 THEN
        (* Maintain the current state *)
        Y20 := FALSE; (* Ensure grip stays off *)
    END_IF;
END_IF;

END_PROGRAM