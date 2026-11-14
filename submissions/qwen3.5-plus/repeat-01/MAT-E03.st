PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    
    start_edge : R_TRIG;
    selected : INT;
    release_active : BOOL;
    complete : BOOL;
END_VAR

start_edge(CLK := X10);

IF NOT complete THEN
    IF NOT release_active AND start_edge.Q THEN
        selected := D10;
        release_active := TRUE;
        
        IF (selected AND 1) <> 0 THEN
            Y20 := TRUE;
        END_IF;
        
        IF (selected AND 2) <> 0 THEN
            Y21 := TRUE;
        END_IF;
        
        IF (selected AND 4) <> 0 THEN
            Y22 := TRUE;
        END_IF;
    END_IF;
    
    IF release_active THEN
        complete := TRUE;
        
        IF (selected AND 1) <> 0 THEN
            IF X20 THEN complete := FALSE; END_IF;
        ELSE
            IF NOT X20 THEN complete := FALSE; END_IF;
        END_IF;
        
        IF (selected AND 2) <> 0 THEN
            IF X21 THEN complete := FALSE; END_IF;
        ELSE
            IF NOT X21 THEN complete := FALSE; END_IF;
        END_IF;
        
        IF (selected AND 4) <> 0 THEN
            IF X22 THEN complete := FALSE; END_IF;
        ELSE
            IF NOT X22 THEN complete := FALSE; END_IF;
        END_IF;
        
        IF complete THEN
            Y2 := TRUE;
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM