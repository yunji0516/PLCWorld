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

    step : INT := 0;
END_VAR

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;
        D28 := 0;
        D29 := 1000;
        IF X0 THEN
            step := 10;
        END_IF;

    10:
        Y20 := TRUE;
        D20 := D101;
        D21 := 1000;
        Y21 := FALSE;
        D24 := 0;
        D25 := 1000;
        Y22 := FALSE;
        D28 := 0;
        D29 := 1000;
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 THEN
            step := 20;
        END_IF;

    20:
        Y20 := TRUE;
        D20 := D101;
        D21 := 1000;
        Y21 := TRUE;
        D24 := D103;
        D25 := 1000;
        IF ABS(D12 - D103) <= 20 AND ABS(D13) <= 100 THEN
            step := 30;
        END_IF;

    30:
        Y20 := TRUE;
        D20 := D101;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            step := 40;
        END_IF;

    40:
        Y20 := TRUE;
        D20 := D102;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 THEN
            step := 50;
        END_IF;

    50:
        Y20 := TRUE;
        D20 := D102;
        D21 := 1000;
        Y22 := TRUE;
        D28 := D104;
        D29 := 1000;
        IF ABS(D14 - D104) <= 20 AND ABS(D15) <= 100 THEN
            step := 60;
        END_IF;

    60:
        Y20 := TRUE;
        D20 := D102;
        D21 := 1000;
        Y22 := TRUE;
        D28 := 0;
        D29 := 1000;
        IF ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            step := 70;
        END_IF;

    70:
        Y20 := TRUE;
        D20 := D102;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y22 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y2 := TRUE;
END_CASE;

END_PROGRAM