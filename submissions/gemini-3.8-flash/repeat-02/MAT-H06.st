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

    started : BOOL := FALSE;
    completed : BOOL := FALSE;

    accept_batch_sent : BOOL := FALSE;
    ack_batch_sent : BOOL := FALSE;
    batch_count : INT := 0;

    accept_a_sent : BOOL := FALSE;
    accept_b_sent : BOOL := FALSE;

    spare_adv_active : BOOL := FALSE;
    spare_lock_active : BOOL := FALSE;
    splice_triggered : BOOL := FALSE;
    splice_active : BOOL := FALSE;
    splice_clamped_done : BOOL := FALSE;

    a_count : INT := 0;
    b_count : INT := 0;
    waste_done : BOOL := FALSE;

    piece_state : INT := 0;
    slice_type : INT := 0;
    current_target : INT := 0;
    chosen : INT := 0;
    can_run_a : BOOL := FALSE;
    can_run_b : BOOL := FALSE;

    hold_timer : TON;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

hold_timer(IN := (piece_state = 4), PT := T#180ms);

IF (batch_count >= 5 AND a_count >= 3 AND b_count >= 3 AND waste_done AND piece_state = 0) OR X1E THEN
    completed := TRUE;
END_IF;

IF completed THEN
    Y1B := TRUE;
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
    Y1E := FALSE;
    Y1F := FALSE;
    RETURN;
END_IF;

(* Batch Acceptance and Acknowledgment *)
IF X10 AND (NOT X11) AND (NOT accept_batch_sent) THEN
    Y10 := TRUE;
    accept_batch_sent := TRUE;
ELSIF X11 THEN
    Y10 := FALSE;
    accept_batch_sent := FALSE;
ELSE
    Y10 := FALSE;
END_IF;

IF X12 AND (NOT ack_batch_sent) THEN
    Y11 := TRUE;
    ack_batch_sent := TRUE;
    batch_count := batch_count + 1;
ELSIF NOT X12 THEN
    Y11 := FALSE;
    ack_batch_sent := FALSE;
ELSE
    Y11 := FALSE;
END_IF;

(* Spare Reel Docking, Locking, and Threading *)
IF X20 THEN
    spare_adv_active := TRUE;
END_IF;
Y1C := spare_adv_active;

IF X21 THEN
    spare_lock_active := TRUE;
END_IF;
Y1D := spare_lock_active;

IF X22 AND (NOT X25) THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

(* Splice Handling *)
IF X27 AND (NOT splice_triggered) THEN
    splice_triggered := TRUE;
    splice_active := TRUE;
END_IF;

IF splice_active AND X22 AND X25 AND (NOT splice_clamped_done) THEN
    Y1E := TRUE;
    Y1F := TRUE;
    IF X23 AND X24 AND (NOT X26) THEN
        Y21 := TRUE;
    ELSE
        Y21 := FALSE;
    END_IF;
    IF X26 THEN
        Y21 := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        splice_clamped_done := TRUE;
    END_IF;
ELSE
    IF splice_clamped_done THEN
        Y21 := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        IF X28 AND (NOT X23) AND (NOT X24) THEN
            splice_active := FALSE;
        END_IF;
    END_IF;
END_IF;

(* Feed Actuation *)
IF X11 AND (D1 > 0) AND X28 AND (NOT X23) AND (NOT X24) AND (NOT splice_active) AND (D2 < 1550) THEN
    Y15 := TRUE;
ELSE
    Y15 := FALSE;
END_IF;

(* Order Acceptance for A and B *)
IF X13 AND (NOT X15) AND (NOT accept_a_sent) THEN
    Y12 := TRUE;
    accept_a_sent := TRUE;
ELSIF X15 THEN
    Y12 := FALSE;
    accept_a_sent := FALSE;
ELSE
    Y12 := FALSE;
END_IF;

IF X14 AND (NOT X16) AND (NOT accept_b_sent) THEN
    Y13 := TRUE;
    accept_b_sent := TRUE;
ELSIF X16 THEN
    Y13 := FALSE;
    accept_b_sent := FALSE;
ELSE
    Y13 := FALSE;
END_IF;

(* Downstream Slice and Waste Cutting State Machine *)
can_run_a := (a_count < 3) AND X15 AND ((D5 <= D10) OR X29);
can_run_b := (b_count < 3) AND X16 AND ((D6 <= D10) OR X29);

CASE piece_state OF
    0: (* IDLE *)
        Y16 := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y19 := FALSE;
        Y14 := FALSE;
        Y22 := FALSE;
        Y1A := FALSE;

        IF X17 AND X1C AND X1F AND (NOT X18) AND (NOT X19) THEN
            chosen := 0;
            IF can_run_a AND can_run_b THEN
                IF a_count <= b_count THEN
                    chosen := 1;
                ELSE
                    chosen := 2;
                END_IF;
            ELSIF can_run_a THEN
                chosen := 1;
            ELSIF can_run_b THEN
                chosen := 2;
            ELSIF (NOT waste_done) AND (a_count < 3 OR b_count < 3) THEN
                IF X26 AND (NOT X29) THEN
                    chosen := 3;
                END_IF;
            END_IF;

            IF chosen = 1 THEN
                D200 := 1;
                current_target := D5;
                slice_type := 1;
                Y14 := TRUE;
                piece_state := 1;
            ELSIF chosen = 2 THEN
                D200 := 2;
                current_target := D6;
                slice_type := 2;
                Y14 := TRUE;
                piece_state := 1;
            ELSIF chosen = 3 THEN
                D200 := 0;
                current_target := D11;
                slice_type := 3;
                Y22 := TRUE;
                piece_state := 1;
            END_IF;
        END_IF;

    1: (* START_PULSE *)
        Y14 := FALSE;
        Y22 := FALSE;
        piece_state := 3;

    3: (* PULLING *)
        IF D8 >= current_target THEN
            Y16 := FALSE;
            Y17 := TRUE;
            piece_state := 4;
        ELSE
            IF X1F AND (D2 >= 450) THEN
                Y16 := TRUE;
            ELSE
                Y16 := FALSE;
            END_IF;
        END_IF;

    4: (* HOLDING *)
        Y16 := FALSE;
        Y17 := TRUE;
        IF X1B AND hold_timer.Q AND (ABS(D8 - current_target) <= 2) THEN
            Y18 := TRUE;
            piece_state := 5;
        END_IF;

    5: (* CUTTING *)
        Y18 := TRUE;
        IF X19 THEN
            Y18 := FALSE;
            Y17 := FALSE;
            piece_state := 6;
        END_IF;

    6: (* RELEASE_WAIT *)
        Y18 := FALSE;
        Y17 := FALSE;
        IF (NOT X1A) AND X1F THEN
            Y19 := TRUE;
            piece_state := 7;
        END_IF;

    7: (* RELEASING *)
        Y19 := FALSE;
        piece_state := 8;

    8: (* WAIT_EXIT *)
        IF X1D THEN
            Y1A := TRUE;
            piece_state := 9;
        END_IF;

    9: (* ACK_EXIT *)
        IF NOT X1D THEN
            Y1A := FALSE;
            IF slice_type = 1 THEN
                a_count := a_count + 1;
            ELSIF slice_type = 2 THEN
                b_count := b_count + 1;
            ELSIF slice_type = 3 THEN
                waste_done := TRUE;
            END_IF;
            piece_state := 10;
        ELSE
            Y1A := TRUE;
        END_IF;

    10: (* WAIT_CLEAR *)
        Y1A := FALSE;
        IF X1C AND X17 AND X1F THEN
            piece_state := 0;
        END_IF;
END_CASE;

END_PROGRAM