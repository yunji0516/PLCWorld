PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    start_edge : R_TRIG;
    requested_index : INT := -1;
    rotating_cw : BOOL := FALSE;
    rotating_ccw : BOOL := FALSE;
    pushing : BOOL := FALSE;
    operation_started : BOOL := FALSE;
    item_found : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

// Start processing on a rising edge of X10
IF start_edge.Q THEN
    requested_index := -1; (* Reset index search *)
    operation_started := TRUE;
    Y2 := FALSE; (* Ensure completion claim is reset *)
END_IF

// Main control logic
IF operation_started THEN
    // Check if the requested item index has been identified
    IF requested_index = -1 THEN
        // Identify the requested item's index
        IF X20 THEN
            IF D20 = D10 THEN
                requested_index := D21;
                item_found := TRUE;
            ELSIF D20 = 0 THEN
                // Do nothing, continue searching
            ELSE
                // Move to the next pocket
                Y20 := TRUE;
                Y21 := FALSE;
                rotating_cw := TRUE;
            END_IF
        ELSE
            // Wait for alignment
            Y20 := FALSE;
            Y21 := FALSE;
            rotating_cw := FALSE;
        END_IF
    ELSE
        // Move carousel to the ejector position (index 2)
        IF D21 <> (requested_index + 2) MOD 4 THEN
            IF NOT X20 THEN
                // Wait for alignment
                Y20 := FALSE;
                Y21 := FALSE;
                rotating_cw := FALSE;
            ELSE
                Y20 := TRUE;
                Y21 := FALSE;
                rotating_cw := TRUE;
            END_IF
        ELSE
            // Eject the item
            Y20 := FALSE;
            Y21 := FALSE;
            rotating_cw := FALSE;
            IF NOT pushing THEN
                IF X22 THEN
                    // Pusher is fully extended, retract it
                    Y22 := FALSE;
                    Y23 := TRUE;
                ELSIF X21 THEN
                    // Pusher is fully retracted
                    Y22 := TRUE;
                    Y23 := FALSE;
                    pushing := TRUE;
                END_IF
            ELSE
                // Pushing is complete, verify the push
                IF X22 THEN
                    // Item ejected successfully
                    pushing := FALSE;
                    Y22 := FALSE;
                    Y23 := TRUE;
                END_IF
            END_IF
            
            // Check if the process is complete
            IF NOT pushing AND X21 THEN
                operation_started := FALSE;
                Y23 := FALSE;
                IF item_found THEN
                    Y2 := TRUE; // Completion claim
                END_IF
            END_IF
        END_IF
    END_IF
END_IF

// Safety interlocks
IF pushing OR X23 THEN
    // Prevent rotation while pushing
    Y20 := FALSE;
    Y21 := FALSE;
END_IF

END_PROGRAM