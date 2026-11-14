PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    start_triggered : BOOL := FALSE;
    within_span_limit : BOOL := TRUE;
    span_limit : INT := 150; // Default to stricter limit
    push_complete : BOOL := FALSE;
END_VAR

// Rising edge detection
IF X10 AND NOT start_triggered THEN
    start_triggered := TRUE;
    span_limit := D10; // Take request value for unsupported span limit
END_IF

IF start_triggered AND NOT Y2 THEN
    // Ensure bridge is raised before commencing with push
    IF NOT X20 THEN
        Y20 := TRUE; // Raise bridge
        Y21 := FALSE;
    ELSE
        Y20 := FALSE; // Stop raise
    END_IF

    // Once the bridge is raised, start pushing if home position confirmed
    IF X20 THEN
        IF X22 THEN
            Y22 := TRUE; // Start pushing
            Y23 := FALSE;
        END_IF

        // Check the span constraints during the push operation
        IF D20 >= -650 AND D20 <= 650 THEN
            within_span_limit := (D20 + 700 <= span_limit);
        ELSE
            within_span_limit := TRUE; // Safety check for bounds outside direct concerns
        END_IF

        // Command retract if end reached or support limit exceeded
        IF X23 OR NOT within_span_limit THEN
            Y22 := FALSE;
            Y23 := TRUE; // Retract
        END_IF
    END_IF
END_IF

// If whole received, lower the bridge and retract pusher
IF X25 THEN
    Y21 := TRUE; // Start lowering bridge
    Y23 := TRUE; // Ensure pusher retract continues if needed
    push_complete := TRUE; // Mark pushing process complete
END_IF

// Confirm pusher home and bridge lowered for final condition
IF push_complete AND X21 AND X22 THEN
    Y2 := TRUE; // Set completion claim true
    Y22 := FALSE; // Stop pusher
    Y23 := FALSE; // Ensure retraction stop
    Y20 := FALSE; // Ensure bridge no longer commanded up
    Y21 := FALSE; // Ensure lowering stop
END_IF

END_PROGRAM