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

    state : INT := 0;
    start_edge : R_TRIG;
    scrap_timer : TON;
    prod_timer : TON;
    rel_timer : TON;
END_VAR

start_edge(CLK := X10);
scrap_timer(IN := (state = 10 AND X21), PT := T#200ms);
prod_timer(IN := (state = 50 AND X20), PT := T#200ms);
rel_timer(IN := (state = 90), PT := T#300ms);

CASE state OF
    0:
        IF start_edge.Q THEN
            state := 10;
        END_IF;

    10:
        IF X21 AND scrap_timer.Q THEN
            state := 20;
        END_IF;

    20:
        IF X27 AND (D21 >= 645) THEN
            state := 30;
        END_IF;

    30:
        IF X25 THEN
            state := 40;
        END_IF;

    40:
        IF X23 AND (D20 <= 4) THEN
            state := 50;
        END_IF;

    50:
        IF X20 AND prod_timer.Q THEN
            state := 60;
        END_IF;

    60:
        IF X22 AND (D20 >= 275) THEN
            state := 70;
        END_IF;

    70:
        IF X24 THEN
            state := 80;
        END_IF;

    80:
        IF X23 AND (D20 <= 4) THEN
            state := 90;
        END_IF;

    90:
        IF (NOT X20) AND rel_timer.Q THEN
            state := 100;
        END_IF;

    100:
        IF X22 AND (D20 >= 275) THEN
            state := 999;
        END_IF;

    999:
        ;
END_CASE;

Y2 := (state = 999);
Y20 := (state = 50) OR (state = 60) OR (state = 70) OR (state = 80);
Y21 := (state >= 10);
Y22 := (state = 60) OR (state = 100);
Y23 := (state = 40) OR (state = 80);
Y24 := (state = 30);
Y25 := (state = 70);
Y26 := (state = 20);
Y27 := FALSE;

END_PROGRAM