PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    state : INT := 0;
    searchDir : INT := 0;
    edgeA : DINT := 0;
    finalTarget : DINT := 0;
    sensorSeenOff : BOOL := FALSE;
    refEdge : R_TRIG;
    configTimer : TON;
END_VAR

refEdge(CLK := X34);
configTimer(IN := (state = 70), PT := T#600ms);

finalTarget := D90 + D101;

D20 := 0;
D21 := 1000;
Y20 := FALSE;
D24 := 0;
D25 := 1000;
Y21 := FALSE;
D28 := 10000;
D29 := 1000;
Y22 := FALSE;
Y30 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        D20 := D10;
        D24 := 0;
        D28 := 10000;
        IF X0 THEN
            state := 10;
        END_IF;

    10:
        D20 := D10;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            state := 20;
        END_IF;

    20:
        D20 := D10;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) AND (ABS(D14 - 10000) <= 20) AND (ABS(D15) <= 100) THEN
            state := 30;
        END_IF;

    30:
        D20 := D10;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        sensorSeenOff := FALSE;
        IF X34 THEN
            IF D10 <= 10000 THEN
                searchDir := -1;
            ELSE
                searchDir := 1;
            END_IF;
            state := 35;
        ELSE
            sensorSeenOff := TRUE;
            IF D10 <= 10000 THEN
                searchDir := 1;
            ELSE
                searchDir := -1;
            END_IF;
            state := 40;
        END_IF;

    35:
        D21 := 100;
        Y20 := TRUE;
        IF searchDir >= 0 THEN
            D20 := 35000;
        ELSE
            D20 := 0;
        END_IF;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        IF NOT X34 THEN
            sensorSeenOff := TRUE;
            IF D10 <= 10000 THEN
                searchDir := 1;
            ELSE
                searchDir := -1;
            END_IF;
            state := 40;
        END_IF;

    40:
        D21 := 100;
        Y20 := TRUE;
        IF searchDir >= 0 THEN
            D20 := 35000;
        ELSE
            D20 := 0;
        END_IF;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;

        IF NOT X34 THEN
            sensorSeenOff := TRUE;
        END_IF;

        IF sensorSeenOff AND refEdge.Q THEN
            edgeA := D10;
            D20 := D10;
            state := 50;
        END_IF;

    50:
        D20 := edgeA;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        IF (ABS(D10 - edgeA) <= 20) AND (ABS(D11) <= 100) AND (ABS(D10 - edgeA) <= 1000) THEN
            state := 60;
        END_IF;

    60:
        D20 := edgeA;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        Y30 := TRUE;
        state := 70;

    70:
        D20 := edgeA;
        D21 := 100;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        Y30 := TRUE;
        IF configTimer.Q AND X35 THEN
            state := 80;
        END_IF;

    80:
        finalTarget := D90 + D101;
        D20 := finalTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        IF (ABS(D10 - finalTarget) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12) <= 20) AND (ABS(D13) <= 100) AND
           (ABS(D14 - 10000) <= 20) AND (ABS(D15) <= 100) THEN
            state := 90;
        END_IF;

    90:
        finalTarget := D90 + D101;
        D20 := finalTarget;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 10000;
        D29 := 1000;
        Y22 := TRUE;
        Y2 := TRUE;

ELSE
    state := 0;
END_CASE;

END_PROGRAM