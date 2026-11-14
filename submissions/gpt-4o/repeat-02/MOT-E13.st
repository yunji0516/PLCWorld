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
    D21 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    targetX : REAL;
    currentX : REAL;
    currentZ : REAL;
    currentC : REAL;
    currentXSpeed : REAL;
    currentCSpeed : REAL;
    leftCommand : REAL;
    rightCommand : REAL;
    toleranceMet : BOOL;
    completionTimer : TON;
    retentionTimer : TON;
    timerActive : BOOL := FALSE;
END_VAR

(* Initialize the timer instances *)
completionTimer(IN := FALSE, PT := T#30ms);
retentionTimer(IN := FALSE, PT := T#100ms);

(* Implement the control logic here. *)
targetX := REAL(D10) / 100.0;
currentX := REAL(D11) / 100.0;
currentZ := REAL(D13) / 100.0;
currentC := REAL(D15) / 100.0;
currentXSpeed := REAL(D12) / 100.0;
currentCSpeed := REAL(D16) / 100.0;

(* Calculate wheel speeds to follow the path *)
leftCommand := 0.0;
rightCommand := 0.0;

IF X10 THEN
    IF (ABS(targetX - currentX) > 1.0) OR (ABS(currentZ) > 2.0) OR (ABS(currentC) > 0.3) THEN
        (* Calculate appropriate wheel commands *)
        leftCommand := 1500.0; (* This should be calculated based on the path following algorithm *)
        rightCommand := 1500.0; (* This should be calculated based on the path following algorithm *)
    ELSE
        toleranceMet := TRUE;
        IF NOT timerActive THEN
            completionTimer(IN := TRUE);
            timerActive := TRUE;
        END_IF
    END_IF

    IF completionTimer.Q THEN
        Y2 := TRUE;
        retentionTimer(IN := Y2);
    END_IF

    IF retentionTimer.Q THEN
        (* Task is complete, maintain Y2 for the retention period *)
        Y2 := TRUE;
    END_IF

    (* Limit the commands to valid ranges *)
    leftCommand := LIMIT(-2000.0, leftCommand, 2000.0);
    rightCommand := LIMIT(-2000.0, rightCommand, 2000.0);

    (* Convert to output command format *)
    D20 := DINT(leftCommand * 100);
    D21 := DINT(rightCommand * 100);
ELSE
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    completionTimer(IN := FALSE);
    retentionTimer(IN := FALSE);
    timerActive := FALSE;
END_IF

END_PROGRAM