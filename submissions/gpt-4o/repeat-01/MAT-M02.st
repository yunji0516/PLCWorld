PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
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
    Y2 : BOOL := FALSE;
    D20 : INT;
    D21 : INT;
    
    // Internal variables
    state : INT := 0; // State machine variable
    start_request_edge : R_TRIG;
    current_angle_error : INT;
END_VAR

// Function to calculate the shortest angle difference modulo 360
FUNCTION shortest_angle_difference : INT
VAR_INPUT
    angle1 : INT;
    angle2 : INT;
END_VAR
VAR
    diff : INT;
END_VAR
diff := (angle1 - angle2) MOD 360;
IF diff > 180 THEN
    diff := diff - 360;
ELSIF diff < -180 THEN
    diff := diff + 360;
END_IF;
shortest_angle_difference := diff;
END_FUNCTION

// Update R_TRIG for start request
start_request_edge(CLK := X10);

// Main State Machine
CASE state OF
    0: // Initial State: Wait for start request
        IF start_request_edge.Q THEN
            // Accept start request
            state := 1;
        END_IF

    1: // Move to Acquire position
        IF X22 AND X25 THEN // At source and holding
            Y24 := TRUE; // Move down
        ELSE
            Y24 := FALSE;
            IF X22 THEN
                Y20 := TRUE; // Grip
                IF X24 THEN
                    state := 2; // Move to the next state after gripping
                END_IF
            END_IF
        END_IF

    2: // Adjust the head angle to match requested angle (D10)
        current_angle_error := shortest_angle_difference(D21, D10);
        IF current_angle_error > 2 THEN
            Y26 := TRUE; // Turn CCW
        ELSIF current_angle_error < -2 THEN
            Y25 := TRUE; // Turn CW
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
            state := 3; // Angle matched, move to the next state
        END_IF

    3: // Lift the plate
        IF NOT X23 THEN
            Y23 := TRUE; // Move up
        ELSE
            Y23 := FALSE;
            state := 4; // Reached upper position
        END_IF

    4: // Move to the receiver
        IF NOT X21 THEN
            Y21 := TRUE; // Advance
        ELSE
            Y21 := FALSE;
            state := 5; // Reached receiver
        END_IF

    5: // Place the plate
        IF X21 THEN
            IF X23 THEN // At high position
                Y24 := TRUE; // Move down to place
            ELSE
                Y24 := FALSE;
                Y20 := FALSE; // Release grip
                IF X25 THEN
                    state := 6; // Move to next state
                END_IF
            END_IF
        END_IF

    6: // Return to source position
        IF NOT X20 THEN
            Y22 := TRUE; // Return
        ELSE
            Y22 := FALSE;
            state := 7; // Reached source
        END_IF

    7: // Move up to initial position
        IF NOT X23 THEN
            Y23 := TRUE; // Move up
        ELSE
            Y23 := FALSE;
            Y2 := TRUE; // Completion claim
            state := 8; // Process completed
        END_IF

    8: // Maintain completion
        // All actuator outputs should remain OFF; maintain Y2
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := TRUE;
END_CASE

END_PROGRAM