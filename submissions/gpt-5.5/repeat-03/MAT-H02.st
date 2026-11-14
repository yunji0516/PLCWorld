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
    Y20 : BOOL;
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
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D16 : INT;
    D200 : INT;
    D201 : INT;
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
    (* Add internal variables here. *)
    started : BOOL;
    complete_latched : BOOL;

    current_gen : INT := 1;
    source_index : INT := 1;
    source_kind : INT;

    deck_state : INT;
    deck_target : INT := 1;
    deck_op : INT;
    pending_source_inc : BOOL;

    a_accept_gen : INT;
    b_accept_gen : INT;
    a_close_sent : BOOL;
    b_close_sent : BOOL;
    a_release_sent : BOOL;
    b_release_sent : BOOL;
    a_pack_sent : BOOL;
    b_pack_sent : BOOL;
    a_ack_sent : BOOL;
    b_ack_sent : BOOL;

    box_state : INT;
    clamp_timer : TON;

    a_needs_deck : BOOL;
    b_needs_deck : BOOL;
    a_needs_source : BOOL;
    b_needs_source : BOOL;
    storage0_empty : BOOL;
    storage1_empty : BOOL;
    storage_has_empty : BOOL;
    can_start_deck : BOOL;
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
Y1A := FALSE;
Y1B := complete_latched;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF X0 THEN
    started := TRUE;
END_IF;

IF source_index = 1 THEN
    source_kind := 1;
ELSIF source_index = 2 THEN
    source_kind := 1;
ELSIF source_index = 3 THEN
    source_kind := 1;
ELSIF source_index = 4 THEN
    source_kind := 2;
ELSIF source_index = 5 THEN
    source_kind := 2;
ELSIF source_index = 6 THEN
    source_kind := 1;
ELSIF source_index = 7 THEN
    source_kind := 2;
ELSIF source_index = 8 THEN
    source_kind := 2;
ELSE
    source_kind := 0;
END_IF;

storage0_empty := (D5 = 0) OR (D6 = 0);
storage1_empty := (D7 = 0) OR (D8 = 0);
storage_has_empty := storage0_empty OR storage1_empty;

IF current_gen < 1 THEN
    current_gen := 1;
END_IF;
IF current_gen > 2 THEN
    current_gen := 2;
END_IF;

D201 := current_gen;
D200 := deck_target;

