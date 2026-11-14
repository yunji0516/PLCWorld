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
    source_spacing : INT := 0;
    x10_prev : BOOL := FALSE;
    spacing_done : BOOL := FALSE;
END_VAR

IF X10 AND NOT x10_prev THEN
    IF state = 0 THEN
        target_spacing := D10;
        source_spacing := D20;
        state := 1;
    END_IF;
END_IF;
x10_prev := X10;

(* Default all non-holding outputs to FALSE *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF
    0:
        Y2 := FALSE;
        Y24 := FALSE;
        
    1: 
        Y24 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
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
            spacing_done := FALSE;
            state := 4;
        END_IF;
        
    4: 
        Y24 := TRUE;
        
        IF NOT X21 THEN
            Y20 := TRUE;
        END_IF;
        
        IF NOT spacing_done THEN
            IF D20 < target_spacing - 1 THEN
                Y25 := TRUE;
            ELSIF D20 > target_spacing + 1 THEN
                Y26 := TRUE;
            ELSE
                spacing_done := TRUE;
            END_IF;
        END_IF;
        
        IF X21 AND spacing_done THEN
            state := 5;
        END_IF;
        
    5: 
        Y24 := TRUE;
        Y23 := TRUE;
        IF X23 THEN
            state := 6;
        END_IF;
        
    6: 
        Y24 := FALSE;
        IF X25 THEN
            state := 7;
        END_IF;
        
    7: 
        Y24 := FALSE;
        Y22 := TRUE;
        IF X22 THEN
            spacing_done := FALSE;
            state := 8;
        END_IF;
        
    8: 
        Y24 := FALSE;
        
        IF NOT X20 THEN
            Y21 := TRUE;
        END_IF;
        
        IF NOT spacing_done THEN
            IF D20 < source_spacing - 1 THEN
                Y25 := TRUE;
            ELSIF D20 > source_spacing + 1 THEN
                Y26 := TRUE;
            ELSE
                spacing_done := TRUE;
            END_IF;
        END_IF;
        
        IF X20 AND spacing_done THEN
            state := 9;
        END_IF;
        
    9: 
        Y24 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM