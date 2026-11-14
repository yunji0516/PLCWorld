```pascal
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
    // Internal variables
    pitch_counter : INT := 0;
    recovery_counter : INT := 0;
    stage_timer : TON;
    edge_detect : R_TRIG;
END_VAR

// Main logic
edge_detect(CLK := X10); // Detect rising edge of pitch_available

IF X0 THEN
    // Accept pitch
    IF edge_detect.Q AND NOT X11 THEN
        Y10 := TRUE;
        pitch_counter := pitch_counter + 1;
    ELSE
        Y10 := FALSE;
    END_IF;
    
    // Advance the web
    IF Y10 OR Y11 OR NOT X11 THEN
        Y11 := TRUE;
    ELSE
        Y11 := FALSE;
    END_IF;

    // Cut the connections
    IF X15 THEN
        Y12 := TRUE;
        D200 := D1; // Set cut_mask
    ELSE
        Y12 := FALSE;
    END_IF;
    
    IF Y12 AND NOT X13 THEN
        Y13 := TRUE;
    ELSE
        Y13 := FALSE;
    END_IF;

    // Pickup the product
    IF X23 AND NOT Y14 THEN
        Y14 := TRUE;
    ELSE
        Y14 := FALSE;
    END_IF;

    // Transfer product
    IF X16 AND X19 AND NOT X18 THEN
        Y16 := TRUE;
    ELSE
        Y16 := FALSE;
    END_IF;

    // Acknowledge exit
    IF X1A AND NOT Y1A THEN
        Y1A := TRUE;
    ELSE
        Y1A := FALSE;
    END_IF;

    // Process recovery
    IF X1B AND NOT X21 THEN
        Y17 := TRUE;
        recovery_counter := recovery_counter + 1;
        Y18 := TRUE;
    ELSE
        Y17 := FALSE;
        Y18 := FALSE;
    END_IF;

    // Acknowledge recovery
    IF X1D AND NOT Y19 THEN
        Y19 := TRUE;
    ELSE
        Y19 := FALSE;
    END_IF;

    // Load core
    IF X25 AND NOT Y20 THEN
        Y20 := TRUE;
    ELSE
        Y20 := FALSE;
    END_IF;

    // Thread left and right
    IF X26 AND NOT Y21 THEN
        Y21 := TRUE;
    ELSE
        Y21 := FALSE;
    END_IF;

    IF X26 AND NOT Y22 THEN
        Y22 := TRUE;
    ELSE
        Y22 := FALSE;
    END_IF;

    // Unload reel
    IF X14 AND X23 AND NOT Y1F THEN
        Y1F := TRUE;
    ELSE
        Y1F := FALSE;
    END_IF;

    // Complete condition
    IF (pitch_counter = 6) AND (recovery_counter = 4) AND X1E THEN
        Y1B := TRUE;
    ELSE
        Y1B := FALSE;
    END_IF;
END_IF;

END_PROGRAM
```