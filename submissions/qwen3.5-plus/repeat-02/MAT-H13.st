PROGRAM Main
VAR
    X0 : BOOL; X10 : BOOL; X11 : BOOL; X12 : BOOL; X13 : BOOL; X14 : BOOL; X15 : BOOL; X16 : BOOL; X17 : BOOL; X18 : BOOL; X19 : BOOL; X20 : BOOL; X21 : BOOL; X22 : BOOL; X23 : BOOL; X24 : BOOL; X25 : BOOL; X26 : BOOL; X27 : BOOL; X28 : BOOL; X29 : BOOL; X30 : BOOL; X31 : BOOL; X32 : BOOL; X33 : BOOL;
    Y10 : BOOL; Y11 : BOOL; Y12 : BOOL; Y13 : BOOL; Y14 : BOOL; Y15 : BOOL; Y16 : BOOL; Y17 : BOOL; Y18 : BOOL; Y19 : BOOL; Y20 : BOOL; Y21 : BOOL; Y22 : BOOL; Y23 : BOOL; Y24 : BOOL;
    D0 : INT; D1 : INT; D2 : INT; D3 : INT; D4 : INT; D5 : INT; D6 : INT; D7 : INT; D8 : INT; D9 : INT; D10 : INT; D11 : INT; D200 : INT;
    X1A : BOOL; X1B : BOOL; X1C : BOOL; X1D : BOOL; X1E : BOOL; X1F : BOOL; X2A : BOOL; X2B : BOOL; X2C : BOOL; X2D : BOOL; X2E : BOOL; X2F : BOOL;
    Y1A : BOOL; Y1B : BOOL; Y1C : BOOL; Y1D : BOOL; Y1E : BOOL; Y1F : BOOL;
    
    state : INT := 0;
    bundle_num : INT := 0;
    swap_needed : BOOL := FALSE;
    cut_timer : TON;
    stability_timer : TON;
    index_timer : TON;
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X0);

(* Default all outputs to FALSE for safety *)
Y10 := FALSE; Y11 := FALSE; Y12 := FALSE; Y13 := FALSE; Y14 := FALSE;
Y15 := FALSE; Y16 := FALSE; Y17 := FALSE; Y18 := FALSE; Y19 := FALSE;
Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
Y1A := FALSE; Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE; Y1F := FALSE;

CASE state OF
    0: (* WAIT_START *)
        IF start_edge.Q THEN
            bundle_num := 1;
            state := 1;
        END_IF;
        
    1: (* FEED_SETUP *)
        Y1D := TRUE;
        state := 2;
        
    2: (* WAIT_FEED_READY *)
        Y1D := TRUE;
        IF X25 AND X28 AND (D9 < D10) THEN
            state := 3;
        END_IF;
        
    3: (* FEED_ITEM *)
        Y1D := TRUE;
        IF NOT Y10 AND NOT (Y13 OR Y14 OR Y15 OR Y22) AND X28 AND (D9 < D10) THEN
            Y1C := TRUE;
            IF NOT index_timer.Q THEN
                index_timer(IN := TRUE, PT := T#100ms);
                Y1E := TRUE;
            ELSE
                index_timer(IN := FALSE);
                Y1E := FALSE;
            END_IF;
        END_IF;
        IF D9 >= D10 THEN
            Y1C := FALSE;
            Y1D := FALSE;
            state := 4;
        END_IF;
        
    4: (* ALIGN *)
        Y1F := TRUE;
        state := 5;
        
    5: (* WAIT_ALIGNED *)
        Y1F := TRUE;
        IF X29 THEN
            state := 6;
        END_IF;
        
    6: (* FORM_GRIP *)
        Y1F := TRUE; Y20 := TRUE;
        state := 7;
        
    7: (* WAIT_FORM_GRIPPED *)
        Y1F := TRUE; Y20 := TRUE;
        IF X2A THEN
            state := 8;
        END_IF;
        
    8: (* FORM_LIFT *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        state := 9;
        
    9: (* WAIT_HIGH *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        IF X2C THEN
            state := 10;
        END_IF;
        
    10: (* MOVE_TO_SUPPLY *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        IF X2C THEN Y22 := TRUE; END_IF;
        state := 11;
        
    11: (* WAIT_AT_SUPPLY *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        IF X30 THEN
            Y22 := FALSE;
            state := 12;
        END_IF;
        
    12: (* DESCEND_TRANSFER *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        IF X10 AND X33 THEN
            Y24 := TRUE;
            state := 13;
        END_IF;
        
    13: (* WAIT_AT_SOURCE *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        IF X12 THEN
            Y24 := FALSE;
            state := 14;
        END_IF;
        
    14: (* GRIP_BUNDLE *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y10 := TRUE;
        state := 15;
        
    15: (* WAIT_GRIPPED *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y10 := TRUE;
        IF X16 THEN
            state := 16;
        END_IF;
        
    16: (* RAISE_TRANSFER *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y10 := TRUE;
        state := 17;
        
    17: (* MOVE_TO_WRAP *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y10 := TRUE;
        IF X2C THEN
            Y14 := TRUE;
            state := 18;
        END_IF;
        
    18: (* WAIT_AT_WRAP *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y10 := TRUE;
        IF X13 THEN
            Y14 := FALSE;
            state := 19;
        END_IF;
        
    19: (* CLAMP_BUNDLE *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y10 := TRUE; Y11 := TRUE;
        state := 20;
        
    20: (* WAIT_CLAMPED *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y10 := TRUE; Y11 := TRUE;
        IF X19 AND X11 THEN
            Y10 := FALSE;
            state := 21;
        END_IF;
        
    21: (* WAIT_OPEN *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        IF X17 THEN
            state := 22;
        END_IF;
        
    22: (* RETURN_TO_SOURCE *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE; Y13 := TRUE;
        state := 23;
        
    23: (* WAIT_AT_SOURCE_RET *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        IF X12 THEN
            Y13 := FALSE;
            state := 24;
        END_IF;
        
    24: (* CHECK_FILM *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        IF D4 < D3 THEN
            swap_needed := TRUE;
            state := 25;
        ELSE
            swap_needed := FALSE;
            state := 26;
        END_IF;
        
    25: (* SWAP_REEL *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        IF NOT Y16 AND X19 AND X1B AND X18 THEN
            Y17 := TRUE;
            state := 26;
        END_IF;
        
    26: (* WAIT_SWAP_OR_START *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        IF swap_needed THEN
            IF NOT X1D THEN
                Y17 := FALSE;
            END_IF;
            state := 27;
        ELSE
            state := 27;
        END_IF;
        
    27: (* START_WRAP *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        IF (D4 > 0) AND (NOT X1D) THEN
            Y16 := TRUE;
            Y12 := TRUE;
            state := 28;
        END_IF;
        
    28: (* WRAP_MONITOR *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        Y16 := TRUE;
        Y12 := TRUE;
        IF D2 >= D3 THEN
            Y16 := FALSE;
            state := 29;
        END_IF;
        
    29: (* CUT *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        Y12 := TRUE;
        Y1A := TRUE;
        cut_timer(IN := TRUE, PT := T#800MS);
        state := 30;
        
    30: (* WAIT_CUT *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        Y12 := TRUE;
        Y1A := TRUE;
        IF cut_timer.Q THEN
            Y1A := FALSE;
            Y12 := FALSE;
            state := 31;
        END_IF;
        
    31: (* WAIT_SEPARATED *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        IF X22 THEN
            state := 32;
        END_IF;
        
    32: (* TAPE_PREP *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        Y18 := TRUE;
        D200 := D6;
        state := 33;
        
    33: (* WAIT_TAPE_READY *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        Y18 := TRUE;
        D200 := D6;
        IF X20 THEN
            Y18 := FALSE;
            state := 34;
        END_IF;
        
    34: (* TAPE_APPLY *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        D200 := D6;
        IF D5 = D0 THEN
            Y19 := TRUE;
            state := 35;
        END_IF;
        
    35: (* WAIT_TAPED *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE; Y11 := TRUE;
        D200 := D6;
        Y19 := TRUE;
        IF X21 THEN
            Y19 := FALSE;
            state := 36;
        END_IF;
        
    36: (* RELEASE_CLAMP *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        Y11 := FALSE;
        state := 37;
        
    37: (* WAIT_EXIT_COND *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        IF X22 AND X23 AND X17 AND (NOT Y11) AND X2C THEN
            Y15 := TRUE;
            state := 38;
        END_IF;
        
    38: (* MOVE_TO_EXIT *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        Y15 := TRUE;
        IF X14 THEN
            Y15 := FALSE;
            Y10 := FALSE;
            state := 39;
        END_IF;
        
    39: (* DISCHARGE *)
        Y1F := TRUE; Y20 := TRUE; Y21 := TRUE;
        state := 40;
        
    40: (* NEXT_BUNDLE *)
        bundle_num := bundle_num + 1;
        IF bundle_num <= 3 THEN
            state := 1;
        ELSE
            state := 100;
        END_IF;
        
    100: (* COMPLETE *)
        Y1B := TRUE;
        stability_timer(IN := TRUE, PT := T#500MS);
END_CASE;

(* Concurrent source_advance with safety interlocks *)
Y23 := X32 AND X2C AND (NOT Y24) AND (state >= 1) AND (NOT Y10) AND (NOT Y15) AND (NOT Y14) AND (NOT Y22);

END_PROGRAM