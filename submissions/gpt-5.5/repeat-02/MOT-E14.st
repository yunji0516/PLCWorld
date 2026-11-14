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
    Y2 : BOOL;
    accepted : BOOL;
    resultSet : BOOL;
    targetRaw : DINT;
    errRaw : DINT;
    absErrRaw : DINT;
    absSpeedRaw : DINT;
    absAngleRaw : DINT;
    absOmegaRaw : DINT;
    inWindow : BOOL;
    stableTimer : TON;
    targetMm : REAL;
    posMm : REAL;
    speedMmS : REAL;
    errMm : REAL;
    lengthMm : REAL;
    thetaRad : REAL;
    omegaRadS : REAL;
    cmdAcc : REAL;
    cmdRawReal : REAL;
    kPos : REAL;
    kSpeed : REAL;
    kTheta : REAL;
    kOmega : REAL;
    rawCmd : DINT;
END_VAR

IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    targetRaw := D10;
END_IF;

IF accepted THEN
    targetMm := REAL(targetRaw) * 0.01;
    posMm := REAL(D11) * 0.01;
    speedMmS := REAL(D12) * 0.01;
    errMm := posMm - targetMm;

    lengthMm := REAL(D13) * 0.01;
    IF lengthMm < 800.0 THEN
        lengthMm := 800.0;
    ELSIF lengthMm > 1100.0 THEN
        lengthMm := 1100.0;
    END_IF;

    thetaRad := REAL(D15) * 0.000174532925;
    omegaRadS := REAL(D16) * 0.000174532925;

    kPos := 39.0625 * lengthMm / 9810.0;
    kSpeed := 10.0;
    kTheta := (62.5 * lengthMm) - 98100.0;
    kOmega := (37.5 * lengthMm) - (lengthMm * kPos) - 9810.0;

    cmdAcc := (0.0 - (kPos * errMm)) - (kSpeed * speedMmS) + (kTheta * thetaRad) + (kOmega * omegaRadS);

    IF cmdAcc > 1800.0 THEN
        cmdAcc := 1800.0;
    ELSIF cmdAcc < -1800.0 THEN
        cmdAcc := -1800.0;
    END_IF;

    cmdRawReal := cmdAcc * 100.0;
    rawCmd := DINT(cmdRawReal);

    IF rawCmd > 180000 THEN
        rawCmd := 180000;
    ELSIF rawCmd < -180000 THEN
        rawCmd := -180000;
    END_IF;

    D20 := rawCmd;
ELSE
    D20 := 0;
END_IF;

errRaw := D11 - targetRaw;
absErrRaw := ABS(errRaw);
absSpeedRaw := ABS(D12);
absAngleRaw := ABS(D15);
absOmegaRaw := ABS(D16);

inWindow := accepted AND (absErrRaw <= 99) AND (absSpeedRaw <= 99) AND (absAngleRaw <= 19) AND (absOmegaRaw <= 99);

stableTimer(IN := (inWindow AND (NOT resultSet)), PT := T#30ms);

IF accepted AND stableTimer.Q THEN
    resultSet := TRUE;
END_IF;

Y2 := resultSet;

END_PROGRAM