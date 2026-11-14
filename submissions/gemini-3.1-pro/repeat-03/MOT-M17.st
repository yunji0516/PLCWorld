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

    state : INT := 0;
    a_target_internal : DINT := 28000;
    b_target_internal : DINT := 0;
    c_target_internal : DINT := 0;
    d_target_internal : DINT := 0;

    a_in_pos : BOOL;
    b_in_pos : BOOL;
    c_in_pos : BOOL;
    d_in_pos : BOOL;
END_VAR

a_in_pos := ABS(D10 - a_target_internal) <= 20 AND ABS(D11) <= 100;
b_in_pos := ABS(D12 - b_target_internal) <= 20 AND ABS(D13) <= 100;
c_in_pos := ABS(D14 - c_target_internal) <= 20 AND ABS(D15) <= 100;
d_in_pos := ABS(D16 - d_target_internal) <= 20 AND ABS(D17) <= 100;

IF state = 0 THEN
    IF X0 THEN
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        a_target_internal := 0;
        state := 1;
    END_IF;
ELSIF state = 1 THEN
    IF a_in_pos THEN
        b_target_internal := 9000;
        state := 2;
    END_IF;
ELSIF state = 2 THEN
    IF b_in_pos THEN
        c_target_internal := D101;
        state := 3;
    END_IF;
ELSIF state = 3 THEN
    IF c_in_pos THEN
        d_target_internal := 10000;
        state := 4;
    END_IF;
ELSIF state = 4 THEN
    IF d_in_pos THEN
        b_target_internal := 0;
        state := 5;
    END_IF;
ELSIF state = 5 THEN
    IF b_in_pos THEN
        a_target_internal := 28000;
        c_target_internal := 0;
        state := 6;
    END_IF;
ELSIF state = 6 THEN
    IF a_in_pos AND c_in_pos THEN
        state := 7;
    END_IF;
ELSIF state = 7 THEN
    Y2 := TRUE;
END_IF;

D20 := a_target_internal;
D24 := b_target_internal;
D28 := c_target_internal;
D32 := d_target_internal;

D21 := 1000;
D25 := 1000;
D29 := 1000;
D33 := 1000;

END_PROGRAM