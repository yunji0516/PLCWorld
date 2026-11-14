PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D200 : INT;
    
    state : INT := 0;
    target_len : INT := 100;
END_VAR

CASE state OF
    0:
        IF X0 THEN
            target_len := D0;
            state := 1;
        END_IF;
    1:
        IF X12 THEN
            state := 2;
        END_IF;
    2:
        IF X11 AND ABS(D1 - target_len) <= 1 THEN
            state := 3;
        END_IF;
    3:
        IF X14 THEN
            state := 4;
        END_IF;
    4:
        IF X16 THEN
            state := 5;
        END_IF;
    5:
        IF X15 AND X17 THEN
            state := 6;
        END_IF;
    6:
        IF X13 THEN
            state := 7;
        END_IF;
    7:
        IF X11 AND ABS(D1 - 100) <= 1 THEN
            state := 8;
        END_IF;
    8:
        IF X19 THEN
            state := 9;
        END_IF;
    9:
        IF X1C THEN
            state := 10;
        END_IF;
    10:
        IF X18 THEN
            state := 11;
        END_IF;
    11:
        IF X1B THEN
            state := 12;
        END_IF;
    12:
        IF X19 THEN
            state := 13;
        END_IF;
    13:
        IF NOT X1C THEN
            state := 14;
        END_IF;
    14:
        IF X18 THEN
            state := 15;
        END_IF;
    15:
        IF X1A THEN
            state := 16;
        END_IF;
    16:
        ; (* Await completion observation duration *)
END_CASE;

Y10 := (state >= 0 AND state <= 5);
Y11 := (state >= 3 AND state <= 16);
Y12 := (state = 2 OR state = 7);
Y13 := (state = 4);
Y14 := (state = 8 OR state = 9 OR state = 12 OR state = 13);
Y15 := (state >= 11 AND state <= 14);
Y16 := (state >= 9 AND state <= 12);
Y17 := (state = 16 AND ABS(D3 - target_len) <= 1);

IF state >= 1 AND state <= 6 THEN
    D200 := target_len;
ELSE
    D200 := 100;
END_IF;

END_PROGRAM