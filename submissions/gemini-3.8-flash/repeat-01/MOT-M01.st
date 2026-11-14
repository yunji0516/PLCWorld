PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    target_s : DINT := 0;
    target_u : DINT := 0;
    s_settled : BOOL := FALSE;
    u_settled : BOOL := FALSE;
    v_settled : BOOL := FALSE;
    cond_xy : BOOL := FALSE;
    cond_final : BOOL := FALSE;
    t_settle_xy : TON;
    t_settle_final : TON;
END_VAR

s_settled := (ABS(D11 - target_s) <= 20) AND (ABS(D12) <= 100);
u_settled := (ABS(D14 - target_u) <= 20) AND (ABS(D15) <= 100);
v_settled := (ABS(D16) <= 20) AND (ABS(D17) <= 100);

cond_xy := (state = 2) AND s_settled AND u_settled;
t_settle_xy(IN := cond_xy, PT := T#30ms);

cond_final := (state = 3) AND s_settled AND u_settled AND v_settled;
t_settle_final(IN := cond_final, PT := T#30ms);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := D11;
        D21 := D14;
        D22 := D16;
        IF X10 THEN
            target_s := D10;
            target_u := D13;
            state := 1;
        END_IF;

    1:
        D22 := 45000;
        Y22 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF D16 >= 42000 THEN
            state := 2;
        END_IF;

    2:
        D22 := 45000;
        Y22 := TRUE;
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        Y2 := FALSE;
        IF t_settle_xy.Q THEN
            state := 3;
        END_IF;

    3:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 0;
        Y22 := TRUE;
        Y2 := FALSE;
        IF t_settle_final.Q THEN
            state := 4;
        END_IF;

    4:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 0;
        Y22 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM