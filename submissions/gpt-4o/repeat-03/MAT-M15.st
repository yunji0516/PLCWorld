PROGRAM Main
VAR
    X10 : BOOL; // Start request
    D10 : INT; // Requested net batch count, 2 or 3
    Y2 : BOOL; // Completion claim
    Y20 : BOOL; // feed command
    Y21 : BOOL; // dispatch command
    X20 : BOOL; // Photoeye A
    X21 : BOOL; // Photoeye B
    X22 : BOOL; // external_pending
    X23 : BOOL; // empty
    X24 : BOOL; // settled
    X25 : BOOL; // dispatched

    // Internal variables
    start_edge : R_TRIG;
    product_count : INT;
    forward_count : INT;
    reverse_count : INT;
    external_disturbance_handled : BOOL;
    feeding : BOOL;
    dispatching : BOOL;
    process_started : BOOL;
    
END_VAR

// Edge detection for start request
start_edge(CLK := X10);

// Main control logic
IF start_edge.Q AND NOT process_started THEN
    // Initialize process
    product_count := 0;
    forward_count := 0;
    reverse_count := 0;
    external_disturbance_handled := FALSE;
    Y2 := FALSE;
    process_started := TRUE;
END_IF

IF process_started THEN
    // Feeding logic
    IF NOT X22 AND NOT X25 AND (X23 OR X24) THEN 
        feeding := TRUE;
    ELSE
        feeding := FALSE;
    END_IF
    
    IF feeding THEN
        // Counting products based on photoeye transitions
        IF NOT X20 AND X21 THEN
            // Forward passage detected
            IF external_disturbance_handled OR NOT X22 THEN 
                forward_count := forward_count + 1;
            END_IF
        ELSIF X20 AND NOT X21 AND external_disturbance_handled THEN
            // Reverse passage detected
            reverse_count := reverse_count + 1;
        END_IF
    END_IF
    
    // Handle external disturbances
    IF X22 THEN
        external_disturbance_handled := TRUE;
    END_IF
    
    // Stop feed when reaching requested count
    IF forward_count - reverse_count >= D10 THEN
        feeding := FALSE;
    END_IF
    
    Y20 := feeding;
    
    // Dispatch logic
    IF NOT feeding AND X24 AND (forward_count - reverse_count = D10) AND NOT X22 AND NOT X25 THEN
        dispatching := TRUE;
    ELSE
        dispatching := FALSE;
    END_IF

    Y21 := dispatching;

    // Completion claim
    IF dispatching AND X25 THEN
        Y2 := TRUE;
        process_started := FALSE; // End the process after completion
    END_IF
END_IF

END_PROGRAM