PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    
    step : INT := 0;
    started : BOOL := FALSE;
    edgeStart : R_TRIG;
END_VAR

edgeStart(CLK := X10);
IF edgeStart.Q THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
ELSE
    CASE step OF
        0: 
            Y20 := TRUE;
            IF X21 THEN
                Y20 := FALSE;
                step := 1;
            END_IF;
        1: 
            IF X23 THEN
                step := 2;
            ELSE
                step := 3;
            END_IF;
        2: 
            Y23 := FALSE;
            IF NOT X23 THEN
                step := 3;
            END_IF;
        3: 
            Y23 := TRUE;
            IF X23 THEN
                step := 4;
            END_IF;
        4: 
            Y22 := TRUE;
            IF X25 THEN
                step := 5;
            END_IF;
        5: 
            Y21 := TRUE;
            IF X20 THEN
                Y21 := FALSE;
                step := 6;
            END_IF;
        6: 
            Y23 := FALSE;
            IF NOT X23 THEN
                step := 7;
            END_IF;
        7: 
            Y2 := TRUE;
            Y20 := FALSE;
            Y21 := FALSE;
            Y23 := FALSE;
    END_CASE;
END_IF;

END_PROGRAM