PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL := FALSE;
    D20 : DINT := 0;
    Y2 : BOOL := FALSE;
    detection_triggered : BOOL := FALSE;
    valid_reopen_timer : TON;
    result_hold_timer : TON;
END_VAR

(* Implement the control logic here. *)
IF X10 THEN
    (* Check if the approaching object is detected. *)
    IF X11 THEN
        detection_triggered := TRUE;
    END_IF;

    (* If detection is triggered, command to open and set Y20. *)
    IF detection_triggered THEN
        Y20 := TRUE;
        D20 := D10; (* Command the open position *)
        
        (* Check if the position and speed are within the valid range for reopening *)
        IF ABS(D11 - D10) <= DINT(20) AND ABS(D12) <= DINT(100) THEN
            valid_reopen_timer(IN := TRUE, PT := T#30ms);
        ELSE
            valid_reopen_timer(IN := FALSE);
        END_IF;

        (* If valid reopen condition is met for 30 ms, set Y2 *)
        IF valid_reopen_timer.Q THEN
            Y2 := TRUE;
            result_hold_timer(IN := TRUE, PT := T#100ms);
        ELSE
            result_hold_timer(IN := FALSE);
        END_IF;

        (* Maintain Y2 TRUE for the observation period after meeting the condition *)
        IF result_hold_timer.Q THEN
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM