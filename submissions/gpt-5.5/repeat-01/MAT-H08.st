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
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
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
    Y1F : BOOL;
    started : BOOL;
    complete_latched : BOOL;
    p_state : INT := 0;
    r_state : INT := 0;
    e_state : INT := 0;
    accepted_count : INT := 0;
    recovery_ack_count : INT := 0;
    roll_count : INT := 0;
    cut_issued : BOOL;
    transfer_started : BOOL;
    e_cut_issued : BOOL;
    e_unload_issued : BOOL;
    e_load_issued : BOOL;
    hold_timer : TON;
    unload_timer : TON;
    thread_timer : TON;
    can_recover_length : BOOL;
END_VAR

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
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
D200 := 0;

IF X0 THEN
    started := TRUE;
END_IF;

hold_timer(IN := (e_state = 10), PT := T#300ms);
unload_timer(IN := (e_state = 31), PT := T#12000ms);
thread_timer(IN := (e_state = 50), PT := T#700ms);

IF started AND NOT complete_latched THEN

    IF (e_state = 0) AND (roll_count < 2) AND (X21 OR ((recovery_ack_count >= 4) AND (D4 >= 3200))) THEN
        e_state := 10;
        e_cut_issued := FALSE;
        e_unload_issued := FALSE;
        e_load_issued := FALSE;
    END_IF;

    CASE p_state OF
        0:
            cut_issued := FALSE;
            transfer_started := FALSE;
            IF (accepted_count < 6) AND X10 AND (D3 <= 300) AND (NOT X11) AND (NOT X13) AND (NOT X18) AND X20 AND (NOT X1A) THEN
                Y10 := TRUE;
                accepted_count := accepted_count + 1;
                p_state := 10;
            END_IF;

        10:
            IF (D3 < 590) AND NOT (X16 AND (D1 <> 0)) THEN
                Y11 := TRUE;
            END_IF;
            IF X12 AND (NOT X11) THEN
                cut_issued := FALSE;
                p_state := 20;
            END_IF;

        20:
            Y12 := TRUE;
            D200 := 15;
            IF X15 AND (NOT X13) AND (NOT cut_issued) THEN
                Y13 := TRUE;
                cut_issued := TRUE;
            END_IF;
            IF cut_issued AND (NOT X13) AND (X14 OR (D1 = 0)) THEN
                p_state := 30;
            END_IF;

        30:
            IF X20 AND (NOT X13) THEN
                Y14 := TRUE;
                IF X16 THEN
                    p_state := 40;
                END_IF;
            END_IF;

        40:
            Y14 := TRUE;
            IF X16 AND (D1 = 0) THEN
                Y15 := TRUE;
                IF X17 THEN
                    transfer_started := FALSE;
                    p_state := 50;
                END_IF;
            END_IF;

        50:
            Y14 := TRUE;
            IF X16 AND (D1 = 0) THEN
                Y15 := TRUE;
                IF transfer_started OR (X17 AND X19 AND (NOT X18)) THEN
                    transfer_started := TRUE;
                    Y16 := TRUE;
                END_IF;
                IF transfer_started AND X1A THEN
                    Y1A := TRUE;
                    p_state := 60;
                END_IF;
            END_IF;

        60:
            IF X1A THEN
                Y1A := TRUE;
            ELSE
                p_state := 70;
            END_IF;

        70:
            IF (NOT X18) AND X20 AND (NOT X1A) THEN
                transfer_started := FALSE;
                p_state := 0;
            END_IF;

        ELSE
            p_state := 0;
    END_CASE;

    IF X1E OR (DINT(D4) < (DINT(D2) + 1400)) THEN
        can_recover_length := TRUE;
    ELSE
        can_recover_length := FALSE;
    END_IF;

    CASE r_state OF
        0:
            IF (recovery_ack_count < 4) AND X1B AND (e_state = 0) AND ((roll_count = 0) OR X29) THEN
                Y17 := TRUE;
                r_state := 10;
            END_IF;

        10:
            IF X1D THEN
                Y19 := TRUE;
                recovery_ack_count := recovery_ack_count + 1;
                r_state := 20;
            ELSE
                IF (e_state = 0) AND ((roll_count = 0) OR X29) AND can_recover_length AND NOT (X16 AND (D1 <> 0)) THEN
                    Y18 := TRUE;
                END_IF;
            END_IF;

        20:
            Y19 := TRUE;
            IF NOT X1D THEN
                r_state := 0;
            END_IF;

        ELSE
            r_state := 0;
    END_CASE;

    CASE e_state OF
        0:
            e_cut_issued := FALSE;
            e_unload_issued := FALSE;
            e_load_issued := FALSE;

        10:
            Y1C := TRUE;
            IF X22 AND hold_timer.Q THEN
                e_cut_issued := FALSE;
                e_state := 20;
            END_IF;

        20:
            Y1C := TRUE;
            IF NOT e_cut_issued THEN
                Y1D := TRUE;
                Y1E := TRUE;
                e_cut_issued := TRUE;
            END_IF;
            e_state := 21;

        21:
            Y1C := TRUE;
            IF X23 THEN
                e_unload_issued := FALSE;
                e_state := 30;
            END_IF;

        30:
            Y1C := TRUE;
            IF NOT e_unload_issued THEN
                Y1F := TRUE;
                e_unload_issued := TRUE;
                roll_count := roll_count + 1;
            END_IF;
            e_state := 31;

        31:
            Y1C := TRUE;
            IF ((NOT X24) AND (NOT X21)) OR unload_timer.Q THEN
                IF (roll_count >= 2) OR (recovery_ack_count >= 4) THEN
                    e_state := 0;
                ELSE
                    e_load_issued := FALSE;
                    e_state := 40;
                END_IF;
            END_IF;

        40:
            Y1C := TRUE;
            IF X25 AND (NOT e_load_issued) THEN
                Y20 := TRUE;
                e_load_issued := TRUE;
                e_state := 41;
            END_IF;

        41:
            Y1C := TRUE;
            IF X26 THEN
                e_state := 50;
            END_IF;

        50:
            Y1C := TRUE;
            Y21 := TRUE;
            Y22 := TRUE;
            IF X27 AND X28 AND thread_timer.Q THEN
                e_state := 60;
            END_IF;

        60:
            IF X29 THEN
                e_state := 0;
            END_IF;

        ELSE
            e_state := 0;
    END_CASE;

    IF (accepted_count >= 6) AND (D6 >= 6) AND (recovery_ack_count >= 4) AND (roll_count >= 2) AND
       (p_state = 0) AND (r_state = 0) AND (e_state = 0) AND (NOT X18) AND (NOT X1A) AND
       (NOT X1C) AND (NOT X1D) AND (X1F OR (X1E AND (D4 >= 3200))) THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

IF complete_latched THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM