PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    started : BOOL;
    completed : BOOL;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    started := TRUE;
END_IF;

IF completed THEN
    Y20 := FALSE;
    Y2 := TRUE;
ELSIF started THEN
    IF D20 = D10 THEN
        Y20 := FALSE;
        Y2 := TRUE;
        completed := TRUE;
    ELSE
        Y20 := TRUE;
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM