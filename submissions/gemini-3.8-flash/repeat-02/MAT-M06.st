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
    D20 : INT;
    D21 : INT;
    state : INT := 0;
    target_vol : INT := 0;
    r_trig_x10 : R_TRIG;
END_VAR

r_trig_x10(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF r_trig_x10.Q THEN
            target_vol := D10;
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X21 THEN
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := TRUE;
        Y2 := FALSE;
        IF D20 >= target_vol THEN
            Y23 := FALSE;
            Y22 := FALSE;
            state := 4;
        END_IF;

    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X23 THEN
            state := 5;
        END_IF;

    5:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            state := 6;
        END_IF;

    6:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM