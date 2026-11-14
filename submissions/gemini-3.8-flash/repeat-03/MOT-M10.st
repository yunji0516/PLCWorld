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
    state : INT := 0;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        D20 := 20000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        IF X0 THEN
            state := 10;
        END_IF;

    10:
        D20 := 50000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D10 - 50000) <= 20) AND (ABS(D11) <= 100) THEN
            state := 20;
        END_IF;

    20:
        D20 := 50000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 9000;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D12 - 9000) <= 20) AND (ABS(D13) <= 100) THEN
            state := 30;
        END_IF;

    30:
        D20 := LIMIT(0, D101, 100000);
        D21 := 1000;
        Y20 := TRUE;
        D24 := 9000;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D10 - LIMIT(0, D101, 100000)) <= 20) AND (ABS(D11) <= 100) THEN
            state := 40;
        END_IF;

    40:
        D20 := 50000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 9000;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D10 - 50000) <= 20) AND (ABS(D11) <= 100) THEN
            state := 50;
        END_IF;

    50:
        D20 := 50000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            state := 60;
        END_IF;

    60:
        D20 := 20000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        IF (ABS(D10 - 20000) <= 20) AND (ABS(D11) <= 100) THEN
            state := 70;
        END_IF;

    70:
        D20 := 20000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM