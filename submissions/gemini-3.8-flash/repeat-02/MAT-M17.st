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
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    state : INT := 0;
    req_id : INT := 0;
    r_trig_start : R_TRIG;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF r_trig_start.Q THEN
            req_id := D10;
            IF D20 = req_id THEN
                state := 20;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    10:
        Y20 := TRUE;
        Y21 := FALSE;
        IF D20 = req_id THEN
            Y20 := FALSE;
            state := 15;
        END_IF;

    15:
        Y20 := FALSE;
        Y21 := FALSE;
        state := 20;

    20:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            state := 30;
        END_IF;

    30:
        Y20 := TRUE;
        Y21 := TRUE;
        IF X22 THEN
            Y20 := FALSE;
            state := 40;
        END_IF;

    40:
        Y20 := FALSE;
        Y21 := TRUE;
        state := 50;

    50:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM