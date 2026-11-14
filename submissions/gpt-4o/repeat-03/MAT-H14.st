PROGRAM Main
VAR
    X0 : BOOL; // Start
    X10 : BOOL; // Source ready
    X11 : BOOL; // Pre present
    X12 : BOOL; // Pre busy
    X13 : BOOL; // Post present
    X14 : BOOL; // Post busy
    X15 : BOOL; // Pre measuring
    X16 : BOOL; // Post measuring
    X17 : BOOL; // Lane 1 free
    X18 : BOOL; // Lane 1 done
    X19 : BOOL; // Lane 2 free
    X20 : BOOL; // Post supported
    X21 : BOOL; // Post lowered
    Y10 : BOOL; // Feed
    Y11 : BOOL; // Measure pre
    Y12 : BOOL; // To lane
    Y13 : BOOL; // Load post
    Y14 : BOOL; // Measure post
    Y15 : BOOL; // Dispatch
    Y16 : BOOL; // Complete
    Y17 : BOOL; // Pre lift
    Y18 : BOOL; // Post lift
    D0 : INT; // Pre ID
    D1 : INT; // Post ID
    D2 : INT; // Pre mass
    D3 : INT; // Post mass
    D4 : INT; // Pre seq
    D5 : INT; // Post seq
    D6 : INT; // Received
    D7 : INT; // Queue
    D200 : INT; // In lane
    D201 : INT; // Out lane
    D202 : INT; // Seq pre
    D203 : INT; // Seq post
    D204 : INT; // Route
    X1A : BOOL; // Lane 2 done
    X1B : BOOL; // Accept clear
    X1C : BOOL; // Hold clear
    X1D : BOOL; // All received
    X1E : BOOL; // Pre supported
    X1F : BOOL; // Pre lowered

    // Internal variables
    current_pre_id : INT := 0;
    current_post_id : INT := 0;
    current_pre_mass : INT := 0;
    current_post_mass : INT := 0;
    pre_measured : BOOL := FALSE;
    post_measured : BOOL := FALSE;
    seq_pre_rising_edge : R_TRIG;
    seq_post_rising_edge : R_TRIG;
    accepted_weight : BOOL := FALSE;
    hold_weight : BOOL := FALSE;
    tray_available : BOOL := FALSE;
    start_edge : R_TRIG;
    is_complete : BOOL := FALSE;
    complete_timer : TON;
END_VAR

// Logic implementation

// Start trigger
start_edge(CLK := X0);

// Pre-scale measurement trigger
seq_pre_rising_edge(CLK := X11 AND NOT X12 AND NOT X15 AND X10);
IF seq_pre_rising_edge.Q THEN
    Y11 := TRUE;
    D202 := D4 + 1; // Request new sequence
    Y17 := NOT X12; // Pre lift if not busy
END_IF

// Pre-scale weight acquisition
IF X11 AND X12 AND NOT X15 AND X1E THEN
    Y11 := FALSE;
    IF D4 = D202 THEN
        current_pre_id := D0;
        current_pre_mass := D2;
        pre_measured := TRUE;
        current_pre_id := D0;
    END_IF
END_IF

// Post-scale measurement trigger
seq_post_rising_edge(CLK := X13 AND NOT X14 AND NOT X16 AND X20);
IF seq_post_rising_edge.Q THEN
    Y14 := TRUE;
    D203 := D5 + 1; // Request new sequence
    Y18 := NOT X14; // Post lift if not busy
END_IF

// Post-scale weight acquisition
IF X13 AND X14 AND NOT X16 AND X20 THEN
    Y14 := FALSE;
    IF D5 = D203 THEN
        current_post_id := D1;
        current_post_mass := D3;
        post_measured := TRUE;
        current_post_id := D1;
    END_IF
END_IF

// Determine route from mass difference
IF pre_measured AND post_measured THEN
    IF current_pre_id = current_post_id THEN
        IF (current_post_mass - current_pre_mass) >= 95 AND (current_post_mass - current_pre_mass) <= 105 THEN
            accepted_weight := TRUE;
            hold_weight := FALSE;
            D204 := 1;
        ELSE
            accepted_weight := FALSE;
            hold_weight := TRUE;
            D204 := 2;
        END_IF
    END_IF
    pre_measured := FALSE; // Reset for next operation
    post_measured := FALSE; // Reset for next operation
END_IF

// Dispatch logic
IF accepted_weight AND X1B THEN
    Y15 := TRUE; // Dispatch to acceptance
    Y15 := FALSE;
ELSIF hold_weight AND X1C THEN
    Y15 := TRUE; // Dispatch to hold
    Y15 := FALSE;
END_IF

// Transfer logic
IF X10 AND NOT X11 THEN
    Y10 := TRUE;
    Y12 := TRUE;
    D200 := 1; // Default lane
ELSIF X17 THEN
    Y12 := TRUE;
    D200 := 1; // Lane 1
ELSEIF X19 THEN
    Y12 := TRUE;
    D200 := 2; // Lane 2
END_IF

// Complete condition and maintenance timer
IF NOT tray_available AND X1D THEN
    complete_timer(IN := TRUE, PT := T#500ms);
    IF complete_timer.Q THEN
        is_complete := TRUE;
        Y16 := TRUE;
    END_IF
ELSE
    complete_timer(IN := FALSE);
    Y16 := FALSE;
END_IF

END_PROGRAM