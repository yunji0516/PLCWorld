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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    
    edge : R_TRIG;
    state : INT := 0;
    items_done : INT := 0;
    current_class : INT := 0;
END_VAR

edge(CLK := X10);

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        IF edge.Q AND (D10 = 2) THEN
            state := 1;
            items_done := 0;
        END_IF

    1:
        IF X20 AND X23 AND X26 AND X31 THEN
            current_class := D20;
            state := 2;
        END_IF

    2:
        Y24 := TRUE;
        IF X22 THEN
            state := 3;
        END_IF

    3:
        Y20 := TRUE;
        IF X24 THEN
            state := 4;
        END_IF

    4:
        Y23 := TRUE;
        Y20 := TRUE;
        IF X23 THEN
            state := 5;
        END_IF

    5:
        Y21 := TRUE;
        Y20 := TRUE;
        IF current_class = 1 THEN
            Y25 := TRUE;
        END_IF
        IF X21 THEN
            state := 6;
        END_IF

    6:
        Y24 := TRUE;
        Y20 := TRUE;
        IF current_class = 1 THEN
            Y25 := TRUE;
        END_IF
        IF X22 THEN
            state := 7;
        END_IF

    7:
        IF current_class = 1 THEN
            Y25 := TRUE;
        END_IF
        IF X25 THEN
            state := 8;
        END_IF

    8:
        Y23 := TRUE;
        IF current_class = 1 THEN
            Y25 := TRUE;
        END_IF
        IF X23 THEN
            state := 9;
        END_IF

    9:
        Y22 := TRUE;
        IF X20 THEN
            items_done := items_done + 1;
            IF items_done >= 2 THEN
                state := 10;
            ELSE
                state := 1;
            END_IF
        END_IF

    10:
        Y2 := TRUE;

END_CASE;

END_PROGRAM