IF started AND NOT complete_latched THEN
    IF X13 AND (a_accept_gen < current_gen) THEN
        D201 := current_gen;
        Y13 := TRUE;
        a_accept_gen := current_gen;
        a_close_sent := FALSE;
        a_release_sent := FALSE;
        a_pack_sent := FALSE;
        a_ack_sent := FALSE;
    END_IF;

    IF X14 AND (b_accept_gen < current_gen) THEN
        D201 := current_gen;
        Y14 := TRUE;
        b_accept_gen := current_gen;
        b_close_sent := FALSE;
        b_release_sent := FALSE;
        b_pack_sent := FALSE;
        b_ack_sent := FALSE;
    END_IF;

    IF X15 AND (a_accept_gen = current_gen) AND (D13 >= 2) AND NOT a_close_sent AND NOT X11 AND NOT X21 THEN
        Y15 := TRUE;
        a_close_sent := TRUE;
    END_IF;

    IF X16 AND (b_accept_gen = current_gen) AND (D14 >= 2) AND NOT b_close_sent AND NOT X11 AND NOT X21 THEN
        Y16 := TRUE;
        b_close_sent := TRUE;
    END_IF;

    IF X17 AND X19 AND a_close_sent AND NOT a_release_sent AND NOT X11 AND NOT X21 THEN
        Y17 := TRUE;
        a_release_sent := TRUE;
    END_IF;

    IF X18 AND X1A AND b_close_sent AND NOT b_release_sent AND NOT X11 AND NOT X21 THEN
        Y18 := TRUE;
        b_release_sent := TRUE;
    END_IF;

    CASE box_state OF
        0:
            IF X1F THEN
                box_state := 1;
            ELSIF X1E AND NOT X11 AND NOT X21 THEN
                D201 := current_gen;
                Y1C := TRUE;
            END_IF;

        1:
            IF X1F THEN
                Y1D := TRUE;
                IF X20 THEN
                    box_state := 2;
                END_IF;
            ELSE
                box_state := 0;
            END_IF;

        2:
            Y1D := TRUE;
            IF X24 AND a_ack_sent AND b_ack_sent THEN
                box_state := 3;
            END_IF;

        3:
            Y1D := FALSE;
            IF (NOT X20) AND X25 AND NOT X11 AND NOT X21 THEN
                box_state := 4;
            END_IF;

        4:
            IF X25 AND NOT X11 AND NOT X21 THEN
                Y20 := TRUE;
                IF current_gen < 2 THEN
                    current_gen := current_gen + 1;
                    box_state := 0;
                ELSE
                    box_state := 5;
                END_IF;
            END_IF;

        5:
            Y1D := FALSE;

        ELSE
            box_state := 0;
    END_CASE;

    IF (box_state = 1) OR (box_state = 2) THEN
        IF X1F THEN
            Y1D := TRUE;
        END_IF;
    END_IF;

    clamp_timer(IN := Y1D AND X1F, PT := T#300ms);

    IF (box_state = 2) AND clamp_timer.Q AND X20 AND NOT X11 AND NOT X21 THEN
        IF X1B AND a_release_sent AND NOT a_pack_sent AND (D16 = current_gen) AND (D9 = current_gen) AND (D15 <> 0) THEN
            Y1E := TRUE;
            a_pack_sent := TRUE;
        ELSIF X1C AND b_release_sent AND NOT b_pack_sent AND (D16 = current_gen) AND (D10 = current_gen) AND (D15 <> 0) THEN
            Y1F := TRUE;
            b_pack_sent := TRUE;
        END_IF;
    END_IF;

    IF X22 AND a_pack_sent AND NOT a_ack_sent THEN
        Y19 := TRUE;
        a_ack_sent := TRUE;
    END_IF;

    IF X23 AND b_pack_sent AND NOT b_ack_sent THEN
        Y1A := TRUE;
        b_ack_sent := TRUE;
    END_IF;

    IF X12 OR (D1 <> 0) THEN
        a_needs_deck := X15 AND (a_accept_gen = current_gen) AND (D9 = current_gen) AND (D13 < 2) AND (D2 = D11);
        b_needs_deck := X16 AND (b_accept_gen = current_gen) AND (D10 = current_gen) AND (D14 < 2) AND (D2 = D12);
    ELSE
        a_needs_deck := FALSE;
        b_needs_deck := FALSE;
    END_IF;

    a_needs_source := X15 AND (a_accept_gen = current_gen) AND (D9 = current_gen) AND (D13 < 2) AND (source_kind = D11);
    b_needs_source := X16 AND (b_accept_gen = current_gen) AND (D10 = current_gen) AND (D14 < 2) AND (source_kind = D12);

    can_start_deck := NOT X11 AND NOT X21 AND NOT Y1C AND NOT Y1E AND NOT Y1F;

    CASE deck_state OF
        0:
            IF can_start_deck THEN
                IF X12 OR (D1 <> 0) THEN
                    IF a_needs_deck THEN
                        deck_target := 4;
                        deck_op := 2;
                        deck_state := 10;
                    ELSIF b_needs_deck THEN
                        deck_target := 5;
                        deck_op := 2;
                        deck_state := 10;
                    ELSIF storage0_empty THEN
                        deck_target := 2;
                        deck_op := 2;
                        deck_state := 10;
                    ELSIF storage1_empty THEN
                        deck_target := 3;
                        deck_op := 2;
                        deck_state := 10;
                    END_IF;
                ELSE
                    IF (D5 <> 0) AND (D6 <> 0) AND ((X15 AND (a_accept_gen = current_gen) AND (D9 = current_gen) AND (D13 < 2) AND (D6 = D11)) OR (X16 AND (b_accept_gen = current_gen) AND (D10 = current_gen) AND (D14 < 2) AND (D6 = D12))) THEN
                        deck_target := 2;
                        deck_op := 1;
                        pending_source_inc := FALSE;
                        deck_state := 10;
                    ELSIF (D7 <> 0) AND (D8 <> 0) AND ((X15 AND (a_accept_gen = current_gen) AND (D9 = current_gen) AND (D13 < 2) AND (D8 = D11)) OR (X16 AND (b_accept_gen = current_gen) AND (D10 = current_gen) AND (D14 < 2) AND (D8 = D12))) THEN
                        deck_target := 3;
                        deck_op := 1;
                        pending_source_inc := FALSE;
                        deck_state := 10;
                    ELSIF X10 AND (source_kind <> 0) AND (a_needs_source OR b_needs_source OR storage_has_empty) THEN
                        deck_target := 1;
                        deck_op := 1;
                        pending_source_inc := TRUE;
                        deck_state := 10;
                    END_IF;
                END_IF;
            END_IF;

        10:
            D200 := deck_target;
            IF can_start_deck THEN
                IF D0 = deck_target THEN
                    deck_state := 20;
                ELSE
                    Y10 := TRUE;
                    deck_state := 11;
                END_IF;
            END_IF;

        11:
            D200 := deck_target;
            IF (D0 = deck_target) AND can_start_deck THEN
                deck_state := 20;
            END_IF;

        20:
            D200 := deck_target;
            IF (D0 = deck_target) AND can_start_deck THEN
                IF deck_op = 1 THEN
                    Y11 := TRUE;
                    deck_state := 30;
                ELSIF deck_op = 2 THEN
                    IF (deck_target = 4) OR (deck_target = 5) THEN
                        D201 := current_gen;
                    END_IF;
                    Y12 := TRUE;
                    deck_state := 30;
                ELSE
                    deck_state := 0;
                END_IF;
            END_IF;

        30:
            IF NOT X11 THEN
                IF deck_op = 1 THEN
                    IF X12 OR (D1 <> 0) THEN
                        IF pending_source_inc THEN
                            source_index := source_index + 1;
                            pending_source_inc := FALSE;
                        END_IF;
                        deck_state := 0;
                    END_IF;
                ELSIF deck_op = 2 THEN
                    IF (NOT X12) OR (D1 = 0) THEN
                        deck_state := 0;
                    END_IF;
                ELSE
                    deck_state := 0;
                END_IF;
            END_IF;

        ELSE
            deck_state := 0;
    END_CASE;

    D200 := deck_target;

    IF X1D AND (box_state = 5) AND a_ack_sent AND b_ack_sent AND (source_index > 8) AND (NOT X12) AND (D1 = 0) AND ((D5 = 0) OR (D6 = 0)) AND ((D7 = 0) OR (D8 = 0)) AND NOT X11 AND NOT X21 AND (deck_state = 0) THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

IF complete_latched THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

END_PROGRAM