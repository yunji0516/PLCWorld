PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    start_edge : R_TRIG;
    started : BOOL;
    completed : BOOL;
END_VAR

start_edge(CLK := X10);

IF NOT started AND start_edge.Q THEN
    started := TRUE;
END_IF;

IF started THEN
    Y20 := TRUE;
END_IF;

IF started AND X20 THEN
    completed := TRUE;
END_IF;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM