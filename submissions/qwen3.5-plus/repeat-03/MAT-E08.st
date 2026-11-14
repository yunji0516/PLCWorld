PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    start_edge : R_TRIG;
    prev_X20 : BOOL;
    running : BOOL;
    done : BOOL;
    falling_X20 : BOOL;
END_VAR

start_edge(CLK := X10);
falling_X20 := prev_X20 AND NOT X20;

IF done THEN
    Y20 := FALSE;
    Y2 := TRUE;
ELSIF running THEN
    Y20 := TRUE;
    IF falling_X20 THEN
        running := FALSE;
        done := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    IF start_edge.Q THEN
        running := TRUE;
    END_IF;
END_IF;

prev_X20 := X20;
END_PROGRAM