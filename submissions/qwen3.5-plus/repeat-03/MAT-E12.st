PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;
    
    x10_edge : R_TRIG;
    started : BOOL;
END_VAR

x10_edge(CLK := X10);

IF NOT started AND x10_edge.Q THEN
    started := TRUE;
END_IF;

IF started THEN
    IF D20 = 2 THEN
        Y20 := FALSE;
        Y2 := TRUE;
    ELSE
        Y20 := TRUE;
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM