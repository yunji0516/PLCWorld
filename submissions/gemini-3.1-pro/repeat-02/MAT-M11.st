PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q AND (D10 = 1) THEN
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        IF X20 AND X21 THEN
            state := 2;
        END_IF;
        
    2:
        Y22 := TRUE;
        IF X22 THEN
            state := 3;
        END_IF;
        
    3:
        Y24 := TRUE;
        IF X24 AND X25 THEN
            state := 4;
        END_IF;
        
    4:
        Y24 := FALSE;
        Y25 := TRUE;
        IF X23 THEN
            state := 5;
        END_IF;
        
    5:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y25 := FALSE;
        IF NOT X20 AND NOT X21 AND X26 THEN
            state := 6;
        END_IF;
        
    6:
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM