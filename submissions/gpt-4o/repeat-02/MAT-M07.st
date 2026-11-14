```iec
PROGRAM Main
VAR
    // Inputs
    X10 : BOOL; // One rising-edge start request
    D10 : INT; // Requested spacing value

    // Outputs
    Y2 : BOOL; // Completion claim
    Y20 : BOOL; // Command: forward
    Y21 : BOOL; // Command: back
    Y22 : BOOL; // Command: up
    Y23 : BOOL; // Command: down
    Y24 : BOOL; // Command: grip
    Y25 : BOOL; // Command: widen
    Y26 : BOOL; // Command: narrow

    // Feedback Inputs
    X20 : BOOL; // Physical/status feedback: home
    X21 : BOOL; // Physical/status feedback: target
    X22 : BOOL; // Physical/status feedback: high
    X23 : BOOL; // Physical/status feedback: low
    X24 : BOOL; // Physical/status feedback: holding both
    X25 : BOOL; // Physical/status feedback: released
    X26 : BOOL; // Physical/status feedback: holding1
    X27 : BOOL; // Physical/status feedback: holding2
    D20 : INT; // Measured data: pitch

    // Internal Variables
    start_edge : R_TRIG;
    move_timer : TON;
    spacing_adjustment : BOOL := FALSE;
    move_done : BOOL := FALSE;
    target_spacing : INT;
    at_source : BOOL := FALSE;
    at_target : BOOL := FALSE;
END_VAR

// Rising edge detection for start
start_edge(CLK := X10);

// State Machine implementation
IF start_edge.Q THEN
    target_spacing := D10;

    // Ensure the heads are lifted before start moving or spacing
    IF NOT X22 THEN
        Y22 := TRUE; // Command up
    ELSE
        Y22 := FALSE;

        // Grip the materials when reaching the source upper position
        IF X20 AND NOT X24 THEN
            IF NOT X23 THEN
                Y23 := TRUE; // Command down
            ELSE
                Y23 := FALSE;
            END_IF

            Y24 := TRUE; // Close grips

            // Ensure the system actually holds both materials
            IF X24 THEN
                IF D20 < target_spacing THEN
                    spacing_adjustment := TRUE;
                    Y25 := TRUE; // Command widen
                ELSIF D20 > target_spacing THEN
                    spacing_adjustment := TRUE;
                    Y26 := TRUE; // Command narrow
                ELSE
                    spacing_adjustment := FALSE; // Spacing is correct
                END_IF

                // Move horizontally only if spacing is adjusted and material held
                IF NOT spacing_adjustment AND X24 THEN
                    IF NOT X21 THEN
                        Y20 := TRUE; // Command forward
                    ELSE
                        Y20 := FALSE;
                        at_target := TRUE; // Reached target
                    END_IF
                END_IF
            END_IF
        END_IF
    END_IF
END_IF

// When at target, release materials
IF at_target AND X21 THEN
    IF NOT X23 THEN
        Y23 := TRUE; // Command down
    ELSE
        Y23 := FALSE;
        Y24 := FALSE; // Release grip
        IF X25 THEN
            // Move back to source upper position after release
            IF X20 THEN
                Y2 := TRUE; // Completion claim
            ELSE
                Y21 := TRUE; // Command back
            END_IF
        END_IF
    END_IF
END_IF

// Ensure all outputs turned off at completion
IF Y2 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
END_IF

END_PROGRAM
```