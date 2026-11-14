PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    D20 : INT;
    
    state : INT := 0;
    x10_prev : BOOL := FALSE;
END_VAR

IF X10 AND NOT x10_prev THEN
    IF state = 0 THEN
        state := 1;
    END_IF;
END_IF;
x10_prev := X10;

CASE state OF
    1:
        IF X22 THEN
            state := 2;
        END_IF;
    2:
        IF X20 THEN
            state := 3;
        END_IF;
END_CASE;

Y20 := (state = 1);
Y21 := (state = 2);
Y2 := (state = 3);

END_PROGRAM