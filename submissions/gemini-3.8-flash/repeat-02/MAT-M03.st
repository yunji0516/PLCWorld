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
    Y26 : BOOL;
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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL;
    state : INT;
    claim : BOOL;
    trig_start : R_TRIG;
    ton_align : TON;
    ton_grip : TON;
    ton_release : TON;
    ton_stop : TON;
END_VAR

trig_start(CLK := X10);
ton_align(IN := (state = 10) AND X31 AND X32, PT := T#100ms);
ton_grip(IN := (state = 40) AND X24, PT := T#50ms);
ton_release(IN := (state = 80) AND X25 AND X27, PT := T#50ms);
ton_stop(IN := (state = 110) AND X20 AND X23 AND X25 AND X27 AND X28, PT := T#50ms);

CASE state OF
    0:
        IF trig_start.Q AND (D10 = 1) THEN
            IF X31 AND X32 THEN
                state := 30;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    10:
        IF ton_align.Q THEN
            state := 20;
        END_IF;

    20:
        IF X29 THEN
            state := 30;
        END_IF;

    30:
        IF X22 THEN
            state := 40;
        END_IF;

    40:
        IF ton_grip.Q THEN
            state := 50;
        END_IF;

    50:
        IF X23 THEN
            state := 55;
        END_IF;

    55:
        IF X28 THEN
            state := 60;
        END_IF;

    60:
        IF X21 THEN
            state := 65;
        END_IF;

    65:
        IF X28 THEN
            state := 70;
        END_IF;

    70:
        IF X22 THEN
            state := 80;
        END_IF;

    80:
        IF ton_release.Q THEN
            state := 90;
        END_IF;

    90:
        IF X23 THEN
            state := 95;
        END_IF;

    95:
        IF X28 THEN
            state := 100;
        END_IF;

    100:
        IF X20 THEN
            state := 110;
        END_IF;

    110:
        IF ton_stop.Q THEN
            claim := TRUE;
        END_IF;
END_CASE;

Y20 := (state = 40) OR (state = 50) OR (state = 55) OR (state = 60) OR (state = 65) OR (state = 70);
Y21 := (state = 60);
Y22 := (state = 100);
Y23 := (state = 50) OR (state = 90);
Y24 := (state = 30) OR (state = 70);
Y25 := (state = 10);
Y26 := (state = 10);
Y2 := claim;

END_PROGRAM