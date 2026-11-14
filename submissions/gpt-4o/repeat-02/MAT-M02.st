PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL := FALSE; // Grip
    Y21 : BOOL := FALSE; // Advance
    Y22 : BOOL := FALSE; // Return
    Y23 : BOOL := FALSE; // Up
    Y24 : BOOL := FALSE; // Down
    Y25 : BOOL := FALSE; // CW
    Y26 : BOOL := FALSE; // CCW
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X31 : BOOL;
    Y2 : BOOL := FALSE; // Completion claim
    D20 : INT;
    D21 : INT;
    
    // Internal variables
    start_trigger : R_TRIG;
    target_angle : INT := 0;
    state : INT := 0;
    angle_error : INT;
    cw_required : BOOL;
    ccw_required : BOOL;
    
    // Constants
    DEG_TOLERANCE : INT := 2;
    LIFT_HEIGHT : INT := 360;
END_VAR

// Start trigger
start_trigger(CLK := X10);

IF start_trigger.Q THEN
    target_angle := D10; // Accept the request value for the target angle
    state := 1; // Move to next state after start trigger
END_IF

// Main state machine for task workflow
CASE state OF
    0: // Wait for start
        // Do nothing, just wait for start trigger
        
    1: // Grip plate at source
        IF X22 AND X20 AND X25 THEN
            // At low position, at source, and grip is released
            Y20 := TRUE; // Close grip
            state := 2; // Move to next state
        END_IF

    2: // Lift plate
        IF X24 THEN
            Y24 := FALSE; // Turn off down command
            Y23 := TRUE; // Move up
            state := 3;
        END_IF

    3: // Check if lifted
        IF X23 THEN
            Y23 := FALSE; // Move up
            state := 4;
        END_IF

    4: // Rotate head to match target angle
        angle_error := D10 - (D21 + D20);
        
        // Calculate shortest path
        angle_error := MOD(angle_error + 180, 360) - 180;
        
        cw_required := angle_error > DEG_TOLERANCE;
        ccw_required := angle_error < -DEG_TOLERANCE;
        
        IF cw_required THEN
            Y25 := TRUE; // rotate CW
            Y26 := FALSE;
        ELSIF ccw_required THEN
            Y26 := TRUE; // rotate CCW
            Y25 := FALSE;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
            state := 5; // Go to next state
        END_IF

    5: // Move to receiver
        IF NOT cw_required AND NOT ccw_required THEN
            Y21 := TRUE; // Start moving to receiver
            Y22 := FALSE;
            IF X21 THEN
                Y21 := FALSE; // Stop advance
                state := 6; // Move to next state
            END_IF
        END_IF

    6: // Place plate at receiver
        IF (X22 AND X21 AND X24) THEN
            Y20 := FALSE; // Open grip
            state := 7; // Move to next state
        END_IF
        
    7: // Move up without plate
        IF X25 THEN // Ensure grip is released
            Y23 := TRUE; 
            state := 8;
        END_IF
        
    8: // Return to source
        IF X23 THEN // At high
            Y23 := FALSE;
            Y22 := TRUE; // Move back to source
            IF X20 THEN
                Y22 := FALSE; // Stop returning
                Y2 := TRUE; // Claim completion
                state := 9; // Completion
            END_IF
        END_IF

    9: // Completion
        // At this state, task is complete, maintain output
        Y2 := TRUE;
END_CASE

END_PROGRAM