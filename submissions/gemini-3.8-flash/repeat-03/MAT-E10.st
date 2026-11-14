PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;

    r_trig_start : R_TRIG;
    active : BOOL;
    done : BOOL;
END_VAR

r_trig_start(CLK := X10);
IF r_trig_start.Q THEN
    active := TRUE;
END_IF;

IF done THEN
    Y20 := FALSE;
    Y2 := TRUE;
ELSIF active THEN
    IF X20 THEN
        done := TRUE;
        Y20 := FALSE;
        Y2 := TRUE;
    ELSE
        IF D20 <= 380 THEN
            Y20 := TRUE;
        ELSIF D20 >= 480 THEN
            Y20 := FALSE;
        END_IF;
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM