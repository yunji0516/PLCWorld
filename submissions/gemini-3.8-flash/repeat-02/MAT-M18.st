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
    target_len : INT := 0;
    ton_hold : TON;
    ton_grip : TON;
    ton_release : TON;
END_VAR

ton_hold(IN := (state = 60 AND X1C), PT := T#100ms);
ton_grip(IN := (state = 70 AND X13), PT := T#100ms);
ton_release(IN := (state = 120 AND NOT X1C), PT := T#200ms);

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
        IF X0 AND X12 AND NOT X14 THEN
            target_len := D0;
            D200 := target_len;
            state := 10;
        END_IF;

    10:
        Y10 := TRUE;
        Y11 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        D200 := target_len;
        IF D1 < target_len THEN
            Y12 := TRUE;
        ELSE
            Y12 := FALSE;
            IF X11 THEN
                state := 20;
            END_IF;
        END_IF;

    20:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        IF X14 THEN
            state := 30;
        END_IF;

    30:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := TRUE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        IF X16 THEN
            state := 40;
        END_IF;

    40:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        IF X15 AND X17 THEN
            state := 50;
        END_IF;

    50:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        IF X19 AND X1A THEN
            state := 60;
        END_IF;

    60:
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        IF ton_hold.Q THEN
            state := 70;
        END_IF;

    70:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        IF ton_grip.Q THEN
            state := 80;
        END_IF;

    80:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        IF X18 THEN
            state := 90;
        END_IF;

    90:
        Y10 := FALSE;
        Y11 := TRUE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := TRUE;
        Y17 := FALSE;
        D200 := 100;
        IF D1 > 100 THEN
            Y12 := TRUE;
        ELSE
            Y12 := FALSE;
            IF X11 AND X10 THEN
                state := 100;
            END_IF;
        END_IF;

    100:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := FALSE;
        IF X1B AND X18 THEN
            state := 110;
        END_IF;

    110:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y17 := FALSE;
        IF X19 AND X1D THEN
            state := 120;
        END_IF;

    120:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        IF ton_release.Q AND (ABS(D3 - target_len) <= 1) THEN
            state := 130;
        END_IF;

    130:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        IF X18 THEN
            state := 140;
        END_IF;

    140:
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
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
        Y17 := TRUE;
        D200 := 100;
END_CASE;

END_PROGRAM