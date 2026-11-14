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
    state : INT;
    x10_edge : R_TRIG;
END_VAR

x10_edge(CLK := X10);

IF state = 0 THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    IF x10_edge.Q THEN
        state := 1;
    END_IF;
END_IF;

IF state = 1 THEN
    IF X20 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        IF ABS(D20) <= 12 THEN
            Y2 := TRUE;
            state := 2;
        END_IF;
    ELSE
        IF D20 > 0 AND D21 > -95 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < 0 AND D21 < 95 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
    END_IF;
ELSIF state = 2 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM