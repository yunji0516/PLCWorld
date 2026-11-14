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
    target_val : DINT := 0;
    stroke_val : DINT := 0;
END_VAR

CASE state OF
    0:
        IF X0 THEN
            target_val := D101;
            stroke_val := D102;
            state := 10;
        END_IF;

    10:
        IF ABS(D10 - 10000) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            state := 20;
        END_IF;

    20:
        IF ABS(D14 - target_val) <= 20 AND ABS(D15) <= 100 THEN
            state := 30;
        END_IF;

    30:
        IF ABS(D16 - 7000) <= 20 AND ABS(D17) <= 100 THEN
            state := 40;
        END_IF;

    40:
        IF ABS(D18 - stroke_val) <= 20 AND ABS(D19) <= 100 THEN
            state := 50;
        END_IF;

    50:
        IF ABS(D18) <= 20 AND ABS(D19) <= 100 THEN
            state := 60;
        END_IF;

    60:
        IF ABS(D16) <= 20 AND ABS(D17) <= 100 THEN
            state := 70;
        END_IF;

    70:
        IF ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            state := 80;
        END_IF;

    80:
        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 90;
        END_IF;

    90:
        ;
END_CASE;

IF state >= 10 AND state <= 70 THEN
    D20 := 10000;
    D21 := 1000;
    Y20 := TRUE;
    D24 := 10000;
    D25 := 1000;
    Y21 := TRUE;
ELSIF state >= 80 THEN
    D20 := 0;
    D21 := 1000;
    Y20 := TRUE;
    D24 := 0;
    D25 := 1000;
    Y21 := TRUE;
ELSE
    D20 := 0;
    D21 := 0;
    Y20 := FALSE;
    D24 := 0;
    D25 := 0;
    Y21 := FALSE;
END_IF;

IF state >= 20 AND state <= 60 THEN
    D28 := target_val;
    D29 := 1000;
    Y22 := TRUE;
ELSIF state >= 70 THEN
    D28 := 0;
    D29 := 1000;
    Y22 := TRUE;
ELSE
    D28 := 0;
    D29 := 0;
    Y22 := FALSE;
END_IF;

IF state >= 30 AND state <= 50 THEN
    D32 := 7000;
    D33 := 1000;
    Y23 := TRUE;
ELSIF state >= 60 THEN
    D32 := 0;
    D33 := 1000;
    Y23 := TRUE;
ELSE
    D32 := 0;
    D33 := 0;
    Y23 := FALSE;
END_IF;

IF state = 40 THEN
    D36 := stroke_val;
    D37 := 1000;
    Y24 := TRUE;
ELSIF state >= 50 THEN
    D36 := 0;
    D37 := 1000;
    Y24 := TRUE;
ELSE
    D36 := 0;
    D37 := 0;
    Y24 := FALSE;
END_IF;

Y2 := (state = 90);

END_PROGRAM