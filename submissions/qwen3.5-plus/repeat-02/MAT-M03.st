PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
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
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL;
    
    startEdge : R_TRIG;
    step : INT := 0;
END_VAR

Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;

startEdge(CLK := X10);

CASE step OF
    0: 
        IF startEdge.Q THEN
            step := 1;
        END_IF;
    1: 
        Y24 := TRUE;
        IF X22 THEN
            step := 2;
        END_IF;
    2: 
        Y25 := TRUE;
        Y26 := TRUE;
        IF X31 AND X32 THEN
            step := 3;
        END_IF;
    3: 
        Y20 := TRUE;
        IF X24 THEN
            step := 4;
        END_IF;
    4: 
        IF X29 THEN
            step := 5;
        END_IF;
    5: 
        Y23 := TRUE;
        IF X23 THEN
            step := 6;
        END_IF;
    6: 
        Y21 := TRUE;
        IF X21 THEN
            step := 7;
        END_IF;
    7: 
        Y24 := TRUE;
        IF X22 THEN
            step := 8;
        END_IF;
    8: 
        IF X25 THEN
            step := 9;
        END_IF;
    9: 
        Y23 := TRUE;
        IF X23 THEN
            step := 10;
        END_IF;
    10: 
        Y22 := TRUE;
        IF X20 THEN
            step := 11;
        END_IF;
    11: 
        Y2 := TRUE;
END_CASE;

END_PROGRAM