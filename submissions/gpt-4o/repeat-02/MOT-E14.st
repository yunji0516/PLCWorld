PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    timer : TON;
    stopTimer : TON;
    swayLimitExceeded : BOOL := FALSE;
    targetReached : BOOL := FALSE;
    requestAccepted : BOOL := FALSE;
    maintainResult : BOOL := FALSE;
    observeResult : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
IF NOT requestAccepted AND X10 THEN
    (* Accept function request *)
    requestAccepted := TRUE;
END_IF

(* Check sway limit *)
IF ABS(D15 * 0.01) > 25.0 THEN
    swayLimitExceeded := TRUE;
END_IF

(* Main control logic *)
IF requestAccepted AND NOT swayLimitExceeded THEN
    (* Reduce sway and control trolley position *)
    IF ABS(D15 * 0.01) <= 0.2 AND ABS(D16 * 0.01) <= 1.0 AND ABS(D13 * 0.01) <= 1.0 AND ABS(D14 * 0.01) <= 1.0 THEN
        targetReached := TRUE;
    ELSE
        D20 := 0;
    END_IF
ELSE
    D20 := 0; (* Keep command within bounds if sway exceeds limits *)
END_IF

(* Timer logic to check completion and result retention *)
timer(IN := targetReached, PT := T#30ms);
stopTimer(IN := maintainResult, PT := T#100ms);

(* Completion condition and result retention *)
IF timer.Q THEN
    maintainResult := TRUE;
END_IF

IF maintainResult THEN
    Y2 := TRUE;
    IF stopTimer.Q THEN
        observeResult := TRUE;
    END_IF
ELSE
    Y2 := FALSE;
END_IF

(* Ensure D20 remains within bounds *)
IF D20 < -200000 THEN
    D20 := -200000;
ELSIF D20 > 200000 THEN
    D20 := 200000;
END_IF

END_PROGRAM