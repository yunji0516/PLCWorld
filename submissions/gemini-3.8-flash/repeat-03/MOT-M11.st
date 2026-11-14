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
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
END_VAR

CASE state OF
    0:
        IF X0 THEN
            D20 := D101;
            D21 := 1000;
            Y20 := TRUE;
            state := 10;
        END_IF;

    10:
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 THEN
            D24 := D103;
            D25 := 1000;
            Y21 := TRUE;
            state := 20;
        END_IF;

    20:
        IF ABS(D12 - D103) <= 20 AND ABS(D13) <= 100 THEN
            D24 := 0;
            state := 30;
        END_IF;

    30:
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            D20 := D102;
            state := 40;
        END_IF;

    40:
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 THEN
            D28 := D104;
            D29 := 1000;
            Y22 := TRUE;
            state := 50;
        END_IF;

    50:
        IF ABS(D14 - D104) <= 20 AND ABS(D15) <= 100 THEN
            D28 := 0;
            state := 60;
        END_IF;

    60:
        IF ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            state := 70;
        END_IF;

    70:
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            Y2 := TRUE;
            state := 80;
        END_IF;

    80:
        Y2 := TRUE;
END_CASE;

END_PROGRAM