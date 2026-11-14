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

    batch_accept_latch : BOOL;
    batch_ack_latch : BOOL;
    batch_ack_count : INT;

    accept_a_latch : BOOL;
    accept_b_latch : BOOL;

    feed_request : BOOL;
    feed_allowed : BOOL;

    spare_lock_cmd : BOOL;
    splice_started : BOOL;
    splice_press_record : BOOL;
    thread_record : BOOL;

    piece_state : INT;
    current_target : INT;
    current_side : INT;
    current_is_waste : BOOL;
    normal_started : INT;
    normal_ack_count : INT;
    waste_started : BOOL;
    waste_ack_count : INT;
    waiting_receipt : BOOL;
    receipt_is_waste : BOOL;

    next_side : INT;
    next_target : INT;
    next_active : BOOL;
    ready_start : BOOL;
    waste_required : BOOL;

    complete_latched : BOOL;
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

next_side := 0;
next_target := 0;
next_active := FALSE;

CASE normal_started OF
    0:
        next_side := 1;
        next_target := D5;
        next_active := X15;
    1:
        next_side := 2;
        next_target := D6;
        next_active := X16;
    2:
        next_side := 1;
        next_target := D5;
        next_active := X15;
    3:
        next_side := 2;
        next_target := D6;
        next_active := X16;
    4:
        next_side := 1;
        next_target := D5;
        next_active := X15;
    5:
        next_side := 2;
        next_target := D6;
        next_active := X16;
ELSE
    next_side := 0;
    next_target := 0;
    next_active := FALSE;
END_CASE;

IF piece_state <> 0 THEN
    D200 := current_side;
ELSE
    D200 := next_side;
END_IF;

IF X27 THEN
    splice_started := TRUE;
END_IF;

IF X25 THEN
    thread_record := TRUE;
END_IF;

IF X20 THEN
    Y1C := TRUE;
END_IF;

IF X21 OR X22 THEN
    spare_lock_cmd := TRUE;
END_IF;
Y1D := spare_lock_cmd;

IF X22 AND (NOT X25) AND (NOT X26) THEN
    Y20 := TRUE;
END_IF;

IF X25 AND (NOT X26) THEN
    Y1F := TRUE;
END_IF;

IF splice_started AND (NOT X26) THEN
    Y1E := TRUE;
END_IF;

IF X22 AND X25 AND splice_started AND X23 AND X24 AND (NOT X26) THEN
    Y21 := TRUE;
    splice_press_record := TRUE;
END_IF;

IF X26 THEN
    splice_press_record := TRUE;
END_IF;

IF X11 OR (NOT X10) THEN
    batch_accept_latch := FALSE;
END_IF;

IF X10 AND (NOT X11) AND (batch_ack_count < 5) AND (NOT batch_accept_latch) THEN
    Y10 := TRUE;
    batch_accept_latch := TRUE;
END_IF;

IF NOT X12 THEN
    batch_ack_latch := FALSE;
END_IF;

IF X12 AND (D1 <= 0) AND (NOT batch_ack_latch) THEN
    Y11 := TRUE;
    batch_ack_latch := TRUE;
    IF batch_ack_count < 5 THEN
        batch_ack_count := batch_ack_count + 1;
    END_IF;
END_IF;

IF X15 OR (NOT X13) THEN
    accept_a_latch := FALSE;
END_IF;

IF X16 OR (NOT X14) THEN
    accept_b_latch := FALSE;
END_IF;

IF (normal_started < 6) AND (NOT complete_latched) THEN
    IF (next_side = 1) AND (NOT X15) AND X13 AND (NOT accept_a_latch) THEN
        Y12 := TRUE;
        accept_a_latch := TRUE;
    END_IF;

    IF (next_side = 2) AND (NOT X16) AND X14 AND (NOT accept_b_latch) THEN
        Y13 := TRUE;
        accept_b_latch := TRUE;
    END_IF;
END_IF;

IF D2 <= 1450 THEN
    feed_request := TRUE;
