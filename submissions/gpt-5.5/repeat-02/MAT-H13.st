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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
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
    Y23 : BOOL;
    Y24 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    form_state : INT;
    transfer_state : INT;
    wrap_state : INT;
    active_target_count : INT;
    required_length : INT;
    current_token : INT;
    wrap_bundle_index : INT;
    started : BOOL;
    complete_latched : BOOL;
    index_wait : BOOL;
    index_seen_busy : BOOL;
    prep_sent : BOOL;
    swap_sent : BOOL;
    discharge_gripped : BOOL;
    source_bundle_waiting : BOOL;
    no_transfer_motion : BOOL;
    target_reached : BOOL;
    tape_ready_for_token : BOOL;
    can_feed_or_index : BOOL;
    remaining_needed : INT;
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
Y23 := FALSE;
Y24 := FALSE;
Y1A := FALSE;
Y1B := complete_latched;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF X0 THEN
    started := TRUE;
END_IF;

IF D10 > 0 THEN
    active_target_count := D10;
ELSE
    CASE wrap_bundle_index OF
        0:
            active_target_count := 2;
        1:
            active_target_count := 3;
        ELSE
            active_target_count := 4;
    END_CASE;
END_IF;

IF active_target_count < 2 THEN
    active_target_count := 2;
END_IF;
IF active_target_count > 4 THEN
    active_target_count := 4;
END_IF;

no_transfer_motion := NOT X15 AND NOT X27 AND NOT X1D;
can_feed_or_index := started AND NOT complete_latched AND no_transfer_motion AND (transfer_state <> 35) AND (transfer_state <> 50) AND (transfer_state <> 55);

IF NOT started THEN
    form_state := 0;
    transfer_state := 0;
    wrap_state := 0;
    index_wait := FALSE;
    index_seen_busy := FALSE;
    prep_sent := FALSE;
    swap_sent := FALSE;
    discharge_gripped := FALSE;
    source_bundle_waiting := FALSE;
