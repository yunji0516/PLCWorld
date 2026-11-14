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
    state : INT;
    product_received : BOOL;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        product_received := FALSE;
        IF start_trig.Q THEN
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        IF X22 THEN
            product_received := TRUE;
        END_IF;
        IF X21 AND (X22 OR product_received) THEN
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            state := 3;
        END_IF;

    3:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM