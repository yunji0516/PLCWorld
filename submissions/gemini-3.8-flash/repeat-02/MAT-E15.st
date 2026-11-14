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
    D20 : INT;

    state : INT := 0;
    trig_start : R_TRIG;
END_VAR

Y20 := TRUE;
Y21 := TRUE;
Y23 := FALSE;

trig_start(CLK := X10);

CASE state OF
    0:
        Y22 := FALSE;
        Y2 := FALSE;
        IF trig_start.Q THEN
            state := 1;
        END_IF;

    1:
        IF (D20 >= D10 + 1) OR X22 THEN
            Y22 := FALSE;
            state := 2;
        ELSE
            Y22 := TRUE;
        END_IF;
        Y2 := FALSE;

    2:
        Y22 := FALSE;
        Y2 := FALSE;
        state := 3;

    3:
        Y22 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM