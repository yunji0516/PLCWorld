PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;

    state : INT := 0;
    X10_prev : BOOL := FALSE;
END_VAR

IF X10 AND NOT X10_prev THEN
    IF state = 0 THEN
        state := 1;
    END_IF;
END_IF;
X10_prev := X10;

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X20 THEN
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        IF D20 >= D10 THEN
            Y21 := FALSE;
            Y20 := FALSE;
            state := 3;
        END_IF;
        
    3:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X21 THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM