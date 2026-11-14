PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    started : BOOL;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);
IF NOT started AND start_edge.Q THEN
    started := TRUE;
END_IF;

Y20 := started;
Y2 := started AND X20;

END_PROGRAM