ELSIF D2 >= 1550 THEN
    feed_request := FALSE;
END_IF;

feed_allowed := X28 AND (NOT X23) AND (NOT X24) AND ((NOT splice_started) OR X26);

IF X11 AND (NOT X12) AND (D1 > 0) AND feed_request AND feed_allowed AND (NOT complete_latched) THEN
    Y15 := TRUE;
END_IF;

IF NOT X1D THEN
    batch_ack_latch := batch_ack_latch;
ELSE
    IF waiting_receipt THEN
        batch_ack_latch := batch_ack_latch;
    END_IF;
END_IF;

IF NOT X1D THEN
END_IF;

IF X1D AND (NOT batch_accept_latch) THEN
END_IF;

IF NOT X1D THEN
    (* exit acknowledge latch is represented by waiting for the input to drop through this retained flag reuse-free path *)
END_IF;

IF X1D THEN
    IF NOT receipt_is_waste THEN
        IF waiting_receipt THEN
            Y1A := TRUE;
            normal_ack_count := normal_ack_count + 1;
            waiting_receipt := FALSE;
        ELSE
            Y1A := TRUE;
        END_IF;
    ELSE
        IF waiting_receipt THEN
            Y1A := TRUE;
            waste_ack_count := waste_ack_count + 1;
            waiting_receipt := FALSE;
            receipt_is_waste := FALSE;
        ELSE
            Y1A := TRUE;
        END_IF;
    END_IF;
END_IF;

ready_start := (piece_state = 0) AND X17 AND X1C AND (NOT X1D) AND (NOT complete_latched);

waste_required := FALSE;
IF (waste_ack_count = 0) AND (NOT waste_started) AND (D10 > 0) AND (next_target > D10) AND (NOT X29) THEN
    waste_required := TRUE;
END_IF;

CASE piece_state OF
    0:
        IF ready_start AND (normal_started < 6) AND next_active AND (next_target > 0) THEN
            IF ((waste_ack_count = 0) AND (waste_started OR waste_required)) THEN
                IF (NOT waste_started) AND waste_required AND X26 AND (NOT X29) AND (D11 > 0) THEN
                    D200 := 0;
                    Y22 := TRUE;
                    current_target := D11;
                    current_side := 0;
                    current_is_waste := TRUE;
                    waste_started := TRUE;
                    piece_state := 1;
                END_IF;
            ELSE
                D200 := next_side;
                Y14 := TRUE;
                current_target := next_target;
                current_side := next_side;
                current_is_waste := FALSE;
                normal_started := normal_started + 1;
                piece_state := 1;
            END_IF;
        END_IF;

    1:
        IF D8 < (current_target - 2) THEN
            IF X1F AND (D2 > 430) THEN
                Y16 := TRUE;
            END_IF;
        ELSE
            piece_state := 2;
        END_IF;

    2:
        Y17 := TRUE;
        IF X1B AND (NOT X1A) AND (ABS(D8 - current_target) <= 2) THEN
            Y18 := TRUE;
            piece_state := 3;
        END_IF;

    3:
        Y17 := TRUE;
        IF X19 AND (NOT X1A) THEN
            piece_state := 4;
        END_IF;

    4:
        IF X1F AND (NOT X1A) THEN
            Y19 := TRUE;
            waiting_receipt := TRUE;
            receipt_is_waste := current_is_waste;
            piece_state := 5;
        END_IF;

    5:
        IF X17 THEN
            current_is_waste := FALSE;
            current_side := 0;
            piece_state := 0;
        END_IF;
ELSE
    piece_state := 0;
END_CASE;

IF (NOT complete_latched) THEN
    IF (normal_ack_count >= 6) AND (waste_ack_count >= 1) AND (batch_ack_count >= 5) AND X26 AND X29 AND splice_press_record AND thread_record AND (piece_state = 0) AND (NOT waiting_receipt) AND (NOT X11) THEN
        complete_latched := TRUE;
    END_IF;
END_IF;

IF complete_latched THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM