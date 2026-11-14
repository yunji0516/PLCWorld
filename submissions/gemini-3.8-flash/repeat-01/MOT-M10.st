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
    req_s : DINT := 0;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        D20 := 20000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        Y2 := FALSE;
        IF X0 THEN
            req_s := D101;
            state := 10;
        END_IF;

    10:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        Y2 := FALSE;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 THEN
            state := 20;
        END_IF;

    20:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 1000;
        D24 := 9000;
        D25 := 1000;
        Y2 := FALSE;
        IF ABS(D12 - 9000) <= 20 AND ABS(D13) <= 100 THEN
            state := 30;
        END_IF;

    30:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := req_s;
        D21 := 1000;
        D24 := 9000;
        D25 := 1000;
        Y2 := FALSE;
        IF ABS(D10 - req_s) <= 20 AND ABS(D11) <= 100 THEN
            state := 40;
        END_IF;

    40:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 1000;
        D24 := 9000;
        D25 := 1000;
        Y2 := FALSE;
        IF ABS(D10 - 50000) <= 20 AND ABS(D11) <= 100 THEN
            state := 50;
        END_IF;

    50:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 50000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        Y2 := FALSE;
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 60;
        END_IF;

    60:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 20000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        Y2 := FALSE;
        IF ABS(D10 - 20000) <= 20 AND ABS(D11) <= 100 THEN
            state := 70;
            Y2 := TRUE;
        END_IF;

    70:
        Y20 := TRUE;
        Y21 := TRUE;
        D20 := 20000;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        Y2 := TRUE;
END_CASE;

END_PROGRAM