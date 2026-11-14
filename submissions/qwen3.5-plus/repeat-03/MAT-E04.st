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
    X23 : BOOL;
    
    startEdge : R_TRIG;
    step : INT := 0;
END_VAR

startEdge(CLK := X10);

CASE step OF
0:
    IF startEdge.Q THEN
        step := 1;
    END_IF;
    
1:
    Y21 := FALSE;
    IF NOT X21 THEN
        step := 2;
    END_IF;
    
2:
    Y21 := TRUE;
    IF X22 THEN
        step := 3;
    END_IF;
    
3:
    IF X21 THEN
        step := 4;
    END_IF;
    
4:
    Y20 := TRUE;
    IF X20 THEN
        step := 5;
    END_IF;
    
5:
    IF X23 THEN
        step := 6;
    END_IF;
    
6:
    Y21 := FALSE;
    IF NOT X21 THEN
        step := 7;
    END_IF;
    
7:
    Y2 := TRUE;
    Y20 := TRUE;
END_CASE;

END_PROGRAM