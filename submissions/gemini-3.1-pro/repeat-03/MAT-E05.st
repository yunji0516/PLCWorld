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
    
    start_trig : R_TRIG;
    state : INT := 0;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        IF start_trig.Q THEN
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        IF X20 AND X21 THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;
        
    3:
        Y2 := TRUE;
END_CASE;

END_PROGRAM