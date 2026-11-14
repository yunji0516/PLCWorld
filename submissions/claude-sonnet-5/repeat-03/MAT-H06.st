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

    (* ---- internal ---- *)
    scan_count : DINT := 0;

    (* batch handling *)
    batch_state : INT := 0;
    batch_count : INT := 0;

    (* order queues *)
    a_targets : ARRAY[1..3] OF INT := [600,1000,800];
    b_targets : ARRAY[1..3] OF INT := [900,700,1100];
    a_idx : INT := 1;
    b_idx : INT := 1;
    a_candidate : BOOL;
    b_candidate : BOOL;
    a_len : INT;
    b_len : INT;
    a_order_accepted : BOOL := FALSE;
    b_order_accepted : BOOL := FALSE;
    r_a_avail : R_TRIG;
    r_b_avail : R_TRIG;

    (* piece production *)
    piece_state : INT := 0;
    current_side : INT := 0;
    is_waste : BOOL := FALSE;
    target_len : INT := 0;
    start_pull_pos : INT := 0;
    pos_now : INT := 0;
    normal_count : INT := 0;
    waste_count : INT := 0;
    waste_accepted : BOOL := FALSE;
    ton_hold : TON;
    ton_cut : TON;

    (* splice / reel exchange *)
    splice_state : INT := 0;
    splice_waste_needed : BOOL := FALSE;
    splice_waste_done : BOOL := FALSE;
    joined_recorded : BOOL := FALSE;
    r_joined : R_TRIG;

    (* completion *)
    complete_declared : BOOL := FALSE;
    complete_ready : BOOL := FALSE;
END_VAR

scan_count := scan_count + 1;

(* ---------- connection record latch ---------- *)
r_joined(CLK := X26);
IF r_joined.Q THEN
    joined_recorded := TRUE;
END_IF;

(* ---------- order acceptance pulses ---------- *)
r_a_avail(CLK := X13);
r_b_avail(CLK := X14);

Y12 := FALSE;
Y13 := FALSE;
IF r_a_avail.Q AND NOT a_order_accepted THEN
    Y12 := TRUE;
    a_order_accepted := TRUE;
END_IF;
IF r_b_avail.Q AND NOT b_order_accepted THEN
    Y13 := TRUE;
    b_order_accepted := TRUE;
END_IF;

(* ---------- batch handling ---------- *)
CASE batch_state OF
0:
    Y11 := FALSE;
    IF X10 AND NOT X11 THEN
        Y10 := TRUE;
        batch_state := 1;
    ELSE
        Y10 := FALSE;
    END_IF;
1:
    Y10 := TRUE;
    IF X11 THEN
        batch_state := 2;
    END_IF;
2:
    Y10 := FALSE;
    IF X12 THEN
        Y11 := TRUE;
        batch_state := 3;
    END_IF;
3:
    Y11 := TRUE;
    IF NOT X12 THEN
        Y11 := FALSE;
        batch_count := batch_count + 1;
        batch_state := 0;
    END_IF;
ELSE
    batch_state := 0;
END_CASE;

(* ---------- order selection helpers ---------- *)
a_candidate := (a_idx <= 3) AND X13;
b_candidate := (b_idx <= 3) AND X14;
IF a_candidate THEN
    a_len := a_targets[a_idx];
ELSE
    a_len := 0;
END_IF;
IF b_candidate THEN
    b_len := b_targets[b_idx];
ELSE
    b_len := 0;
END_IF;

splice_waste_needed := X26 AND NOT X29 AND NOT splice_waste_done;

(* ---------- piece production state machine ---------- *)
CASE piece_state OF
0:
    Y14 := FALSE;
    Y22 := FALSE;
    IF splice_waste_needed AND X17 THEN
        current_side := 0;
        target_len := D11;
        is_waste := TRUE;
        D200 := 0;
        Y22 := TRUE;
        piece_state := 1;
    ELSIF X17 THEN
        IF a_candidate AND (a_len <= D10) THEN
            current_side := 1;
            target_len := a_len;
            is_waste := FALSE;
            D200 := 1;
            Y14 := TRUE;
            piece_state := 1;
        ELSIF b_candidate AND (b_len <= D10) THEN
            current_side := 2;
            target_len := b_len;
            is_waste := FALSE;
            D200 := 2;
            Y14 := TRUE;
            piece_state := 1;
        ELSIF a_candidate AND (a_len > D10) THEN
            current_side := 0;
            target_len := D11;
            is_waste := TRUE;
            D200 := 0;
            Y22 := TRUE;
            piece_state := 1;
        ELSIF b_candidate AND (b_len > D10) THEN
            current_side := 0;
            target_len := D11;
            is_waste := TRUE;
            D200 := 0;
            Y22 := TRUE;
            piece_state := 1;
        END_IF;
    END_IF;

1:
    Y14 := FALSE;
    Y22 := FALSE;
    start_pull_pos := D4;
    piece_state := 2;

2:
    pos_now := D4 - start_pull_pos;
    IF X18 AND (splice_state = 0 OR splice_state >= 7) THEN
        Y15 := TRUE;
    ELSE
        Y15 := FALSE;
    END_IF;
    IF X1F AND X18 THEN
        Y16 := TRUE;
    ELSE
        Y16 := FALSE;
    END_IF;
    IF pos_now >= (target_len - 2) THEN
        Y15 := FALSE;
        Y16 := FALSE;
        Y17 := TRUE;
        piece_state := 3;
    END_IF;

3:
    Y17 := TRUE;
    ton_hold(IN := TRUE, PT := T#150ms);
    IF ton_hold.Q AND X1B THEN
        piece_state := 4;
    END_IF;

4:
    ton_hold(IN := FALSE, PT := T#150ms);
    pos_now := D4 - start_pull_pos;
    IF (NOT Y15) AND (NOT Y16) AND X1B AND (pos_now >= target_len - 2) AND (pos_now <= target_len + 2) THEN
        Y18 := TRUE;
        ton_cut(IN := TRUE, PT := T#600ms);
        piece_state := 5;
    END_IF;

5:
    ton_cut(IN := TRUE, PT := T#600ms);
    IF ton_cut.Q THEN
        Y18 := FALSE;
    END_IF;
    IF X19 THEN
        piece_state := 6;
    END_IF;

6:
    ton_cut(IN := FALSE, PT := T#600ms);
    Y17 := FALSE;
    IF (NOT X1A) AND (NOT X1B) THEN
        Y19 := TRUE;
        piece_state := 7;
    END_IF;

7:
    Y19 := FALSE;
    IF X1D THEN
        piece_state := 8;
    END_IF;

8:
    Y1A := TRUE;
    IF NOT X1D THEN
        Y1A := FALSE;
        IF is_waste THEN
            waste_count := waste_count + 1;
            waste_accepted := TRUE;
            IF splice_waste_needed THEN
                splice_waste_done := TRUE;
            END_IF;
        ELSE
            normal_count := normal_count + 1;
            IF current_side = 1 THEN
                a_idx := a_idx + 1;
            ELSIF current_side = 2 THEN
                b_idx := b_idx + 1;
            END_IF;
        END_IF;
        is_waste := FALSE;
        piece_state := 0;
    END_IF;

ELSE
    piece_state := 0;
END_CASE;

(* ---------- splice / reel exchange state machine ---------- *)
CASE splice_state OF
0:
    IF X27 THEN
        splice_state := 1;
    END_IF;

1:
    IF X20 THEN
        Y1C := TRUE;
        splice_state := 2;
    END_IF;

2:
    Y1C := TRUE;
    IF X21 THEN
        Y1D := TRUE;
        splice_state := 3;
    END_IF;

3:
    Y1C := TRUE;
    Y1D := TRUE;
    IF X22 THEN
        Y20 := TRUE;
        splice_state := 4;
    END_IF;

4:
    Y20 := TRUE;
    IF X25 AND X22 THEN
        Y1E := TRUE;
        Y1F := TRUE;
        Y21 := TRUE;
        splice_state := 5;
    END_IF;

5:
    IF X26 THEN
        splice_state := 6;
    END_IF;

6:
    IF X29 THEN
        Y1E := FALSE;
        Y1F := FALSE;
        Y21 := FALSE;
        Y20 := FALSE;
        splice_state := 7;
    END_IF;

7:
    IF X28 AND (NOT Y1E) AND (NOT Y1F) THEN
        splice_state := 8;
    END_IF;

8:
    ; (* done - keep spare_advance/lock high, endpoint held *)

ELSE
    splice_state := 0;
END_CASE;

(* ---------- completion handling ---------- *)
complete_ready := (batch_count >= 5) AND (normal_count >= 6) AND joined_recorded AND waste_accepted;

IF complete_ready AND NOT complete_declared AND (scan_count <= 30000) THEN
    complete_declared := TRUE;
END_IF;

Y1B := complete_declared;

IF complete_declared THEN
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
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
END_IF;

END_PROGRAM