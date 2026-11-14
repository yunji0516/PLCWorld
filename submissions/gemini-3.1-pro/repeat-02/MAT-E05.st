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
    
    step : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            step := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        IF X20 AND X21 THEN
            step := 2;
        END_IF;
        
    2:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X22 THEN
            step := 3;
        END_IF;
        
    3:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM