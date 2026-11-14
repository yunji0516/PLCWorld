PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;
    requestLatched : BOOL;
    brakeFullLatched : BOOL;
    resultDone : BOOL;
    state : INT;
    reqD : DINT;
    reqB : DINT;
    cmdA : DINT;
    targetBalD : DINT;
    angleForBalD : DINT;
    prevD20 : DINT;
    prevD21 : DINT;
    prevD22 : DINT;
    freezeD20 : DINT;
    freezeD21 : DINT;
    freezeD22 : DINT;
    diffA : DINT;
    actualRad : REAL;
    actualBmm : REAL;
    moment : REAL;
    calcRad : REAL;
    radScale : REAL := 0.000174532925199;
    rampStep : DINT := 65;
    compCond : BOOL;
    completeTimer : TON;
END_VAR

actualRad := REAL(D11) * radScale;
actualBmm := REAL(D13) * 0.01;
moment := 88.29 * SIN(actualRad) + 0.1962 * actualBmm;

IF X10 AND NOT requestLatched AND NOT brakeFullLatched THEN
    requestLatched := TRUE;
    reqD := D10;
    calcRad := REAL(reqD) * radScale;
    reqB := DINT(-45000.0 * SIN(calcRad));
    IF reqB > 60000 THEN
        reqB := 60000;
    ELSIF reqB < -60000 THEN
        reqB := -60000;
    END_IF;
    cmdA := D11;
    state := 10;
END_IF;

IF X11 AND NOT brakeFullLatched THEN
    brakeFullLatched := TRUE;
    freezeD20 := prevD20;
    freezeD21 := prevD21;
    freezeD22 := prevD22;
    state := 50;
END_IF;

D22 := 0;
Y2 := resultDone;
compCond := FALSE;

CASE state OF
    0:
        D20 := D11;
        angleForBalD := D11;
        calcRad := REAL(angleForBalD) * radScale;
        targetBalD := DINT(-45000.0 * SIN(calcRad));
        IF targetBalD > 60000 THEN
            targetBalD := 60000;
        ELSIF targetBalD < -60000 THEN
            targetBalD := -60000;
        END_IF;
        D21 := targetBalD;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;

    10:
        D20 := cmdA;
        angleForBalD := cmdA;
        calcRad := REAL(angleForBalD) * radScale;
        targetBalD := DINT(-45000.0 * SIN(calcRad));
        IF targetBalD > 60000 THEN
            targetBalD := 60000;
        ELSIF targetBalD < -60000 THEN
            targetBalD := -60000;
        END_IF;
        D21 := targetBalD;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;

        IF (ABS(moment) <= 3.0) AND (ABS(D12) <= 100) AND (ABS(D14) <= 100) AND (ABS(D13 - targetBalD) <= 30) THEN
            state := 20;
        END_IF;

    20:
        IF ABS(moment) <= 18.0 THEN
            diffA := reqD - cmdA;
            IF diffA > rampStep THEN
                cmdA := cmdA + rampStep;
            ELSIF diffA < -rampStep THEN
                cmdA := cmdA - rampStep;
            ELSE
                cmdA := reqD;
            END_IF;
        END_IF;

        D20 := cmdA;

        IF ABS(moment) > 18.0 THEN
            angleForBalD := D11;
        ELSE
            angleForBalD := cmdA;
        END_IF;

        calcRad := REAL(angleForBalD) * radScale;
        targetBalD := DINT(-45000.0 * SIN(calcRad));
        IF targetBalD > 60000 THEN
            targetBalD := 60000;
        ELSIF targetBalD < -60000 THEN
            targetBalD := -60000;
        END_IF;
        D21 := targetBalD;

        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;

        IF cmdA = reqD THEN
            state := 30;
        END_IF;

    30:
        D20 := reqD;
        D21 := reqB;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;

        IF (ABS(D11 - reqD) <= 10) AND (ABS(D12) <= 50) AND
           (ABS(D13 - reqB) <= 10) AND (ABS(D14) <= 50) AND
           (ABS(moment) <= 0.8) THEN
            state := 40;
        END_IF;

    40:
        D20 := reqD;
        D21 := reqB;
        Y20 := TRUE;
        Y21 := TRUE;

        IF ABS(D12) > 90 THEN
            Y22 := FALSE;
            state := 30;
        ELSE
            Y22 := TRUE;
        END_IF;

    50:
        D20 := freezeD20;
        D21 := freezeD21;
        D22 := freezeD22;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;

        compCond := requestLatched AND X11 AND
                    (ABS(moment) <= 1.0) AND
                    (ABS(D11 - reqD) <= 20) AND
                    (ABS(D12) <= 100) AND
                    (ABS(D13 - reqB) <= 20) AND
                    (ABS(D14) <= 100);

ELSE
    D20 := D11;
    angleForBalD := D11;
    calcRad := REAL(angleForBalD) * radScale;
    targetBalD := DINT(-45000.0 * SIN(calcRad));
    IF targetBalD > 60000 THEN
        targetBalD := 60000;
    ELSIF targetBalD < -60000 THEN
        targetBalD := -60000;
    END_IF;
    D21 := targetBalD;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    state := 0;
END_CASE;

IF brakeFullLatched THEN
    D20 := freezeD20;
    D21 := freezeD21;
    D22 := freezeD22;
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := TRUE;

    compCond := requestLatched AND X11 AND
                (ABS(moment) <= 1.0) AND
                (ABS(D11 - reqD) <= 20) AND
                (ABS(D12) <= 100) AND
                (ABS(D13 - reqB) <= 20) AND
                (ABS(D14) <= 100);
END_IF;

completeTimer(IN := compCond, PT := T#30ms);
IF completeTimer.Q THEN
    resultDone := TRUE;
END_IF;
Y2 := resultDone;

prevD20 := D20;
prevD21 := D21;
prevD22 := D22;

END_PROGRAM