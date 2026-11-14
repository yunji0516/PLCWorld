PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    start_edge : R_TRIG;
    pass_edge : R_TRIG;
    started : BOOL;
    finished : BOOL;
END_VAR

start_edge(CLK := X10);
pass_edge(CLK := NOT X20);

IF start_edge.Q THEN
    started := TRUE;
END_IF;

IF started AND pass_edge.Q THEN
    finished := TRUE;
END_IF;

Y20 := started AND NOT finished;
Y2 := finished;

END_PROGRAM