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
    cmdReal : REAL;
    integReal : REAL;
    stableCondition : BOOL;
    stableTimer : TON;
    kp : REAL := 3.0;
    kv : REAL := 0.30;
    ki : REAL := 0.08;
    respEstimate : REAL := 0.90;
END_VAR

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    IF D10 < -4500 THEN
        targetRaw := -4500;
    ELSIF D10 > 9000 THEN
        targetRaw := 9000;
    ELSE
        targetRaw := D10;
    END_IF;
    integReal := 0.0;
END_IF;

IF accepted THEN
    Y20 := TRUE;

    errRaw := targetRaw - D11;
    absErrRaw := ABS(errRaw);
    absSpeedRaw := ABS(D12);

    IF (absErrRaw < 8000) AND (absSpeedRaw < 12000) THEN
        integReal := integReal + (ki * REAL(errRaw));
        IF integReal > 40000.0 THEN
            integReal := 40000.0;
        ELSIF integReal < -40000.0 THEN
            integReal := -40000.0;
        END_IF;
    END_IF;

    cmdReal := (REAL(targetRaw) / respEstimate) + (kp * REAL(errRaw)) - (kv * REAL(D12)) + integReal;

    IF cmdReal > 200000.0 THEN
        cmdReal := 200000.0;
    ELSIF cmdReal < -200000.0 THEN
        cmdReal := -200000.0;
    END_IF;

    D20 := DINT(cmdReal);

    IF D20 > 200000 THEN
        D20 := 200000;
    ELSIF D20 < -200000 THEN
        D20 := -200000;
    END_IF;

    stableCondition := (absErrRaw <= 10) AND (absSpeedRaw <= 50);
    stableTimer(IN := stableCondition, PT := T#30ms);

    IF stableTimer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    stableCondition := FALSE;
    stableTimer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM