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
    D20 : INT;
    
    start_edge : R_TRIG;
    started : BOOL;
    opened : BOOL;
END_VAR

Y20 := TRUE;
Y21 := TRUE;

start_edge(CLK := X10);

IF NOT started AND start_edge.Q THEN
    started := TRUE;
    IF D20 >= D10 THEN
        opened := TRUE;
    END_IF;
END_IF;

IF started AND NOT opened THEN
    Y22 := TRUE;
    Y23 := FALSE;
    IF D20 >= D10 THEN
        opened := TRUE;
        Y22 := FALSE;
    END_IF;
ELSE
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

Y2 := opened AND X20 AND X21 AND (NOT Y22) AND (NOT Y23) AND (D20 >= D10);

END_PROGRAM