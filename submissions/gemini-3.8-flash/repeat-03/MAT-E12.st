PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;

    state : INT := 0;
    r_trig_start : R_TRIG;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y2 := FALSE;
        IF r_trig_start.Q THEN
            IF D20 = D10 THEN
                Y20 := FALSE;
                Y2 := TRUE;
                state := 2;
            ELSE
                Y20 := TRUE;
                state := 1;
            END_IF;
        END_IF;

    1:
        IF D20 = D10 THEN
            Y20 := FALSE;
            Y2 := TRUE;
            state := 2;
        ELSE
            Y20 := TRUE;
            Y2 := FALSE;
        END_IF;

    2:
        Y20 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM