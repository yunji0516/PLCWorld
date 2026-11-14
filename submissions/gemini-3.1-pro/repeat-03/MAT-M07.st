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
    
    State : INT := 0;
    TargetD10 : INT := 0;
    SourceSpacing : INT := 0;
    EdgeX10 : R_TRIG;
END_VAR

EdgeX10(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE State OF
    0:
        IF EdgeX10.Q THEN
            TargetD10 := D10;
            SourceSpacing := D20;
            State := 1;
        END_IF
        
    1: 
        Y23 := TRUE;
        IF X23 THEN
            State := 2;
        END_IF
        
    2: 
        IF X24 THEN
            State := 3;
        END_IF
        
    3: 
        Y22 := TRUE;
        IF X22 THEN
            State := 4;
        END_IF
        
    4: 
        IF NOT X21 THEN
            Y20 := TRUE;
        END_IF
        
        IF D20 < (TargetD10 - 1) THEN
            Y25 := TRUE;
        ELSIF D20 > (TargetD10 + 1) THEN
            Y26 := TRUE;
        END_IF
        
        IF X21 AND NOT Y25 AND NOT Y26 THEN
            State := 5;
        END_IF
        
    5: 
        Y23 := TRUE;
        IF X23 THEN
            State := 6;
        END_IF
        
    6: 
        IF X25 THEN
            State := 7;
        END_IF
        
    7: 
        Y22 := TRUE;
        IF X22 THEN
            State := 8;
        END_IF
        
    8: 
        IF NOT X20 THEN
            Y21 := TRUE;
        END_IF
        
        IF D20 < (SourceSpacing - 1) THEN
            Y25 := TRUE;
        ELSIF D20 > (SourceSpacing + 1) THEN
            Y26 := TRUE;
        END_IF
        
        IF X20 AND NOT Y25 AND NOT Y26 THEN
            State := 9;
        END_IF
        
    9:
        Y2 := TRUE;
END_CASE

IF State >= 2 AND State <= 5 THEN
    Y24 := TRUE;
ELSE
    Y24 := FALSE;
END_IF

END_PROGRAM