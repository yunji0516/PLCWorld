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

    step : INT := 0;
    latched_target : DINT := 0;
    latched_stroke : DINT := 0;
END_VAR

CASE step OF
    0:
        IF X0 THEN
            latched_target := LIMIT(0, D101, 40000);
            latched_stroke := LIMIT(0, D102, 21000);
            step := 10;
        END_IF;

    10:
        IF ABS(D10 - 10000) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            step := 20;
        END_IF;

    20:
        IF ABS(D14 - latched_target) <= 20 AND ABS(D15) <= 100 THEN
            step := 30;
        END_IF;

    30:
        IF ABS(D16 - 7000) <= 20 AND ABS(D17) <= 100 THEN
            step := 40;
        END_IF;

    40:
        IF ABS(D18 - latched_stroke) <= 20 AND ABS(D19) <= 100 THEN
            step := 50;
        END_IF;

    50:
        IF ABS(D18) <= 20 AND ABS(D19) <= 100 THEN
            step := 60;
        END_IF;

    60:
        IF ABS(D16) <= 20 AND ABS(D17) <= 100 THEN
            step := 70;
        END_IF;

    70:
        IF ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            step := 80;
        END_IF;

    80:
        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            step := 90;
        END_IF;

    90:
        ;
END_CASE;

D21 := 1000;
D25 := 1000;
D29 := 1000;
D33 := 1000;
D37 := 1000;

Y20 := (step >= 10);
Y21 := (step >= 10);
Y22 := (step >= 20);
Y23 := (step >= 30);
Y24 := (step >= 40);

IF step >= 10 AND step < 80 THEN
    D20 := 10000;
    D24 := 10000;
ELSE
    D20 := 0;
    D24 := 0;
END_IF;

IF step >= 20 AND step < 70 THEN
    D28 := latched_target;
ELSE
    D28 := 0;
END_IF;

IF step >= 30 AND step < 60 THEN
    D32 := 7000;
ELSE
    D32 := 0;
END_IF;

IF step >= 40 AND step < 50 THEN
    D36 := latched_stroke;
ELSE
    D36 := 0;
END_IF;

Y2 := (step >= 90);

END_PROGRAM