```
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
    D20 : INT;
    D21 : INT;
    start_edge : R_TRIG;
    timer_head : TON;
    timer_scrap : TON;
    phase : INT;
END_VAR

CASE phase OF
    0: (* Wait for start edge *)
        start_edge(CLK := X10);
        IF start_edge.Q THEN
            phase := 1;
        END_IF;
    1: (* Forward to source *)
        Y24 := TRUE;
        IF X25 THEN (* source *)
            Y24 := FALSE;
            phase := 2;
        END_IF;
    2: (* Down to contact *)
        Y23 := TRUE;
        IF X23 THEN (* low *)
            Y23 := FALSE;
            phase := 3;
        END_IF;
    3: (* Head vac ON *)
        Y20 := TRUE;
        phase := 4;
    4: (* Wait for head acquisition *)
        timer_head(IN := TRUE, PT := T#200ms);
        IF timer_head.Q OR X20 THEN
            timer_head(IN := FALSE);
            phase := 5;
        END_IF;
    5: (* Head up *)
        Y22 := TRUE;
        IF X22 THEN (* high *)
            Y22 := FALSE;
            phase := 6;
        END_IF;
    6: (* Back to home *)
        Y25 := TRUE;
        IF X24 THEN (* home *)
            Y25 := FALSE;
            phase := 7;
        END_IF;
    7: (* Head down *)
        Y23 := TRUE;
        IF X23 THEN (* low *)
            Y23 := FALSE;
            phase := 8;
        END_IF;
    8: (* Release product *)
        Y20 := FALSE;
        phase := 9;
    9: (* Wait for release *)
        IF NOT X20 THEN
            phase := 10;
        END_IF;
    10: (* Head up *)
        Y22 := TRUE;
        IF X22 THEN (* high *)
            Y22 := FALSE;
            phase := 11;
        END_IF;
    11: (* Forward to source for scrap *)
        Y24 := TRUE;
        IF X25 THEN (* source *)
            Y24 := FALSE;
            phase := 12;
        END_IF;
    12: (* Carrier down to contact *)
        Y27 := TRUE;
        IF X28 THEN (* scrap low *)
            Y27 := FALSE;
            phase := 13;
        END_IF;
    13: (* Scrap vac ON *)
        Y21 := TRUE;
        phase := 14;
    14: (* Wait for scrap acquisition *)
        timer_scrap(IN := TRUE, PT := T#300ms);
        IF timer_scrap.Q OR X21 THEN
            timer_scrap(IN := FALSE);
            phase := 15;
        END_IF;
    15: (* Carrier up *)
        Y26 := TRUE;
        IF X27 THEN (* scrap high *)
            Y26 := FALSE;
            phase := 16;
        END_IF;
    16: (* All done - product delivered, scraps held *)
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM
```