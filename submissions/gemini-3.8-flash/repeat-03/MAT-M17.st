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

    step : INT := 0;
    req_id : INT := 0;
    trig_start : R_TRIG;
END_VAR

trig_start(CLK := X10);

CASE step OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        IF trig_start.Q THEN
            req_id := D10;
            step := 10;
        END_IF;

    10:
        Y20 := FALSE;
        IF D20 = req_id THEN
            step := 30;
        ELSIF X20 THEN
            step := 20;
        ELSE
            Y21 := FALSE;
        END_IF;

    20:
        Y21 := FALSE;
        Y20 := TRUE;
        IF D20 = req_id THEN
            Y20 := FALSE;
            step := 25;
        END_IF;

    25:
        Y20 := FALSE;
        Y21 := FALSE;
        step := 30;

    30:
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            step := 40;
        END_IF;

    40:
        Y21 := TRUE;
        Y20 := TRUE;
        IF X22 THEN
            Y20 := FALSE;
            step := 50;
        END_IF;

    50:
        Y20 := FALSE;
        Y21 := TRUE;
        step := 60;

    60:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM