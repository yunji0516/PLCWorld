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

    r_trig_start : R_TRIG;
    state : INT := 0;
    req_len : INT := 0;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF r_trig_start.Q THEN
            req_len := D10;
            state := 10;
        END_IF;

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
        END_IF;

        IF (req_len - D21) > 2 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
            state := 20;
        END_IF;

    20:
        Y22 := FALSE;
        IF D20 > 0 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < 0 THEN
            Y20 := FALSE;
            Y21 := TRUE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            state := 30;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X20 THEN
            state := 40;
            Y2 := TRUE;
        END_IF;

    40:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
END_CASE;

END_PROGRAM