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

    state : INT := 0;
    req_len : INT := 0;
    prefill_target : INT := 0;
    x10_prev : BOOL := FALSE;
    x10_rise : BOOL := FALSE;
    claimed : BOOL := FALSE;
END_VAR

x10_rise := X10 AND NOT x10_prev;
x10_prev := X10;

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;
Y26 := FALSE;

CASE state OF
    0:
        IF x10_rise THEN
            req_len := D10;
            prefill_target := req_len + 180;
            IF D20 < prefill_target THEN
                state := 10;
            ELSE
                state := 20;
            END_IF;
        END_IF;

    10:
        Y26 := TRUE;
        IF D20 >= prefill_target THEN
            Y26 := FALSE;
            state := 20;
        END_IF;

    20:
        Y20 := TRUE;
        IF D21 >= req_len THEN
            Y20 := FALSE;
            state := 25;
        END_IF;

    25:
        IF X21 AND (ABS(D21 - req_len) <= 3) THEN
            state := 30;
        END_IF;

    30:
        Y24 := TRUE;
        IF X24 THEN
            Y24 := FALSE;
            state := 40;
        END_IF;

    40:
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            state := 50;
        END_IF;

    50:
        Y21 := TRUE;
        IF X20 THEN
            Y21 := FALSE;
            state := 55;
        END_IF;

    55:
        IF X21 AND X20 THEN
            state := 60;
        END_IF;

    60:
        IF (ABS(D21 - req_len) <= 3) AND X24 AND X23 AND X20 AND X21 AND (D20 >= 80) AND (D20 <= 900) THEN
            claimed := TRUE;
        END_IF;
END_CASE;

Y2 := claimed;

END_PROGRAM