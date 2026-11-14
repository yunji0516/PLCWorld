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
    X26 : BOOL;
    D20 : INT;

    r_trig_start : R_TRIG;
    state : INT := 0;
    target_pos : INT := 0;
END_VAR

r_trig_start(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF r_trig_start.Q AND (D10 = 1) THEN
            target_pos := 0;
            state := 10;
        END_IF;

    10:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF (ABS(D20 - target_pos) <= 2) AND X25 THEN
            IF NOT X24 THEN
                state := 30;
            ELSE
                target_pos := target_pos + 160;
                state := 20;
            END_IF;
        ELSE
            state := 20;
        END_IF;

    20:
        Y22 := FALSE;
        Y23 := FALSE;
        IF X22 THEN
            IF D20 < (target_pos - 1) THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 > (target_pos + 1) THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
                state := 10;
            END_IF;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        IF X25 THEN
            Y22 := TRUE;
            Y23 := FALSE;
            IF X23 THEN
                Y22 := FALSE;
                state := 40;
            END_IF;
        ELSE
            Y22 := FALSE;
            Y23 := FALSE;
        END_IF;

    40:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            Y23 := FALSE;
            state := 50;
        END_IF;

    50:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM