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

    step : INT := 0;
    start_trig : R_TRIG;
END_VAR

start_trig(CLK := X10);

CASE step OF
    0:
        IF start_trig.Q THEN
            step := 10;
        END_IF;

    10:
        IF X20 THEN
            Y20 := FALSE;
            step := 20;
        ELSE
            Y20 := TRUE;
            Y21 := FALSE;
        END_IF;

    20:
        IF X23 AND (D20 >= 699) THEN
            Y22 := FALSE;
            step := 30;
        ELSE
            Y22 := TRUE;
            Y23 := FALSE;
        END_IF;

    30:
        IF X22 THEN
            Y23 := FALSE;
            step := 40;
        ELSE
            Y23 := TRUE;
            Y22 := FALSE;
        END_IF;

    40:
        IF X21 THEN
            Y21 := FALSE;
            step := 50;
        ELSE
            Y21 := TRUE;
            Y20 := FALSE;
        END_IF;

    50:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 AND X22 AND (D20 >= 699) THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM