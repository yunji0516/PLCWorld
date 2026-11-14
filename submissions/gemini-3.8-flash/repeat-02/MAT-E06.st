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

    state : INT := 0;
    trig_start : R_TRIG;
    received_latched : BOOL := FALSE;
END_VAR

trig_start(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF trig_start.Q THEN
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF X22 THEN
            received_latched := TRUE;
        END_IF;
        IF X21 AND (X22 OR received_latched) THEN
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            Y2 := TRUE;
            state := 3;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM