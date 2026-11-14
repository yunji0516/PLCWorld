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
    req_mm : INT := 300;
    stockOpenTimer : TON;
    final_ok : BOOL;
END_VAR

IF state = 0 THEN
    req_mm := D0;
    IF req_mm < 300 THEN
        req_mm := 300;
    ELSIF req_mm > 440 THEN
        req_mm := 440;
    END_IF;

    IF X0 THEN
        state := 10;
    END_IF;
END_IF;

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
D200 := req_mm;

CASE state OF
    0:
        D200 := 100;
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;

    10:
        D200 := req_mm;
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;

    20:
        D200 := req_mm;
        Y10 := TRUE;
        Y11 := FALSE;
        Y12 := TRUE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;

    30:
        D200 := req_mm;
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;

    40:
        D200 := req_mm;
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := FALSE;

    45:
        D200 := req_mm;
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;

    50:
        D200 := req_mm;
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;

    55:
        D200 := req_mm;
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;

    60:
        D200 := req_mm;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := TRUE;

    70:
        D200 := req_mm;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := TRUE;

    80:
        D200 := req_mm;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := TRUE;

    90:
        D200 := req_mm;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := TRUE;

    100:
        D200 := req_mm;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := TRUE;
        Y15 := TRUE;
        Y16 := FALSE;

    110:
        D200 := req_mm;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;

    120:
        D200 := req_mm;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;

    130:
        D200 := 100;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := TRUE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;

    140:
        D200 := 100;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;

    200:
        D200 := 100;
        Y10 := FALSE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := TRUE;

ELSE
        state := 0;
END_CASE;

stockOpenTimer(IN := ((state = 0) OR (state = 10)), PT := T#400ms);

final_ok := X14 AND X15 AND X10 AND X11 AND X13 AND X18 AND X1A AND (NOT X1C) AND X1D
            AND (ABS(D3 - req_mm) <= 1)
            AND (ABS(D2 + 300) <= 2)
            AND (NOT Y10) AND Y11 AND (NOT Y12) AND (NOT Y13)
            AND (NOT Y14) AND (NOT Y15) AND (NOT Y16);

CASE state OF
    10:
        IF X12 AND (NOT X14) AND X15 AND stockOpenTimer.Q THEN
            state := 20;
        END_IF;

    20:
        IF ABS(D1 - req_mm) <= 1 THEN
            state := 30;
        END_IF;

    30:
        IF X11 AND X14 THEN
            state := 40;
        END_IF;

    40:
        IF X19 AND X1A THEN
            state := 45;
        END_IF;

    45:
        IF X1C THEN
            state := 50;
        END_IF;

    50:
        IF X16 THEN
            state := 55;
        END_IF;

    55:
        IF X15 AND X17 THEN
            state := 60;
        END_IF;

    60:
        IF X13 THEN
            state := 70;
        END_IF;

    70:
        IF X18 THEN
            state := 80;
        END_IF;

    80:
        IF X1B THEN
            state := 90;
        END_IF;

    90:
        IF X19 AND X1B THEN
            state := 100;
        END_IF;

    100:
        IF (NOT X1C) AND X1D AND (ABS(D3 - req_mm) <= 1) THEN
            state := 110;
        END_IF;

    110:
        IF X18 THEN
            state := 120;
        END_IF;

    120:
        IF X1A THEN
            state := 130;
        END_IF;

    130:
        IF X10 OR (ABS(D1 - 100) <= 1) THEN
            state := 140;
        END_IF;

    140:
        IF final_ok THEN
            state := 200;
        END_IF;

    200:
        state := 200;
END_CASE;

END_PROGRAM