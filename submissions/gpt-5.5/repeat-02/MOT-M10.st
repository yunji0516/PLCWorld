PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;
    started : BOOL;
    stage : INT;
    reqTarget : DINT;
    desiredA : DINT;
    desiredB : DINT;
    aDiff : DINT;
    bDiff : DINT;
    aVelAbs : DINT;
    bVelAbs : DINT;
    aArrived : BOOL;
    bArrived : BOOL;
END_VAR

IF (NOT started) AND X0 THEN
    started := TRUE;
    stage := 10;
    IF D101 < 84000 THEN
        reqTarget := 84000;
    ELSIF D101 > 85000 THEN
        reqTarget := 85000;
    ELSE
        reqTarget := D101;
    END_IF;
END_IF;

IF NOT started THEN
    D20 := 20000;
    D21 := 1000;
    Y20 := FALSE;
    D24 := 0;
    D25 := 1000;
    Y21 := FALSE;
    Y2 := FALSE;
ELSE
    CASE stage OF
        10:
            desiredA := 50000;
            desiredB := 0;
        20:
            desiredA := 50000;
            desiredB := 9000;
        30:
            desiredA := reqTarget;
            desiredB := 9000;
        40:
            desiredA := 50000;
            desiredB := 9000;
        50:
            desiredA := 50000;
            desiredB := 0;
        60:
            desiredA := 20000;
            desiredB := 0;
        70:
            desiredA := 20000;
            desiredB := 0;
    ELSE
        stage := 10;
        desiredA := 50000;
        desiredB := 0;
    END_CASE;

    aDiff := D10 - desiredA;
    IF aDiff < 0 THEN
        aDiff := -aDiff;
    END_IF;

    bDiff := D12 - desiredB;
    IF bDiff < 0 THEN
        bDiff := -bDiff;
    END_IF;

    aVelAbs := D11;
    IF aVelAbs < 0 THEN
        aVelAbs := -aVelAbs;
    END_IF;

    bVelAbs := D13;
    IF bVelAbs < 0 THEN
        bVelAbs := -bVelAbs;
    END_IF;

    aArrived := (aDiff <= 19) AND (aVelAbs <= 99);
    bArrived := (bDiff <= 19) AND (bVelAbs <= 99);

    IF aArrived AND bArrived THEN
        CASE stage OF
            10:
                stage := 20;
            20:
                stage := 30;
            30:
                stage := 40;
            40:
                stage := 50;
            50:
                stage := 60;
            60:
                stage := 70;
            70:
                stage := 70;
        ELSE
            stage := 10;
        END_CASE;
    END_IF;

    CASE stage OF
        10:
            D20 := 50000;
            D24 := 0;
        20:
            D20 := 50000;
            D24 := 9000;
        30:
            D20 := reqTarget;
            D24 := 9000;
        40:
            D20 := 50000;
            D24 := 9000;
        50:
            D20 := 50000;
            D24 := 0;
        60:
            D20 := 20000;
            D24 := 0;
        70:
            D20 := 20000;
            D24 := 0;
    ELSE
        D20 := 50000;
        D24 := 0;
    END_CASE;

    D21 := 1000;
    D25 := 1000;
    Y20 := TRUE;
    Y21 := TRUE;
    Y2 := (stage = 70);
END_IF;

END_PROGRAM