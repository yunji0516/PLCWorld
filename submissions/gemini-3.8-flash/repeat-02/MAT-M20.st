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

    r_trig_x10 : R_TRIG;
    state : INT := 0;
END_VAR

r_trig_x10(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF r_trig_x10.Q THEN
            IF X20 THEN
                state := 2;
            ELSE
                state := 1;
            END_IF;
        END_IF;

    1:
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X20 THEN
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X23 AND (D20 >= 699) THEN
            Y22 := FALSE;
            state := 3;
        END_IF;

    3:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            Y23 := FALSE;
            state := 4;
        END_IF;

    4:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            Y21 := FALSE;
            state := 5;
        END_IF;

    5:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
END_CASE;

END_PROGRAM