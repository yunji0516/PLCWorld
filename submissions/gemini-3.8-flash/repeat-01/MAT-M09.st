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

    step : INT;
    r_trig_x10 : R_TRIG;
    ton_reset : TON;
END_VAR

r_trig_x10(CLK := X10);
ton_reset(IN := (NOT Y23), PT := T#3600ms);

CASE step OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF r_trig_x10.Q THEN
            step := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            Y20 := FALSE;
            step := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF ton_reset.Q AND (NOT X23) AND X24 THEN
            step := 3;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            step := 4;
        END_IF;

    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := TRUE;
        IF X22 AND X25 THEN
            step := 5;
        END_IF;

    5:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            step := 6;
        END_IF;

    6:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF (NOT X23) AND X25 AND X20 AND X22 THEN
            Y2 := TRUE;
            step := 7;
        END_IF;

    7:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
END_CASE;

END_PROGRAM