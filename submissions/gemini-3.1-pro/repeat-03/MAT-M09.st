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
    
    state : INT := 0;
    x10_prev : BOOL := FALSE;
    x10_edge : BOOL := FALSE;
END_VAR

x10_edge := X10 AND NOT x10_prev;
x10_prev := X10;

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF x10_edge THEN
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X21 THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF NOT X23 AND X24 THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y2 := FALSE;
        IF X23 THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := TRUE;
        Y2 := FALSE;
        IF X22 AND X25 THEN
            state := 5;
        END_IF;
        
    5:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF X20 THEN
            state := 6;
        END_IF;
        
    6:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF NOT X23 THEN
            state := 7;
        END_IF;
        
    7:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM