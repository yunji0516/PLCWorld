PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;

    start_edge : R_TRIG;
    state : INT;
END_VAR

start_edge(CLK := X10);

IF state = 0 THEN
    Y20 := FALSE;
    Y2 := FALSE;
    IF start_edge.Q THEN
        state := 1;
    END_IF;
END_IF;

IF state = 1 THEN
    IF D20 = D10 THEN
        state := 2;
    ELSE
        Y20 := TRUE;
        Y2 := FALSE;
    END_IF;
END_IF;

IF state = 2 THEN
    Y20 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM