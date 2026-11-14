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
    
    state : INT := 0;
    x10_prev : BOOL := FALSE;
    x10_edge : BOOL := FALSE;
END_VAR

x10_edge := X10 AND NOT x10_prev;
x10_prev := X10;

IF state = 0 THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    IF x10_edge THEN
        state := 1;
    END_IF;
END_IF;

IF state = 1 THEN
    IF X20 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
        state := 2;
    ELSE
        IF D20 >= 4 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 <= -4 THEN
            Y21 := TRUE;
            Y20 := FALSE;
        ELSIF D20 <= 0 AND Y20 THEN
            Y20 := FALSE;
        ELSIF D20 >= 0 AND Y21 THEN
            Y21 := FALSE;
        END_IF;
    END_IF;
END_IF;

IF state = 2 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := TRUE;
END_IF;

END_PROGRAM