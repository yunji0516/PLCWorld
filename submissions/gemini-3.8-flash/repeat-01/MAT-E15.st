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
    D20 : INT;

    r_trig_start : R_TRIG;
    state : INT;
END_VAR

// Maintain both vacuum commands ON from the first scan
Y20 := TRUE;
Y21 := TRUE;
Y23 := FALSE;

r_trig_start(CLK := X10);

CASE state OF
    0: // Wait for start request
        Y22 := FALSE;
        Y2 := FALSE;
        IF r_trig_start.Q THEN
            state := 1;
            Y22 := TRUE;
        END_IF;

    1: // Opening to requested passage width
        IF D20 > D10 THEN
            Y22 := FALSE;
            state := 2;
        ELSE
            Y22 := TRUE;
        END_IF;

    2: // Holding open position and claiming completion
        Y22 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM