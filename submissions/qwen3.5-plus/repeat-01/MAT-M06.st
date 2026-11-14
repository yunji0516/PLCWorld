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
    
    start_edge : R_TRIG;
    state : INT := 0;
    target_vol : INT := 0;
END_VAR

start_edge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

CASE state OF
    0:
        IF start_edge.Q THEN
            target_vol := D10;
            state := 1;
        END_IF;
    1:
        Y20 := TRUE;
        IF X21 THEN
            state := 2;
        END_IF;
    2:
        Y22 := TRUE;
        IF X22 THEN
            state := 3;
        END_IF;
    3:
        Y23 := TRUE;
        IF D20 >= target_vol THEN
            state := 4;
        END_IF;
    4:
        IF X23 THEN
            state := 5;
        END_IF;
    5:
        Y21 := TRUE;
        IF X20 THEN
            state := 6;
        END_IF;
    6:
        Y2 := TRUE;
END_CASE;

END_PROGRAM