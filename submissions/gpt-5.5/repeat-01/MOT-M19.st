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
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
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
    Y2 : BOOL;
    state : INT;
    reqFirst : DINT;
    reqSecond : DINT;
    reqLane : DINT;
    posTol : DINT := 10;
    velTol : DINT := 50;
    aAtFirst : BOOL;
    aAtSecond : BOOL;
    aAtHome : BOOL;
    bAtRetract : BOOL;
    bAtGuide : BOOL;
    bEngaged : BOOL;
    cAtWork : BOOL;
    cAtStandby : BOOL;
    dAtLane : BOOL;
    dAtHome : BOOL;
END_VAR

aAtFirst := (ABS(D10 - reqFirst) <= posTol) AND (ABS(D11) <= velTol);
aAtSecond := (ABS(D10 - reqSecond) <= posTol) AND (ABS(D11) <= velTol);
aAtHome := (ABS(D10 - 6000) <= posTol) AND (ABS(D11) <= velTol);
bAtRetract := (ABS(D12 - 0) <= posTol) AND (ABS(D13) <= velTol);
bAtGuide := (ABS(D12 - 7000) <= posTol) AND (ABS(D13) <= velTol);
bEngaged := (D12 >= 6000) AND (D12 <= 7500);
cAtWork := (ABS(D14 - 0) <= posTol) AND (ABS(D15) <= velTol);
cAtStandby := (ABS(D14 - 8000) <= posTol) AND (ABS(D15) <= velTol);
dAtLane := (ABS(D16 - reqLane) <= posTol) AND (ABS(D17) <= velTol);
dAtHome := (ABS(D16 - 0) <= posTol) AND (ABS(D17) <= velTol);

CASE state OF
    0:
        D20 := 6000;
        D21 := 1000;
        Y20 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y21 := FALSE;
        D28 := 8000;
        D29 := 1000;
        Y22 := FALSE;
        D32 := 0;
        D33 := 1000;
        Y23 := FALSE;
        Y2 := FALSE;

    10:
        D20 := reqFirst;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        D32 := reqLane;
        D33 := 1000;
        Y23 := TRUE;
        Y2 := FALSE;

    20:
        D20 := reqFirst;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 7000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        D32 := reqLane;
        D33 := 1000;
        Y23 := TRUE;
        Y2 := FALSE;

    30:
        D20 := reqSecond;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 7000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        D32 := reqLane;
        D33 := 1000;
        Y23 := TRUE;
        Y2 := FALSE;

    40:
        D20 := reqSecond;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 7000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        D32 := reqLane;
        D33 := 1000;
        Y23 := TRUE;
        Y2 := TRUE;

    45:
        D20 := reqSecond;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        D32 := reqLane;
        D33 := 1000;
        Y23 := TRUE;
        Y2 := TRUE;

    50:
        D20 := 6000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 8000;
        D29 := 1000;
        Y22 := TRUE;
        D32 := 0;
        D33 := 1000;
        Y23 := TRUE;
        Y2 := TRUE;

    60:
        D20 := 6000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 8000;
        D29 := 1000;
        Y22 := TRUE;
        D32 := 0;
        D33 := 1000;
        Y23 := TRUE;
        Y2 := TRUE;

ELSE
        D20 := 6000;
        D21 := 1000;
        Y20 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y21 := FALSE;
        D28 := 8000;
        D29 := 1000;
        Y22 := FALSE;
        D32 := 0;
        D33 := 1000;
        Y23 := FALSE;
        Y2 := FALSE;
        state := 0;
END_CASE;

CASE state OF
    0:
        IF X0 THEN
            reqFirst := D101;
            reqSecond := D102;
            reqLane := D103;
            state := 10;
        END_IF;

    10:
        IF aAtFirst AND bAtRetract AND cAtWork AND dAtLane THEN
            state := 20;
        END_IF;

    20:
        IF (NOT aAtFirst) OR (NOT cAtWork) OR (NOT dAtLane) THEN
            state := 10;
        ELSIF bAtGuide THEN
            state := 30;
        END_IF;

    30:
        IF (NOT cAtWork) OR (NOT dAtLane) OR (NOT bEngaged) THEN
            state := 10;
        ELSIF aAtSecond AND bAtGuide AND cAtWork AND dAtLane THEN
            state := 40;
        END_IF;

    40:
        state := 45;

    45:
        IF bAtRetract THEN
            state := 50;
        END_IF;

    50:
        IF aAtHome AND bAtRetract AND cAtStandby AND dAtHome THEN
            state := 60;
        END_IF;

    60:
        state := 60;

ELSE
        state := 0;
END_CASE;

END_PROGRAM