PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;

    state : INT := 0;
    trig_start : R_TRIG;
    t_arm : TON;
END_VAR

trig_start(CLK := X10);

t_arm(IN := (state >= 10 AND state < 30 AND NOT X23 AND NOT Y23), PT := T#3600ms);

CASE state OF
    0:
        IF trig_start.Q AND (D10 = 1) THEN
            state := 10;
        END_IF;

    10:
        IF X21 THEN
            state := 20;
        END_IF;

    20:
        IF X21 AND X24 AND t_arm.Q THEN
            state := 30;
        END_IF;

    30:
        IF X23 THEN
            state := 40;
        END_IF;

    40:
        IF X22 AND X25 THEN
            state := 50;
        END_IF;

    50:
        IF X20 THEN
            state := 60;
        END_IF;

    60:
        IF NOT X23 THEN
            state := 70;
        END_IF;

    70:
        ;
END_CASE;

Y20 := (state = 10);
Y21 := (state = 50);
Y22 := (state >= 40);
Y23 := (state = 30 OR state = 40);
Y2 := (state = 70);

END_PROGRAM