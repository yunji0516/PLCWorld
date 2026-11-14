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
    Y26 : BOOL;
    Y27 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    D20 : INT;
    D21 : INT;
    
    state : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        Y25 := TRUE; Y24 := FALSE;
        Y22 := FALSE; Y23 := FALSE;
        Y20 := FALSE; Y21 := FALSE;
        Y26 := FALSE; Y27 := FALSE;
        IF X25 THEN
            state := 2;
        END_IF;
        
    2:
        Y23 := TRUE; Y22 := FALSE;
        Y20 := FALSE; Y21 := FALSE;
        Y24 := FALSE; Y25 := FALSE;
        Y26 := FALSE; Y27 := FALSE;
        IF X23 THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE; Y21 := TRUE;
        Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE;
        Y26 := FALSE; Y27 := FALSE;
        IF X20 AND X21 THEN
            state := 4;
        END_IF;
        
    4:
        Y22 := TRUE; Y23 := FALSE;
        Y20 := TRUE; Y21 := TRUE;
        Y24 := FALSE; Y25 := FALSE;
        Y26 := FALSE; Y27 := FALSE;
        IF X22 THEN
            state := 5;
        END_IF;
        
    5:
        Y24 := TRUE; Y25 := FALSE;
        Y22 := FALSE; Y23 := FALSE;
        Y20 := TRUE; Y21 := TRUE;
        Y26 := FALSE; Y27 := FALSE;
        IF X24 THEN
            state := 6;
        END_IF;
        
    6:
        Y23 := TRUE; Y22 := FALSE;
        Y20 := TRUE; Y21 := TRUE;
        Y24 := FALSE; Y25 := FALSE;
        Y26 := FALSE; Y27 := FALSE;
        IF X23 THEN
            state := 7;
        END_IF;
        
    7:
        Y20 := FALSE; Y21 := TRUE;
        Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE;
        Y26 := FALSE; Y27 := FALSE;
        IF NOT X20 THEN
            state := 8;
        END_IF;
        
    8:
        Y22 := TRUE; Y23 := FALSE;
        Y20 := FALSE; Y21 := TRUE;
        Y24 := FALSE; Y25 := FALSE;
        Y26 := FALSE; Y27 := FALSE;
        IF X22 THEN
            state := 9;
        END_IF;
        
    9:
        Y26 := TRUE; Y27 := FALSE;
        Y20 := FALSE; Y21 := TRUE;
        Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE;
        IF X27 THEN
            state := 10;
        END_IF;
        
    10:
        Y2 := TRUE;
        Y21 := TRUE;
        Y20 := FALSE; Y22 := FALSE; Y23 := FALSE;
        Y24 := FALSE; Y25 := FALSE; Y26 := FALSE; Y27 := FALSE;
END_CASE;

END_PROGRAM