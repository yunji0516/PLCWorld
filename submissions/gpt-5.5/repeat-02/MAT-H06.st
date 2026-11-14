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

    run_latched : BOOL := FALSE;
    complete_latched : BOOL := FALSE;

    a_accept_count : INT := 0;
    b_accept_count : INT := 0;
    a_accept_cool : INT := 0;
    b_accept_cool : INT := 0;

    batch_accept_count : INT := 0;
    batch_accept_cool : INT := 0;

    a_started : INT := 0;
    b_started : INT := 0;
    normal_index : INT := 0;
    normal_completed : INT := 0;

    piece_state : INT := 0;
    current_target : INT := 0;
    current_side : INT := 0;
    current_waste : BOOL := FALSE;

    next_side : INT := 0;
    next_len : INT := 0;
    order_ready : BOOL := FALSE;
    need_waste_before_next : BOOL := FALSE;
    waste_started : BOOL := FALSE;
    waste_done : BOOL := FALSE;
    target_reached : BOOL := FALSE;

    spare_arrived : BOOL := FALSE;
    spare_lock_cmd : BOOL := FALSE;
    splice_required : BOOL := FALSE;
    splice_joined_seen : BOOL := FALSE;
    feed_allowed : BOOL := TRUE;
END_VAR

IF X0 THEN
    run_latched := TRUE;
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
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

IF a_accept_cool > 0 THEN
    a_accept_cool := a_accept_cool - 1;
END_IF;
IF b_accept_cool > 0 THEN
    b_accept_cool := b_accept_cool - 1;
END_IF;
IF batch_accept_cool > 0 THEN
    batch_accept_cool := batch_accept_cool - 1;
END_IF;

IF run_latched AND NOT complete_latched THEN
    IF X13 AND (a_accept_count < 3) AND (a_accept_cool = 0) THEN
        Y12 := TRUE;
        a_accept_count := a_accept_count + 1;
        a_accept_cool := 5;
    END_IF;

    IF X14 AND (b_accept_count < 3) AND (b_accept_cool = 0) THEN
        Y13 := TRUE;
        b_accept_count := b_accept_count + 1;
        b_accept_cool := 5;
    END_IF;

    IF X10 AND NOT X11 AND NOT X12 AND (batch_accept_count < 5) AND (batch_accept_cool = 0) THEN
        Y10 := TRUE;
        batch_accept_count := batch_accept_count + 1;
        batch_accept_cool := 10;
    END_IF;
END_IF;

IF X12 OR (X11 AND (D1 = 0)) THEN
    Y11 := TRUE;
END_IF;

IF X20 THEN
    spare_arrived := TRUE;
END_IF;

IF X21 OR X22 THEN
    spare_lock_cmd := TRUE;
END_IF;

IF X27 THEN
    splice_required := TRUE;
END_IF;

IF X26 THEN
    splice_joined_seen := TRUE;
END_IF;

IF spare_arrived AND NOT X22 THEN
    Y1C := TRUE;
END_IF;

IF spare_lock_cmd THEN
    Y1D := TRUE;
END_IF;

IF splice_required AND NOT X26 AND NOT complete_latched THEN
    Y1E := TRUE;
    IF X22 AND NOT X25 THEN
        Y20 := TRUE;
    END_IF;
    IF X25 THEN
        Y1F := TRUE;
    END_IF;
    IF X25 AND X22 AND (X23 OR Y1E) AND (X24 OR Y1F) THEN
        Y21 := TRUE;
    END_IF;
END_IF;

IF NOT splice_required THEN
    feed_allowed := TRUE;
ELSE
    feed_allowed := X26 AND X28 AND (NOT X23) AND (NOT X24);
END_IF;

IF run_latched AND NOT complete_latched AND feed_allowed AND X11 AND NOT X12 AND (D1 > 0) AND (D2 < 1550) THEN
    Y15 := TRUE;
END_IF;

next_side := 0;
next_len := 0;

CASE normal_index OF
    0:
        next_side := 1;
        next_len := 600;
    1:
        next_side := 2;
        next_len := 900;
    2:
        next_side := 1;
        next_len := 1000;
    3:
        next_side := 2;
        next_len := 700;
    4:
        next_side := 1;
        next_len := 800;
    5:
        next_side := 2;
        next_len := 1100;
ELSE
    next_side := 0;
    next_len := 0;
END_CASE;

IF next_side = 1 THEN
    IF D5 > 0 THEN
        next_len := D5;
    END_IF;
    order_ready := a_accept_count > a_started;
ELSIF next_side = 2 THEN
    IF D6 > 0 THEN
        next_len := D6;
    END_IF;
    order_ready := b_accept_count > b_started;
ELSE
    order_ready := FALSE;
END_IF;

need_waste_before_next := FALSE;
IF (normal_index < 6) AND NOT waste_done AND NOT waste_started THEN
    IF D10 <= (next_len + 5) THEN
        need_waste_before_next := TRUE;
    END_IF;
END_IF;

IF piece_state = 0 THEN
    D200 := next_side;
ELSE
    D200 := current_side;
END_IF;

CASE piece_state OF
    0:
        IF run_latched AND NOT complete_latched AND X17 AND X1C AND X1F AND NOT X1A AND NOT X1D THEN
            IF need_waste_before_next THEN
                IF X26 AND feed_allowed AND NOT X29 THEN
                    current_waste := TRUE;
                    current_side := 0;
                    D200 := 0;
                    current_target := D11;
                    IF current_target <= 0 THEN
                        current_target := 900;
                    END_IF;
                    Y22 := TRUE;
                    Y14 := TRUE;
                    waste_started := TRUE;
                    piece_state := 1;
                END_IF;
            ELSE
                IF (normal_index < 6) AND order_ready THEN
                    current_waste := FALSE;
                    current_side := next_side;
                    D200 := next_side;
                    current_target := next_len;
                    Y14 := TRUE;

                    IF next_side = 1 THEN
                        a_started := a_started + 1;
                    ELSIF next_side = 2 THEN
                        b_started := b_started + 1;
                    END_IF;

                    normal_index := normal_index + 1;
                    piece_state := 1;
                END_IF;
            END_IF;
        END_IF;

    1:
        target_reached := D8 >= (current_target - 2);
        IF NOT target_reached AND X1F AND (D2 > 430) THEN
            Y16 := TRUE;
        END_IF;
        IF target_reached THEN
            piece_state := 2;
        END_IF;

    2:
        Y17 := TRUE;
        IF X1B AND NOT X1A AND (ABS(D8 - current_target) <= 3) THEN
            Y18 := TRUE;
            piece_state := 3;
        END_IF;

    3:
        Y17 := TRUE;
        IF X19 AND NOT X1A THEN
            piece_state := 4;
        END_IF;

    4:
        Y19 := TRUE;
        piece_state := 5;

    5:
        IF X1D THEN
            Y1A := TRUE;
            IF current_waste THEN
                waste_done := TRUE;
            ELSE
                normal_completed := normal_completed + 1;
            END_IF;
            current_waste := FALSE;
            current_side := 0;
            current_target := 0;
            piece_state := 0;
        END_IF;
ELSE
    piece_state := 0;
END_CASE;

IF complete_latched THEN
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

IF NOT complete_latched THEN
    IF X1E AND (normal_completed >= 6) AND waste_done AND splice_joined_seen AND X29 AND (D3 >= 6000) AND (D9 >= 7) THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

Y1B := complete_latched;

END_PROGRAM