PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    trig_start : R_TRIG;
    state : INT := 0;
    req_len : INT := 0;
    target_buffer : INT := 0;
    claimed : BOOL := FALSE;
END_VAR

trig_start(CLK := X10);

IF trig_start.Q AND (state = 0) THEN
    req_len := D10;
    target_buffer := req_len + 250;
    IF NOT X22 THEN
        state := 1;
    ELSIF D20 < (req_len + 120) THEN
        state := 2;
    ELSE
        state := 3;
    END_IF;
END_IF;

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF
    1:
        IF X22 THEN
            IF D20 < (req_len + 120) THEN
                state := 2;
            ELSE
                state := 3;
            END_IF;
        ELSE
            Y22 := TRUE;
        END_IF;

    2:
        IF D20 >= target_buffer THEN
            state := 3;
        ELSE
            Y26 := TRUE;
        END_IF;

    3:
        IF D21 >= req_len THEN
            state := 4;
        ELSE
            IF X22 AND NOT X24 THEN
                Y20 := TRUE;
            END_IF;
        END_IF;

    4:
        IF X21 AND (ABS(D21 - req_len) <= 3) THEN
            state := 5;
        END_IF;

    5:
        IF X24 THEN
            state := 6;
        ELSE
            IF X21 AND (ABS(D21 - req_len) <= 3) THEN
                Y24 := TRUE;
            END_IF;
        END_IF;

    6:
        IF X23 THEN
            state := 7;
        ELSE
            IF X24 THEN
                Y23 := TRUE;
            END_IF;
        END_IF;

    7:
        IF X20 THEN
            state := 8;
        ELSE
            IF X23 THEN
                Y21 := TRUE;
            END_IF;
        END_IF;

    8:
        IF X21 AND X20 THEN
            state := 9;
        END_IF;

    9:
        IF (ABS(D21 - req_len) <= 3) AND X24 AND X23 AND X20 AND X21 THEN
            claimed := TRUE;
        END_IF;
END_CASE;

IF claimed THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
END_IF;

END_PROGRAM