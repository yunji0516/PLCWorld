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

    started : BOOL := FALSE;
    complete_latched : BOOL := FALSE;

    state_a : INT := 0;
    batches_done_a : INT := 0;

    state_b : INT := 0;
    batches_done_b : INT := 0;

    swap_state : INT := 0;
    swap_done : BOOL := FALSE;

    ret_state : INT := 0;

    docked_committed : INT := 0;
    reserved_capacity : INT := 0;

    all_conditions_met : BOOL := FALSE;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT complete_latched THEN
    (* Press A Control *)
    CASE state_a OF
        0:
            Y13 := FALSE;
            Y14 := FALSE;
            Y15 := FALSE;
            IF started THEN
                IF (batches_done_a = 0) AND X16 AND (NOT X17) AND (NOT X18) AND (NOT X19) AND (NOT X1A) AND (D5 = 0)
                   AND X10 AND (NOT X11)
                   AND ((docked_committed + reserved_capacity + 3) <= 6)
                   AND ((D0 + D1 + reserved_capacity + 3) <= 6) THEN
                    reserved_capacity := reserved_capacity + 3;
                    Y13 := TRUE;
                    state_a := 1;
                ELSIF (batches_done_a = 1) AND swap_done AND X16 AND (NOT X17) AND (NOT X18) AND (NOT X19) AND (NOT X1A) AND (D5 = 0)
                   AND X10 AND (NOT X11)
                   AND ((docked_committed + reserved_capacity + 3) <= 6)
                   AND ((D0 + D1 + reserved_capacity + 3) <= 6) THEN
                    reserved_capacity := reserved_capacity + 3;
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
            Y14 := TRUE;
            reserved_capacity := reserved_capacity - 3;
            docked_committed := docked_committed + 3;
            state_a := 3;

        3:
            Y14 := FALSE;
            IF X1A THEN
                state_a := 4;
            END_IF;

        4:
            IF X1B THEN
                Y15 := TRUE;
                state_a := 5;
            END_IF;

        5:
            Y15 := FALSE;
            IF (NOT X17) AND (NOT X1A) THEN
                batches_done_a := batches_done_a + 1;
                state_a := 0;
            END_IF;
    END_CASE;

    (* Press B Control *)
    CASE state_b OF
        0:
            Y16 := FALSE;
            Y17 := FALSE;
            Y18 := FALSE;
            IF started THEN
                IF (batches_done_b = 0) AND X1C AND (NOT X1D) AND (NOT X1E) AND (NOT X1F) AND (NOT X20) AND (D7 = 0)
                   AND X10 AND (NOT X11)
                   AND ((docked_committed + reserved_capacity + 2) <= 6)
                   AND ((D0 + D1 + reserved_capacity + 2) <= 6) THEN
                    reserved_capacity := reserved_capacity + 2;
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
            IF state_a <> 2 THEN
                Y17 := TRUE;
                reserved_capacity := reserved_capacity - 2;
                docked_committed := docked_committed + 2;
                state_b := 3;
            END_IF;

        3:
            Y17 := FALSE;
            IF X20 THEN
                state_b := 4;
            END_IF;

        4:
            IF X21 THEN
                Y18 := TRUE;
                state_b := 5;
            END_IF;

        5:
            Y18 := FALSE;
            IF (NOT X1D) AND (NOT X20) THEN
                batches_done_b := batches_done_b + 1;
                state_b := 0;
            END_IF;
    END_CASE;

    (* Shared Bin Exchange Control *)
    CASE swap_state OF
        0:
            Y10 := FALSE;
            IF (batches_done_a >= 1) AND (batches_done_b >= 1)
               AND (state_a = 0) AND (state_b = 0)
               AND (NOT X19) AND (NOT X1F)
               AND (D1 = 0) AND (D0 > 0)
               AND X12 AND (NOT X11)
               AND (NOT X13) AND (NOT X14) THEN
                Y10 := TRUE;
                swap_state := 1;
            END_IF;

        1:
            Y10 := FALSE;
            IF X11 OR (NOT X10) THEN
                swap_state := 2;
            END_IF;

        2:
            Y10 := FALSE;
            IF (NOT X11) AND X10 THEN
                swap_done := TRUE;
                docked_committed := 0;
                swap_state := 3;
            END_IF;

        3:
            Y10 := FALSE;
    END_CASE;

    (* External Bin Retrieval Control *)
    CASE ret_state OF
        0:
            Y11 := FALSE;
            IF (swap_state >= 1) AND X13 THEN
                Y11 := TRUE;
                ret_state := 1;
            END_IF;

        1:
            Y11 := FALSE;
            IF X14 THEN
                ret_state := 2;
            ELSIF NOT X13 THEN
                ret_state := 3;
            END_IF;

        2:
            Y11 := FALSE;
            IF (NOT X14) AND (NOT X13) THEN
                ret_state := 3;
            END_IF;

        3:
            Y11 := FALSE;
    END_CASE;

    (* Completion Evaluation *)
    all_conditions_met := started
        AND (batches_done_a = 2)
        AND (batches_done_b = 1)
        AND (state_a = 0)
        AND (state_b = 0)
        AND (swap_state = 3)
        AND (ret_state = 3)
        AND (X15 OR (D4 >= 3))
        AND (D0 >= 3)
        AND (D1 = 0)
        AND (NOT X19) AND (NOT X1F)
        AND (NOT X17) AND (NOT X1A)
        AND (NOT X1D) AND (NOT X20)
        AND X10 AND (NOT X11);

    IF all_conditions_met THEN
        complete_latched := TRUE;
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
        Y12 := FALSE;
    END_IF;
ELSE
    Y10 := FALSE;
    Y11 := FALSE;
    Y12 := TRUE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
END_IF;

END_PROGRAM