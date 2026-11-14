PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    
    started : BOOL;
    edge_X10 : R_TRIG;
END_VAR

edge_X10(CLK := X10);
IF edge_X10.Q THEN
    started := TRUE;
END_IF;

IF started THEN
    IF X20 THEN
        Y2 := TRUE;
    END_IF;
    
    IF Y2 THEN
        Y20 := FALSE;
    ELSE
        IF D20 <= 400 THEN
            Y20 := TRUE;
        ELSIF D20 >= 600 THEN
            Y20 := FALSE;
        END_IF;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM