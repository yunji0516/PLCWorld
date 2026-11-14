PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    start_edge : R_TRIG;
    grip_cmd : BOOL;
    complete_flag : BOOL;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    grip_cmd := TRUE;
END_IF;

Y20 := grip_cmd;

IF X20 THEN
    complete_flag := TRUE;
END_IF;

Y2 := complete_flag;

END_PROGRAM