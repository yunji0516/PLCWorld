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

    (* Batch feeding state machine *)
    batch_state : INT := 0;

    (* Splicing state machine *)
    splice_state : INT := 0;

    (* Downstream piece state machine *)
    piece_state : INT := 0;
    target_side : INT := 0;
    current_target_len : INT := 0;
    pull_start_enc : INT := 0;
    is_waste_piece : BOOL := FALSE;
    waste_done : BOOL := FALSE;
    total_normal_slices : INT := 0;

    (* Timers & delays *)
    hold_timer : TON;
    cut_timer : TON;
    release_timer : TON;
    press_timer : TON;
    complete_timer : TON;

    completion_latched : BOOL := FALSE;
END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
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
    D200 := 0;
    Y1A := FALSE;
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
    RETURN;
END_IF;

(* ------------------------------------------------------------- *)
(* 1. Splice Subsystem                                           *)
(* ------------------------------------------------------------- *)
CASE splice_state OF
    0: (* Wait for spare reel available or splice needed *)
        IF X20 THEN
            Y1C := TRUE; (* spare_advance *)
            splice_state := 1;
        END_IF;

    1: (* Advancing spare carriage until docked *)
        Y1C := TRUE;
        IF X21 THEN (* spare_docked *)
            Y1D := TRUE; (* spare_lock *)
            splice_state := 2;
        END_IF;

    2: (* Lock spare carriage *)
        Y1C := TRUE;
        Y1D := TRUE;
        IF X22 THEN (* spare_locked *)
            IF X27 THEN (* splice_needed *)
                splice_state := 3;
            END_IF;
        END_IF;

    3: (* Thread leading end of spare *)
        Y1C := TRUE;
        Y1D := TRUE;
        Y20 := TRUE; (* thread *)
        IF X25 THEN (* threaded *)
            Y20 := FALSE;
            Y1E := TRUE; (* old_end_hold *)
            Y1F := TRUE; (* new_end_hold *)
            splice_state := 4;
        END_IF;

    4: (* Hold both ends *)
        Y1C := TRUE;
        Y1D := TRUE;
        Y1E := TRUE;
        Y1F := TRUE;
        IF X23 AND X24 THEN (* old_end_held and new_end_held *)
            Y21 := TRUE; (* splice_press *)
            splice_state := 5;
        END_IF;

    5: (* Lower connection press plate until joined *)
        Y1C := TRUE;
        Y1D := TRUE;
        Y1E := TRUE;
        Y1F := TRUE;
        Y21 := TRUE;
        IF X26 THEN (* joined *)
            press_timer(IN := TRUE, PT := T#200ms);
            IF press_timer.Q THEN
                press_timer(IN := FALSE, PT := T#200ms);
                Y21 := FALSE;
                Y1E := FALSE;
                Y1F := FALSE;
                splice_state := 6;
            END_IF;
        ELSE
            press_timer(IN := FALSE, PT := T#200ms);
        END_IF;

    6: (* Splice complete, path cleared *)
        Y1C := TRUE;
        Y1D := TRUE;
        Y21 := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        IF X28 THEN (* feed_path_clear *)
            splice_state := 7;
        END_IF;

    7: (* Maintained holding for docked/locked spare *)
        Y1C := TRUE;
        Y1D := TRUE;
END_CASE;

(* ------------------------------------------------------------- *)
(* 2. Upstream Batch Feeding Subsystem                           *)
(* ------------------------------------------------------------- *)
CASE batch_state OF
    0: (* Wait for batch_ready *)
        Y10 := FALSE;
        Y11 := FALSE;
        Y15 := FALSE;
        IF X10 THEN
            Y10 := TRUE; (* accept_batch *)
            batch_state := 1;
        END_IF;

    1: (* Wait for batch_active *)
        IF X11 THEN
            Y10 := FALSE;
            batch_state := 2;
        END_IF;

    2: (* Feed raw material *)
        (* Can feed only when feed path is clear and storage allows *)
        IF (splice_state = 0 OR splice_state = 1 OR splice_state = 2 OR splice_state >= 6)
           AND (NOT X27 OR X26)
           AND (D2 < 1550) THEN
            Y15 := TRUE;
        ELSE
            Y15 := FALSE;
        END_IF;

        IF D1 <= 0 OR X12 THEN
            Y15 := FALSE;
            IF X12 THEN
                Y11 := TRUE; (* ack_batch *)
                batch_state := 3;
            END_IF;
        END_IF;

    3: (* Acknowledge batch completion *)
        Y15 := FALSE;
        IF NOT X12 AND NOT X11 THEN
            Y11 := FALSE;
            batch_state := 0;
        ELSE
            Y11 := TRUE;
        END_IF;
END_CASE;

(* ------------------------------------------------------------- *)
(* 3. Downstream Slice Production Subsystem                      *)
(* ------------------------------------------------------------- *)
CASE piece_state OF
    0: (* Idle: determine whether to cut Waste, Side A, Side B, or Finish *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y19 := FALSE;
        Y22 := FALSE;
        Y1A := FALSE;

        IF total_normal_slices >= 6 AND (waste_done OR NOT X26) THEN
            piece_state := 99; (* Done *)
        ELSIF X17 AND X1C AND X1F THEN
            (* Check if we must insert waste piece *)
            (* If splice is joined, not yet passed, and safe_length < next target *)
            IF X26 AND NOT waste_done THEN
                IF D10 < 1100 OR D10 <= D11 THEN
                    (* Must cut waste now *)
                    is_waste_piece := TRUE;
                    current_target_len := D11;
                    target_side := 0;
                    D200 := 0;
                    Y22 := TRUE; (* start_waste *)
                    pull_start_enc := D4;
                    piece_state := 2;
                ELSIF X13 AND (D10 >= D5) THEN
                    (* Safe to cut A *)
                    is_waste_piece := FALSE;
                    current_target_len := D5;
                    target_side := 1;
                    D200 := 1;
                    Y12 := TRUE; (* accept_a *)
                    Y14 := TRUE; (* start_piece *)
                    pull_start_enc := D4;
                    piece_state := 1;
                ELSIF X14 AND (D10 >= D6) THEN
                    (* Safe to cut B *)
                    is_waste_piece := FALSE;
                    current_target_len := D6;
                    target_side := 2;
                    D200 := 2;
                    Y13 := TRUE; (* accept_b *)
                    Y14 := TRUE; (* start_piece *)
                    pull_start_enc := D4;
                    piece_state := 1;
                ELSE
                    (* Not enough safe length for order, generate waste *)
                    is_waste_piece := TRUE;
                    current_target_len := D11;
                    target_side := 0;
                    D200 := 0;
                    Y22 := TRUE;
                    pull_start_enc := D4;
                    piece_state := 2;
                END_IF;
            ELSE
                (* Normal order processing *)
                IF X13 AND (total_normal_slices = 0 OR total_normal_slices = 2 OR total_normal_slices = 4) THEN
                    is_waste_piece := FALSE;
                    current_target_len := D5;
                    target_side := 1;
                    D200 := 1;
                    Y12 := TRUE;
                    Y14 := TRUE;
                    pull_start_enc := D4;
                    piece_state := 1;
                ELSIF X14 THEN
                    is_waste_piece := FALSE;
                    current_target_len := D6;
                    target_side := 2;
                    D200 := 2;
                    Y13 := TRUE;
                    Y14 := TRUE;
                    pull_start_enc := D4;
                    piece_state := 1;
                ELSIF X13 THEN
                    is_waste_piece := FALSE;
                    current_target_len := D5;
                    target_side := 1;
                    D200 := 1;
                    Y12 := TRUE;
                    Y14 := TRUE;
                    pull_start_enc := D4;
                    piece_state := 1;
                END_IF;
            END_IF;
        END_IF;

    1: (* Normal order piece started *)
        IF X18 OR D8 > 0 THEN
            Y12 := FALSE;
            Y13 := FALSE;
            Y14 := FALSE;
            piece_state := 3;
        END_IF;

    2: (* Waste piece started *)
        IF X18 OR D8 > 0 THEN
            Y22 := FALSE;
            piece_state := 3;
        END_IF;

    3: (* Pulling web *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y22 := FALSE;
        IF X1F AND (D2 > 450) AND ((D4 - pull_start_enc) < current_target_len) THEN
            Y16 := TRUE; (* pull *)
        ELSE
            Y16 := FALSE;
        END_IF;

        IF (D4 - pull_start_enc) >= current_target_len THEN
            Y16 := FALSE;
            Y17 := TRUE; (* hold *)
            piece_state := 4;
        END_IF;

    4: (* Holding web, wait for holder closed *)
        Y16 := FALSE;
        Y17 := TRUE;
        hold_timer(IN := TRUE, PT := T#160ms);
        IF X1B AND hold_timer.Q THEN
            hold_timer(IN := FALSE, PT := T#160ms);
            Y18 := TRUE; (* cut *)
            piece_state := 5;
        END_IF;

    5: (* Cutting web *)
        Y17 := TRUE;
        cut_timer(IN := TRUE, PT := T#650ms);
        IF (X19 OR cut_timer.Q) AND NOT X1A THEN
            cut_timer(IN := FALSE, PT := T#650ms);
            Y18 := FALSE;
            Y17 := FALSE;
            piece_state := 6;
        END_IF;

    6: (* Release holder and cut piece *)
        Y17 := FALSE;
        Y18 := FALSE;
        release_timer(IN := TRUE, PT := T#160ms);
        IF X1F AND release_timer.Q THEN
            release_timer(IN := FALSE, PT := T#160ms);
            Y19 := TRUE; (* release *)
            piece_state := 7;
        END_IF;

    7: (* Wait for slice to be received at exit belt *)
        IF X1D THEN
            Y19 := FALSE;
            Y1A := TRUE; (* ack_exit *)
            IF is_waste_piece THEN
                waste_done := TRUE;
            ELSE
                total_normal_slices := total_normal_slices + 1;
            END_IF;
            piece_state := 8;
        END_IF;

    8: (* Acknowledge exit and clear *)
        Y1A := TRUE;
        IF NOT X1D AND X1C THEN
            Y1A := FALSE;
            piece_state := 0;
        END_IF;

    99: (* All slices complete *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y16 := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y19 := FALSE;
        Y22 := FALSE;
        Y1A := FALSE;
END_CASE;

(* ------------------------------------------------------------- *)
(* 4. Task Completion Evaluation                                 *)
(* ------------------------------------------------------------- *)
IF (total_normal_slices >= 6 AND waste_done AND batch_state = 3 AND D1 <= 0)
   OR X1E THEN
    completion_latched := TRUE;
END_IF;

IF completion_latched THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

END_PROGRAM
