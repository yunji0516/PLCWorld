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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    state : INT;
    current_id : INT;
    pkg_count : INT;
    sep_count : INT;
    align_count : INT;
    pkg_done : ARRAY[1..4] OF BOOL;
    align_done : ARRAY[1..4] OF BOOL;
    sepHoldTimer : TON;
    ackTimer : TON;
    content_available : BOOL;
    allPackagesDone : BOOL;
    readyHome : BOOL;
    aperture_safe : BOOL;
END_VAR

sepHoldTimer(IN := (state = 20), PT := T#250ms);
ackTimer(IN := (state = 54), PT := T#100ms);

Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
D200 := 0;

content_available := FALSE;
CASE current_id OF
    1:
        content_available := (INT(AND_WORD(WORD(D4), WORD(1))) <> 0);
    2:
        content_available := (INT(AND_WORD(WORD(D4), WORD(2))) <> 0);
    3:
        content_available := (INT(AND_WORD(WORD(D4), WORD(4))) <> 0);
    4:
        content_available := (INT(AND_WORD(WORD(D4), WORD(8))) <> 0);
ELSE
    content_available := FALSE;
END_CASE;

allPackagesDone := (pkg_count >= 4) AND (sep_count >= 2) AND (align_count >= 4);
readyHome := (NOT X11) AND (NOT X12) AND (NOT X13) AND (NOT X14) AND (NOT X16) AND X17 AND X25 AND X1D AND (D2 = 0);
aperture_safe := X1A AND X1B AND X1C AND (D5 >= 39);

CASE state OF
    0:
        IF X0 THEN
            state := 10;
        END_IF;

    10:
        current_id := 0;
        IF allPackagesDone THEN
            state := 90;
        ELSIF X10 AND (NOT X12) THEN
            IF X20 AND (NOT X21) THEN
                state := 20;
            ELSIF X23 AND (NOT X21) THEN
                state := 30;
            END_IF;
        END_IF;

    20:
        Y1B := TRUE;
        IF (NOT X10) OR X12 THEN
            state := 10;
        ELSIF sepHoldTimer.Q AND X22 AND X20 AND (NOT X21) THEN
            state := 21;
        END_IF;

    21:
        Y1B := TRUE;
        IF X22 AND X20 AND (NOT X21) THEN
            Y1C := TRUE;
            state := 22;
        ELSE
            state := 20;
        END_IF;

    22:
        Y1B := TRUE;
        IF (NOT X21) AND X23 THEN
            IF sep_count < 2 THEN
                sep_count := sep_count + 1;
            END_IF;
            state := 10;
        END_IF;

    30:
        IF X10 AND X23 AND (NOT X12) AND (NOT X21) THEN
            Y10 := TRUE;
            state := 31;
        ELSE
            state := 10;
        END_IF;

    31:
        IF X11 AND (D0 >= 1) AND (D0 <= 4) THEN
            current_id := D0;
            IF NOT pkg_done[current_id] THEN
                state := 32;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    32:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF X11 AND aperture_safe THEN
            state := 33;
        END_IF;

    33:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y15 := TRUE;
        state := 34;

    34:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF X13 AND aperture_safe THEN
            state := 40;
        END_IF;

    40:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF X13 AND aperture_safe AND (current_id >= 1) AND (current_id <= 4) THEN
            IF content_available AND (D2 = 0) AND (NOT X14) THEN
                D200 := current_id;
                Y11 := TRUE;
                state := 41;
            END_IF;
        END_IF;

    41:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        D200 := current_id;
        IF X15 AND (NOT X14) AND (D2 = current_id) AND ((D6 = 30) OR (D6 = 34)) THEN
            state := 42;
        END_IF;

    42:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y1D := TRUE;
        Y1E := TRUE;
        IF X24 AND (D2 = current_id) THEN
            IF (current_id >= 1) AND (current_id <= 4) THEN
                IF NOT align_done[current_id] THEN
                    align_done[current_id] := TRUE;
                    align_count := align_count + 1;
                END_IF;
            END_IF;
            state := 43;
        END_IF;

    43:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF X25 THEN
            state := 50;
        END_IF;

    50:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF X13 AND (D2 = current_id) AND X24 AND X25 AND X1A AND X1B AND X1C AND (D5 >= (D6 + 5)) THEN
            Y16 := TRUE;
            IF X19 AND X18 THEN
                state := 51;
            END_IF;
        END_IF;

    51:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y17 := TRUE;
        IF X17 AND (NOT X16) THEN
            state := 52;
        END_IF;

    52:
        IF X19 AND X17 AND (NOT X16) AND (NOT X14) AND X25 AND X1D THEN
            Y18 := TRUE;
            state := 53;
        END_IF;

    53:
        IF X1E THEN
            IF (current_id >= 1) AND (current_id <= 4) THEN
                IF NOT pkg_done[current_id] THEN
                    pkg_done[current_id] := TRUE;
                    pkg_count := pkg_count + 1;
                END_IF;
            END_IF;
            state := 54;
        END_IF;

    54:
        Y19 := TRUE;
        IF ackTimer.Q THEN
            state := 55;
        END_IF;

    55:
        IF (NOT X1E) AND readyHome THEN
            IF allPackagesDone THEN
                state := 90;
            ELSE
                state := 10;
            END_IF;
        END_IF;

    90:
        IF allPackagesDone AND readyHome THEN
            state := 100;
        END_IF;

    100:
        Y1A := TRUE;

ELSE
    state := 0;
END_CASE;

END_PROGRAM