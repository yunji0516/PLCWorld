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
    accepted : BOOL;
    targetX : REAL;
    xPos : REAL;
    xVel : REAL;
    zPos : REAL;
    hPos : REAL;
    hVel : REAL;
    xErr : REAL;
    absXErr : REAL;
    vCmd : REAL;
    vLimit : REAL;
    turnCmd : REAL;
    turnBias : REAL;
    leftCmd : REAL;
    rightCmd : REAL;
    leftRaw : REAL;
    rightRaw : REAL;
    stableCond : BOOL;
    stableTimer : TON;
END_VAR

xPos := REAL(D11) / 100.0;
xVel := REAL(D12) / 100.0;
zPos := REAL(D13) / 100.0;
hPos := REAL(D15) / 100.0;
hVel := REAL(D16) / 100.0;

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    targetX := REAL(D10) / 100.0;
END_IF;

IF accepted THEN
    xErr := targetX - xPos;
    absXErr := ABS(xErr);

    vCmd := (6.0 * xErr) - (2.0 * xVel);

    IF absXErr > 250.0 THEN
        vLimit := 1100.0;
    ELSIF absXErr > 80.0 THEN
        vLimit := 900.0;
    ELSIF absXErr > 30.0 THEN
        vLimit := 500.0;
    ELSIF absXErr > 8.0 THEN
        vLimit := 250.0;
    ELSE
        vLimit := 100.0;
    END_IF;

    IF vCmd > vLimit THEN
        vCmd := vLimit;
    ELSIF vCmd < -vLimit THEN
        vCmd := -vLimit;
    END_IF;

    turnBias := 0.0055 * vCmd;
    turnCmd := turnBias - (6.0 * zPos) - (45.0 * hPos) - (5.0 * hVel);

    IF turnCmd > 500.0 THEN
        turnCmd := 500.0;
    ELSIF turnCmd < -500.0 THEN
        turnCmd := -500.0;
    END_IF;

    leftCmd := vCmd - turnCmd;
    rightCmd := vCmd + turnCmd;

    IF leftCmd > 1800.0 THEN
        leftCmd := 1800.0;
    ELSIF leftCmd < -1800.0 THEN
        leftCmd := -1800.0;
    END_IF;

    IF rightCmd > 1800.0 THEN
        rightCmd := 1800.0;
    ELSIF rightCmd < -1800.0 THEN
        rightCmd := -1800.0;
    END_IF;

    leftRaw := leftCmd * 100.0;
    rightRaw := rightCmd * 100.0;

    IF leftRaw > 200000.0 THEN
        D20 := 200000;
    ELSIF leftRaw < -200000.0 THEN
        D20 := -200000;
    ELSE
        D20 := DINT(leftRaw);
    END_IF;

    IF rightRaw > 200000.0 THEN
        D21 := 200000;
    ELSIF rightRaw < -200000.0 THEN
        D21 := -200000;
    ELSE
        D21 := DINT(rightRaw);
    END_IF;

    stableCond := (ABS(xErr) <= 0.8) AND
                  (ABS(zPos) <= 1.5) AND
                  (ABS(hPos) <= 0.2) AND
                  (ABS(xVel) <= 1.2) AND
                  (ABS(hVel) <= 0.6);

    stableTimer(IN := stableCond, PT := T#30ms);

    IF stableTimer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    stableCond := FALSE;
    stableTimer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM