PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    r_trig_start : R_TRIG;
    ton_align : TON;
    ton_down1 : TON;
    ton_grip : TON;
    ton_up1 : TON;
    ton_adv : TON;
    ton_down2 : TON;
    ton_rel : TON;
    ton_up2 : TON;
    ton_ret : TON;
END_VAR

r_trig_start(CLK := X10);

ton_align(IN := (state = 1 AND X31 AND X32), PT := T#50ms);
ton_down1(IN := (state = 3 AND X22), PT := T#100ms);
ton_grip(IN := (state = 4 AND X24), PT := T#50ms);
ton_up1(IN := (state = 5 AND X23), PT := T#100ms);
ton_adv(IN := (state = 6 AND X21), PT := T#100ms);
ton_down2(IN := (state = 7 AND X22), PT := T#100ms);
ton_rel(IN := (state = 8 AND X25 AND X27), PT := T#50ms);
ton_up2(IN := (state = 9 AND X23), PT := T#100ms);
ton_ret(IN := (state = 10 AND X20), PT := T#100ms);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF
    0:
        IF r_trig_start.Q AND (D10 = 1) THEN
            IF X31 AND X32 THEN
                state := 3;
            ELSE
                state := 1;
            END_IF;
        END_IF;

    1:
        Y25 := TRUE;
        Y26 := TRUE;
        IF ton_align.Q THEN
            state := 2;
        END_IF;

    2:
        IF X29 THEN
            state := 3;
        END_IF;

    3:
        IF NOT X22 THEN
            Y24 := TRUE;
        ELSIF X28 OR ton_down1.Q THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        IF ton_grip.Q THEN
            state := 5;
        END_IF;

    5:
        Y20 := TRUE;
        IF NOT X23 THEN
            Y23 := TRUE;
        ELSIF X28 OR ton_up1.Q THEN
            state := 6;
        END_IF;

    6:
        Y20 := TRUE;
        IF NOT X21 THEN
            Y21 := TRUE;
        ELSIF X28 OR ton_adv.Q THEN
            state := 7;
        END_IF;

    7:
        Y20 := TRUE;
        IF NOT X22 THEN
            Y24 := TRUE;
        ELSIF X28 OR ton_down2.Q THEN
            state := 8;
        END_IF;

    8:
        IF ton_rel.Q THEN
            state := 9;
        END_IF;

    9:
        IF NOT X23 THEN
            Y23 := TRUE;
        ELSIF X28 OR ton_up2.Q THEN
            state := 10;
        END_IF;

    10:
        IF NOT X20 THEN
            Y22 := TRUE;
        ELSIF X28 OR ton_ret.Q THEN
            state := 11;
        END_IF;

    11:
        Y2 := TRUE;
END_CASE;

END_PROGRAM