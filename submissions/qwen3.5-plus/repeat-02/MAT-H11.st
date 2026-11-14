PROGRAM Main
VAR
    state : INT := 0;
    product_count : INT := 0;
    next_width : INT := 160;
    next_tool : INT := 1;
    t_complete : TON;
END_VAR

Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;

CASE state OF
    0: // IDLE
        IF X0 THEN
            next_width := 160; next_tool := 1;
            D201 := next_width; Y23 := TRUE;
            D202 := next_width; Y24 := TRUE;
            state := 1;
        END_IF;
        
    1: // WAIT_A_B_ADJ
        IF X2C AND X2D THEN
            Y23 := FALSE; Y24 := FALSE;
            IF D8 <> next_tool THEN
                state := 24;
            ELSE
                state := 2;
            END_IF;
        END_IF;
        
    2: // WAIT_SOURCE
        IF X10 AND X28 AND X13 THEN
            Y10 := TRUE;
            state := 3;
        END_IF;
        
    3: // ADOPT
        IF X14 OR NOT X11 THEN
            Y10 := FALSE;
            state := 4;
        END_IF;
        
    4: // WORK_A_WAIT
        IF X14 THEN
            Y11 := TRUE;
            state := 5;
        END_IF;
        
    5: // WORK_A
        IF X15 THEN
            Y11 := FALSE;
            state := 6;
        END_IF;
        
    6: // TO_CRADLE_WAIT
        IF X13 THEN
            Y12 := TRUE;
            state := 7;
        END_IF;
        
    7: // CRADLE_TRANSFER
        IF X17 AND X13 THEN
            Y12 := FALSE;
            state := 8;
        END_IF;
        
    8: // LOCK_CRADLE
        Y13 := TRUE;
        IF X18 THEN
            state := 9;
        END_IF;
        
    9: // RELEASE_HEAD
        Y14 := TRUE;
        IF X13 AND NOT X12 THEN
            Y14 := FALSE;
            state := 10;
        END_IF;
        
    10: // ROTATE
        Y15 := TRUE;
        IF X1A THEN
            Y15 := FALSE;
            state := 11;
        END_IF;
        
    11: // GRIP_HEAD
        Y16 := TRUE;
        IF X12 THEN
            state := 12;
        END_IF;
        
    12: // UNLOCK_CRADLE
        Y17 := TRUE;
        IF X19 THEN
            Y17 := FALSE;
            state := 13;
        END_IF;
        
    13: // HEAD_RETREAT
        IF X13 THEN
            state := 14;
        END_IF;
        
    14: // PREP_B_WIDTH
        next_width := IF product_count MOD 2 = 0 THEN 160 ELSE 120 END_IF;
        D202 := next_width; Y24 := TRUE;
        state := 15;
        
    15: // WAIT_B_ADJ
        IF X2D THEN
            Y24 := FALSE;
            state := 16;
        END_IF;
        
    16: // TO_B
        Y18 := TRUE;
        IF X1C THEN
            Y18 := FALSE;
            state := 17;
        END_IF;
        
    17: // B_CLAMP_KEEPER
        Y1D := TRUE;
        Y1E := TRUE;
        IF X23 AND X25 THEN
            state := 18;
        END_IF;
        
    18: // WORK_B_CHECK
        IF X15 AND X22 AND X26 AND X23 AND X25 THEN
            Y19 := TRUE;
            state := 19;
        END_IF;
        
    19: // WORK_B
        IF X1D THEN
            Y19 := FALSE;
            state := 20;
        END_IF;
        
    20: // RELEASE
        Y1A := TRUE;
        IF X20 THEN
            Y1A := FALSE;
            state := 21;
        END_IF;
        
    21: // ACK_EXIT
        Y1B := TRUE;
        state := 22;
        
    22: // ACK_DONE
        Y1B := FALSE;
        product_count := product_count + 1;
        IF product_count >= 4 THEN
            state := 30;
        ELSE
            next_tool := IF product_count MOD 2 = 0 THEN 1 ELSE 2 END_IF;
            IF D8 <> next_tool THEN
                state := 24;
            ELSE
                state := 2;
            END_IF;
        END_IF;
        
    24: // TOOL_EXCHANGE
        D200 := next_tool;
        Y1F := TRUE;
        state := 25;
        
    25: // TOOL_DOCK_WAIT
        IF X2A THEN
            Y1F := FALSE;
            Y20 := TRUE;
            state := 26;
        END_IF;
        
    26: // TOOL_UNLOCK_WAIT
        IF NOT X2B THEN
            Y20 := FALSE;
            Y22 := TRUE;
            state := 27;
        END_IF;
        
    27: // TOOL_RETURN_WAIT
        IF X13 THEN
            Y22 := FALSE;
            Y21 := TRUE;
            state := 28;
        END_IF;
        
    28: // TOOL_LOCK_WAIT
        IF X2B THEN
            Y21 := FALSE;
            state := 2;
        END_IF;
        
    30: // CHECK_COMPLETION
        IF X13 AND NOT X11 AND X15 AND X1D AND X20 THEN
            IF (D8 = 0 OR D8 = next_tool) AND (NOT X17 OR NOT X1B) THEN
                Y1C := TRUE;
                state := 31;
            END_IF;
        END_IF;
        
    31: // MAINTAIN_COMPLETE
        t_complete(IN := TRUE, PT := T#500ms);
        Y1C := TRUE;
END_CASE;
END_PROGRAM