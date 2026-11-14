PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    edge_start : R_TRIG;
    start_latch : BOOL;
END_VAR

edge_start(CLK := X10);

IF edge_start.Q THEN
    start_latch := TRUE;
END_IF;

IF start_latch THEN
    Y20 := TRUE;
END_IF;

IF Y20 AND X20 THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM