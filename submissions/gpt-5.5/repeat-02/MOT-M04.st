PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;
    completeLatch : BOOL;
    finalOK : BOOL;
    stableTimer : TON;
    tmpD : DINT;
    outAccel : DINT;
    wirePosMM : REAL;
    trolleyPosMM : REAL;
    trolleyVelMMs : REAL;
    targetBMM : REAL;
    swayDeg : REAL;
    swayVelDegs : REAL;
    targetSwayDeg : REAL;
    swayErrDeg : REAL;
    lenM : REAL;
    eB : REAL;
    absEB : REAL;
    vStop : REAL;
    vDes : REAL;
    aVel : REAL;
    aBase : REAL;
    aSway : REAL;
    accelCmd : REAL;
    maxAccel : REAL := 750.0;
    maxVel : REAL := 480.0;
    velGain : REAL := 3.0;
    accelLimit : REAL := 1600.0;
END_VAR

IF NOT X10 THEN
    completeLatch := FALSE;
END_IF;

IF X10 THEN
    tmpD := D10;
    IF tmpD < 60000 THEN
        tmpD := 60000;
    ELSIF tmpD > 160000 THEN
        tmpD := 160000;
    END_IF;
    D20 := tmpD;
    Y20 := TRUE;
ELSE
    tmpD := D11;
    IF tmpD < 60000 THEN
        tmpD := 60000;
    ELSIF tmpD > 160000 THEN
        tmpD := 160000;
    END_IF;
    D20 := tmpD;
    Y20 := FALSE;
END_IF;

wirePosMM := REAL(D11) * 0.01;
trolleyPosMM := REAL(D13) * 0.01;
trolleyVelMMs := REAL(D14) * 0.01;
targetBMM := REAL(D17) * 0.01;
swayDeg := REAL(D15) * 0.01;
swayVelDegs := REAL(D16) * 0.01;
targetSwayDeg := REAL(D18) * 0.01;
swayErrDeg := swayDeg - targetSwayDeg;

lenM := wirePosMM * 0.001;
IF lenM < 0.6 THEN
    lenM := 0.6;
ELSIF lenM > 1.6 THEN
    lenM := 1.6;
END_IF;

IF X10 THEN
    eB := targetBMM - trolleyPosMM;
    absEB := ABS(eB);

    IF completeLatch THEN
        aBase := (3.0 * eB) - (4.0 * trolleyVelMMs);
        IF aBase > 200.0 THEN
            aBase := 200.0;
        ELSIF aBase < -200.0 THEN
            aBase := -200.0;
        END_IF;
        aSway := 0.0;
    ELSE
        vStop := SQRT(2.0 * maxAccel * absEB);
        IF vStop > maxVel THEN
            vStop := maxVel;
        END_IF;

        IF eB > 0.0 THEN
            vDes := vStop;
        ELSIF eB < 0.0 THEN
            vDes := -vStop;
        ELSE
            vDes := 0.0;
        END_IF;

        aVel := velGain * (vDes - trolleyVelMMs);

        IF aVel > maxAccel THEN
            aBase := maxAccel;
        ELSIF aVel < -maxAccel THEN
            aBase := -maxAccel;
        ELSE
            aBase := aVel;
        END_IF;

        IF absEB < 3.0 THEN
            aBase := (5.0 * eB) - (6.0 * trolleyVelMMs);
            IF aBase > 300.0 THEN
                aBase := 300.0;
            ELSIF aBase < -300.0 THEN
                aBase := -300.0;
            END_IF;
        END_IF;

        IF ABS(swayErrDeg) > 8.0 THEN
            aBase := aBase * 0.4;
        END_IF;
        IF ABS(swayErrDeg) > 15.0 THEN
            aBase := 0.0;
        END_IF;

        aSway := lenM * ((90.0 * swayErrDeg) + (85.0 * swayVelDegs));
    END_IF;

    accelCmd := aBase + aSway;

    IF accelCmd > accelLimit THEN
        accelCmd := accelLimit;
    ELSIF accelCmd < -accelLimit THEN
        accelCmd := -accelLimit;
    END_IF;

    IF (trolleyPosMM > 1200.0) AND (accelCmd > 0.0) THEN
        accelCmd := 0.0;
    END_IF;
    IF (trolleyPosMM < -1200.0) AND (accelCmd < 0.0) THEN
        accelCmd := 0.0;
    END_IF;

    outAccel := DINT(ROUND(accelCmd * 100.0));
    IF outAccel > 400000 THEN
        outAccel := 400000;
    ELSIF outAccel < -400000 THEN
        outAccel := -400000;
    END_IF;
    D21 := outAccel;
ELSE
    D21 := 0;
END_IF;

finalOK := X10
           AND (ABS(D11 - D20) <= 100)
           AND (ABS(D12) <= 100)
           AND (ABS(D13 - D17) <= 100)
           AND (ABS(D14) <= 100)
           AND (ABS(D15 - D18) <= 20)
           AND (ABS(D16) <= 100);

stableTimer(IN := finalOK, PT := T#30ms);

IF stableTimer.Q THEN
    completeLatch := TRUE;
END_IF;

Y2 := completeLatch;

END_PROGRAM