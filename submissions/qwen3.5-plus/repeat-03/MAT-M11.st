PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
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
    D20 : INT;
    D21 : INT;
    trigStart : R_TRIG;
    state : INT := 0;
END_VAR

trigStart(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
        IF trigStart.Q THEN
            state := 1;
        END_IF;
    1:
        Y2 := FALSE;
        Y20 := TRUE; Y21 := TRUE;
        Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
        IF X20 AND X21 THEN
            state := 2;
        END_IF;
    2:
        Y2 := FALSE;
        Y20 := TRUE; Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;
    3:
        Y2 := FALSE;
        Y20 := TRUE; Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE; Y24 := TRUE; Y25 := FALSE;
        IF X25 THEN
            state := 4;
        END_IF;
    4:
        Y2 := FALSE;
        Y20 := TRUE; Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE; Y24 := FALSE; Y25 := TRUE;
        IF X23 THEN
            state := 5;
        END_IF;
    5:
        Y2 := FALSE;
        Y20 := FALSE; Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
        IF X26 THEN
            state := 6;
        END_IF;
    6:
        Y2 := TRUE;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
END_CASE;

END_PROGRAM