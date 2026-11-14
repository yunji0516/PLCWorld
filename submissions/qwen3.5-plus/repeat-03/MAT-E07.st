PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    D20 : INT;
    start_edge : R_TRIG;
    state : INT := 0;
    y2_claimed : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X22 THEN
            Y20 := FALSE;
            state := 2;
        END_IF;
    2:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            state := 3;
        END_IF;
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        y2_claimed := TRUE;
END_CASE;

Y2 := y2_claimed;

END_PROGRAM