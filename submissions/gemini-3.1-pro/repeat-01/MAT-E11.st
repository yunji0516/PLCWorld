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
    done : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    active := TRUE;
    done := FALSE;
    Y2 := FALSE;
END_IF;

IF active THEN
    IF X20 THEN
        active := FALSE;
        done := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
    ELSE
        IF D20 > 0 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < 0 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
        Y2 := FALSE;
    END_IF;
ELSIF done THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM