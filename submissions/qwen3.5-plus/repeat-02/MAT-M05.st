PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
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
    D20 : INT;
    D22 : INT;
    
    start_edge : R_TRIG;
    layer_idx : INT;
    layer_type : INT;
    stack_plates : INT;
    state : INT;
    deck_target : INT;
    layer_recipe : ARRAY[0..3] OF INT;
    
    IDLE_STATE : INT := 0;
    GO_SOURCE_STATE : INT := 1;
    LOW_SOURCE_STATE : INT := 2;
    GRIP_STATE : INT := 3;
    HIGH_STATE : INT := 4;
    GO_STACK_STATE : INT := 5;
    LOW_STACK_STATE : INT := 6;
    RELEASE_STATE : INT := 7;
    HIGH_RETURN_STATE : INT := 8;
    DECK_ADJUST_STATE : INT := 9;
    RETURN_HOME_STATE : INT := 10;
    DONE_STATE : INT := 11;
END_VAR

start_edge(CLK := X10);

CASE state OF
    IDLE_STATE:
        // All outputs OFF before start
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        Y2 := FALSE;
        
        IF start_edge.Q THEN
            layer_recipe[0] := D11;
            layer_recipe[1] := D12;
            layer_recipe[2] := D13;
            layer_recipe[3] := D14;
            layer_idx := 0;
            stack_plates := 0;
            state := GO_SOURCE_STATE;
        END_IF;
        
    GO_SOURCE_STATE:
        layer_type := layer_recipe[layer_idx];
        
        // Keep head high during horizontal travel
        Y24 := FALSE;
        Y20 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
        IF layer_type = 0 THEN
            // Source A at x=-700
            IF X20 = FALSE AND D20 > -691 THEN
                Y21 := TRUE;
                Y22 := FALSE;
            ELSIF X20 = TRUE OR (D20 >= -709 AND D20 <= -691) THEN
                Y21 := FALSE;
                Y22 := FALSE;
                state := LOW_SOURCE_STATE;
            ELSE
                Y21 := FALSE;
                Y22 := FALSE;
            END_IF;
        ELSE
            // Source B at x=+700
            IF X21 = FALSE AND D20 < 691 THEN
                Y22 := TRUE;
                Y21 := FALSE;
            ELSIF X21 = TRUE OR (D20 >= 691 AND D20 <= 709) THEN
                Y22 := FALSE;
                Y21 := FALSE;
                state := LOW_SOURCE_STATE;
            ELSE
                Y22 := FALSE;
                Y21 := FALSE;
            END_IF;
        END_IF;
        
        // Ensure head is high for horizontal travel safety
        IF X23 = FALSE THEN
            Y23 := TRUE;
        ELSE
            Y23 := FALSE;
        END_IF;
        
    LOW_SOURCE_STATE:
        Y23 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
        Y24 := TRUE;
        IF X24 = TRUE THEN
            Y24 := FALSE;
            state := GRIP_STATE;
        END_IF;
        
    GRIP_STATE:
        Y23 := FALSE;
        Y24 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
        Y20 := TRUE;
        IF X25 = TRUE THEN
            state := HIGH_STATE;
        END_IF;
        
    HIGH_STATE:
        Y24 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
        Y20 := TRUE;
        Y23 := TRUE;
        IF X23 = TRUE THEN
            Y23 := FALSE;
            state := GO_STACK_STATE;
        END_IF;
        
    GO_STACK_STATE:
        Y24 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
        Y20 := TRUE;
        
        IF X22 = FALSE AND ABS(D20) > 9 THEN
            IF D20 > 9 THEN
                Y21 := TRUE;
                Y22 := FALSE;
            ELSIF D20 < -9 THEN
                Y22 := TRUE;
                Y21 := FALSE;
            ELSE
                Y21 := FALSE;
                Y22 := FALSE;
            END_IF;
        ELSE
            Y21 := FALSE;
            Y22 := FALSE;
            state := LOW_STACK_STATE;
        END_IF;
        
        IF X23 = FALSE THEN
            Y23 := TRUE;
        ELSE
            Y23 := FALSE;
        END_IF;
        
    LOW_STACK_STATE:
        Y23 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
        Y20 := TRUE;
        Y24 := TRUE;
        IF X24 = TRUE THEN
            Y24 := FALSE;
            state := RELEASE_STATE;
        END_IF;
        
    RELEASE_STATE:
        Y23 := FALSE;
        Y24 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
        Y20 := FALSE;
        IF X26 = TRUE THEN
            stack_plates := stack_plates + 1;
            state := HIGH_RETURN_STATE;
        END_IF;
        
    HIGH_RETURN_STATE:
        Y24 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
        Y20 := FALSE;
        Y23 := TRUE;
        IF X23 = TRUE THEN
            Y23 := FALSE;
            IF stack_plates < 4 THEN
                state := DECK_ADJUST_STATE;
            ELSE
                state := RETURN_HOME_STATE;
            END_IF;
        END_IF;
        
    DECK_ADJUST_STATE:
        Y23 := FALSE;
        Y24 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y27 := FALSE;
        
        // After placement, D22 = old_deck + stack_plates*25 = 725
        // Target: deck lowers so D22 = 700
        // Deck target = 700 - stack_plates*25 + stack_plates*25 = 700... 
        // Actually: deck lowers by 25mm each time
        // After layer 0: deck 700->675, D22=725->700
        // After layer 1: deck 675->650, D22=725->700
        // After layer 2: deck 650->625, D22=725->700
        
        IF D22 > 702 THEN
            Y26 := TRUE;
        ELSE
            Y26 := FALSE;
            layer_idx := layer_idx + 1;
            IF layer_idx < 4 THEN
                state := GO_SOURCE_STATE;
            ELSE
                state := RETURN_HOME_STATE;
            END_IF;
        END_IF;
        
    RETURN_HOME_STATE:
        Y24 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        Y20 := FALSE;
        
        // Move to A (x=-700)
        IF X20 = FALSE AND D20 > -691 THEN
            Y21 := TRUE;
            Y22 := FALSE;
        ELSE
            Y21 := FALSE;
            Y22 := FALSE;
        END_IF;
        
        // Ensure head is high
        IF X23 = FALSE THEN
            Y23 := TRUE;
        ELSE
            Y23 := FALSE;
        END_IF;
        
        // Completion: at A, high position, grip open
        IF X20 = TRUE AND X23 = TRUE AND X25 = FALSE THEN
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y20 := FALSE;
            Y2 := TRUE;
            state := DONE_STATE;
        END_IF;
        
    DONE_STATE:
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y26 := FALSE;
        Y27 := FALSE;
        
END_CASE;

// Safety: prevent opposing commands on same axis
IF Y21 AND Y22 THEN
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

IF Y23 AND Y24 THEN
    Y23 := FALSE;
    Y24 := FALSE;
END_IF;

IF Y26 AND Y27 THEN
    Y26 := FALSE;
    Y27 := FALSE;
END_IF;

END_PROGRAM