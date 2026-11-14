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
    rtrig_start : R_TRIG;
    timer_settle : TON;
END_VAR

rtrig_start(CLK := X10);
timer_settle(IN := (state = 110), PT := T#100ms);

CASE state OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        IF rtrig_start.Q AND (D10 = 1) THEN
            state := 10;
        END_IF;

    10:
        Y21 := TRUE;
        IF X21 THEN
            state := 20;
        END_IF;

    20:
        Y21 := TRUE;
        Y26 := TRUE;
        IF X27 AND (D21 >= 650) THEN
            Y26 := FALSE;
            state := 30;
        END_IF;

    30:
        Y21 := TRUE;
        IF (D20 >= 250) AND X27 THEN
            Y24 := TRUE;
        ELSE
            Y24 := FALSE;
        END_IF;
        IF X25 THEN
            Y24 := FALSE;
            state := 40;
        END_IF;

    40:
        Y21 := TRUE;
        Y23 := TRUE;
        IF X23 AND (D20 <= 4) THEN
            Y23 := FALSE;
            state := 50;
        END_IF;

    50:
        Y21 := TRUE;
        Y20 := TRUE;
        IF X20 THEN
            state := 60;
        END_IF;

    60:
        Y21 := TRUE;
        Y20 := TRUE;
        Y22 := TRUE;
        IF X22 AND (D20 >= 280) THEN
            Y22 := FALSE;
            state := 70;
        END_IF;

    70:
        Y21 := TRUE;
        Y20 := TRUE;
        IF D20 >= 250 THEN
            Y25 := TRUE;
        ELSE
            Y25 := FALSE;
        END_IF;
        IF X24 THEN
            Y25 := FALSE;
            state := 80;
        END_IF;

    80:
        Y21 := TRUE;
        Y20 := TRUE;
        Y23 := TRUE;
        IF X23 AND (D20 <= 4) THEN
            Y23 := FALSE;
            state := 90;
        END_IF;

    90:
        Y21 := TRUE;
        Y20 := FALSE;
        IF X26 AND (NOT X20) THEN
            state := 100;
        END_IF;

    100:
        Y21 := TRUE;
        Y22 := TRUE;
        IF X22 AND (D20 >= 280) THEN
            Y22 := FALSE;
            state := 110;
        END_IF;

    110:
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        IF timer_settle.Q AND X24 AND X22 AND (D20 >= 280) AND X27 AND (D21 >= 650) AND X21 AND X26 AND (NOT X20) THEN
            state := 120;
        END_IF;

    120:
        Y2 := TRUE;
        Y21 := TRUE;
        Y20 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
END_CASE;

IF (Y24 OR Y25) AND (D20 < 250) THEN
    Y24 := FALSE;
    Y25 := FALSE;
END_IF;

IF Y22 AND Y23 THEN
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

IF Y24 AND Y25 THEN
    Y24 := FALSE;
    Y25 := FALSE;
END_IF;

IF Y26 AND Y27 THEN
    Y26 := FALSE;
    Y27 := FALSE;
END_IF;

END_PROGRAM