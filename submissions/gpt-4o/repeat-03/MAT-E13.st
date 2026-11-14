PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    // Internal variables
    product_key : INT;
    start_edge : R_TRIG;
    action_in_progress : BOOL := FALSE;
    move_timer : TON;
    result_held : BOOL := FALSE;
    hold_counter : DINT := 0;
END_VAR

// Detect rising edge of Start request
start_edge(CLK := X10);

IF start_edge.Q THEN
    // Capture the product key on start
    product_key := D20;
    action_in_progress := TRUE;
    Y2 := FALSE; // Reset completion claim
END_IF

// Main control logic
IF action_in_progress THEN
    IF X20 THEN
        // Module is at home, evaluate key
        IF product_key = D10 THEN
            // Route to accepted pocket
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            // Route to bypass pocket
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF

        // Activate timer to track advancement
        move_timer(IN := TRUE, PT := T#500ms);

        // Check if movement period is complete
        IF move_timer.Q THEN
            Y20 := FALSE;
            Y21 := FALSE;
            // Wait to check if reached end position
            IF X21 THEN
                result_held := TRUE;
                Y2 := TRUE; // Claim completion
                action_in_progress := FALSE;
            ELSE
                // Reset if not placed
                product_key := 0; // Zero key after failure to place
                action_in_progress := FALSE;
            END_IF
        END_IF

    END_IF
END_IF

// Hold the result for at least 50 scans
IF result_held THEN
    hold_counter := hold_counter + 1;
    IF hold_counter >= 50 THEN
        result_held := FALSE;
    END_IF
END_IF

END_PROGRAM