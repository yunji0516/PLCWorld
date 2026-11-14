PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    accepted : BOOL;
    directionCaptured : BOOL;
    positiveDirection : BOOL;
    speedOK : BOOL;
    limitOK : BOOL;
    resultOK : BOOL;
    stableTimer : TON;
END_VAR

IF X10 AND NOT accepted THEN
    accepted := TRUE;
END_IF;

IF accepted AND NOT directionCaptured THEN
    positiveDirection := (D12 >= 0);
    directionCaptured := TRUE;
END_IF;

IF accepted THEN
    Y20 := TRUE;
    D20 := 400000;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

speedOK := (ABS(D12) <= 100);

IF NOT directionCaptured THEN
    limitOK := FALSE;
ELSIF positiveDirection THEN
    limitOK := (D11 <= D13);
ELSE
    limitOK := (D11 >= D13);
END_IF;

resultOK := accepted AND speedOK AND limitOK;

stableTimer(IN := resultOK, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM