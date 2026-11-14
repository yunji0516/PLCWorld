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
    
    start_edge : R_TRIG;
    step : INT := 0;
    item_count : INT := 0;
    items_delivered : INT := 0;
    destination_class : INT := 0;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q AND step = 0 AND D10 > 0 THEN
    step := 10;
    item_count := D10;
    items_delivered := 0;
END_IF;

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;

    10:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := TRUE;
        IF X22 THEN
            step := 15;
        END_IF;

    15:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        destination_class := D20;
        step := 20;

    20:
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y20 := TRUE;
        IF X24 THEN
            step := 30;
        END_IF;

    30:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y24 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            step := 40;
        END_IF;

    40:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y25 := (destination_class = 1);
        step := 50;

    50:
        Y20 := TRUE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            Y21 := FALSE;
            step := 60;
        END_IF;

    60:
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := TRUE;
        IF X22 THEN
            step := 70;
        END_IF;

    70:
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y20 := FALSE;
        IF X25 THEN
            step := 80;
        END_IF;

    80:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y24 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            step := 90;
        END_IF;

    90:
        Y20 := FALSE;
        Y21 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y22 := TRUE;
        IF X20 THEN
            Y22 := FALSE;
            items_delivered := items_delivered + 1;
            IF items_delivered >= item_count THEN
                step := 100;
            ELSE
                step := 10;
            END_IF;
        END_IF;

    100:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y24 := FALSE;
        Y23 := TRUE;
        IF X20 AND X23 THEN
            Y23 := FALSE;
            step := 200;
        END_IF;

    200:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y2 := TRUE;

END_CASE;

END_PROGRAM