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

    x10_prev : BOOL;
    x10_edge : BOOL;
    started : BOOL;
    step : INT;
    req_count : INT;
    items_done : INT;
    is_reject : BOOL;
END_VAR

x10_edge := X10 AND NOT x10_prev;
x10_prev := X10;

IF x10_edge AND NOT started THEN
    started := TRUE;
    req_count := D10;
    items_done := 0;
    step := 10;
END_IF;

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y25 := FALSE;

IF started THEN
    CASE step OF
        10:
            IF items_done >= req_count THEN
                step := 100;
            ELSE
                step := 11;
            END_IF;

        11:
            IF X26 AND X31 AND X20 AND X23 THEN
                is_reject := (D20 = 1);
                step := 20;
            END_IF;

        20:
            Y24 := TRUE;
            IF X22 THEN
                Y24 := FALSE;
                step := 30;
            END_IF;

        30:
            Y20 := TRUE;
            IF X24 THEN
                step := 40;
            END_IF;

        40:
            Y20 := TRUE;
            Y23 := TRUE;
            IF X23 THEN
                Y23 := FALSE;
                step := 50;
            END_IF;

        50:
            Y20 := TRUE;
            Y21 := TRUE;
            Y25 := is_reject;
            IF X21 THEN
                Y21 := FALSE;
                step := 60;
            END_IF;

        60:
            Y20 := TRUE;
            Y25 := is_reject;
            Y24 := TRUE;
            IF X22 THEN
                Y24 := FALSE;
                step := 70;
            END_IF;

        70:
            Y20 := FALSE;
            Y25 := is_reject;
            IF X25 THEN
                step := 80;
            END_IF;

        80:
            Y23 := TRUE;
            IF X23 THEN
                Y23 := FALSE;
                step := 90;
            END_IF;

        90:
            Y22 := TRUE;
            IF X20 THEN
                Y22 := FALSE;
                items_done := items_done + 1;
                step := 10;
            END_IF;

        100:
            Y2 := TRUE;
    END_CASE;
END_IF;

END_PROGRAM