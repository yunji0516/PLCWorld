PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    
    start_edge : R_TRIG;
    active : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    active := TRUE;
END_IF;

IF active THEN
    Y20 := TRUE;
    IF X20 THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM