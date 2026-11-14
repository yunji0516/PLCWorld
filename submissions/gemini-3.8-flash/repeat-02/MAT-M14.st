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

    state : INT := 0;
    x10_prev : BOOL := FALSE;
    x10_edge : BOOL := FALSE;
    pocket_armed : BOOL := FALSE;
    was_received : BOOL := FALSE;
    wait_count : INT := 0;
END_VAR

x10_edge := X10 AND NOT x10_prev;
x10_prev := X10;

IF X22 THEN
    was_received := TRUE;
END_IF;

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF x10_edge AND (D10 = 1) AND X20 THEN
            Y22 := TRUE;
            state := 10;
        END_IF;

    10:
        Y22 := TRUE;
        IF X23 THEN
            Y22 := FALSE;
            state := 20;
        END_IF;

    20:
        Y22 := FALSE;
        IF X24 THEN
            state := 30;
        END_IF;

    30:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF D20 > (D21 + 20) THEN
            pocket_armed := TRUE;
        END_IF;
        IF pocket_armed AND (D20 <= D21) THEN
            Y20 := TRUE;
            state := 40;
        END_IF;

    40:
        Y20 := TRUE;
        IF X21 THEN
            Y20 := FALSE;
            IF X22 OR was_received THEN
                state := 50;
            ELSE
                state := 45;
            END_IF;
        END_IF;

    45:
        Y20 := FALSE;
        Y21 := FALSE;
        wait_count := wait_count + 1;
        IF X22 OR was_received OR (wait_count >= 100) THEN
            state := 50;
        END_IF;

    50:
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            state := 60;
        END_IF;

    60:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE;

    ELSE
        state := 0;
END_CASE;

IF NOT X20 THEN
    Y22 := FALSE;
END_IF;

IF NOT (X23 AND X24) THEN
    Y20 := FALSE;
END_IF;

IF Y20 AND Y21 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

END_PROGRAM