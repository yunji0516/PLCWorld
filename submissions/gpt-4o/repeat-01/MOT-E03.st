PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Internal variables *)
    targetSpeed : REAL;
    deceleration : DINT;
    withinLimit : BOOL := FALSE;
    holdingTimer : TON;
    resultTimer : TON;
    edge : R_TRIG;
END_VAR

(* Initialize deceleration to the maximum permitted command *)
deceleration := 400000;

(* Process control logic *)
IF X10 THEN
    (* Calculate the target speed with deceleration application *)
    targetSpeed := REAL(D12) * 0.01 - REAL(deceleration) * 0.0001 * 0.01; // Convert deceleration to mm/s² and apply 2ms step

    (* Calculate new position with deceleration *)
    D20 := deceleration;

    (* Ensure deceleration logic holds the value within limit before stopping *)
    IF (D12 <= 100) THEN // 100 corresponds to speed 1 mm/s, considering *0.01 factor
        IF (ABS(REAL(D11) * 0.01 - REAL(D13) * 0.01) <= 1.0) THEN // Ensure position at or below stop limit
            withinLimit := TRUE;
            Y20 := FALSE; // Stop deceleration command execution
        ELSE
            withinLimit := FALSE;
        END_IF
    ELSE
        withinLimit := FALSE;
    END_IF

    Y20 := TRUE;

    (* Code to check if we have reached the completion condition *)
    IF withinLimit THEN
        (* Start holding once within limit and speed is reduced to 1 mm/s or less *)
        holdingTimer(IN := TRUE, PT := T#30ms);

        IF holdingTimer.Q THEN
            Y2 := TRUE;
            resultTimer(IN := TRUE, PT := T#100ms);
        ELSE
            Y2 := FALSE;
            resultTimer(IN := FALSE);
        END_IF
    ELSE
        holdingTimer(IN := FALSE);
        resultTimer(IN := FALSE);
        Y2 := FALSE;
    END_IF
ELSE
    (* Reset outputs if function request is not active *)
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    holdingTimer(IN := FALSE);
    resultTimer(IN := FALSE);
END_IF

END_PROGRAM