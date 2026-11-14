PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    accepted : BOOL;
    done : BOOL;
    targetRaw : DINT;
    errorRaw : DINT;
    absErrorRaw : DINT;
    absSpeedRaw : DINT;
    stableCond : BOOL;
    stableTimer : TON;
END_VAR

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    IF D10 < -35000 THEN
        targetRaw := -35000;
    ELSIF D10 > 45000 THEN
        targetRaw := 45000;
    ELSE
        targetRaw := D10;
    END_IF;
END_IF;

IF accepted THEN
    Y20 := TRUE;
    D20 := targetRaw;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

IF D20 < -200000 THEN
    D20 := -200000;
ELSIF D20 > 200000 THEN
    D20 := 200000;
END_IF;

errorRaw := targetRaw - D11;
absErrorRaw := ABS(errorRaw);
absSpeedRaw := ABS(D12);

stableCond := accepted AND (absErrorRaw <= 19) AND (absSpeedRaw <= 99);
stableTimer(IN := stableCond, PT := T#30ms);

IF stableTimer.Q THEN
    done := TRUE;
END_IF;

Y2 := done;

END_PROGRAM