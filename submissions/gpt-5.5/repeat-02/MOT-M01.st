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
    state : INT;
    targetA : DINT;
    targetB : DINT;
    initA : DINT;
    initB : DINT;
    hDone : BOOL;
    finalDone : BOOL;
    hCount : INT;
    finalCount : INT;
END_VAR

IF (state = 0) AND X10 THEN
    targetA := D10;
    targetB := D13;
    initA := D11;
    initB := D14;
    hCount := 0;
    finalCount := 0;
    Y2 := FALSE;
    state := 10;
END_IF;

IF (state = 10) AND (D16 >= 32000) THEN
    state := 20;
    hCount := 0;
END_IF;

hDone := (ABS(D11 - targetA) <= 20) AND (ABS(D12) <= 100) AND
         (ABS(D14 - targetB) <= 20) AND (ABS(D15) <= 100);

IF state = 20 THEN
    IF hDone THEN
        IF hCount < 1000 THEN
            hCount := hCount + 1;
        END_IF;
    ELSE
        hCount := 0;
    END_IF;

    IF hCount >= 3 THEN
        hCount := 0;
        finalCount := 0;
        state := 30;
    END_IF;
ELSE
    hCount := 0;
END_IF;

finalDone := (ABS(D11 - targetA) <= 20) AND (ABS(D12) <= 100) AND
             (ABS(D14 - targetB) <= 20) AND (ABS(D15) <= 100) AND
             (ABS(D16) <= 20) AND (ABS(D17) <= 100);

IF state = 30 THEN
    IF finalDone THEN
        IF finalCount < 1000 THEN
            finalCount := finalCount + 1;
        END_IF;
    ELSE
        finalCount := 0;
    END_IF;

    IF finalCount >= 3 THEN
        state := 40;
    END_IF;
ELSIF state <> 40 THEN
    finalCount := 0;
END_IF;

CASE state OF
    0:
        D20 := D11;
        Y20 := FALSE;
        D21 := D14;
        Y21 := FALSE;
        D22 := 0;
        Y22 := FALSE;
        Y2 := FALSE;

    10:
        D20 := initA;
        Y20 := TRUE;
        D21 := initB;
        Y21 := TRUE;
        D22 := 40000;
        Y22 := TRUE;
        Y2 := FALSE;

    20:
        D20 := targetA;
        Y20 := TRUE;
        D21 := targetB;
        Y21 := TRUE;
        D22 := 40000;
        Y22 := TRUE;
        Y2 := FALSE;

    30:
        D20 := targetA;
        Y20 := TRUE;
        D21 := targetB;
        Y21 := TRUE;
        D22 := 0;
        Y22 := TRUE;
        Y2 := FALSE;

    40:
        D20 := targetA;
        Y20 := TRUE;
        D21 := targetB;
        Y21 := TRUE;
        D22 := 0;
        Y22 := TRUE;
        Y2 := TRUE;

ELSE
        D20 := D11;
        Y20 := FALSE;
        D21 := D14;
        Y21 := FALSE;
        D22 := 0;
        Y22 := FALSE;
        Y2 := FALSE;
        state := 0;
END_CASE;

END_PROGRAM