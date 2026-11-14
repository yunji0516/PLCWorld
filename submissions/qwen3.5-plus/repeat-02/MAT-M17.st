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
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    startEdge : R_TRIG;
    state : INT := 0;
END_VAR

startEdge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        IF startEdge.Q THEN
            state := 1;
        END_IF;
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF D20 = 2 THEN
            Y20 := FALSE;
            state := 2;
        END_IF;
    2:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 = TRUE THEN
            state := 3;
        END_IF;
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        IF X22 = TRUE THEN
            Y20 := FALSE;
            state := 4;
        END_IF;
    4:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM