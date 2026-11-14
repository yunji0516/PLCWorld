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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    state_a : INT := 0;
    state_b : INT := 0;
    state_swap : INT := 0;
    state_retrieval : INT := 0;

    a_trays_done : INT := 0;
    b_trays_done : INT := 0;
    res_a : INT := 0;
    res_b : INT := 0;

    swap_done : BOOL := FALSE;
    take_bin_sent : BOOL := FALSE;
    take_bin_done : BOOL := FALSE;
    complete_latch : BOOL := FALSE;
    sys_start : BOOL := FALSE;
END_VAR

sys_start := sys_start OR X0 OR X16 OR X1C;

IF complete_latch THEN
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := TRUE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
ELSE
    CASE state_a OF
        0:
            Y13 := FALSE;
            Y14 := FALSE;
            Y15 := FALSE;
            res_a := 0;
            IF sys_start AND (a_trays_done < 2) AND X16 AND (NOT X17) AND (NOT X18) AND (NOT X19) AND (NOT X1A) THEN
                IF X10 AND (NOT X11) AND ((D0 + D1 + res_b + 3) <= 6) THEN
                    res_a := 3;
                    Y13 := TRUE;
                    state_a := 1;
                END_IF;
            END_IF;

        1:
            Y13 := TRUE;
            IF X17 THEN
                Y13 := FALSE;
                state_a := 2;
            END_IF;

        2:
            Y13 := FALSE;
            IF X17 AND (NOT X18) AND (NOT X19) AND X10 AND (NOT X11) THEN
                Y14 := TRUE;
                state_a := 3;
            END_IF;

        3:
            Y14 := FALSE;
            IF X1A THEN
                state_a := 4;
            END_IF;

        4:
            Y14 := FALSE;
            IF X1A AND X1B THEN
                Y15 := TRUE;
                state_a := 5;
            END_IF;

        5:
            Y15 := FALSE;
            IF (NOT X17) AND (NOT X1A) THEN
                a_trays_done := a_trays_done + 1;
                res_a := 0;
                IF a_trays_done >= 2 THEN
                    state_a := 6;
                ELSE
                    state_a := 0;
                END_IF;
            END_IF;

        6:
            Y13 := FALSE;
            Y14 := FALSE;
            Y15 := FALSE;
            res_a := 0;
    END_CASE;

    CASE state_b OF
        0:
            Y16 := FALSE;
            Y17 := FALSE;
            Y18 := FALSE;
            res_b := 0;
            IF sys_start AND (b_trays_done < 1) AND X1C AND (NOT X1D) AND (NOT X1E) AND (NOT X1F) AND (NOT X20) THEN
                IF X10 AND (NOT X11) AND ((D0 + D1 + res_a + 2) <= 6) THEN
                    res_b := 2;
                    Y16 := TRUE;
                    state_b := 1;
                END_IF;
            END_IF;

        1:
            Y16 := TRUE;
            IF X1D THEN
                Y16 := FALSE;
                state_b := 2;
            END_IF;

        2:
            Y16 := FALSE;
            IF X1D AND (NOT X1E) AND (NOT X1F) AND X10 AND (NOT X11) THEN
                Y17 := TRUE;
                state_b := 3;
            END_IF;

        3:
            Y17 := FALSE;
            IF X20 THEN
                state_b := 4;
            END_IF;

        4:
            Y17 := FALSE;
            IF X20 AND X21 THEN
                Y18 := TRUE;
                state_b := 5;
            END_IF;

        5:
            Y18 := FALSE;
            IF (NOT X1D) AND (NOT X20) THEN
                b_trays_done := b_trays_done + 1;
                res_b := 0;
                state_b := 6;
            END_IF;

        6:
            Y16 := FALSE;
            Y17 := FALSE;
            Y18 := FALSE;
            res_b := 0;
    END_CASE;

    CASE state_swap OF
        0:
            Y10 := FALSE;
            IF (a_trays_done >= 1) AND (b_trays_done >= 1) AND (D1 = 0) AND (D0 = 5) AND X12 AND (NOT X11) AND (NOT X13) AND (NOT X14) THEN
                Y10 := TRUE;
                state_swap := 1;
            END_IF;

        1:
            Y10 := FALSE;
            state_swap := 2;

        2:
            Y10 := FALSE;
            IF X11 OR (NOT X10) THEN
                state_swap := 3;
            END_IF;

        3:
            Y10 := FALSE;
            IF (NOT X11) AND X10 AND (D2 = 102) THEN
                swap_done := TRUE;
                state_swap := 4;
            END_IF;

        4:
            Y10 := FALSE;
    END_CASE;

    CASE state_retrieval OF
        0:
            Y11 := FALSE;
            IF X13 AND (NOT take_bin_done) THEN
                Y11 := TRUE;
                take_bin_sent := TRUE;
                state_retrieval := 1;
            END_IF;

        1:
            Y11 := FALSE;
            state_retrieval := 2;

        2:
            Y11 := FALSE;
            IF X14 THEN
                state_retrieval := 3;
            ELSIF (NOT X13) THEN
                take_bin_done := TRUE;
                state_retrieval := 4;
            END_IF;

        3:
            Y11 := FALSE;
            IF (NOT X14) AND (NOT X13) THEN
                take_bin_done := TRUE;
                state_retrieval := 4;
            END_IF;

        4:
            Y11 := FALSE;
    END_CASE;

    IF (a_trays_done >= 2) AND (b_trays_done >= 1) AND (X15 OR (D4 >= 3))
       AND swap_done AND take_bin_done
       AND (D0 = 3) AND (D1 = 0) AND (D2 = 102) AND X10 AND (NOT X11)
       AND (state_a = 6) AND (state_b = 6) THEN
        complete_latch := TRUE;
        Y12 := TRUE;
        Y10 := FALSE;
        Y11 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
    END_IF;
END_IF;

END_PROGRAM