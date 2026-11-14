PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;
    
    started : BOOL;
    done : BOOL;
    x10_prev : BOOL;
END_VAR

IF X10 AND NOT x10_prev THEN
    started := TRUE;
END_IF;
x10_prev := X10;

IF started AND X20 THEN
    done := TRUE;
END_IF;

IF done THEN
    Y20 := FALSE;
    Y2 := TRUE;
ELSIF started THEN
    Y2 := FALSE;
    IF D20 < 400 THEN
        Y20 := TRUE;
    ELSIF D20 > 500 THEN
        Y20 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM