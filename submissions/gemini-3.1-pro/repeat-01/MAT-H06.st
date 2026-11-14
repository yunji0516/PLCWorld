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
    
    running : BOOL := FALSE;
    
    piece_state : INT := 0;
    batch_state : INT := 0;
    splice_state : INT := 0;
    
    pieces_done_count : INT := 0;
    waste_done_count : INT := 0;
    batches_done_count : INT := 0;
    
    next_target : INT := 0;
    next_side : INT := 0;
    target_len : INT := 0;
    current_target : INT := 0;
    is_waste : BOOL := FALSE;
    
    pull_ok : BOOL := FALSE;
    feed_ok : BOOL := FALSE;
END_VAR

IF X0 THEN
    running := TRUE;
END_IF

IF running THEN
    
    // Batch and Feed Control
    CASE batch_state OF
    0:
        IF X10 THEN
            Y10 := TRUE; 
            batch_state := 1;
        END_IF
    1:
        IF X11 THEN
            Y10 := FALSE;
            batch_state := 2;
        END_IF
    2:
        IF D2 > 1500 THEN
            feed_ok := FALSE;
        ELSIF D2 < 1200 THEN
            feed_ok := TRUE;
        END_IF
        
        Y15 := feed_ok AND X28;
        
        IF X12 THEN
            Y15 := FALSE;
            Y11 := TRUE; 
            batches_done_count := batches_done_count + 1;
            batch_state := 3;
        END_IF
    3:
        IF NOT X12 THEN
            Y11 := FALSE;
            batch_state := 0;
        END_IF
    END_CASE
    
    // Splicing (Reel Exchange) Control
    CASE splice_state OF
    0:
        IF X20 THEN
            Y1C := TRUE; 
            splice_state := 1;
        END_IF
    1:
        IF X21 THEN
            Y1D := TRUE; 
            splice_state := 2;
        END_IF
    2:
        IF X22 THEN
            Y20 := TRUE; 
            splice_state := 3;
        END_IF
    3:
        IF X25 THEN
            Y20 := FALSE;
        END_IF
        IF X25 AND X27 THEN
            Y1E := TRUE; 
            Y1F := TRUE; 
            splice_state := 4;
        END_IF
    4:
        IF X23 AND X24 THEN
            Y21 := TRUE; 
            splice_state := 5;
        END_IF
    5:
        IF X26 THEN
            Y21 := FALSE;
            Y1E := FALSE;
            Y1F := FALSE;
            splice_state := 6;
        END_IF
    6:
        // Splice Sequence Completed
    END_CASE
    
    // Downstream Piece Control
    CASE piece_state OF
    0:
        IF X17 THEN
            IF X13 AND D5 > 0 THEN
                next_target := D5;
                next_side := 1;
            ELSIF X14 AND D6 > 0 THEN
                next_target := D6;
                next_side := 2;
            ELSE
                next_target := 0;
                next_side := 0;
            END_IF
            
            IF next_target > 0 THEN
                IF NOT X29 THEN
                    IF next_target > D10 THEN
                        IF X26 THEN
                            is_waste := TRUE;
                            Y22 := TRUE;
                            piece_state := 1;
                        END_IF
                    ELSE
                        is_waste := FALSE;
                        target_len := next_target;
                        D200 := next_side;
                        Y14 := TRUE;
                        IF next_side = 1 THEN Y12 := TRUE; ELSE Y13 := TRUE; END_IF
                        piece_state := 1;
                    END_IF
                ELSE
                    is_waste := FALSE;
                    target_len := next_target;
                    D200 := next_side;
                    Y14 := TRUE;
                    IF next_side = 1 THEN Y12 := TRUE; ELSE Y13 := TRUE; END_IF
                    piece_state := 1;
                END_IF
            END_IF
        END_IF
        
    1:
        IF X18 THEN
            Y14 := FALSE;
            Y22 := FALSE;
            Y12 := FALSE;
            Y13 := FALSE;
            pull_ok := TRUE;
            piece_state := 2;
        END_IF
        
    2:
        IF is_waste THEN
            current_target := D11;
        ELSE
            current_target := target_len;
        END_IF
        
        IF D8 >= current_target - 1 THEN
            Y16 := FALSE;
            Y17 := TRUE;
            piece_state := 3;
        ELSE
            IF D2 < 450 THEN
                pull_ok := FALSE;
            ELSIF D2 > 500 THEN
                pull_ok := TRUE;
            END_IF
            Y16 := pull_ok;
        END_IF
        
    3:
        IF X1B THEN
            Y18 := TRUE;
            piece_state := 4;
        END_IF
        
    4:
        IF X19 THEN
            Y18 := FALSE;
            Y17 := FALSE;
            piece_state := 5;
        END_IF
        
    5:
        IF X1F AND NOT X1A THEN
            Y19 := TRUE;
            piece_state := 6;
        END_IF
        
    6:
        IF X1D THEN
            Y19 := FALSE;
            Y1A := TRUE;
            IF is_waste THEN
                waste_done_count := waste_done_count + 1;
            ELSE
                pieces_done_count := pieces_done_count + 1;
            END_IF
            piece_state := 7;
        END_IF
        
    7:
        IF NOT X1D THEN
            Y1A := FALSE;
            piece_state := 0;
        END_IF
        
    END_CASE
    
    // Completion Logic
    IF pieces_done_count >= 6 AND waste_done_count >= 1 AND batches_done_count >= 5 AND piece_state = 0 AND batch_state = 0 THEN
        Y1B := TRUE;
    END_IF
    
END_IF

END_PROGRAM