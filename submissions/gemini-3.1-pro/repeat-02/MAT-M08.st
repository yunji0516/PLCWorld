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
    X26 : BOOL;
    D20 : INT;
    
    state : INT := 0;
    target : INT := 0;
    timer : INT := 0;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            state := 2;
            target := 0;
        END_IF;
        
    2:
        Y22 := FALSE;
        Y23 := FALSE;
        IF X22 THEN
            IF X25 AND (ABS(D20 - target) <= 1) THEN
                Y20 := FALSE;
                Y21 := FALSE;
                state := 3;
                timer := 0;
            ELSIF D20 < target THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 > target THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
        
    3:
        timer := timer + 1;
        IF timer > 5 THEN
            IF X24 THEN
                target := target + 160;
                IF target > 480 THEN
                    target := 480;
                END_IF;
                state := 2;
            ELSE
                state := 4;
            END_IF;
        END_IF;
        
    4:
        Y22 := TRUE;
        Y23 := FALSE;
        IF X23 THEN
            state := 5;
        END_IF;
        
    5:
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            state := 6;
        END_IF;
        
    6:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM