PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    D20 : INT;
    // Internal Variables
    startEdge : R_TRIG;
    spacingOK : BOOL;
    targetPitch : INT;
    moving : BOOL;
    gripping : BOOL;
    spacingInProgress : BOOL;
    horizontalInProgress : BOOL;
    verticalInProgress : BOOL;
    completing : BOOL;
END_VAR

// Initialize state machine
startEdge(CLK := X10);

// Start request processing
IF startEdge.Q THEN
    targetPitch := D10;
    spacingOK := targetPitch >= 160 AND targetPitch <= 620;
    Y2 := FALSE; // Reset completion claim
END_IF

// Control logic
IF spacingOK THEN
    // Check if we need to adjust the spacing
    IF D20 < targetPitch THEN
        Y25 := TRUE; // widen
        spacingInProgress := TRUE;
        IF X22 THEN // Ensure vertical clearance before spacing motion
            Y22 := TRUE; // Up
            verticalInProgress := TRUE;
        END_IF
    ELSIF D20 > targetPitch THEN
        Y26 := TRUE; // narrow
        spacingInProgress := TRUE;
        IF X22 THEN // Ensure vertical clearance before spacing motion
            Y22 := TRUE; // Up
            verticalInProgress := TRUE;
        END_IF
    ELSE
        spacingInProgress := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
    END_IF

    // Vertical motion control
    IF verticalInProgress THEN
        IF X22 THEN
            Y22 := FALSE; // Stop upward movement when high is reached
            verticalInProgress := FALSE;
        END_IF
    ELSE
        // If spacing complete, proceed to acquire materials
        IF X23 AND NOT horizontalInProgress AND NOT Y24 THEN
            Y23 := TRUE; // Move down to acquire
        END_IF

        IF X23 THEN // Already at low
            Y23 := FALSE;

            IF X25 THEN
                Y24 := TRUE; // Grip if released and at low
                gripping := TRUE;
            END_IF

            IF gripping THEN
                Y24 := FALSE;  // Grip command maintained briefly
                gripping := FALSE;

                // Move back to high before moving to target
                IF X23 AND NOT X22 THEN
                    Y22 := TRUE; // Move up
                END_IF
            END_IF

            IF X22 AND NOT horizontalInProgress AND NOT spacingInProgress THEN
                Y22 := FALSE; // stop upward movement
                IF NOT X21 THEN
                    Y20 := TRUE; // Forward to target
                    horizontalInProgress := TRUE;
                END_IF
            END_IF
        END_IF

        IF X21 AND horizontalInProgress THEN
            Y20 := FALSE; // Stop forward command
            horizontalInProgress := FALSE;

            IF NOT verticalInProgress THEN
                Y23 := TRUE; // Move down to place materials
            END_IF
        END_IF
    END_IF

    IF X23 AND X21 AND NOT completing THEN
        // Release materials at the target
        IF X24 THEN
            Y24 := FALSE; // Ensure grip is off
            Y23 := FALSE; // Stop downward
            IF NOT X25 THEN
                Y24 := TRUE; // Release materials
            END_IF
        END_IF

        // Move back to source upper position
        IF X25 AND NOT Y21 AND NOT Y22 THEN
            Y21 := TRUE; // Move back to the source
        END_IF

        IF X20 AND NOT Y22 THEN
            Y21 := FALSE; // Stop back command
            IF X22 THEN
                Y2 := TRUE; // Signal completion
                completing := TRUE;
            END_IF
        END_IF
    END_IF   
END_IF

END_PROGRAM