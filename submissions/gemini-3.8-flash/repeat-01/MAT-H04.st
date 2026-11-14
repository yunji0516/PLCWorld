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
    cur_pouch_id : INT := 0;
    packages_done : INT := 0;
    pulse_cnt : INT := 0;
    ton_sep_hold : TON;
    ton_align : TON;
    ton_closure : TON;
    ton_complete : TON;
END_VAR

ton_sep_hold(IN := (state = 20), PT := T#300ms);
ton_align(IN := (state = 53), PT := T#500ms);
ton_closure(IN := (state = 70), PT := T#500ms);
ton_complete(IN := (state = 91), PT := T#600ms);

CASE state OF
    0:
        IF X0 THEN
            state := 10;
        END_IF;

    10:
        IF packages_done >= 4 OR X1F THEN
            state := 90;
        ELSIF X10 AND (NOT X12) AND (NOT X13) AND (NOT X11) THEN
            IF X20 AND (NOT X21) THEN
                state := 20;
            ELSIF X23 AND (NOT X21) THEN
                state := 30;
                pulse_cnt := 0;
            END_IF;
        END_IF;

    20:
        Y1B := TRUE;
        IF ton_sep_hold.Q AND X22 THEN
            state := 21;
            pulse_cnt := 0;
        END_IF;

    21:
        Y1B := TRUE;
        Y1C := TRUE;
        pulse_cnt := pulse_cnt + 1;
        IF X21 OR pulse_cnt >= 5 THEN
            Y1C := FALSE;
            pulse_cnt := 0;
            state := 22;
        END_IF;

    22:
        Y1B := TRUE;
        IF NOT X21 THEN
            Y1B := FALSE;
            state := 23;
        END_IF;

    23:
        Y1B := FALSE;
        IF (NOT X21) AND X23 THEN
            state := 30;
            pulse_cnt := 0;
        END_IF;

    30:
        Y10 := TRUE;
        pulse_cnt := pulse_cnt + 1;
        IF X12 OR pulse_cnt >= 5 THEN
            Y10 := FALSE;
            pulse_cnt := 0;
            state := 31;
        END_IF;

    31:
        Y10 := FALSE;
        IF (NOT X12) AND X11 AND (D0 > 0) THEN
            cur_pouch_id := D0;
            state := 35;
            pulse_cnt := 0;
        END_IF;

    35:
        Y15 := TRUE;
        pulse_cnt := pulse_cnt + 1;
        IF X12 OR pulse_cnt >= 5 THEN
            Y15 := FALSE;
            pulse_cnt := 0;
            state := 36;
        END_IF;

    36:
        Y15 := FALSE;
        IF (NOT X12) AND X13 THEN
            state := 40;
        END_IF;

    40:
        Y12 := TRUE;
        Y13 := TRUE;
        IF X1A AND X1B THEN
            state := 41;
        END_IF;

    41:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF X1C THEN
            state := 50;
            pulse_cnt := 0;
        END_IF;

    50:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF cur_pouch_id >= 1 AND cur_pouch_id <= 4 THEN
            IF ((SHR(D4, cur_pouch_id - 1) AND 1) = 1) AND (NOT X14) AND (D2 = 0) THEN
                D200 := cur_pouch_id;
                Y11 := TRUE;
                pulse_cnt := pulse_cnt + 1;
                IF X14 OR pulse_cnt >= 5 THEN
                    Y11 := FALSE;
                    pulse_cnt := 0;
                    state := 51;
                END_IF;
            END_IF;
        END_IF;

    51:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y11 := FALSE;
        IF (NOT X14) AND (D2 = cur_pouch_id) THEN
            state := 53;
        END_IF;

    53:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y1D := TRUE;
        Y1E := TRUE;
        IF ton_align.Q AND X24 THEN
            Y1D := FALSE;
            Y1E := FALSE;
            state := 54;
        END_IF;

    54:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y1D := FALSE;
        Y1E := FALSE;
        IF X25 THEN
            state := 60;
        END_IF;

    60:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        IF X13 AND X1A AND X1B AND X1C AND X24 AND X25 AND (D2 = cur_pouch_id) AND X17 THEN
            Y16 := TRUE;
            state := 61;
        END_IF;

    61:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y16 := TRUE;
        IF X18 AND X19 THEN
            Y16 := FALSE;
            state := 62;
        END_IF;

    62:
        Y12 := TRUE;
        Y13 := TRUE;
        Y14 := TRUE;
        Y16 := FALSE;
        Y17 := TRUE;
        IF X17 AND (NOT X16) THEN
            Y17 := FALSE;
            state := 70;
        END_IF;

    70:
        Y14 := FALSE;
        Y12 := TRUE;
        Y13 := TRUE;
        Y16 := FALSE;
        Y17 := FALSE;
        IF ton_closure.Q THEN
            Y12 := FALSE;
            Y13 := FALSE;
            state := 71;
            pulse_cnt := 0;
        END_IF;

    71:
        Y14 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        IF X19 AND X17 AND (NOT X14) AND X1D THEN
            Y18 := TRUE;
            pulse_cnt := pulse_cnt + 1;
            IF pulse_cnt >= 3 THEN
                Y18 := FALSE;
                pulse_cnt := 0;
                state := 72;
            END_IF;
        END_IF;

    72:
        Y18 := FALSE;
        IF X1E THEN
            Y19 := TRUE;
            packages_done := packages_done + 1;
            state := 73;
        END_IF;

    73:
        Y19 := TRUE;
        IF NOT X1E THEN
            Y19 := FALSE;
            state := 80;
            pulse_cnt := 0;
        END_IF;

    80:
        Y19 := FALSE;
        Y15 := TRUE;
        pulse_cnt := pulse_cnt + 1;
        IF X12 OR pulse_cnt >= 5 THEN
            Y15 := FALSE;
            pulse_cnt := 0;
            state := 81;
        END_IF;

    81:
        Y15 := FALSE;
        IF (NOT X12) AND (NOT X13) THEN
            IF packages_done >= 4 OR X1F THEN
                state := 90;
            ELSE
                cur_pouch_id := 0;
                state := 10;
            END_IF;
        END_IF;

    90:
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
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y1E := FALSE;
        IF (NOT X13) AND X17 AND (NOT X14) THEN
            Y1A := TRUE;
            state := 91;
        END_IF;

    91:
        Y1A := TRUE;
END_CASE;

END_PROGRAM