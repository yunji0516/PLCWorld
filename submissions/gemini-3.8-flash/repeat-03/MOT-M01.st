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
    init_s : DINT := 0;
    init_u : DINT := 0;

    ton_v_up : TON;
    ton_horiz : TON;
    ton_settle : TON;
END_VAR

IF (state = 0) AND X10 THEN
    target_s := D10;
    target_u := D13;
    init_s := D11;
    init_u := D14;
    state := 10;
END_IF;

ton_v_up(
    IN := (state = 10) AND (ABS(D16 - 40000) <= 20) AND (ABS(D17) <= 100),
    PT := T#30ms
);

ton_horiz(
    IN := (state = 20) AND (ABS(D11 - target_s) <= 20) AND (ABS(D12) <= 100)
                       AND (ABS(D14 - target_u) <= 20) AND (ABS(D15) <= 100),
    PT := T#30ms
);

ton_settle(
    IN := (state = 30) AND (ABS(D11 - target_s) <= 20) AND (ABS(D12) <= 100)
                       AND (ABS(D14 - target_u) <= 20) AND (ABS(D15) <= 100)
                       AND (ABS(D16) <= 20) AND (ABS(D17) <= 100),
    PT := T#30ms
);

IF (state = 10) AND ton_v_up.Q THEN
    state := 20;
ELSIF (state = 20) AND ton_horiz.Q THEN
    state := 30;
ELSIF (state = 30) AND ton_settle.Q THEN
    state := 40;
END_IF;

CASE state OF
    0:
        D20 := D11;
        Y20 := FALSE;
        D21 := D14;
        Y21 := FALSE;
        D22 := D16;
        Y22 := FALSE;
        Y2 := FALSE;
    10:
        D20 := init_s;
        Y20 := FALSE;
        D21 := init_u;
        Y21 := FALSE;
        D22 := 40000;
        Y22 := TRUE;
        Y2 := FALSE;
    20:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 40000;
        Y22 := TRUE;
        Y2 := FALSE;
    30:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 0;
        Y22 := TRUE;
        Y2 := FALSE;
    40:
        D20 := target_s;
        Y20 := TRUE;
        D21 := target_u;
        Y21 := TRUE;
        D22 := 0;
        Y22 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM