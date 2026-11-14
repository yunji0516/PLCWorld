PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;

    r_trig_x10 : R_TRIG;
    ton_reset : TON;
    state : INT := 0;
END_VAR

r_trig_x10(CLK := X10);
ton_reset(IN := NOT Y23, PT := T#3600ms);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF r_trig_x10.Q THEN
            state := 10;
        END_IF;

    10:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            Y20 := FALSE;
            state := 20;
        END_IF;

    20:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF ton_reset.Q AND (NOT X23) AND X24 THEN
            state := 30;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            state := 40;
        END_IF;

    40:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := TRUE;
        IF X22 AND X25 THEN
            state := 50;
        END_IF;

    50:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            state := 60;
        END_IF;

    60:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF NOT X23 THEN
            state := 70;
        END_IF;

    70:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
END_CASE;

END_PROGRAM