PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D200 : INT;

    state : INT := 0;
    t_delay : TON;
    t_delay_in : BOOL := FALSE;
    t_delay_pt : TIME := T#0ms;
END_VAR

CASE state OF
    0:
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        D200 := 100;
        t_delay_in := FALSE;
        IF X0 AND X12 AND (NOT X14) THEN
            D200 := D0;
            state := 10;
        END_IF;

    10:
        Y10 := TRUE;
        Y11 := FALSE;
        D200 := D0;
        Y12 := TRUE;
        IF X11 AND (D1 = D0) THEN
            Y12 := FALSE;
            state := 20;
        END_IF;

    20:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        IF X14 THEN
            state := 30;
        END_IF;

    30:
        Y10 := TRUE;
        Y11 := TRUE;
        Y14 := TRUE;
        IF X19 THEN
            state := 40;
        END_IF;

    40:
        Y10 := TRUE;
        Y11 := TRUE;
        Y14 := TRUE;
        Y16 := TRUE;
        IF X1C THEN
            state := 50;
        END_IF;

    50:
        Y10 := TRUE;
        Y11 := TRUE;
        Y14 := TRUE;
        Y16 := TRUE;
        Y13 := TRUE;
        IF X16 THEN
            state := 60;
        END_IF;

    60:
        Y10 := TRUE;
        Y11 := TRUE;
        Y14 := TRUE;
        Y16 := TRUE;
        Y13 := FALSE;
        IF X15 AND X17 THEN
            state := 70;
        END_IF;

    70:
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := TRUE;
        Y16 := TRUE;
        IF X13 THEN
            state := 80;
        END_IF;

    80:
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := FALSE;
        Y16 := TRUE;
        IF X18 THEN
            state := 90;
        END_IF;

    90:
        Y10 := FALSE;
        Y11 := TRUE;
        Y16 := TRUE;
        D200 := 100;
        Y12 := TRUE;
        IF X10 AND X11 AND (D1 = 100) THEN
            Y12 := FALSE;
            state := 100;
        END_IF;

    100:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y16 := TRUE;
        Y15 := TRUE;
        IF X1B AND X18 THEN
            state := 110;
        END_IF;

    110:
        Y10 := FALSE;
        Y11 := TRUE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y14 := TRUE;
        IF X19 THEN
            state := 120;
        END_IF;

    120:
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := FALSE;
        t_delay_in := (NOT X1C) AND X1D;
        t_delay_pt := T#200ms;
        IF t_delay.Q THEN
            t_delay_in := FALSE;
            state := 130;
        END_IF;

    130:
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;
        IF X18 THEN
            state := 140;
        END_IF;

    140:
        Y10 := FALSE;
        Y11 := TRUE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        IF X1A AND X18 THEN
            state := 150;
        END_IF;

    150:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        D200 := 100;
        IF X14 AND X15 AND X17 AND X13 AND X10 AND X11 AND X18 AND X1A AND (NOT X1C) AND X1D AND (ABS(D3 - D0) <= 1) THEN
            Y17 := TRUE;
        END_IF;
END_CASE;

t_delay(IN := t_delay_in, PT := t_delay_pt);

END_PROGRAM