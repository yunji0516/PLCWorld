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
    state : INT := 0;
    pouchId : INT := 0;
    sep_count : INT := 0;
    align_count : INT := 0;
    receipt_count : INT := 0;
    contentAvail : BOOL := FALSE;
    openReady : BOOL := FALSE;
    insertReady : BOOL := FALSE;
    homeReady : BOOL := FALSE;
    sepHoldTimer : TON;
    alignTimer : TON;
END_VAR

sepHoldTimer(IN := (state = 20) AND X20 AND (NOT X21), PT := T#250ms);
alignTimer(IN := (state = 43), PT := T#350ms);

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

contentAvail := FALSE;
IF pouchId = 1 THEN
    IF (D4 = 1) OR (D4 = 3) OR (D4 = 5) OR (D4 = 7) OR (D4 = 9) OR (D4 = 11) OR (D4 = 13) OR (D4 = 15) THEN
        contentAvail := TRUE;
    END_IF;
ELSIF pouchId = 2 THEN
    IF (D4 = 2) OR (D4 = 3) OR (D4 = 6) OR (D4 = 7) OR (D4 = 10) OR (D4 = 11) OR (D4 = 14) OR (D4 = 15) THEN
        contentAvail := TRUE;
    END_IF;
ELSIF pouchId = 3 THEN
    IF (D4 = 4) OR (D4 = 5) OR (D4 = 6) OR (D4 = 7) OR (D4 = 12) OR (D4 = 13) OR (D4 = 14) OR (D4 = 15) THEN
        contentAvail := TRUE;
    END_IF;
ELSIF pouchId = 4 THEN
    IF (D4 = 8) OR (D4 = 9) OR (D4 = 10) OR (D4 = 11) OR (D4 = 12) OR (D4 = 13) OR (D4 = 14) OR (D4 = 15) THEN
        contentAvail := TRUE;
    END_IF;
END_IF;

openReady := X1A AND X1B AND X1C AND (D5 >= 34);
insertReady := X13 AND (D2 = pouchId) AND (pouchId >= 1) AND (pouchId <= 4) AND X24 AND X25 AND X1A AND X1B AND X1C AND (D5 >= (D6 + 4)) AND X17 AND (NOT X16);
homeReady := (NOT X11) AND (NOT X13) AND X17 AND (NOT X16) AND (D2 = 0) AND (NOT X14) AND X25;

CASE state OF
    0:
        pouchId := 0;
        IF X0 THEN
            state := 10;
        END_IF;

    10:
        pouchId := 0;
        IF (receipt_count >= 4) AND (sep_count >= 2) AND (align_count >= 4) AND X1F AND homeReady THEN
            state := 900;
        ELSIF X20 AND X10 AND (sep_count < 2) AND (NOT X12) AND (NOT X21) AND (NOT X11) AND (NOT X13) THEN
            state := 20;
        ELSIF X10 AND X23 AND (NOT X20) AND (NOT X12) AND (NOT X21) AND (NOT X22) AND (NOT X11) AND (NOT X13) THEN
            state := 30;
        END_IF;

    20:
        Y1B := TRUE;
        IF sepHoldTimer.Q AND X22 AND X20 AND (NOT X21) AND (NOT X12) THEN
            state := 21;
        END_IF;

    21:
        Y1B := TRUE;
        Y1C := TRUE;
        state := 22;

    22:
        Y1B := TRUE;
        IF (NOT X21) AND X23 THEN
            IF sep_count < 2 THEN
                sep_count := sep_count + 1;
            END_IF;
            state := 23;
        END_IF;

    23:
        IF (NOT X22) AND (NOT X21) THEN
            state := 10;
        END_IF;

    30:
        Y10 := TRUE;
        state := 31;

    31:
        IF X11 AND (D0 >= 1) AND (D0 <= 4) THEN
            pouchId := D0;
            state := 32;
        END_IF;

    32:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF openReady AND (NOT X12) THEN
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
        IF X13 THEN
            state := 40;
        END_IF;

    40:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        D200 := pouchId;
        IF (D2 = pouchId) AND (pouchId >= 1) AND (pouchId <= 4) THEN
            state := 42;
        ELSIF (D2 = 0) AND (NOT X14) AND X15 AND contentAvail AND (pouchId >= 1) AND (pouchId <= 4) THEN
            state := 41;
        END_IF;

    41:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        D200 := pouchId;
        Y11 := TRUE;
        state := 42;

    42:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        D200 := pouchId;
        IF (D2 = pouchId) AND (D6 >= 30) AND (D6 <= 34) AND (NOT X14) THEN
            state := 43;
        END_IF;

    43:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y1D := TRUE;
        Y1E := TRUE;
        IF X24 AND alignTimer.Q THEN
            align_count := align_count + 1;
            state := 44;
        END_IF;

    44:
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
        IF insertReady THEN
            state := 51;
        END_IF;

    51:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y16 := TRUE;
        IF X19 THEN
            state := 52;
        END_IF;

    52:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y17 := TRUE;
        IF X19 AND X17 AND (NOT X16) AND (NOT X14) AND X25 AND X1D THEN
            state := 53;
        END_IF;

    53:
        Y18 := TRUE;
        state := 54;

    54:
        IF X1E THEN
            IF receipt_count < 4 THEN
                receipt_count := receipt_count + 1;
            END_IF;
            state := 55;
        END_IF;

    55:
        Y19 := TRUE;
        IF NOT X1E THEN
            state := 56;
        END_IF;

    56:
        IF (receipt_count >= 4) AND (sep_count >= 2) AND (align_count >= 4) AND X1F AND homeReady THEN
            state := 900;
        ELSIF homeReady THEN
            state := 10;
        END_IF;

    900:
        Y1A := TRUE;

ELSE
    state := 0;
END_CASE;

END_PROGRAM