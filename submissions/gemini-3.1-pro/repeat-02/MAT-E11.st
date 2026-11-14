PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    active : BOOL := FALSE;
    completed : BOOL := FALSE;
    failed : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q AND NOT active AND NOT completed THEN
    active := TRUE;
END_IF;

IF active THEN
    IF X20 THEN
        active := FALSE;
        completed := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
    ELSE
        IF D20 > 1 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < -1 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
    END_IF;
END_IF;

IF active OR completed THEN
    IF D20 > 12 OR D20 < -12 THEN
        failed := TRUE;
    END_IF;
END_IF;

Y2 := completed AND NOT failed AND NOT Y20 AND NOT Y21 AND (D20 <= 12 AND D20 >= -12);

END_PROGRAM