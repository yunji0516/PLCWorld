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

    (* Internal variables *)
    prev_batch_ready : BOOL;
    prev_batch_active : BOOL;
    prev_batch_done : BOOL;
    prev_ack_batch : BOOL;
    prev_ack_exit : BOOL;
    prev_complete : BOOL;

    batch_state : INT := 0;
    batch_accepted : BOOL := FALSE;

    piece_state : INT := 0;
    side : INT := 1;
    piece_num : INT := 0;
    piece_target : INT := 0;
    zone_index : INT := 0;
    piece_done : BOOL := FALSE;

    cut_timer : INT := 0;

    splice_state : INT := 0;
    splice_done : BOOL := FALSE;
    feed_resumed : BOOL := FALSE;
    prev_threaded : BOOL;
    prev_old_end_held : BOOL;
    prev_new_end_held : BOOL;

    waste_state : INT := 0;
    waste_done : BOOL := FALSE;
    waste_cut_timer : INT := 0;

    batch_count : INT := 0;
    complete_timer : INT := 0;

    Z_pos_A : ARRAY[0..2] OF INT := [70, 90, 110];
    Z_pos_B : ARRAY[0..2] OF INT := [-70, -90, -110];
END_VAR

(* Batch completion counting *)
IF X12 AND NOT prev_batch_done THEN
    batch_count := batch_count + 1;
    ack_batch := TRUE;
    prev_ack_batch := TRUE;
END_IF;
prev_batch_done := X12;

(* Batch handling state machine *)
CASE batch_state OF
    0: (* idle - wait for rising edge of batch_ready *)
        IF X10 AND NOT prev_batch_ready AND NOT batch_accepted THEN
            Y10 := TRUE;
            batch_accepted := TRUE;
            batch_state := 1;
        END_IF;
        prev_batch_ready := X10;

    1: (* accept - wait for batch_active *)
        IF X11 THEN
            Y10 := FALSE;
            batch_state := 2;
        END_IF;

    2: (* active - running *)
        IF NOT X11 THEN
            batch_state := 3;
        END_IF;

    3: (* done detected *)
        IF NOT X12 THEN
            batch_state := 4;
        END_IF;

    4: (* reset *)
        Y10 := FALSE;
        ack_batch := FALSE;
        batch_accepted := FALSE;
        prev_ack_batch := FALSE;
        batch_state := 0;
END_CASE;

(* Piece handling state machine *)
CASE piece_state OF
    0: (* idle - select side and target *)
        side := 1;
        IF piece_num >= 2 THEN
            side := 2;
        END_IF;
        IF piece_num >= 4 THEN
            side := 2;
        END_IF;

        IF side = 1 THEN
            piece_target := D5;
        ELSE
            piece_target := D6;
        END_IF;

        D200 := side;

        IF X17 AND (D4 < 1) THEN
            piece_state := 1;
        END_IF;

    1: (* produce *)
        Y14 := TRUE;
        IF X18 THEN
            Y14 := FALSE;
            piece_state := 2;
        END_IF;

    2: (* cut - when target reached, holder closed, cutter idle *)
        IF (D8 >= (piece_target - 2)) AND (D8 <= (piece_target + 2)) AND NOT X1A THEN
            Y17 := TRUE;
            Y18 := TRUE;
            cut_timer := 0;
            piece_state := 3;
        END_IF;

    3: (* cutting for 0.6s = 60 scans *)
        cut_timer := cut_timer + 1;
        IF cut_timer >= 60 THEN
            Y18 := FALSE;
            piece_state := 4;
        END_IF;

    4: (* release - after separation, blade return, holder open *)
        IF (X19 OR (NOT X1A)) AND X1F THEN
            Y17 := FALSE;
            piece_state := 5;
        END_IF;

    5: (* receiving - wait for exit *)
        IF piece_num < 6 THEN
            IF side = 1 THEN
                D200 := Z_pos_A[zone_index];
            ELSE
                D200 := Z_pos_B[zone_index];
            END_IF;

            IF X1D THEN
                Y1A := TRUE;
                IF NOT prev_ack_exit THEN
                    zone_index := zone_index + 1;
                    IF zone_index > 2 THEN
                        zone_index := 0;
                    END_IF;
                END_IF;
            ELSE
                Y1A := FALSE;
            END_IF;

            IF NOT X1D AND prev_ack_exit THEN
                prev_ack_exit := FALSE;
                piece_num := piece_num + 1;
                IF piece_num >= 6 THEN
                    piece_done := TRUE;
                END_IF;
                piece_state := 0;
            END_IF;

            prev_ack_exit := Y1A;
        ELSE
            piece_state := 0;
        END_IF;
END_CASE;

Y16 := X16;

(* Splicing state machine *)
CASE splice_state OF
    0: (* idle - wait for spare_available *)
        IF X20 THEN
            Y1C := TRUE;
            Y1D := TRUE;
            splice_state := 1;
        END_IF;

    1: (* advance - wait for spare_docked *)
        IF X21 THEN
            Y1C := FALSE;
            splice_state := 2;
        END_IF;

    2: (* locked - wait for threaded *)
        IF X25 AND NOT prev_threaded THEN
            prev_threaded := X25;
            splice_state := 3;
        END_IF;
        prev_threaded := X25;

    3: (* hold old end *)
        Y1E := TRUE;
        IF X23 AND NOT prev_old_end_held THEN
            prev_old_end_held := X23;
            splice_state := 4;
        END_IF;
        prev_old_end_held := X23;

    4: (* hold new end *)
        Y1F := TRUE;
        IF X24 AND NOT prev_new_end_held THEN
            prev_new_end_held := X24;
            splice_state := 5;
        END_IF;
        prev_new_end_held := X24;

    5: (* splice press *)
        Y21 := TRUE;
        IF X26 THEN
            Y21 := FALSE;
            Y1E := FALSE;
            Y1F := FALSE;
            splice_state := 6;
        END_IF;

    6: (* wait for feed_path_clear *)
        IF X28 THEN
            feed_resumed := TRUE;
            splice_done := TRUE;
            splice_state := 7;
        END_IF;

    7: (* splice complete *)
        Y1C := FALSE;
        Y1D := FALSE;
END_CASE;

(* Waste handling state machine *)
CASE waste_state OF
    0: (* idle - wait for feed_resumed and splice not passed *)
        IF feed_resumed AND NOT X29 AND NOT waste_done THEN
            Y22 := TRUE;
            piece_target := D11;
            waste_state := 1;
        END_IF;

    1: (* produce waste *)
        IF X18 THEN
            waste_state := 2;
        END_IF;

    2: (* cut waste *)
        IF (D8 >= (piece_target - 2)) AND (D8 <= (piece_target + 2)) AND NOT X1A THEN
            Y17 := TRUE;
            Y18 := TRUE;
            waste_cut_timer := 0;
            waste_state := 3;
        END_IF;

    3: (* cutting waste for 0.6s *)
        waste_cut_timer := waste_cut_timer + 1;
        IF waste_cut_timer >= 60 THEN
            Y18 := FALSE;
            waste_state := 4;
        END_IF;

    4: (* release waste *)
        IF (X19 OR (NOT X1A)) AND X1F THEN
            Y17 := FALSE;
            Y22 := FALSE;
            waste_state := 5;
        END_IF;

    5: (* receive waste *)
        D200 := Z_pos_B[0];
        IF X1D THEN
            Y1A := TRUE;
        ELSE
            Y1A := FALSE;
        END_IF;

        IF NOT X1D AND Y1A THEN
            waste_done := TRUE;
            Y1A := FALSE;
            waste_state := 6;
        END_IF;

    6: (* waste complete *)
END_CASE;

(* Completion check *)
IF (batch_count >= 5) AND (piece_num >= 6) AND splice_done AND waste_done THEN
    IF NOT prev_complete THEN
        complete_timer := 0;
    END_IF;
    complete_timer := complete_timer + 1;
    Y1B := TRUE;
ELSE
    complete_timer := 0;
    Y1B := FALSE;
END_IF;

prev_complete := Y1B;

END_PROGRAM