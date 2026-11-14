PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    start_trig : R_TRIG;
    state : INT := 0;
END_VAR

start_trig(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF start_trig.Q THEN
            state := 1;
        END_IF;

    1:
        IF X20 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        ELSE
            IF D20 > 0 AND D21 > -98 THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 < 0 AND D21 < 98 THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        IF ABS(D20) <= 12 THEN
            Y2 := TRUE;
            state := 3;
        END_IF;

    3:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
END_CASE;

END_PROGRAM