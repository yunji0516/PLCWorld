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
    start_edge : R_TRIG;
    target_vol : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            target_vol := D10;
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X21 THEN
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        IF D20 >= target_vol THEN
            Y22 := FALSE;
            Y23 := FALSE;
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X23 THEN
            state := 4;
        END_IF;

    4:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X20 THEN
            state := 5;
        END_IF;

    5:
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM