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
    targetRaw : DINT;
    commandRaw : DINT;
    speedErrorRaw : DINT;
    stableCondition : BOOL;
    stableTimer : TON;
END_VAR

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    targetRaw := D10;
END_IF;

IF accepted THEN
    commandRaw := targetRaw;
    IF commandRaw > 200000 THEN
        commandRaw := 200000;
    ELSIF commandRaw < -200000 THEN
        commandRaw := -200000;
    END_IF;

    Y20 := TRUE;
    D20 := commandRaw;

    speedErrorRaw := ABS(D12 - targetRaw);
    stableCondition := (speedErrorRaw <= 199);
ELSE
    Y20 := FALSE;
    D20 := 0;
    speedErrorRaw := 0;
    stableCondition := FALSE;
END_IF;

stableTimer(IN := stableCondition, PT := T#30ms);

IF accepted AND (Y2 OR stableTimer.Q) THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM