PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    state : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            state := 1;
            Y20 := TRUE;
        END_IF;
        
    1:
        IF D20 = D10 THEN
            Y20 := FALSE;
            Y2 := TRUE;
            state := 2;
        ELSE
            Y20 := TRUE;
        END_IF;
        
    2:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM