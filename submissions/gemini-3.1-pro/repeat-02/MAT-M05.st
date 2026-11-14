PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    D20 : INT;
    D22 : INT;

    state : INT := 0;
    current_layer : INT := 1;
    target_x : INT := 0;
    layer_type : INT := 0;
    x10_prev : BOOL := FALSE;
END_VAR

IF X10 AND NOT x10_prev THEN
    IF state = 0 THEN
        state := 10;
        current_layer := 1;
    END_IF;
END_IF;
x10_prev := X10;

IF state >= 10 AND state < 90 AND X23 THEN
    IF D22 > 700 THEN
        Y26 := TRUE;
        Y27 := FALSE;
    ELSIF D22 < 700 THEN
        Y26 := FALSE;
        Y27 := TRUE;
    ELSE
        Y26 := FALSE;
        Y27 := FALSE;
    END_IF;
ELSE
    Y26 := FALSE;
    Y27 := FALSE;
END_IF;

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y2 := FALSE;

    10:
        IF current_layer = 1 THEN
            layer_type := D11;
        ELSIF current_layer = 2 THEN
            layer_type := D12;
        ELSIF current_layer = 3 THEN
            layer_type := D13;
        ELSIF current_layer = 4 THEN
            layer_type := D14;
        END_IF;

        IF current_layer > 4 THEN
            state := 90;
        ELSE
            IF layer_type = 0 THEN
                target_x := -700;
            ELSE
                target_x := 700;
            END_IF;
            state := 11;
        END_IF;

    11:
        Y23 := TRUE;
        Y24 := FALSE;
        IF X23 THEN
            state := 12;
        END_IF;

    12:
        IF target_x = -700 THEN
            IF NOT X20 THEN
                Y21 := TRUE;
                Y22 := FALSE;
            ELSE
                Y21 := FALSE;
                Y22 := FALSE;
                state := 13;
            END_IF;
        ELSE
            IF NOT X21 THEN
                Y22 := TRUE;
                Y21 := FALSE;
            ELSE
                Y21 := FALSE;
                Y22 := FALSE;
                state := 13;
            END_IF;
        END_IF;

    13:
        IF X27 AND X29 THEN
            state := 14;
        END_IF;

    14:
        Y24 := TRUE;
        Y23 := FALSE;
        IF X24 THEN
            state := 15;
        END_IF;

    15:
        Y20 := TRUE;
        IF X25 THEN
            state := 16;
        END_IF;

    16:
        Y23 := TRUE;
        Y24 := FALSE;
        IF X23 THEN
            state := 17;
        END_IF;

    17:
        IF NOT X22 THEN
            IF target_x = -700 THEN
                Y22 := TRUE;
                Y21 := FALSE;
            ELSE
                Y21 := TRUE;
                Y22 := FALSE;
            END_IF;
        ELSE
            Y21 := FALSE;
            Y22 := FALSE;
            state := 18;
        END_IF;

    18:
        IF D22 = 700 THEN
            state := 19;
        END_IF;

    19:
        Y24 := TRUE;
        Y23 := FALSE;
        IF X24 THEN
            state := 20;
        END_IF;

    20:
        Y20 := FALSE;
        IF X26 AND X28 THEN
            state := 21;
        END_IF;

    21:
        Y23 := TRUE;
        Y24 := FALSE;
        IF X23 THEN
            current_layer := current_layer + 1;
            state := 10;
        END_IF;

    90:
        Y23 := TRUE;
        Y24 := FALSE;
        IF X23 THEN
            state := 91;
        END_IF;

    91:
        IF NOT X20 THEN
            Y21 := TRUE;
            Y22 := FALSE;
        ELSE
            Y21 := FALSE;
            Y22 := FALSE;
            state := 99;
        END_IF;

    99:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;

END_CASE;

END_PROGRAM