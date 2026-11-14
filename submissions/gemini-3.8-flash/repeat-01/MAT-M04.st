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
    state : INT := 0;
    target_count : INT := 2;
    items_delivered : INT := 0;
    item_is_reject : BOOL := FALSE;
    trig_start : R_TRIG;
    timer_source : TON;
    timer_release : TON;
END_VAR

trig_start(CLK := X10);

timer_source(IN := (state = 1 AND X20 AND X23 AND X26 AND X31), PT := T#50ms);
timer_release(IN := (state = 7 AND X25), PT := T#100ms);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y2 := FALSE;
        IF trig_start.Q THEN
            target_count := D10;
            IF target_count <= 0 THEN
                target_count := 2;
            END_IF;
            items_delivered := 0;
            state := 1;
        END_IF;

    1:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF timer_source.Q THEN
            item_is_reject := (D20 = 1);
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := TRUE;
        Y25 := FALSE;
        IF X22 THEN
            state := 21;
        END_IF;

    21:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X28 THEN
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X24 THEN
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X23 THEN
            state := 41;
        END_IF;

    41:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X28 THEN
            state := 5;
        END_IF;

    5:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := item_is_reject;
        IF X21 THEN
            state := 51;
        END_IF;

    51:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := item_is_reject;
        IF X28 THEN
            state := 6;
        END_IF;

    6:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := TRUE;
        Y25 := item_is_reject;
        IF X22 THEN
            state := 61;
        END_IF;

    61:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := item_is_reject;
        IF X28 THEN
            state := 7;
        END_IF;

    7:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := item_is_reject;
        IF timer_release.Q THEN
            state := 8;
        END_IF;

    8:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y25 := item_is_reject;
        IF X23 THEN
            state := 81;
        END_IF;

    81:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := item_is_reject;
        IF X28 THEN
            items_delivered := items_delivered + 1;
            state := 9;
        END_IF;

    9:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X20 THEN
            state := 91;
        END_IF;

    91:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X28 THEN
            IF items_delivered >= target_count THEN
                state := 10;
            ELSE
                state := 1;
            END_IF;
        END_IF;

    10:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM