PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL;

    x10_prev : BOOL;
    state : INT;
END_VAR

IF X10 AND NOT x10_prev THEN
    IF D10 = 1 AND state = 0 THEN
        state := 1;
    END_IF
END_IF
x10_prev := X10;

CASE state OF
    1:
        IF X22 THEN
            IF X31 AND X32 THEN
                state := 3;
            ELSE
                state := 2;
            END_IF
        END_IF
    2:
        IF X31 AND X32 THEN
            state := 3;
        END_IF
    3:
        IF X29 THEN
            state := 4;
        END_IF
    4:
        IF X24 THEN
            state := 5;
        END_IF
    5:
        IF X23 THEN
            state := 6;
        END_IF
    6:
        IF X21 THEN
            state := 7;
        END_IF
    7:
        IF X22 THEN
            state := 8;
        END_IF
    8:
        IF X25 THEN
            state := 9;
        END_IF
    9:
        IF X23 THEN
            state := 10;
        END_IF
    10:
        IF X20 THEN
            state := 11;
        END_IF
END_CASE

Y24 := (state = 1) OR (state = 7);
Y25 := (state = 2);
Y26 := (state = 2);
Y20 := (state >= 4) AND (state <= 7);
Y23 := (state = 5) OR (state = 9);
Y21 := (state = 6);
Y22 := (state = 10);
Y2  := (state = 11);

END_PROGRAM