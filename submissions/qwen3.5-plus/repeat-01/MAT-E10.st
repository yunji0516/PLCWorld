PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    start_edge : R_TRIG;
    process_active : BOOL;
END_VAR

start_edge(CLK := X10);

IF NOT process_active AND start_edge.Q THEN
    process_active := TRUE;
END_IF;

IF process_active THEN
    IF NOT X20 THEN
        IF D20 <= 320 THEN
            Y20 := TRUE;
        ELSIF D20 >= 480 THEN
            Y20 := FALSE;
        END_IF;
    ELSE
        Y20 := FALSE;
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
END_IF;

END_PROGRAM