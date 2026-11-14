PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    D36 : DINT;
    D37 : DINT;
    Y24 : BOOL;
    Y2 : BOOL;
    state : INT := 0;
    started : BOOL := FALSE;
    targetRaw : DINT := 23000;
    strokeRaw : DINT := 17000;
    aAtOpen : BOOL;
    bAtOpen : BOOL;
    cAtTarget : BOOL;
    dAt70 : BOOL;
    eAtStroke : BOOL;
    aAt0 : BOOL;
    bAt0 : BOOL;
    cAt0 : BOOL;
    dAt0 : BOOL;
    eAt0 : BOOL;
    allAt0 : BOOL;
END_VAR

IF (NOT started) AND X0 THEN
    started := TRUE;
    state := 10;

    targetRaw := D101;
    IF targetRaw < 23000 THEN
        targetRaw := 23000;
    ELSIF targetRaw > 24000 THEN
        targetRaw := 24000;
    END_IF;

    strokeRaw := D102;
    IF strokeRaw < 17000 THEN
        strokeRaw := 17000;
    ELSIF strokeRaw > 18000 THEN
        strokeRaw := 18000;
    END_IF;
END_IF;

aAtOpen := (ABS(D10 - 10000) <= 20) AND (ABS(D11) <= 100);
bAtOpen := (ABS(D12 - 10000) <= 20) AND (ABS(D13) <= 100);
cAtTarget := (ABS(D14 - targetRaw) <= 20) AND (ABS(D15) <= 100);
dAt70 := (ABS(D16 - 7000) <= 20) AND (ABS(D17) <= 100);
eAtStroke := (ABS(D18 - strokeRaw) <= 20) AND (ABS(D19) <= 100);

aAt0 := (ABS(D10) <= 20) AND (ABS(D11) <= 100);
bAt0 := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
cAt0 := (ABS(D14) <= 20) AND (ABS(D15) <= 100);
dAt0 := (ABS(D16) <= 20) AND (ABS(D17) <= 100);
eAt0 := (ABS(D18) <= 20) AND (ABS(D19) <= 100);
allAt0 := aAt0 AND bAt0 AND cAt0 AND dAt0 AND eAt0;

IF started THEN
    CASE state OF
        10:
            IF aAtOpen AND bAtOpen THEN
                state := 20;
            END_IF;
        20:
            IF cAtTarget THEN
                state := 30;
            END_IF;
        30:
            IF dAt70 THEN
                state := 40;
            END_IF;
        40:
            IF eAtStroke THEN
                state := 50;
            END_IF;
        50:
            IF eAt0 THEN
                state := 60;
            END_IF;
        60:
            IF dAt0 THEN
                state := 70;
            END_IF;
        70:
            IF cAt0 THEN
                state := 80;
            END_IF;
        80:
            IF allAt0 THEN
                state := 90;
            END_IF;
        90:
            state := 90;
    ELSE
        state := 10;
    END_CASE;
END_IF;

D20 := 0;
D21 := 1000;
Y20 := FALSE;
D24 := 0;
D25 := 1000;
Y21 := FALSE;
D28 := 0;
D29 := 1000;
Y22 := FALSE;
D32 := 0;
D33 := 1000;
Y23 := FALSE;
D36 := 0;
D37 := 1000;
Y24 := FALSE;
Y2 := FALSE;

IF started THEN
    CASE state OF
        10:
            D20 := 10000;
            Y20 := TRUE;
            D24 := 10000;
            Y21 := TRUE;

        20:
            D20 := 10000;
            Y20 := TRUE;
            D24 := 10000;
            Y21 := TRUE;
            D28 := targetRaw;
            Y22 := TRUE;

        30:
            D20 := 10000;
            Y20 := TRUE;
            D24 := 10000;
            Y21 := TRUE;
            D28 := targetRaw;
            Y22 := TRUE;
            D32 := 7000;
            Y23 := TRUE;

        40:
            D20 := 10000;
            Y20 := TRUE;
            D24 := 10000;
            Y21 := TRUE;
            D28 := targetRaw;
            Y22 := TRUE;
            D32 := 7000;
            Y23 := TRUE;
            D36 := strokeRaw;
            Y24 := TRUE;

        50:
            D20 := 10000;
            Y20 := TRUE;
            D24 := 10000;
            Y21 := TRUE;
            D28 := targetRaw;
            Y22 := TRUE;
            D32 := 7000;
            Y23 := TRUE;
            D36 := 0;
            Y24 := TRUE;

        60:
            D20 := 10000;
            Y20 := TRUE;
            D24 := 10000;
            Y21 := TRUE;
            D28 := targetRaw;
            Y22 := TRUE;
            D32 := 0;
            Y23 := TRUE;
            D36 := 0;
            Y24 := TRUE;

        70:
            D20 := 10000;
            Y20 := TRUE;
            D24 := 10000;
            Y21 := TRUE;
            D28 := 0;
            Y22 := TRUE;
            D32 := 0;
            Y23 := TRUE;
            D36 := 0;
            Y24 := TRUE;

        80:
            D20 := 0;
            Y20 := TRUE;
            D24 := 0;
            Y21 := TRUE;
            D28 := 0;
            Y22 := TRUE;
            D32 := 0;
            Y23 := TRUE;
            D36 := 0;
            Y24 := TRUE;

        90:
            D20 := 0;
            Y20 := TRUE;
            D24 := 0;
            Y21 := TRUE;
            D28 := 0;
            Y22 := TRUE;
            D32 := 0;
            Y23 := TRUE;
            D36 := 0;
            Y24 := TRUE;
            Y2 := TRUE;
    ELSE
        D20 := 0;
        D24 := 0;
        D28 := 0;
        D32 := 0;
        D36 := 0;
    END_CASE;
END_IF;

END_PROGRAM