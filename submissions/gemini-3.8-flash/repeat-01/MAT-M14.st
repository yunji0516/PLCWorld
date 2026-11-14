PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;

    state : INT;
    start_trig : R_TRIG;
    armed : BOOL;
    received_latched : BOOL;
    completed : BOOL;
END_VAR

start_trig(CLK := X10);

IF X22 THEN
    received_latched := TRUE;
END_IF;

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF start_trig.Q AND (D10 = 1) AND X20 AND X24 THEN
            state := 10;
        END_IF;

    10:
        IF X20 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
        END_IF;
        IF X23 THEN
            Y22 := FALSE;
            state := 20;
        END_IF;

    20:
        Y22 := FALSE;
        IF X24 THEN
            armed := (D20 > (D21 + 5));
            state := 30;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF NOT armed THEN
            IF D20 > (D21 + 5) THEN
                armed := TRUE;
            END_IF;
        ELSE
            IF (D20 <= D21) AND X20 AND X23 AND X24 THEN
                state := 40;
            END_IF;
        END_IF;

    40:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF X21 THEN
            Y20 := FALSE;
            state := 50;
        END_IF;

    50:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            state := 60;
        END_IF;

    60:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF X20 AND X24 AND (X22 OR received_latched) THEN
            completed := TRUE;
        END_IF;
END_CASE;

IF completed THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM