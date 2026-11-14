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
    done : BOOL;
    stableCount : INT;
    targetX : REAL;
    xPos : REAL;
    xVel : REAL;
    zPos : REAL;
    headDeg : REAL;
    headRate : REAL;
    xErr : REAL;
    absErr : REAL;
    absZ : REAL;
    absFwd : REAL;
    dir : REAL;
    speedLimit : REAL;
    vPlan : REAL;
    fwdCmd : REAL;
    yawCmd : REAL;
    halfDiff : REAL;
    leftCmd : REAL;
    rightCmd : REAL;
    stableOk : BOOL;
    approachAccel : REAL := 1300.0;
    maxWheelSpeed : REAL := 1900.0;
END_VAR

targetX := REAL(D10) / 100.0;
xPos := REAL(D11) / 100.0;
xVel := REAL(D12) / 100.0;
zPos := REAL(D13) / 100.0;
headDeg := REAL(D15) / 100.0;
headRate := REAL(D16) / 100.0;

IF X10 AND NOT accepted THEN
    accepted := TRUE;
END_IF;

xErr := targetX - xPos;
absErr := ABS(xErr);
absZ := ABS(zPos);

stableOk := accepted
            AND (absErr <= 0.6)
            AND (absZ <= 1.5)
            AND (ABS(headDeg) <= 0.22)
            AND (ABS(xVel) <= 1.2)
            AND (ABS(headRate) <= 0.7);

IF stableOk THEN
    IF stableCount < 1000 THEN
        stableCount := stableCount + 1;
    END_IF;
ELSE
    IF NOT done THEN
        stableCount := 0;
    END_IF;
END_IF;

IF (NOT done) AND (stableCount >= 4) THEN
    done := TRUE;
END_IF;

Y2 := done;

IF (NOT accepted) OR done OR stableOk THEN
    leftCmd := 0.0;
    rightCmd := 0.0;
ELSE
    speedLimit := 900.0;
    IF absZ > 60.0 THEN
        speedLimit := 400.0;
    ELSIF absZ > 40.0 THEN
        speedLimit := 650.0;
    END_IF;

    IF xErr >= 0.0 THEN
        dir := 1.0;
    ELSE
        dir := -1.0;
    END_IF;

    IF absErr > 35.0 THEN
        vPlan := SQRT(2.0 * approachAccel * absErr);
        IF vPlan > speedLimit THEN
            vPlan := speedLimit;
        END_IF;
        fwdCmd := (dir * vPlan) - (0.75 * (xVel - (dir * vPlan)));
        IF fwdCmd > speedLimit THEN
            fwdCmd := speedLimit;
        ELSIF fwdCmd < -speedLimit THEN
            fwdCmd := -speedLimit;
        END_IF;
    ELSIF absErr > 8.0 THEN
        fwdCmd := (5.5 * xErr) - (2.4 * xVel);
        IF fwdCmd > 350.0 THEN
            fwdCmd := 350.0;
        ELSIF fwdCmd < -350.0 THEN
            fwdCmd := -350.0;
        END_IF;
    ELSE
        fwdCmd := (2.0 * xErr) - (3.0 * xVel);
        IF fwdCmd > 80.0 THEN
            fwdCmd := 80.0;
        ELSIF fwdCmd < -80.0 THEN
            fwdCmd := -80.0;
        END_IF;
        IF (absErr < 0.25) AND (ABS(xVel) < 0.7) THEN
            fwdCmd := 0.0;
        END_IF;
    END_IF;

    absFwd := ABS(fwdCmd);
    yawCmd := (-0.0012 * fwdCmd * zPos)
              - ((4.0 + (0.006 * absFwd)) * headDeg)
              - (0.6 * headRate)
              - (0.15 * zPos);

    IF yawCmd > 70.0 THEN
        yawCmd := 70.0;
    ELSIF yawCmd < -70.0 THEN
        yawCmd := -70.0;
    END_IF;

    halfDiff := yawCmd * 5.23599;
    leftCmd := fwdCmd - halfDiff;
    rightCmd := fwdCmd + halfDiff;

    IF leftCmd > maxWheelSpeed THEN
        leftCmd := maxWheelSpeed;
    ELSIF leftCmd < -maxWheelSpeed THEN
        leftCmd := -maxWheelSpeed;
    END_IF;

    IF rightCmd > maxWheelSpeed THEN
        rightCmd := maxWheelSpeed;
    ELSIF rightCmd < -maxWheelSpeed THEN
        rightCmd := -maxWheelSpeed;
    END_IF;
END_IF;

D20 := DINT(leftCmd * 100.0);
D21 := DINT(rightCmd * 100.0);

END_PROGRAM