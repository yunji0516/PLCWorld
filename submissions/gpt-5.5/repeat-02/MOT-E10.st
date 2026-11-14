PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    accepted : BOOL;
    targetRaw : DINT;
    errRaw : DINT;
    absErrRaw : DINT;
    absSpeedRaw : DINT;
    cmdRaw : DINT;
    targetDeg : REAL;
    errDeg : REAL;
    spdDeg : REAL;
    cmdDeg : REAL;
    minCmdDeg : REAL;
    maxCmdDeg : REAL;
    iBias : REAL;
    stable : BOOL;
    stableTimer : TON;
END_VAR

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    targetRaw := D10;
    IF targetRaw < -4500 THEN
        targetRaw := -4500;
    ELSIF targetRaw > 9000 THEN
        targetRaw := 9000;
    END_IF;
    iBias := 0.0;
END_IF;

stable := FALSE;

IF accepted THEN
    Y20 := TRUE;

    errRaw := targetRaw - D11;
    absErrRaw := ABS(errRaw);
    absSpeedRaw := ABS(D12);

    targetDeg := REAL(targetRaw) * 0.01;
    errDeg := REAL(errRaw) * 0.01;
    spdDeg := REAL(D12) * 0.01;

    IF (NOT Y2) AND (ABS(errDeg) < 30.0) AND (ABS(spdDeg) < 60.0) THEN
        iBias := iBias + (0.08 * errDeg);
        IF iBias > 80.0 THEN
            iBias := 80.0;
        ELSIF iBias < -80.0 THEN
            iBias := -80.0;
        END_IF;
    END_IF;

    cmdDeg := targetDeg + (3.0 * errDeg) - (0.4 * spdDeg) + iBias;

    minCmdDeg := targetDeg - 400.0;
    maxCmdDeg := targetDeg + 400.0;

    IF cmdDeg < minCmdDeg THEN
        cmdDeg := minCmdDeg;
    ELSIF cmdDeg > maxCmdDeg THEN
        cmdDeg := maxCmdDeg;
    END_IF;

    cmdRaw := DINT(cmdDeg * 100.0);

    IF cmdRaw < -200000 THEN
        D20 := -200000;
    ELSIF cmdRaw > 200000 THEN
        D20 := 200000;
    ELSE
        D20 := cmdRaw;
    END_IF;

    IF (absErrRaw <= 15) AND (absSpeedRaw <= 75) THEN
        stable := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
END_IF;

stableTimer(IN := stable, PT := T#30ms);

IF accepted AND stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM