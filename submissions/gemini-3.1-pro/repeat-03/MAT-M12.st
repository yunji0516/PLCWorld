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
    
    step : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE step OF
    0:
        IF start_edge.Q AND D10 = 1 THEN
            step := 1;
        END_IF;
        
    1:
        IF X21 THEN
            step := 2;
        END_IF;
        
    2:
        IF X27 THEN
            step := 3;
        END_IF;
        
    3:
        IF X25 THEN
            step := 4;
        END_IF;
        
    4:
        IF X23 THEN
            step := 5;
        END_IF;
        
    5:
        IF X20 THEN
            step := 6;
        END_IF;
        
    6:
        IF X22 THEN
            step := 7;
        END_IF;
        
    7:
        IF X24 THEN
            step := 8;
        END_IF;
        
    8:
        IF X23 THEN
            step := 9;
        END_IF;
        
    9:
        IF X26 AND NOT X20 THEN
            step := 10;
        END_IF;
        
    10:
        IF X22 THEN
            step := 11;
        END_IF;
        
    11:
        ; (* Maintain terminal completion state *)
END_CASE;

Y20 := (step >= 5 AND step <= 8);
Y21 := (step >= 1);
Y22 := (step = 3 OR step = 6 OR step = 7 OR step = 10);
Y23 := (step = 4 OR step = 5 OR step = 8 OR step = 9);
Y24 := (step = 3 OR step = 4 OR step = 5 OR step = 6);
Y25 := (step = 7 OR step = 8 OR step = 9 OR step = 10);
Y26 := (step >= 2 AND step <= 10);
Y27 := FALSE;
Y2  := (step = 11);

END_PROGRAM