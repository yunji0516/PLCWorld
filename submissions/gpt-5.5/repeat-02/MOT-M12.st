PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y24 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y25 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y2 : BOOL;
    state : INT;
    approach_checked : BOOL;
    extraction_checked : BOOL;
    c_at_0 : BOOL;
    c_at_50 : BOOL;
    d_at_0 : BOOL;
    d_at_100 : BOOL;
    servo_rate : DINT := 200;
END_VAR

c_at_0 := (ABS(D10) <= 19) AND (ABS(D11) <= 99);
c_at_50 := (ABS(D10 - 5000) <= 19) AND (ABS(D11) <= 99);
d_at_0 := (ABS(D12) <= 19) AND (ABS(D13) <= 99);
d_at_100 := (ABS(D12 - 10000) <= 19) AND (ABS(D13) <= 99);

CASE state OF
    0:
        approach_checked := FALSE;
        extraction_checked := FALSE;
        IF X0 THEN
            state := 10;
        END_IF;

    10:
        IF X2 AND X3 AND c_at_0 AND X5 AND d_at_100 THEN
            state := 20;
        END_IF;

    20:
        IF X2 AND X3 AND X5 AND d_at_100 AND c_at_50 THEN
            approach_checked := TRUE;
            state := 30;
        END_IF;

    30:
        IF c_at_0 THEN
            state := 40;
        END_IF;

    40:
        IF X2 AND X4 AND c_at_0 THEN
            extraction_checked := TRUE;
            state := 50;
        END_IF;

    50:
        IF approach_checked AND extraction_checked AND X1 AND X3 AND c_at_0 AND d_at_0 THEN
            state := 60;
        END_IF;

    60:
        state := 60;

ELSE
    state := 0;
END_CASE;

D20 := 0;
D21 := 0;
Y24 := FALSE;
D24 := 0;
D25 := 0;
Y25 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y2 := FALSE;

CASE state OF
    10:
        D20 := 0;
        D21 := servo_rate;
        Y24 := TRUE;
        D24 := 10000;
        D25 := servo_rate;
        Y25 := TRUE;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;

    20:
        D20 := 5000;
        D21 := servo_rate;
        Y24 := TRUE;
        D24 := 10000;
        D25 := servo_rate;
        Y25 := TRUE;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;

    30:
        D20 := 0;
        D21 := servo_rate;
        Y24 := TRUE;
        D24 := 10000;
        D25 := servo_rate;
        Y25 := TRUE;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;

    40:
        D20 := 0;
        D21 := servo_rate;
        Y24 := FALSE;
        D24 := 0;
        D25 := servo_rate;
        Y25 := TRUE;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;

    50:
        D20 := 0;
        D21 := servo_rate;
        Y24 := FALSE;
        D24 := 0;
        D25 := servo_rate;
        Y25 := TRUE;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;

    60:
        D20 := 0;
        D21 := servo_rate;
        Y24 := FALSE;
        D24 := 0;
        D25 := servo_rate;
        Y25 := FALSE;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM