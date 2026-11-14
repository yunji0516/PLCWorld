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
    run_enable : BOOL;
    complete_latched : BOOL;
    cap : INT;
    res_a : INT;
    res_b : INT;
    a_started_total : INT;
    b_started_total : INT;
    a_ejected_total : INT;
    b_ejected_total : INT;
    a_good_received_total : INT;
    b_good_received_total : INT;
    a_start_latched : BOOL;
    b_start_latched : BOOL;
    a_eject_latched : BOOL;
    b_eject_latched : BOOL;
    a_exit_waiting : BOOL;
    b_exit_waiting : BOOL;
    a_exit_blocked_seen : BOOL;
    b_exit_blocked_seen : BOOL;
    first_bin_sealed : BOOL;
    swap_count : INT;
    retrieval_has_bin : BOOL;
    return_request_issued : BOOL;
    return_started : BOOL;
    return_done : BOOL;
END_VAR

Y10 := FALSE;
Y11 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;

IF X0 THEN
    run_enable := TRUE;
END_IF;

IF a_exit_waiting THEN
    IF NOT X1B THEN
        a_exit_blocked_seen := TRUE;
    END_IF;
    IF a_exit_blocked_seen AND X1B THEN
        a_good_received_total := a_good_received_total + 1;
        a_exit_waiting := FALSE;
        a_exit_blocked_seen := FALSE;
    END_IF;
END_IF;

IF b_exit_waiting THEN
    IF NOT X21 THEN
        b_exit_blocked_seen := TRUE;
    END_IF;
    IF b_exit_blocked_seen AND X21 THEN
        b_good_received_total := b_good_received_total + 1;
        b_exit_waiting := FALSE;
        b_exit_blocked_seen := FALSE;
    END_IF;
END_IF;

IF return_request_issued AND X14 THEN
    return_started := TRUE;
END_IF;

IF return_request_issued AND return_started AND (NOT X14) THEN
    return_done := TRUE;
    retrieval_has_bin := FALSE;
END_IF;

IF (NOT X17) AND (D5 = 0) THEN
    a_start_latched := FALSE;
END_IF;

IF (NOT X1D) AND (D7 = 0) THEN
    b_start_latched := FALSE;
END_IF;

IF NOT X1A THEN
    a_eject_latched := FALSE;
END_IF;

IF NOT X20 THEN
    b_eject_latched := FALSE;
END_IF;

IF run_enable AND (NOT complete_latched) THEN
    IF X16 AND (NOT X17) AND (NOT X18) AND (NOT X19) AND (NOT X1A) AND (a_started_total < 2) THEN
        Y13 := TRUE;
    END_IF;

    IF X1C AND (NOT X1D) AND (NOT X1E) AND (NOT X1F) AND (NOT X20) AND (b_started_total < 1) THEN
        Y16 := TRUE;
    END_IF;

    IF retrieval_has_bin AND (NOT return_request_issued) AND X13 AND (NOT X14) THEN
        Y11 := TRUE;
        return_request_issued := TRUE;
    END_IF;

    cap := D3 - D0 - D1;
    IF cap < 0 THEN
        cap := 0;
    END_IF;

    res_a := D6;
    IF res_a <= 0 THEN
        res_a := 3;
    END_IF;

    res_b := D8;
    IF res_b <= 0 THEN
        res_b := 2;
    END_IF;

    IF X10 AND (NOT X11) THEN
        IF (a_started_total = 0) AND X17 AND (NOT X18) AND (NOT X19) AND (NOT X1A) AND (NOT a_start_latched) AND (res_a <= cap) THEN
            Y14 := TRUE;
            a_start_latched := TRUE;
            a_started_total := a_started_total + 1;
            cap := cap - res_a;
        END_IF;

        IF (b_started_total = 0) AND X1D AND (NOT X1E) AND (NOT X1F) AND (NOT X20) AND (NOT b_start_latched) AND (res_b <= cap) THEN
            Y17 := TRUE;
            b_start_latched := TRUE;
            b_started_total := b_started_total + 1;
            cap := cap - res_b;
        END_IF;

        IF (a_started_total = 1) AND (b_started_total >= 1) AND first_bin_sealed AND X17 AND (NOT X18) AND (NOT X19) AND (NOT X1A) AND (NOT a_start_latched) AND (res_a <= cap) THEN
            Y14 := TRUE;
            a_start_latched := TRUE;
            a_started_total := a_started_total + 1;
            cap := cap - res_a;
        END_IF;
    END_IF;

    IF X1A AND X1B AND (NOT a_eject_latched) AND (NOT a_exit_waiting) AND (a_ejected_total < a_started_total) THEN
        Y15 := TRUE;
        a_eject_latched := TRUE;
        a_exit_waiting := TRUE;
        a_exit_blocked_seen := FALSE;
        a_ejected_total := a_ejected_total + 1;
    END_IF;

    IF X20 AND X21 AND (NOT b_eject_latched) AND (NOT b_exit_waiting) AND (b_ejected_total < b_started_total) THEN
        Y18 := TRUE;
        b_eject_latched := TRUE;
        b_exit_waiting := TRUE;
        b_exit_blocked_seen := FALSE;
        b_ejected_total := b_ejected_total + 1;
    END_IF;

    IF (NOT first_bin_sealed) AND (a_started_total >= 1) AND (b_started_total >= 1) AND (D1 = 0) AND (D0 >= 5) AND X10 AND (NOT X11) AND X12 AND (NOT retrieval_has_bin) AND (NOT X14) THEN
        Y10 := TRUE;
        first_bin_sealed := TRUE;
        swap_count := swap_count + 1;
        retrieval_has_bin := TRUE;
    END_IF;

    IF first_bin_sealed AND return_done AND X10 AND (NOT X11) AND (D1 = 0) AND (D0 >= 3) AND (a_started_total >= 2) AND (b_started_total >= 1) AND (a_good_received_total >= 2) AND (b_good_received_total >= 1) AND (NOT a_exit_waiting) AND (NOT b_exit_waiting) AND X1B AND X21 THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

Y12 := complete_latched;

END_PROGRAM