PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    
    start_edge : R_TRIG;
    active : BOOL := FALSE;
    done : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    active := TRUE;
END_IF

IF active AND NOT done THEN
    IF X20 THEN
        done := TRUE;
        Y20 := FALSE;
    ELSE
        IF D20 <= 350 THEN
            Y20 := TRUE;
        ELSIF D20 >= 550 THEN
            Y20 := FALSE;
        END_IF
    END_IF
END_IF

IF done THEN
    Y2 := TRUE;
    Y20 := FALSE;
END_IF

END_PROGRAM