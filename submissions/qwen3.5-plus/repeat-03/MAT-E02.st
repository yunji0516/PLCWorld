PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    start_edge : R_TRIG;
    started : BOOL;
    completed : BOOL;
END_VAR

start_edge(CLK := X10);

IF NOT started THEN
    Y20 := TRUE;
    IF start_edge.Q THEN
        started := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    IF X22 AND NOT X20 THEN
        completed := TRUE;
    END_IF;
END_IF;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM