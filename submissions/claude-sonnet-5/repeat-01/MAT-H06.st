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

    (* ---- internal state machines ---- *)
    batch_state   : INT := 0;
    batch_count   : INT := 0;

    splice_state  : INT := 0;
    splice_active : BOOL := FALSE;
    feed_allowed  : BOOL := TRUE;

    piece_state   : INT := 0;
    cand_side     : INT := 0;
    cand_target   : INT := 0;
    side_pick     : INT := 0;
    target_len    : INT := 0;
    is_waste      : BOOL := FALSE;
    start_pull_encoder : INT := 0;

    a_count       : INT := 0;
    b_count       : INT := 0;
    slice_count   : INT := 0;
    waste_count   : INT := 0;
    waste_done_flag : BOOL := FALSE;
    joined_ever   : BOOL := FALSE;

    complete_latched : BOOL := FALSE;

    hold_timer  : TON;
    cut_timer   : TON;
    r_joined    : R_TRIG;

END_VAR

(* ============================================================
   PROCESS 2: SPLICE / RELE EXCHANGE
   ============================================================ *)
splice_active := (splice_state >= 2) AND (splice_state <= 6);
feed_allowed  := (NOT splice_active) OR ((splice_state = 7) AND X28);

CASE splice_state OF
    0: (* wait spare available, advance spare carriage *)
        IF X20 THEN
            Y1C := TRUE;
            splice_state := 1;
        END_IF;

    1: (* advancing / docking / locking *)
        Y1C := TRUE;
        IF X21 THEN
            Y1D := TRUE;
        END_IF;
        IF X21 AND X22 THEN
            splice_state := 2;
        END_IF;

    2: (* wait for splice request *)
        IF X27 THEN
            Y20 := TRUE;
            splice_state := 3;
        END_IF;

    3: (* threading leading end *)
        Y20 := TRUE;
        IF X25 THEN
            splice_state := 4;
        END_IF;

    4: (* fix both ends *)
        Y1E := TRUE;
        Y1F := TRUE;
        IF X23 AND X24 THEN
            splice_state := 5;
        END_IF;

    5: (* press connection *)
        IF X25 AND X22 THEN
            Y21 := TRUE;
        END_IF;
        IF X26 THEN
            splice_state := 6;
        END_IF;

    6: (* release fixing ends after joined *)
        Y21 := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        IF (NOT X23) AND (NOT X24) THEN
            splice_state := 7;
        END_IF;

    7: (* wait for clear feed path, resume feeding *)
        Y20 := FALSE;
        IF X28 THEN
            splice_state := 8;
        END_IF;

    8: ; (* splice cycle complete - feeding fully resumed *)
    ELSE
        splice_state := 8;
END_CASE;

r_joined(CLK := X26);
IF r_joined.Q THEN
    waste_done_flag := FALSE;
    joined_ever := TRUE;
END_IF;

(* ============================================================
   PROCESS 1: BATCH / REEL FEED
   ============================================================ *)
Y12 := X13 AND NOT X15;
Y13 := X14 AND NOT X16;

CASE batch_state OF
    0:
        IF X0 AND X10 AND NOT X11 THEN
            Y10 := TRUE;
            batch_state := 1;
        END_IF;

    1:
        Y10 := TRUE;
        IF X11 THEN
            Y10 := FALSE;
            batch_state := 2;
        END_IF;

    2: (* feed while remaining, within storage limits, path allowed *)
        IF (D1 > 0) AND (D2 < 1550) AND feed_allowed THEN
            Y15 := TRUE;
        ELSE
            Y15 := FALSE;
        END_IF;
        IF D1 = 0 THEN
            Y15 := FALSE;
            batch_state := 3;
        END_IF;

    3:
        Y11 := TRUE;
        IF X12 THEN
            batch_state := 4;
        END_IF;

    4:
        Y11 := FALSE;
        IF NOT X12 THEN
            batch_count := batch_count + 1;
            IF batch_count < 5 THEN
                batch_state := 0;
            ELSE
                batch_state := 5;
            END_IF;
        END_IF;

    5: ; (* all 5 supply batches completed *)
    ELSE
        batch_state := 5;
END_CASE;

(* ============================================================
   PROCESS 3: DOWNSTREAM PIECE / WASTE PRODUCTION
   ============================================================ *)

(* candidate normal order selection *)
IF X15 AND (a_count < 3) THEN
    cand_side := 1;
    cand_target := D5;
ELSIF X16 AND (b_count < 3) THEN
    cand_side := 2;
    cand_target := D6;
ELSE
    cand_side := 0;
    cand_target := 0;
END_IF;

hold_timer(IN := (piece_state = 3), PT := T#150ms);
cut_timer(IN := (piece_state = 4), PT := T#600ms);

CASE piece_state OF
    0: (* idle - decide next piece *)
        IF X17 THEN
            IF X26 AND (NOT X29) AND (NOT waste_done_flag) THEN
                is_waste := TRUE;
                target_len := D11;
                D200 := 0;
                Y22 := TRUE;
                start_pull_encoder := D4;
                piece_state := 1;
            ELSIF (cand_side <> 0) AND (D10 > 0) AND (cand_target > D10) THEN
                is_waste := TRUE;
                target_len := D11;
                D200 := 0;
                Y22 := TRUE;
                start_pull_encoder := D4;
                piece_state := 1;
            ELSIF cand_side <> 0 THEN
                is_waste := FALSE;
                side_pick := cand_side;
                target_len := cand_target;
                D200 := cand_side;
                Y14 := TRUE;
                start_pull_encoder := D4;
                piece_state := 1;
            END_IF;
        END_IF;

    1: (* wait for start confirmation *)
        IF X18 THEN
            Y14 := FALSE;
            Y22 := FALSE;
            piece_state := 2;
        END_IF;

    2: (* growing piece - pull only while holder fully open *)
        IF X1F THEN
            Y16 := TRUE;
        ELSE
            Y16 := FALSE;
        END_IF;
        IF ABS(D8 - target_len) <= 2 THEN
            Y16 := FALSE;
            piece_state := 3;
        END_IF;

    3: (* close holder, wait 150ms response *)
        Y17 := TRUE;
        IF hold_timer.Q AND X1B AND (ABS(D8 - target_len) <= 2) THEN
            piece_state := 4;
        END_IF;

    4: (* cut - stopped, holder closed, in tolerance *)
        IF (NOT X1A) AND X1B AND (ABS(D8 - target_len) <= 2) THEN
            Y18 := TRUE;
        END_IF;
        IF X19 AND cut_timer.Q THEN
            Y18 := FALSE;
            piece_state := 5;
        END_IF;

    5: (* open holder, wait for separation, blade return, holder open *)
        Y17 := FALSE;
        IF X19 AND (NOT X1A) AND X1F AND X1C THEN
            Y19 := TRUE;
            piece_state := 6;
        END_IF;

    6: (* release pulse issued, drop it *)
        Y19 := FALSE;
        piece_state := 7;

    7: (* wait for exit received *)
        IF X1D THEN
            Y1A := TRUE;
            piece_state := 8;
        END_IF;

    8: (* wait exit ack cleared, finalize counts *)
        IF NOT X1D THEN
            Y1A := FALSE;
            IF is_waste THEN
                waste_done_flag := TRUE;
                waste_count := waste_count + 1;
            ELSE
                IF side_pick = 1 THEN
                    a_count := a_count + 1;
                ELSE
                    b_count := b_count + 1;
                END_IF;
                slice_count := slice_count + 1;
            END_IF;
            is_waste := FALSE;
            piece_state := 0;
        END_IF;

    ELSE
        piece_state := 0;
END_CASE;

(* ============================================================
   COMPLETION MONITOR
   ============================================================ *)
IF (NOT complete_latched)
   AND (batch_count >= 5)
   AND (a_count >= 3)
   AND (b_count >= 3)
   AND (joined_ever)
   AND (waste_count >= 1) THEN
    complete_latched := TRUE;
END_IF;

Y1B := complete_latched;

END_PROGRAM