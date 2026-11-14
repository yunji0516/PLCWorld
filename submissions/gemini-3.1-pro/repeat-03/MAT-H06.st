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

    accept_batch_mem : BOOL;
    ack_batch_mem : BOOL;
    batch_done_prev : BOOL;
    batches_completed : INT;
    
    a_accepted : BOOL;
    b_accepted : BOOL;
    order_targets : ARRAY[1..15] OF INT;
    order_sides : ARRAY[1..15] OF INT;
    order_count : INT;
    order_index : INT := 1;
    
    piece_state : INT;
    current_target : INT;
    is_waste : BOOL;
    pieces_completed : INT;
    
    splice_state : INT;
END_VAR

(* Feed and Batch Management *)
IF X12 AND D1 = 0 AND NOT batch_done_prev THEN
    batches_completed := batches_completed + 1;
END_IF;
batch_done_prev := (X12 AND D1 = 0);

IF X10 AND NOT accept_batch_mem THEN
    Y10 := TRUE;
    accept_batch_mem := TRUE;
ELSIF X11 THEN
    Y10 := FALSE;
    accept_batch_mem := FALSE;
END_IF;

IF X12 AND D1 = 0 AND NOT ack_batch_mem THEN
    Y11 := TRUE;
    ack_batch_mem := TRUE;
ELSIF NOT X12 THEN
    Y11 := FALSE;
    ack_batch_mem := FALSE;
END_IF;

IF X11 AND (NOT X27 OR X28) THEN
    IF D2 < 1200 THEN
        Y15 := TRUE;
    ELSIF D2 >= 1400 THEN
        Y15 := FALSE;
    END_IF;
ELSE
    Y15 := FALSE;
END_IF;

(* Order Acceptance *)
IF X13 AND NOT a_accepted THEN
    IF order_count < 15 THEN
        order_count := order_count + 1;
        order_targets[order_count] := D5;
        order_sides[order_count] := 1;
    END_IF;
    Y12 := TRUE;
    a_accepted := TRUE;
ELSIF NOT X13 THEN
    Y12 := FALSE;
    a_accepted := FALSE;
END_IF;

IF X14 AND NOT b_accepted THEN
    IF order_count < 15 THEN
        order_count := order_count + 1;
        order_targets[order_count] := D6;
        order_sides[order_count] := 2;
    END_IF;
    Y13 := TRUE;
    b_accepted := TRUE;
ELSIF NOT X14 THEN
    Y13 := FALSE;
    b_accepted := FALSE;
END_IF;

(* Splicing Sequence *)
CASE splice_state OF
    0:
        IF X27 AND X20 THEN
            Y1C := TRUE;
            splice_state := 1;
        END_IF;
    1:
        IF X21 THEN
            Y1D := TRUE;
            splice_state := 2;
        END_IF;
    2:
        IF X22 THEN
            Y20 := TRUE;
            splice_state := 3;
        END_IF;
    3:
        IF X25 THEN
            Y1E := TRUE;
            Y1F := TRUE;
            splice_state := 4;
        END_IF;
    4:
        IF X23 AND X24 THEN
            Y21 := TRUE;
            splice_state := 5;
        END_IF;
    5:
        IF X26 THEN
            Y21 := FALSE;
            Y1E := FALSE;
            Y1F := FALSE;
            Y20 := FALSE;
            splice_state := 6;
        END_IF;
    6:
        (* Splice complete, Y1C and Y1D remain latched *)
END_CASE;

(* Piece Cutting Sequence *)
CASE piece_state OF
    0:
        IF order_index <= order_count AND X17 AND X1C THEN
            IF (X27 OR X26) AND NOT X29 THEN
                IF order_targets[order_index] > D10 THEN
                    IF X26 THEN
                        Y22 := TRUE; 
                        current_target := D11;
                        is_waste := TRUE;
                        piece_state := 1;
                    END_IF;
                ELSE
                    Y14 := TRUE;
                    D200 := order_sides[order_index];
                    current_target := order_targets[order_index];
                    is_waste := FALSE;
                    piece_state := 1;
                END_IF;
            ELSE
                Y14 := TRUE;
                D200 := order_sides[order_index];
                current_target := order_targets[order_index];
                is_waste := FALSE;
                piece_state := 1;
            END_IF;
        END_IF;
    1:
        IF X18 THEN
            Y14 := FALSE;
            Y22 := FALSE;
            piece_state := 2;
        END_IF;
    2:
        IF X1F AND D2 > 450 THEN
            IF D8 < current_target THEN
                Y16 := TRUE;
            ELSE
                Y16 := FALSE;
                Y17 := TRUE;
                piece_state := 3;
            END_IF;
        ELSE
            Y16 := FALSE;
        END_IF;
    3:
        IF X1B AND NOT Y16 THEN
            Y18 := TRUE;
            piece_state := 4;
        END_IF;
    4:
        IF X19 THEN
            Y18 := FALSE;
            piece_state := 41;
        END_IF;
    41:
        IF NOT X1A THEN
            Y17 := FALSE;
            piece_state := 5;
        END_IF;
    5:
        IF X1F THEN
            Y19 := TRUE;
            piece_state := 6;
        END_IF;
    6:
        IF X1D THEN
            Y19 := FALSE;
            Y1A := TRUE;
            piece_state := 7;
        END_IF;
    7:
        IF NOT X1D THEN
            Y1A := FALSE;
            IF NOT is_waste THEN
                order_index := order_index + 1;
                pieces_completed := pieces_completed + 1;
            END_IF;
            piece_state := 0;
        END_IF;
END_CASE;

(* Completion Block *)
IF pieces_completed >= 6 AND batches_completed >= 5 THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM