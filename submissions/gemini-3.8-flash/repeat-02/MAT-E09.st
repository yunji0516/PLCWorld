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
    start_trig : R_TRIG;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_trig.Q THEN
            Y20 := TRUE;
            state := 1;
        END_IF;

    1:
        Y2 := FALSE;
        Y20 := TRUE;
        Y21 := FALSE;
        IF X20 THEN
            Y21 := TRUE;
            state := 2;
        END_IF;

    2:
        Y2 := FALSE;
        Y20 := TRUE;
        IF D20 >= D10 THEN
            Y21 := FALSE;
            Y20 := FALSE;
            state := 3;
        ELSE
            Y21 := TRUE;
        END_IF;

    3:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF X21 THEN
            Y2 := TRUE;
            state := 4;
        END_IF;

    4:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM