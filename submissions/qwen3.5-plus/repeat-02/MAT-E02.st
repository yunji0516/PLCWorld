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
    completed : BOOL;
END_VAR

start_edge(CLK := X10);

IF completed THEN
    Y20 := FALSE;
ELSE
    IF start_edge.Q THEN
        Y20 := FALSE;
        IF NOT X20 AND X21 AND X22 THEN
            completed := TRUE;
        END_IF;
    ELSE
        Y20 := TRUE;
    END_IF;
END_IF;

Y2 := completed;

END_PROGRAM