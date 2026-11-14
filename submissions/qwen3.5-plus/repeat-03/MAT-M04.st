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
    step : INT := 0;
    items_remaining : INT := 0;
    start_edge : R_TRIG;
    item_class : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE step OF
    0:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE; Y2 := FALSE;
        IF start_edge.Q THEN
            items_remaining := D10;
            step := 1;
        END_IF;
    1:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y24 := FALSE;
        item_class := D20;
        IF item_class = 1 THEN Y25 := TRUE; ELSE Y25 := FALSE; END_IF;
        step := 2;
    2:
        Y23 := FALSE; Y24 := TRUE; Y21 := FALSE; Y22 := FALSE; Y20 := FALSE;
        IF X22 THEN step := 3; END_IF;
    3:
        Y24 := FALSE; Y23 := FALSE; Y21 := FALSE; Y22 := FALSE; Y20 := TRUE;
        IF X24 THEN step := 4; END_IF;
    4:
        Y24 := FALSE; Y23 := TRUE; Y21 := FALSE; Y22 := FALSE; Y20 := TRUE;
        IF X23 THEN step := 5; END_IF;
    5:
        Y23 := TRUE; Y21 := TRUE; Y22 := FALSE; Y24 := FALSE; Y20 := TRUE;
        IF X21 THEN step := 6; END_IF;
    6:
        Y21 := FALSE; Y20 := FALSE; Y25 := FALSE; Y23 := TRUE; Y24 := FALSE; Y22 := FALSE;
        IF X25 THEN step := 7; END_IF;
    7:
        Y23 := TRUE; Y22 := TRUE; Y21 := FALSE; Y24 := FALSE; Y20 := FALSE;
        IF X20 THEN step := 8; END_IF;
    8:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
        items_remaining := items_remaining - 1;
        IF items_remaining > 0 THEN
            step := 1;
        ELSE
            step := 9;
        END_IF;
    9:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y25 := FALSE;
        IF X20 AND X23 THEN
            Y23 := FALSE; Y24 := FALSE;
            step := 10;
        ELSIF NOT X23 THEN
            Y23 := TRUE; Y24 := FALSE;
        ELSE
            Y23 := FALSE; Y24 := FALSE;
        END_IF;
    10:
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM