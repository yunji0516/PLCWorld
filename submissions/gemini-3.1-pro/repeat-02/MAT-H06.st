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

    A_q : ARRAY[0..9] OF INT;
    A_head : INT := 0;
    A_tail : INT := 0;
    
    B_q : ARRAY[0..9] OF INT;
    B_head : INT := 0;
    B_tail : INT := 0;
    
    batches_completed : INT := 0;
    slice_state : INT := 0;
    
    next_order_len : INT := 0;
    next_side : INT := 0;
    is_waste : BOOL := FALSE;
    waste_done : BOOL := FALSE;
    
    target_pull : INT := 0;
    start_pull : INT := 0;
    
    splice_completed : BOOL := FALSE;
    feed_allowed : BOOL := FALSE;
    
    batch_done_edge : R_TRIG;
END_VAR

(* Order Acceptance Logic *)
IF X13 AND NOT Y12 THEN
    A_q[A_tail] := D5;
    A_tail := A_tail + 1;
    Y12 := TRUE;
ELSIF NOT X13 THEN
    Y12 := FALSE;
END_IF

IF X14 AND NOT Y13 THEN
    B_q[B_tail] := D6;
    B_tail := B_tail + 1;
    Y13 := TRUE;
ELSIF NOT X14 THEN
    Y13 := FALSE;
END_IF

(* Batch Supply Logic *)
IF X10 AND NOT Y10 THEN
    Y10 := TRUE;
ELSIF NOT X10 THEN
    Y10 := FALSE;
END_IF

batch_done_edge(CLK := X12);
IF batch_done_edge.Q THEN
    batches_completed := batches_completed + 1;
END_IF

IF X12 THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF

(* Splicing / Web Connection Logic *)
IF X20 THEN
    Y1C := TRUE;
END_IF

IF X21 THEN
    Y1D := TRUE;
END_IF

IF X27 AND NOT X25 AND X22 THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF

IF X25 AND X22 AND NOT X26 AND NOT splice_completed THEN
    Y1E := TRUE;
    Y1F := TRUE;
END_IF

IF X23 AND X24 AND NOT X26 AND NOT splice_completed THEN
    Y21 := TRUE;
END_IF

IF X26 THEN
    splice_completed := TRUE;
    Y1E := FALSE;
    Y1F := FALSE;
    Y21 := FALSE;
END_IF

(* Dancer Storage Feed Logic *)
feed_allowed := X28 AND NOT Y1E AND NOT Y1F;
IF X11 AND (D2 < 1550) AND feed_allowed THEN
    Y15 := TRUE;
ELSE
    Y15 := FALSE;
END_IF

(* Cut-Piece Production State Machine *)
CASE slice_state OF
    0:
        IF X17 THEN
            IF A_head < A_tail THEN
                next_order_len := A_q[A_head];
                next_side := 1;
            ELSIF B_head < B_tail THEN
                next_order_len := B_q[B_head];
                next_side := 2;
            ELSE
                next_order_len := 0;
            END_IF
            
            IF next_order_len > 0 THEN
                IF (NOT X29) AND (next_order_len > D10) THEN
                    IF X26 THEN
                        is_waste := TRUE;
                        slice_state := 1;
                    END_IF
                ELSE
                    is_waste := FALSE;
                    slice_state := 1;
                END_IF
            END_IF
        END_IF
        
    1:
        IF is_waste THEN
            Y22 := TRUE;
            target_pull := D11;
        ELSE
            Y14 := TRUE;
            D200 := next_side;
            target_pull := next_order_len;
        END_IF
        start_pull := D4;
        
        IF X18 THEN
            Y14 := FALSE;
            Y22 := FALSE;
            slice_state := 2;
        END_IF
        
    2:
        IF (D4 - start_pull) >= (target_pull - 1) THEN
            Y16 := FALSE;
            Y17 := TRUE;
            slice_state := 3;
        ELSE
            IF X1F THEN
                Y16 := TRUE;
            ELSE
                Y16 := FALSE;
            END_IF
        END_IF
        
    3:
        Y17 := TRUE;
        IF X1B THEN
            Y18 := TRUE;
            slice_state := 4;
        END_IF
        
    4:
        IF X19 THEN
            Y17 := FALSE;
            Y18 := FALSE;
            slice_state := 5;
        END_IF
        
    5:
        IF (NOT X1A) AND X1F AND X19 THEN
            Y19 := TRUE;
            slice_state := 6;
        END_IF
        
    6:
        IF X1D THEN
            Y19 := FALSE;
            Y1A := TRUE;
            slice_state := 7;
        END_IF
        
    7:
        IF NOT X1D THEN
            Y1A := FALSE;
            IF NOT is_waste THEN
                IF next_side = 1 THEN A_head := A_head + 1; END_IF
                IF next_side = 2 THEN B_head := B_head + 1; END_IF
            ELSE
                waste_done := TRUE;
            END_IF
            slice_state := 0;
        END_IF
END_CASE

(* Completion Logic *)
IF (A_head >= A_tail) AND (B_head >= B_tail) AND (A_tail = 3) AND (B_tail = 3) AND (slice_state = 0) AND (batches_completed >= 5) AND waste_done THEN
    Y1B := TRUE;
END_IF

END_PROGRAM