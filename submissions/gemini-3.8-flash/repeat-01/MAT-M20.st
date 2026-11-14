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
    D20 : INT;

    state : INT := 0;
    r_trig_start : R_TRIG;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF r_trig_start.Q AND (D10 = 1) THEN
            state := 10;
        END_IF;

    10:
        IF X20 THEN
            Y20 := FALSE;
            state := 20;
        ELSE
            Y20 := TRUE;
            Y21 := FALSE;
        END_IF;

    20:
        IF X23 AND (D20 >= 699) THEN
            Y22 := FALSE;
            state := 30;
        ELSE
            Y22 := TRUE;
            Y23 := FALSE;
        END_IF;

    30:
        IF X22 THEN
            Y23 := FALSE;
            state := 40;
        ELSE
            Y23 := TRUE;
            Y22 := FALSE;
        END_IF;

    40:
        IF X21 THEN
            Y21 := FALSE;
            state := 50;
        ELSE
            Y21 := TRUE;
            Y20 := FALSE;
        END_IF;

    50:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM