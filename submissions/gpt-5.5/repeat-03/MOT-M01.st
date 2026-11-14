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
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    started : BOOL;
    stage : INT;
    targetA : DINT;
    targetB : DINT;
    holdA : DINT;
    holdB : DINT;
    highTarget : DINT := 40000;
    safeHeight : DINT := 35000;
    zeroTarget : DINT := 0;
    posTol : DINT := 20;
    spdTol : DINT := 100;
    horizontalReady : BOOL;
    resultOk : BOOL;
    stableTimer : TON;
END_VAR

IF NOT started THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y2 := FALSE;

    IF X10 THEN
        started := TRUE;
        stage := 10;
        targetA := D10;
        targetB := D13;
        holdA := D11;
        holdB := D14;
    END_IF;
END_IF;

IF started THEN
    CASE stage OF
        10:
            D20 := holdA;
            Y20 := TRUE;
            D21 := holdB;
            Y21 := TRUE;
            D22 := highTarget;
            Y22 := TRUE;

            IF D16 >= safeHeight THEN
                stage := 20;
            END_IF;

        20:
            D20 := targetA;
            Y20 := TRUE;
            D21 := targetB;
            Y21 := TRUE;
            D22 := highTarget;
            Y22 := TRUE;

            horizontalReady := (ABS(D11 - targetA) <= posTol) AND
                               (ABS(D12) <= spdTol) AND
                               (ABS(D14 - targetB) <= posTol) AND
                               (ABS(D15) <= spdTol);

            IF horizontalReady THEN
                stage := 30;
            END_IF;

        30:
            D20 := targetA;
            Y20 := TRUE;
            D21 := targetB;
            Y21 := TRUE;
            D22 := zeroTarget;
            Y22 := TRUE;

        40:
            D20 := targetA;
            Y20 := TRUE;
            D21 := targetB;
            Y21 := TRUE;
            D22 := zeroTarget;
            Y22 := TRUE;
            Y2 := TRUE;

        ELSE
            stage := 10;
    END_CASE;
END_IF;

resultOk := started AND
            (stage >= 30) AND
            Y20 AND Y21 AND Y22 AND
            (D20 = targetA) AND
            (D21 = targetB) AND
            (D22 = zeroTarget) AND
            (ABS(D11 - targetA) <= posTol) AND
            (ABS(D12) <= spdTol) AND
            (ABS(D14 - targetB) <= posTol) AND
            (ABS(D15) <= spdTol) AND
            (ABS(D16 - zeroTarget) <= posTol) AND
            (ABS(D17) <= spdTol);

stableTimer(IN := resultOk, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
    stage := 40;
END_IF;

END_PROGRAM