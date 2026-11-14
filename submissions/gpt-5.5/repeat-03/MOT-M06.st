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
    req_target : DINT := 23000;
    req_stroke : DINT := 17000;
    a_open : BOOL;
    b_open : BOOL;
    c_at_target : BOOL;
    d_at_dock : BOOL;
    e_at_stroke : BOOL;
    a_zero : BOOL;
    b_zero : BOOL;
    c_zero : BOOL;
    d_zero : BOOL;
    e_zero : BOOL;
END_VAR

a_open := (ABS(D10 - 10000) <= 20) AND (ABS(D11) <= 100);
b_open := (ABS(D12 - 10000) <= 20) AND (ABS(D13) <= 100);
c_at_target := (ABS(D14 - req_target) <= 20) AND (ABS(D15) <= 100);
d_at_dock := (ABS(D16 - 7000) <= 20) AND (ABS(D17) <= 100);
e_at_stroke := (ABS(D18 - req_stroke) <= 20) AND (ABS(D19) <= 100);

a_zero := (ABS(D10) <= 20) AND (ABS(D11) <= 100);
b_zero := (ABS(D12) <= 20) AND (ABS(D13) <= 100);
c_zero := (ABS(D14) <= 20) AND (ABS(D15) <= 100);
d_zero := (ABS(D16) <= 20) AND (ABS(D17) <= 100);
e_zero := (ABS(D18) <= 20) AND (ABS(D19) <= 100);

IF step = 0 THEN
    IF X0 THEN
        IF D101 < 23000 THEN
            req_target := 23000;
        ELSIF D101 > 24000 THEN
            req_target := 24000;
        ELSE
            req_target := D101;
        END_IF;

        IF D102 < 17000 THEN
            req_stroke := 17000;
        ELSIF D102 > 18000 THEN
            req_stroke := 18000;
        ELSE
            req_stroke := D102;
        END_IF;

        step := 10;
    END_IF;
END_IF;

CASE step OF
    0:
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

    10:
        D20 := 10000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := req_target;
        D29 := 1000;
        Y22 := FALSE;
        D32 := 7000;
        D33 := 1000;
        Y23 := FALSE;
        D36 := 0;
        D37 := 1000;
        Y24 := FALSE;
        Y2 := FALSE;

        IF a_open AND b_open THEN
            step := 20;
        END_IF;

    20:
        D20 := 10000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := req_target;
        D29 := 1000;
        Y22 := TRUE;
        D32 := 7000;
        D33 := 1000;
        Y23 := FALSE;
        D36 := 0;
        D37 := 1000;
        Y24 := FALSE;
        Y2 := FALSE;

        IF c_at_target THEN
            step := 30;
        END_IF;

    30:
        D20 := 10000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := req_target;
        D29 := 1000;
        Y22 := TRUE;
        D32 := 7000;
        D33 := 1000;
        Y23 := TRUE;
        D36 := req_stroke;
        D37 := 1000;
        Y24 := FALSE;
        Y2 := FALSE;

        IF d_at_dock THEN
            step := 40;
        END_IF;

    40:
        D20 := 10000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := req_target;
        D29 := 1000;
        Y22 := TRUE;
        D32 := 7000;
        D33 := 1000;
        Y23 := TRUE;
        D36 := req_stroke;
        D37 := 1000;
        Y24 := TRUE;
        Y2 := FALSE;

        IF e_at_stroke THEN
            step := 50;
        END_IF;

    50:
        D20 := 10000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := req_target;
        D29 := 1000;
        Y22 := TRUE;
        D32 := 7000;
        D33 := 1000;
        Y23 := TRUE;
        D36 := 0;
        D37 := 1000;
        Y24 := TRUE;
        Y2 := FALSE;

        IF e_zero THEN
            step := 60;
        END_IF;

    60:
        D20 := 10000;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 10000;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        D32 := 0;
        D33 := 1000;
        Y23 := TRUE;
        D36 := 0;
        D37 := 1000;
        Y24 := TRUE;
        Y2 := FALSE;

        IF c_zero AND d_zero AND e_zero THEN
            step := 70;
        END_IF;

    70:
        D20 := 0;
        D21 := 1000;
        Y20 := TRUE;
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        D28 := 0;
        D29 := 1000;
        Y22 := TRUE;
        D32 := 0;
        D33 := 1000;
        Y23 := TRUE;
        D36 := 0;
        D37 := 1000;
        Y24 := TRUE;
        Y2 := FALSE;

        IF a_zero AND b_zero AND c_zero AND d_zero AND e_zero THEN
            step := 100;
        END_IF;

    100:
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
        Y2 := TRUE;

ELSE
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
        step := 0;
END_CASE;

END_PROGRAM