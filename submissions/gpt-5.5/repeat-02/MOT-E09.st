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
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    active : BOOL;
    resultLatch : BOOL;
    desiredC : DINT;
    desiredV : DINT;
    orientationErr : DINT;
    orientationVel : DINT;
    rawCmd : DINT;
    rawAux : DINT;
    stableOk : BOOL;
    stableTimer : TON;
    cmdMax : DINT := 200000;
    cmdMin : DINT := -200000;
END_VAR

IF X10 THEN
    active := TRUE;
END_IF;

orientationErr := D13 + D15 + D11 - D10;
orientationVel := D14 + D16 + D12;

IF active THEN
    Y20 := TRUE;

    desiredC := D10 - D13 - D15;
    desiredV := 0 - D14 - D16;

    rawCmd := desiredC - orientationErr;
    rawAux := desiredV - orientationVel;

    IF rawCmd > cmdMax THEN
        D20 := cmdMax;
    ELSIF rawCmd < cmdMin THEN
        D20 := cmdMin;
    ELSE
        D20 := rawCmd;
    END_IF;

    IF rawAux > cmdMax THEN
        D21 := cmdMax;
    ELSIF rawAux < cmdMin THEN
        D21 := cmdMin;
    ELSE
        D21 := rawAux;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    resultLatch := FALSE;
END_IF;

stableOk := active AND Y20 AND (ABS(orientationErr) <= 180);
stableTimer(IN := stableOk, PT := T#30ms);

IF stableTimer.Q THEN
    resultLatch := TRUE;
END_IF;

Y2 := resultLatch;

END_PROGRAM