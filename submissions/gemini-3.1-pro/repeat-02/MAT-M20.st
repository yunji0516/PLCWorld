PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
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

IF state = 1 AND X20 THEN
    state := 2;
ELSIF state = 2 AND D20 >= 699 THEN
    state := 3;
ELSIF state = 3 AND X22 THEN
    state := 4;
ELSIF state = 4 AND X21 THEN
    state := 5;
END_IF;

Y20 := (state = 1 OR state = 2 OR state = 3);
Y21 := (state = 4);
Y22 := (state = 2);
Y23 := (state = 3);
Y2  := (state = 5);

END_PROGRAM