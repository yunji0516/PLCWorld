PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    requestAccepted : BOOL;
    obstacleRemembered : BOOL;
    commandRaw : DINT;
    minCommandRaw : DINT := -200000;
    maxCommandRaw : DINT := 200000;
    positionToleranceRaw : DINT := 100;
    speedToleranceRaw : DINT := 500;
    resultCondition : BOOL;
    resultTimer : TON;
END_VAR

IF X10 THEN
    requestAccepted := TRUE;
END_IF;

IF D10 > maxCommandRaw THEN
    commandRaw := maxCommandRaw;
ELSIF D10 < minCommandRaw THEN
    commandRaw := minCommandRaw;
ELSE
    commandRaw := D10;
END_IF;

IF requestAccepted AND X11 THEN
    obstacleRemembered := TRUE;
END_IF;

IF obstacleRemembered THEN
    Y20 := TRUE;
    D20 := commandRaw;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

resultCondition := FALSE;
IF obstacleRemembered THEN
    IF (ABS(D11 - commandRaw) <= positionToleranceRaw) AND (ABS(D12) <= speedToleranceRaw) THEN
        resultCondition := TRUE;
    END_IF;
END_IF;

resultTimer(IN := resultCondition AND NOT Y2, PT := T#30ms);

IF Y2 OR resultTimer.Q THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM