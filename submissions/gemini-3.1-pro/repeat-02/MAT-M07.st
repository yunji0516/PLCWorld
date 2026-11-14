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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    D20 : INT;
    
    state : INT := 0;
    target_spacing : INT := 0;
    initial_spacing : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            target_spacing := D10;
            initial_spacing := D20;
            state := 1;
        END_IF;
        
    1:
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            state := 2;
        END_IF;
        
    2:
        Y24 := TRUE;
        IF X24 THEN
            state := 3;
        END_IF;
        
    3:
        Y24 := TRUE;
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE;
            state := 4;
        END_IF;
        
    4:
        Y24 := TRUE;
        
        IF NOT X21 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
        END_IF;
        
        IF D20 < target_spacing - 1 THEN
            Y25 := TRUE;
            Y26 := FALSE;
        ELSIF D20 > target_spacing + 1 THEN
            Y25 := FALSE;
            Y26 := TRUE;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
        END_IF;
        
        IF X21 AND (D20 >= target_spacing - 1) AND (D20 <= target_spacing + 1) THEN
            Y20 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
            state := 5;
        END_IF;
        
    5:
        Y24 := TRUE;
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            state := 6;
        END_IF;
        
    6:
        Y24 := FALSE;
        IF X25 THEN
            state := 7;
        END_IF;
        
    7:
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE;
            state := 8;
        END_IF;
        
    8:
        IF NOT X20 THEN
            Y21 := TRUE;
        ELSE
            Y21 := FALSE;
        END_IF;
        
        IF D20 < initial_spacing - 1 THEN
            Y25 := TRUE;
            Y26 := FALSE;
        ELSIF D20 > initial_spacing + 1 THEN
            Y25 := FALSE;
            Y26 := TRUE;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
        END_IF;
        
        IF X20 AND (D20 >= initial_spacing - 1) AND (D20 <= initial_spacing + 1) THEN
            Y21 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
            state := 9;
        END_IF;
        
    9:
        Y2 := TRUE;
END_CASE;

END_PROGRAM