ELSE
    IF complete_latched THEN
        form_state := 0;
        transfer_state := 0;
        wrap_state := 0;
    ELSE
        CASE form_state OF
            0:
                Y20 := FALSE;
                Y22 := FALSE;
                IF NOT X2E THEN
                    Y21 := TRUE;
                ELSE
                    Y21 := FALSE;
                END_IF;

                IF X2E AND X2D AND X2B AND (D9 < active_target_count) THEN
                    Y1D := TRUE;
                    IF can_feed_or_index AND X25 AND X28 THEN
                        Y1C := TRUE;
                    END_IF;
                END_IF;

                IF index_wait THEN
                    IF X27 THEN
                        index_seen_busy := TRUE;
                    END_IF;
                    IF index_seen_busy AND NOT X27 THEN
                        index_wait := FALSE;
                        index_seen_busy := FALSE;
                    END_IF;
                ELSE
                    IF can_feed_or_index AND X2E AND X2D AND X2B AND (NOT X28) AND (D9 < active_target_count) AND (NOT X27) THEN
                        Y1E := TRUE;
                        index_wait := TRUE;
                        index_seen_busy := FALSE;
                    END_IF;
                END_IF;

                IF X2E AND X2D AND X2B AND (D9 = active_target_count) AND (D9 > 0) THEN
                    form_state := 1;
                END_IF;

            1:
                Y20 := FALSE;
                Y21 := FALSE;
                Y22 := FALSE;
                Y1F := TRUE;
                IF X29 AND X2E AND X2D AND X2B AND (D9 = active_target_count) THEN
                    form_state := 2;
                END_IF;

            2:
                Y20 := TRUE;
                Y21 := FALSE;
                Y22 := FALSE;
                Y1F := TRUE;
                IF X2A THEN
                    form_state := 3;
                END_IF;

            3:
                Y20 := TRUE;
                Y21 := TRUE;
                Y22 := FALSE;
                IF X2C AND X30 THEN
                    form_state := 4;
                END_IF;

            4:
                Y20 := TRUE;
                Y21 := TRUE;
                Y22 := TRUE;
                IF X2F THEN
                    form_state := 5;
                END_IF;

            5:
                Y20 := TRUE;
                Y21 := FALSE;
                Y22 := TRUE;
                IF X2D THEN
                    form_state := 6;
                END_IF;

            6:
                Y20 := FALSE;
                Y21 := FALSE;
                Y22 := TRUE;
                IF X2B THEN
                    form_state := 7;
                END_IF;

            7:
                Y20 := FALSE;
                Y21 := TRUE;
                Y22 := TRUE;
                IF X2C THEN
                    source_bundle_waiting := TRUE;
                    form_state := 8;
                END_IF;

            8:
                Y20 := FALSE;
                Y21 := TRUE;
                Y22 := TRUE;
                IF source_bundle_waiting AND X32 AND X2C AND X33 AND no_transfer_motion AND (transfer_state = 0) THEN
                    IF NOT X10 THEN
                        Y23 := TRUE;
                    END_IF;
                END_IF;
                IF X10 THEN
                    source_bundle_waiting := FALSE;
                    form_state := 9;
                END_IF;

            9:
                Y20 := FALSE;
                Y21 := TRUE;
                Y22 := FALSE;
                IF X2E THEN
                    form_state := 0;
                END_IF;

            ELSE
                form_state := 0;
        END_CASE;

        IF wrap_state <> 0 THEN
            IF required_length <= 0 THEN
                CASE wrap_bundle_index OF
                    0:
                        required_length := 1192;
                    1:
                        required_length := 1472;
                    ELSE
                        required_length := 1752;
                END_CASE;
            END_IF;

            target_reached := D2 >= required_length;
            remaining_needed := required_length - D2;
            IF remaining_needed < 0 THEN
                remaining_needed := 0;
            END_IF;
            tape_ready_for_token := X20 AND (D5 = current_token) AND (current_token <> 0);

            IF (wrap_state >= 10) AND (wrap_state < 70) AND NOT discharge_gripped THEN
                IF (wrap_state = 10) THEN
                    IF X13 AND X11 THEN
                        Y11 := TRUE;
                    END_IF;
                ELSE
                    Y11 := TRUE;
                END_IF;
            END_IF;

            IF (wrap_state >= 10) AND (wrap_state <= 50) AND NOT X22 THEN
                Y12 := TRUE;
            END_IF;

            CASE wrap_state OF
                10:
                    IF current_token = 0 THEN
                        IF D1 <> 0 THEN
                            current_token := D1;
                        ELSE
                            current_token := D0;
                        END_IF;
                    END_IF;
                    IF D3 > 0 THEN
                        required_length := D3;
                    END_IF;
                    D200 := current_token;
                    IF NOT prep_sent THEN
                        Y18 := TRUE;
                        prep_sent := TRUE;
                    END_IF;
                    IF X19 THEN
                        wrap_state := 20;
                    END_IF;

                20:
                    D200 := current_token;
                    IF NOT prep_sent THEN
                        Y18 := TRUE;
                        prep_sent := TRUE;
                    END_IF;

                    IF NOT target_reached THEN
                        IF X19 AND X1B AND X18 AND X1C AND (NOT X1D) AND (D4 > 5) THEN
                            Y16 := TRUE;
                        ELSE
                            Y16 := FALSE;
                            IF X19 AND X1B AND X18 AND (NOT X1D) AND X1E AND (NOT swap_sent) AND ((NOT X1C) OR (D4 <= 5) OR ((D4 < remaining_needed) AND (D4 > 0))) THEN
                                Y17 := TRUE;
                                swap_sent := TRUE;
                            END_IF;
                        END_IF;
                    ELSE
                        Y16 := FALSE;
                        wrap_state := 30;
                    END_IF;

                30:
                    D200 := current_token;
                    IF NOT prep_sent THEN
                        Y18 := TRUE;
                        prep_sent := TRUE;
                    END_IF;
                    IF tape_ready_for_token AND target_reached AND X19 AND X1B AND X18 THEN
                        Y19 := TRUE;
                    END_IF;
                    IF X21 THEN
                        wrap_state := 40;
                    END_IF;

                40:
                    D200 := current_token;
                    IF X19 AND X1B AND target_reached AND X21 THEN
                        Y1A := TRUE;
                    END_IF;
                    IF X22 THEN
                        wrap_state := 50;
                    END_IF;

                50:
                    D200 := current_token;
                    IF X22 THEN
                        wrap_state := 60;
                    END_IF;

                60:
                    D200 := current_token;

                70:
                    Y11 := FALSE;
                    Y12 := FALSE;

                ELSE
                    wrap_state := 0;
            END_CASE;
        ELSE
            target_reached := FALSE;
        END_IF;

        CASE transfer_state OF
            0:
                Y10 := FALSE;
                IF (wrap_state = 60) AND X18 AND X19 THEN
                    Y14 := TRUE;
                    transfer_state := 50;
                ELSIF (wrap_state = 0) AND X10 AND X33 AND X17 AND X23 AND NOT source_bundle_waiting THEN
                    Y24 := TRUE;
                    transfer_state := 10;
                END_IF;

            10:
                Y24 := TRUE;
                Y10 := FALSE;
                IF X12 AND X11 THEN
                    transfer_state := 20;
                END_IF;

            20:
                Y24 := TRUE;
                IF X12 AND X11 THEN
                    Y10 := TRUE;
                END_IF;
                IF X16 THEN
                    transfer_state := 30;
                END_IF;

            30:
                Y10 := TRUE;
                Y24 := FALSE;
                IF X33 AND (NOT X12) THEN
                    transfer_state := 35;
                END_IF;

            35:
                Y10 := TRUE;
                Y14 := TRUE;
                IF X13 THEN
                    IF wrap_state = 0 THEN
                        wrap_state := 10;
                        discharge_gripped := FALSE;
                        prep_sent := FALSE;
                        swap_sent := FALSE;
                        IF D1 <> 0 THEN
                            current_token := D1;
                        ELSE
                            current_token := D0;
                        END_IF;
                        IF D3 > 0 THEN
                            required_length := D3;
                        ELSE
                            CASE wrap_bundle_index OF
                                0:
                                    required_length := 1192;
                                1:
                                    required_length := 1472;
                                ELSE
                                    required_length := 1752;
                            END_CASE;
                        END_IF;
                        D200 := current_token;
                    END_IF;
                    transfer_state := 40;
                END_IF;

            40:
                IF X19 THEN
                    Y10 := FALSE;
                    IF X17 THEN
                        transfer_state := 41;
                    END_IF;
                ELSE
                    Y10 := TRUE;
                END_IF;

            41:
                Y10 := FALSE;
                Y13 := TRUE;
                IF X33 THEN
                    transfer_state := 0;
                END_IF;

            50:
                Y14 := TRUE;
                Y10 := FALSE;
                IF X13 THEN
                    transfer_state := 51;
                END_IF;

            51:
                IF X13 AND X19 THEN
                    Y10 := TRUE;
                END_IF;
                IF X16 THEN
                    discharge_gripped := TRUE;
                    wrap_state := 70;
                    transfer_state := 52;
                END_IF;

            52:
                Y10 := TRUE;
                Y11 := FALSE;
                Y12 := FALSE;
                IF X1A AND X22 AND X23 THEN
                    transfer_state := 55;
                END_IF;

            55:
                Y10 := TRUE;
                Y15 := TRUE;
                IF X14 THEN
                    transfer_state := 56;
                END_IF;

            56:
                Y10 := FALSE;
                IF X17 THEN
                    transfer_state := 57;
                END_IF;

            57:
                Y10 := FALSE;
                Y13 := TRUE;
                IF wrap_state <> 0 THEN
                    wrap_bundle_index := wrap_bundle_index + 1;
                    wrap_state := 0;
                    current_token := 0;
                    required_length := 0;
                    prep_sent := FALSE;
                    swap_sent := FALSE;
                    discharge_gripped := FALSE;
                END_IF;
                IF X33 THEN
                    transfer_state := 0;
                END_IF;

            ELSE
                transfer_state := 0;
        END_CASE;

        IF Y23 THEN
            Y10 := FALSE;
            Y13 := FALSE;
            Y14 := FALSE;
            Y15 := FALSE;
            Y24 := FALSE;
        END_IF;

        IF X24 AND (D7 >= 3) AND X17 AND X1A AND X22 AND X23 AND (NOT X15) AND (NOT X16) AND (NOT X19) AND (wrap_state = 0) AND (transfer_state = 0) THEN
            complete_latched := TRUE;
        END_IF;
    END_IF;
END_IF;

IF complete_latched THEN
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
    Y23 := FALSE;
    Y24 := FALSE;
    Y1A := FALSE;
    Y1B := TRUE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
END_IF;

END_PROGRAM