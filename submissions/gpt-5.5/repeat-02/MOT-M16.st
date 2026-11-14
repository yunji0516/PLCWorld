PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    state : INT;
    target_cmd : DINT;
    depth_cmd : DINT;
    base_count : DINT;
    done_latch : BOOL;
    a_at_target : BOOL;
    b_at_depth : BOOL;
    b_at_zero : BOOL;
    pos_tol : DINT := 20;
    speed_tol : DINT := 100;
    full_rate : DINT := 1000;
END_VAR

IF state = 0 THEN
    target_cmd := D101;
    depth_cmd := D102;
    IF X0 THEN
        state := 10;
    END_IF;
END_IF;

a_at_target := (ABS(D10 - target_cmd) <= pos_tol) AND (ABS(D11) <= speed_tol);
b_at_depth := (ABS(D12 - depth_cmd) <= pos_tol) AND (ABS(D13) <= speed_tol);
b_at_zero := (ABS(D12) <= pos_tol) AND (ABS(D13) <= speed_tol);

D20 := target_cmd;
D21 := full_rate;
D24 := depth_cmd;
D25 := full_rate;
Y20 := FALSE;
Y21 := FALSE;
Y30 := FALSE;

IF state <> 0 THEN
    Y20 := TRUE;
    Y21 := TRUE;
END_IF;

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;

    10:
        IF a_at_target AND b_at_depth AND (NOT X34) THEN
            state := 20;
        END_IF;

    20:
        IF a_at_target AND b_at_depth AND (NOT X34) THEN
            base_count := D95;
            Y30 := TRUE;
            state := 30;
        ELSE
            state := 10;
        END_IF;

    30:
        IF X35 AND (D95 > base_count) THEN
            state := 40;
        END_IF;

    40:
        D24 := 0;
        IF a_at_target AND b_at_zero THEN
            done_latch := TRUE;
            state := 50;
        END_IF;

    50:
        D24 := 0;
        done_latch := TRUE;

ELSE
    state := 0;
END_CASE;

Y2 := done_latch;

END_PROGRAM