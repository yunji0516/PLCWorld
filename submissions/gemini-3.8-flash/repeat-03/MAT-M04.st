PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL;
    D20 : INT;

    trig_start : R_TRIG;
    started : BOOL;
    step : INT;
    item_idx : INT;
    target_count : INT;
    target_reject : BOOL;
END_VAR

trig_start(CLK := X10);

IF trig_start.Q AND NOT started THEN
    started := TRUE;
    IF D10 > 0 THEN
        target_count := D10;
    ELSE
        target_count := 2;
    END_IF;
    step := 1;
END_IF;

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;

CASE step OF
    1:
        IF X20 AND X23 AND X26 AND X31 THEN
            target_reject := (D20 = 1);
            step := 2;
        END_IF;

    2:
        IF X22 THEN
            step := 3;
        ELSE
            Y24 := TRUE;
        END_IF;

    3:
        Y20 := TRUE;
        IF X24 THEN
            step := 4;
        END_IF;

    4:
        Y20 := TRUE;
        IF X23 THEN
            step := 5;
        ELSE
            Y23 := TRUE;
        END_IF;

    5:
        Y20 := TRUE;
        Y25 := target_reject;
        IF X21 THEN
            IF X28 THEN
                step := 6;
            END_IF;
        ELSIF X23 THEN
            Y21 := TRUE;
        END_IF;

    6:
        Y20 := TRUE;
        Y25 := target_reject;
        IF X22 THEN
            step := 7;
        ELSE
            Y24 := TRUE;
        END_IF;

    7:
        Y25 := target_reject;
        Y20 := FALSE;
        IF X25 THEN
            step := 8;
        END_IF;

    8:
        Y25 := target_reject;
        IF X23 THEN
            step := 9;
        ELSE
            Y23 := TRUE;
        END_IF;

    9:
        IF X20 THEN
            IF X28 THEN
                step := 10;
            END_IF;
        ELSIF X23 THEN
            Y22 := TRUE;
        END_IF;

    10:
        item_idx := item_idx + 1;
        IF item_idx >= target_count THEN
            step := 20;
        ELSE
            step := 11;
        END_IF;

    11:
        IF X26 AND X31 THEN
            target_reject := (D20 = 1);
            step := 2;
        END_IF;

    20:
        Y2 := TRUE;
END_CASE;

IF step = 20 THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM