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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    started : BOOL;
    complete_latched : BOOL;
    batch_state : INT;
    batch_count : INT;
    feed_allowed : BOOL;
    piece_state : INT;
    normal_done : INT;
    next_side : INT;
    next_len : INT;
    base_len : INT;
    side_cmd : INT;
    normal_accepted : BOOL;
    accepted_index : INT;
    current_target : INT;
    current_is_waste : BOOL;
    waste_started : BOOL;
    waste_acked : BOOL;
    waste_required : BOOL;
    target_stop : INT;
    cut_diff : INT;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

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
Y1B := complete_latched;

IF NOT X27 THEN
    feed_allowed := TRUE;
ELSE
    feed_allowed := X26 AND X28 AND (NOT X23) AND (NOT X24);
END_IF;

Y1C := started AND X20 AND ((NOT X21) OR (NOT X22));
Y1D := started AND X21;
Y20 := started AND X22 AND (NOT X25) AND (NOT X26);
Y1E := started AND X27 AND (NOT X26);
Y1F := started AND X25 AND X22 AND (NOT X26);
Y21 := started AND X25 AND X22 AND X23 AND X24 AND (NOT X26);

CASE normal_done OF
    0:
        next_side := 1;
        base_len := 600;
    1:
        next_side := 2;
        base_len := 900;
    2:
        next_side := 1;
        base_len := 1000;
    3:
        next_side := 2;
        base_len := 700;
    4:
        next_side := 1;
        base_len := 800;
    5:
        next_side := 2;
        base_len := 1100;
ELSE
        next_side := 0;
        base_len := 0;
END_CASE;

next_len := base_len;
IF next_side = 1 THEN
    IF D5 > 0 THEN
        next_len := D5;
    END_IF;
ELSIF next_side = 2 THEN
    IF D6 > 0 THEN
        next_len := D6;
    END_IF;
END_IF;

waste_required := FALSE;
IF started AND (normal_done < 6) AND (NOT waste_acked) AND (NOT waste_started) THEN
    IF (D10 > 0) AND (next_len > D10) AND (NOT X29) THEN
        waste_required := TRUE;
    END_IF;
END_IF;

IF started THEN
    CASE batch_state OF
        0:
            IF X10 AND (batch_count < 5) THEN
                Y10 := TRUE;
                batch_state := 1;
            END_IF;
        1:
            IF X12 OR (X11 AND (D1 <= 0)) THEN
                Y11 := TRUE;
                batch_count := batch_count + 1;
                batch_state := 3;
            ELSIF X11 THEN
                batch_state := 2;
            END_IF;
        2:
            IF X12 OR (D1 <= 0) THEN
                Y11 := TRUE;
                batch_count := batch_count + 1;
                batch_state := 3;
            END_IF;
        3:
            IF NOT X12 THEN
                batch_state := 0;
            END_IF;
    ELSE
        batch_state := 0;
    END_CASE;
END_IF;

IF started AND feed_allowed AND (D2 < 1500) AND (batch_state = 2) AND (NOT X12) AND (D1 > 0) THEN
    Y15 := TRUE;
END_IF;

IF normal_accepted AND (accepted_index <> normal_done) THEN
    normal_accepted := FALSE;
END_IF;

CASE piece_state OF
    0:
        IF started AND (normal_done < 6) AND X17 AND X1C AND X1F AND (NOT X1A) THEN
            IF waste_required THEN
                IF X26 AND (NOT X29) AND (D11 > 0) THEN
                    current_target := D11;
                    current_is_waste := TRUE;
                    waste_started := TRUE;
                    side_cmd := 0;
                    Y22 := TRUE;
                    piece_state := 20;
                END_IF;
            ELSIF (NOT waste_required) THEN
                IF normal_accepted AND (accepted_index = normal_done) THEN
                    current_target := base_len;
                    IF next_side = 1 THEN
                        IF D5 > 0 THEN
                            current_target := D5;
                        END_IF;
                    ELSIF next_side = 2 THEN
                        IF D6 > 0 THEN
                            current_target := D6;
                        END_IF;
                    END_IF;
                    IF (next_side > 0) AND (current_target > 0) THEN
                        side_cmd := next_side;
                        current_is_waste := FALSE;
                        D200 := side_cmd;
                        Y14 := TRUE;
                        normal_accepted := FALSE;
                        piece_state := 20;
                    END_IF;
                ELSE
                    IF next_side = 1 THEN
                        IF X15 THEN
                            normal_accepted := TRUE;
                            accepted_index := normal_done;
                        ELSIF X13 THEN
                            Y12 := TRUE;
                            normal_accepted := TRUE;
                            accepted_index := normal_done;
                        END_IF;
                    ELSIF next_side = 2 THEN
                        IF X16 THEN
                            normal_accepted := TRUE;
                            accepted_index := normal_done;
                        ELSIF X14 THEN
                            Y13 := TRUE;
                            normal_accepted := TRUE;
                            accepted_index := normal_done;
                        END_IF;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;

    20:
        IF X18 THEN
            piece_state := 30;
        END_IF;

    30:
        target_stop := current_target - 2;
        IF target_stop < 0 THEN
            target_stop := 0;
        END_IF;
        IF X18 AND (D8 < target_stop) AND X1F AND (D2 > 430) THEN
            Y16 := TRUE;
        ELSE
            piece_state := 40;
        END_IF;

    40:
        Y17 := TRUE;
        cut_diff := D8 - current_target;
        IF cut_diff < 0 THEN
            cut_diff := -cut_diff;
        END_IF;
        IF X1B AND (NOT X1A) AND (cut_diff <= 2) THEN
            Y18 := TRUE;
            piece_state := 50;
        END_IF;

    50:
        Y17 := TRUE;
        IF X19 AND (NOT X1A) THEN
            piece_state := 60;
        END_IF;

    60:
        IF X19 AND (NOT X1A) AND X1F THEN
            Y19 := TRUE;
            piece_state := 70;
        END_IF;

    70:
        IF X1D THEN
            Y1A := TRUE;
            IF current_is_waste THEN
                waste_acked := TRUE;
            ELSE
                normal_done := normal_done + 1;
            END_IF;
            current_is_waste := FALSE;
            piece_state := 0;
        END_IF;
ELSE
    piece_state := 0;
END_CASE;

IF side_cmd <> 0 THEN
    D200 := side_cmd;
END_IF;

IF started AND (NOT complete_latched) THEN
    IF (normal_done >= 6) AND waste_acked AND X26 AND X29 AND ((batch_count >= 5) OR X1E) THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

Y1B := complete_latched;

END_PROGRAM