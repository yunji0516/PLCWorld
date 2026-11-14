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
    D20 : INT;
    D21 : INT;
    D22 : INT;

    start_trig : R_TRIG;
    state : INT := 0;
    target_length : INT := 0;
END_VAR

start_trig(CLK := X10);

IF state = 0 THEN
    IF start_trig.Q THEN
        target_length := D10;
        state := 10;
    END_IF;
END_IF;

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

    10:
        IF D20 > 0 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < 0 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            state := 20;
        END_IF;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;

    20:
        IF (target_length - D21) > 2 THEN
            Y22 := TRUE;
            IF D20 > 0 THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 < 0 THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF;
        ELSE
            Y22 := FALSE;
            Y20 := FALSE;
            Y21 := FALSE;
            Y23 := TRUE;
            state := 30;
        END_IF;
        Y2 := FALSE;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X20 THEN
            state := 40;
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;

    40:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
END_CASE;

END_PROGRAM