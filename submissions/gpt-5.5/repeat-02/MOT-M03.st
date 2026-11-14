PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    requested : BOOL;
    extendLatch : BOOL;
    completeLatch : BOOL;
    alignFine : BOOL;
    resultOk : BOOL;
    posErr : DINT;
    velErr : DINT;
    corrPos : DINT;
    targetPos : DINT;
    speedCmd : DINT;
    alignTimer : TON;
END_VAR

IF X10 THEN
    requested := TRUE;
END_IF;

posErr := D13 - D11;
velErr := D14 - D12;

IF requested THEN
    IF (ABS(posErr) <= 8) AND (ABS(velErr) <= 40) AND X12 AND (NOT extendLatch) THEN
        alignFine := TRUE;
    ELSE
        alignFine := FALSE;
    END_IF;
ELSE
    alignFine := FALSE;
END_IF;

alignTimer(IN := alignFine, PT := T#100ms);

IF NOT requested THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    D20 := D11;
    D21 := 0;
    extendLatch := FALSE;
    completeLatch := FALSE;
ELSE
    Y20 := TRUE;

    IF alignTimer.Q THEN
        extendLatch := TRUE;
    END_IF;

    IF extendLatch THEN
        corrPos := posErr;
    ELSE
        corrPos := posErr * 2;
    END_IF;

    targetPos := D13 + corrPos;
    IF targetPos > 100000 THEN
        targetPos := 100000;
    ELSIF targetPos < -100000 THEN
        targetPos := -100000;
    END_IF;

    speedCmd := D14 + (posErr / 2) + (velErr / 4);
    IF speedCmd > 30000 THEN
        speedCmd := 30000;
    ELSIF speedCmd < -30000 THEN
        speedCmd := -30000;
    END_IF;

    D20 := targetPos;
    D21 := speedCmd;
    Y21 := extendLatch;

    IF X11 AND extendLatch AND (ABS(posErr) <= 20) AND (ABS(velErr) <= 100) THEN
        resultOk := TRUE;
    ELSE
        resultOk := FALSE;
    END_IF;

    IF resultOk THEN
        completeLatch := TRUE;
    END_IF;

    Y2 := completeLatch;
END_IF;

END_PROGRAM