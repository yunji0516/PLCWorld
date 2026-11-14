PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    
    start_edge : R_TRIG;
    state : INT := 0;
    started : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    started := TRUE;
END_IF;

CASE state OF
    0:
        IF started AND X20 THEN
            started := FALSE;
            IF D20 = D10 THEN
                state := 1;
            ELSE
                state := 2;
            END_IF;
        END_IF;
        
    1:
        IF D20 = 0 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 3;
        ELSE
            Y20 := TRUE;
            Y21 := FALSE;
        END_IF;
        
    2:
        IF D20 = 0 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 3;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
        
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X20 THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM