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

    r_trig_start : R_TRIG;
    timer_release : TON;
    timer_done : TON;
    step : INT := 0;
END_VAR

r_trig_start(CLK := X10);
timer_release(IN := (step = 9), PT := T#200ms);
timer_done(IN := (step = 11), PT := T#100ms);

CASE step OF
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
        IF r_trig_start.Q AND (D10 = 1) THEN
            step := 1;
        END_IF;

    1:
        Y21 := TRUE;
        IF X21 THEN
            step := 2;
        END_IF;

    2:
        Y26 := TRUE;
        IF X27 THEN
            Y26 := FALSE;
            step := 3;
        END_IF;

    3:
        IF X22 AND (D20 >= 250) THEN
            Y24 := TRUE;
        END_IF;
        IF X25 THEN
            Y24 := FALSE;
            step := 4;
        END_IF;

    4:
        Y23 := TRUE;
        IF X23 OR (D20 <= 4) THEN
            Y23 := FALSE;
            step := 5;
        END_IF;

    5:
        Y20 := TRUE;
        IF X20 THEN
            step := 6;
        END_IF;

    6:
        Y22 := TRUE;
        IF X22 AND (D20 >= 250) THEN
            Y22 := FALSE;
            step := 7;
        END_IF;

    7:
        IF X22 AND (D20 >= 250) THEN
            Y25 := TRUE;
        END_IF;
        IF X24 THEN
            Y25 := FALSE;
            step := 8;
        END_IF;

    8:
        Y23 := TRUE;
        IF X23 OR (D20 <= 4) THEN
            Y23 := FALSE;
            step := 9;
        END_IF;

    9:
        Y20 := FALSE;
        IF timer_release.Q AND (NOT X20) AND X26 THEN
            step := 10;
        END_IF;

    10:
        Y22 := TRUE;
        IF X22 AND (D20 >= 278) THEN
            Y22 := FALSE;
            step := 11;
        END_IF;

    11:
        IF timer_done.Q AND X24 AND X22 AND X26 AND X27 AND X21 AND (NOT X20) THEN
            step := 12;
        END_IF;

    12:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
END_CASE;

IF (step < 1) OR (step = 12) THEN
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;
END_IF;

IF step = 12 THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := TRUE;
END_IF;

IF D20 < 250 THEN
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