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
    start_edge : R_TRIG;
    state : INT := 0;
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
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X20 THEN
            state := 2;
        END_IF;
        
    2:
        Y22 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF D20 >= 699 THEN
            state := 3;
        END_IF;
        
    3:
        Y23 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        IF X22 THEN
            state := 4;
        END_IF;
        
    4:
        Y21 := TRUE;
        Y20 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X21 THEN
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