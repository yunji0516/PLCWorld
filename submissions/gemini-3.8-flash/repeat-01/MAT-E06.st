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

    start_trig : R_TRIG;
    state : INT := 0;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF start_trig.Q THEN
            state := 10;
        END_IF;

    10:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X21 AND X22 THEN
            Y20 := FALSE;
            state := 20;
        END_IF;

    20:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            state := 30;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM