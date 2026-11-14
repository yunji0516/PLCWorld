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

    r_trig_start : R_TRIG;
    state : INT := 0;
    target_vol : INT := 0;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF r_trig_start.Q THEN
            target_vol := D10;
            Y20 := TRUE;
            state := 1;
        END_IF;

    1:
        IF X21 THEN
            Y20 := FALSE;
            Y22 := TRUE;
            state := 2;
        ELSE
            Y20 := TRUE;
        END_IF;

    2:
        IF X22 THEN
            Y23 := TRUE;
            state := 3;
        ELSE
            Y22 := TRUE;
        END_IF;

    3:
        IF D20 >= target_vol THEN
            Y23 := FALSE;
            Y22 := FALSE;
            state := 4;
        ELSE
            Y22 := TRUE;
            Y23 := TRUE;
        END_IF;

    4:
        IF X23 THEN
            Y21 := TRUE;
            state := 5;
        ELSE
            Y22 := FALSE;
            Y23 := FALSE;
        END_IF;

    5:
        IF X20 THEN
            Y21 := FALSE;
            Y2 := TRUE;
            state := 6;
        ELSE
            Y21 := TRUE;
        END_IF;

    6:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM