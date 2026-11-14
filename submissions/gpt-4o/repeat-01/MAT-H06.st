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
    
    spare_advance_trigger : BOOL := FALSE;
    batch_index : INT := 0;
    current_slice_length : INT;
    
    thread_flag : BOOL := FALSE;
    release_flag : BOOL := FALSE;
    waste_started : BOOL := FALSE;
    
    dancer_storage : REAL := 0.8;  // Initial dancer storage
    reel_A_stock : REAL := 2.8;    // Initial reel A stock in meters
    reel_B_stock : REAL := 5.8;    // Initial reel B stock in meters
    remaining_reel_stock : REAL := 8.6;
    feed_rate : REAL := 100.0;     // Default feed rate in mm/s
    pull_rate : REAL := 100.0;     // Default pull rate in mm/s
    pull_target : INT;
    
    piece_completed_count : INT := 0;
    total_waste_length_mm : INT := 0;

    edge_accept_a : R_TRIG;
    edge_accept_b : R_TRIG;
    edge_batch_done : R_TRIG;
    edge_start_piece : R_TRIG;
    edge_spare_docked : R_TRIG;
    edge_threaded : R_TRIG;
    edge_splice_needed : R_TRIG;
    edge_splice_passed : R_TRIG;
    edge_feed_path_clear : R_TRIG;
    edge_piece_cut : R_TRIG;
    edge_exit_received : R_TRIG;
    edge_ack_exit : R_TRIG;
    cutoff : TON;
END_VAR

(* Process rising edge detections *)
edge_accept_a(CLK := X13);
edge_accept_b(CLK := X14);
edge_batch_done(CLK := X12);
edge_start_piece(CLK := X17);
edge_spare_docked(CLK := X21);
edge_threaded(CLK := X25);
edge_splice_needed(CLK := X27);
edge_splice_passed(CLK := X29);
edge_feed_path_clear(CLK := X28);
edge_piece_cut(CLK := X19);
edge_exit_received(CLK := X1D);
edge_ack_exit(CLK := Y1A);

(* Handle batches and orders *)
IF X10 AND X11 THEN
    Y10 := TRUE; (* accept_batch *)
ELSE
    Y10 := FALSE;
END_IF;

IF edge_batch_done.Q THEN
    Y11 := TRUE; (* ack_batch *)
    batch_index := batch_index + 1;
ELSE
    Y11 := FALSE;
END_IF;

(* Handle slice production and waste *)
IF edge_start_piece.Q THEN
    current_slice_length := D5 + D6; (* Assume target lengths from A and B are combined for slice *)
    IF current_slice_length > D10 THEN
        waste_started := TRUE;
        Y22 := TRUE; (* Start waste piece *)
    ELSE
        Y14 := TRUE; (* Start normal slice *)
    END_IF;
END_IF;

IF waste_started THEN
    Y15 := TRUE;  (* Feed *)
    Y16 := TRUE;  (* Pull *)
    Y17 := TRUE;  (* Hold *)
END_IF;

IF edge_piece_cut.Q THEN
    Y18 := TRUE;  (* Cut *)
    total_waste_length_mm := total_waste_length_mm + current_slice_length;
END_IF;

(* Handle spare reel advance and lock *)
IF X20 AND NOT X22 THEN
    Y1C := TRUE; (* Advance spare reel *)
ELSE
    Y1C := FALSE;
END_IF;

IF edge_spare_docked.Q THEN
    Y1D := TRUE; (* Lock spare reel *)
END_IF;

(* Handle threading and splicing *)
IF NOT X26 AND X27 AND X25 THEN
    IF NOT thread_flag THEN
        Y20 := TRUE; (* Thread the webs together *)
    ELSE
        Y21 := TRUE; (* Splice press *)
    END_IF;
    thread_flag := TRUE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    thread_flag := FALSE;
END_IF;

(* Handle exit reception *)
IF edge_exit_received.Q THEN
    Y1A := TRUE; (* ack_exit *)
ELSE
    Y1A := FALSE;
END_IF;

(* Final completion condition *)
IF piece_completed_count >= 6 THEN
    Y1B := TRUE; (* complete *)
ELSE
    Y1B := FALSE;
END_IF;

(* Timer to finalize processes and maintain complete signal *)
cutoff(IN := Y18, PT := T#500ms);
IF cutoff.Q THEN
    IF waste_started THEN
        Y19 := TRUE; (* Release waste material *)
        IF edge_ack_exit.Q THEN
            waste_started := FALSE;
            piece_completed_count := piece_completed_count + 1;
        END_IF;
    END_IF;
ENDIF;

END_PROGRAM