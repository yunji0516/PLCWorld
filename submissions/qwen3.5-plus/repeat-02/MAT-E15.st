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
    edge_det : R_TRIG;
    started : BOOL;
    completed : BOOL;
END_VAR

edge_det(CLK := X10);

Y20 := TRUE;
Y21 := TRUE;

IF edge_det.Q THEN
    started := TRUE;
END_IF;

IF started THEN
    IF D20 < D10 THEN
        Y22 := TRUE;
        Y23 := FALSE;
    ELSE
        Y22 := FALSE;
        Y23 := FALSE;
    END_IF;
ELSE
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

IF started AND X20 AND X21 AND D20 >= D10 AND NOT Y22 AND NOT Y23 THEN
    completed := TRUE;
END_IF;

Y2 := completed;

END_PROGRAM