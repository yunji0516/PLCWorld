PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
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
    D20 : INT;

    state : INT := 0;
    p1_sel : BOOL := FALSE;
    p2_sel : BOOL := FALSE;
    p3_sel : BOOL := FALSE;
    release_ok : BOOL := FALSE;

    r_trig_x10 : R_TRIG;
    t_release : TON;
    t_release2 : TON;
    t_settle : TON;
END_VAR

r_trig_x10(CLK := X10);
t_release(IN := (state = 2), PT := T#250ms);
t_release2(IN := (state = 6), PT := T#250ms);
t_settle(IN := (state = 9), PT := T#50ms);

CASE state OF
    0:
        IF r_trig_x10.Q THEN
            p1_sel := (D10 MOD 2) = 1;
            p2_sel := ((D10 / 2) MOD 2) = 1;
            p3_sel := ((D10 / 4) MOD 2) = 1;
            state := 1;
        END_IF;

    1:
        IF X23 THEN
            state := 2;
        END_IF;

    2:
        release_ok := (p1_sel OR NOT X26) AND (p2_sel OR NOT X27) AND (p3_sel OR NOT X28);
        IF t_release.Q AND release_ok THEN
            state := 3;
        END_IF;

    3:
        IF X22 THEN
            state := 4;
        END_IF;

    4:
        IF X21 THEN
            state := 5;
        END_IF;

    5:
        IF X23 THEN
            state := 6;
        END_IF;

    6:
        IF t_release2.Q AND X25 THEN
            state := 7;
        END_IF;

    7:
        IF X22 THEN
            state := 8;
        END_IF;

    8:
        IF X20 THEN
            state := 9;
        END_IF;

    9:
        IF t_settle.Q THEN
            state := 10;
        END_IF;

    10:
        ;
END_CASE;

Y20 := (state = 4);
Y21 := (state = 8);
Y22 := (state = 3) OR (state = 7);
Y23 := (state = 1) OR (state = 5);

IF state >= 2 AND state < 6 THEN
    Y24 := NOT p1_sel;
    Y25 := NOT p2_sel;
    Y26 := NOT p3_sel;
ELSIF state >= 6 THEN
    Y24 := TRUE;
    Y25 := TRUE;
    Y26 := TRUE;
ELSE
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
END_IF;

Y2 := (state = 10);

END_PROGRAM