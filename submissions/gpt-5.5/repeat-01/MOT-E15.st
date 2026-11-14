PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    accepted : BOOL;
    prevD14 : DINT;
    absD17 : DINT;
    angleDeg : REAL;
    speedDeg : REAL;
    accelDeg : REAL;
    angleRad : REAL;
    omegaRad : REAL;
    alphaRad : REAL;
    sinA : REAL;
    cosA : REAL;
    bBalance : REAL;
    bVel : REAL;
    bAcc : REAL;
    bLead : REAL;
    vLead : REAL;
    momentNm : REAL;
    propCorr : REAL;
    trimCorr : REAL;
    bCmd : REAL;
    vCmd : REAL;
    rawReal : REAL;
    stableCondition : BOOL;
    pi : REAL := 3.14159265358979;
    degToRad : REAL := 0.0174532925199433;
    leadT : REAL := 0.0333333333333333;
    leadA : REAL := 0.000277777777777778;
    momentToMm : REAL := 5.09683995922528;
    stableTimer : TON;
END_VAR

IF X10 THEN
    accepted := TRUE;
END_IF;

IF D17 < 0 THEN
    absD17 := -D17;
ELSE
    absD17 := D17;
END_IF;

IF accepted THEN
    Y20 := TRUE;

    angleDeg := REAL(D13) * 0.01;
    speedDeg := REAL(D14) * 0.01;
    accelDeg := REAL(D14 - prevD14);

    IF accelDeg > 350.0 THEN
        accelDeg := 350.0;
    ELSIF accelDeg < -350.0 THEN
        accelDeg := -350.0;
    END_IF;

    angleRad := angleDeg * degToRad;
    omegaRad := speedDeg * degToRad;
    alphaRad := accelDeg * degToRad;

    sinA := SIN(angleRad);
    cosA := COS(angleRad);

    bBalance := -450.0 * sinA;
    bVel := -450.0 * cosA * omegaRad;
    bAcc := (450.0 * sinA * omegaRad * omegaRad) - (450.0 * cosA * alphaRad);

    bLead := bBalance + (leadT * bVel) + (leadA * bAcc);
    vLead := bVel + (leadT * bAcc);

    momentNm := REAL(D17) * 0.01;
    propCorr := -momentToMm * momentNm;

    trimCorr := trimCorr - (0.5 * momentNm);
    IF trimCorr > 250.0 THEN
        trimCorr := 250.0;
    ELSIF trimCorr < -250.0 THEN
        trimCorr := -250.0;
    END_IF;

    bCmd := bLead + propCorr + trimCorr;
    vCmd := vLead;

    IF bCmd > 1000.0 THEN
        bCmd := 1000.0;
    ELSIF bCmd < -1000.0 THEN
        bCmd := -1000.0;
    END_IF;

    IF vCmd > 900.0 THEN
        vCmd := 900.0;
    ELSIF vCmd < -900.0 THEN
        vCmd := -900.0;
    END_IF;

    rawReal := bCmd * 100.0;
    IF rawReal >= 0.0 THEN
        D20 := DINT(rawReal + 0.5);
    ELSE
        D20 := DINT(rawReal - 0.5);
    END_IF;

    rawReal := vCmd * 100.0;
    IF rawReal >= 0.0 THEN
        D21 := DINT(rawReal + 0.5);
    ELSE
        D21 := DINT(rawReal - 0.5);
    END_IF;

ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    trimCorr := 0.0;

    IF D11 > 200000 THEN
        D20 := 200000;
    ELSIF D11 < -200000 THEN
        D20 := -200000;
    ELSE
        D20 := D11;
    END_IF;
    D21 := 0;
END_IF;

stableCondition := accepted AND (absD17 <= 99);
stableTimer(IN := stableCondition, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

IF D20 > 200000 THEN
    D20 := 200000;
ELSIF D20 < -200000 THEN
    D20 := -200000;
END_IF;

IF D21 > 200000 THEN
    D21 := 200000;
ELSIF D21 < -200000 THEN
    D21 := -200000;
END_IF;

prevD14 := D14;

END_PROGRAM