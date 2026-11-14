PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    running : BOOL;
    completed : BOOL;
END_VAR

start_edge(CLK := X10);

IF NOT completed THEN
    Y2 := FALSE;
    IF start_edge.Q THEN
        running := TRUE;
    END_IF;
    
    IF running THEN
        Y20 := TRUE;
        IF D20 = 2 THEN
            running := FALSE;
            completed := TRUE;
        END_IF;
    ELSE
        Y20 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM