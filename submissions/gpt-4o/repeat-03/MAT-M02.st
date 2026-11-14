PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL := FALSE; // grip
    Y21 : BOOL := FALSE; // advance
    Y22 : BOOL := FALSE; // return
    Y23 : BOOL := FALSE; // up
    Y24 : BOOL := FALSE; // down
    Y25 : BOOL := FALSE; // cw
    Y26 : BOOL := FALSE; // ccw
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

    start_triggered : BOOL := FALSE;
    requested_angle : INT;
    angle_difference : INT;
    rotation_needed : INT;
    angle_error_margin : INT := 2;
    move_to_receiver : BOOL := FALSE;
    return_to_source : BOOL := FALSE;
    rotate_cw : BOOL := FALSE;
    rotate_ccw : BOOL := FALSE;
    rotation_complete : BOOL := FALSE;
    ready_to_release : BOOL := FALSE;

    edge_start : R_TRIG;
    angle_error : INT;
END_VAR

// Edge detection for the start request
edge_start(CLK := X10);
IF edge_start.Q THEN
    start_triggered := TRUE;
    requested_angle := D10;
END_IF

// Ensure operations are initiated only after a start request
IF start_triggered THEN
    // Check if plate is present at source
    IF X26 AND NOT X25 AND NOT X28 THEN
        // Lower tool to acquire plate
        IF NOT X22 THEN
            Y24 := TRUE;
        END_IF

        IF X22 THEN
            Y24 := FALSE;
            IF X25 THEN
                Y20 := TRUE; // Engage grip
            END_IF
            
            IF X24 THEN
                Y23 := TRUE; // Lift tool after engaging grip
                move_to_receiver := TRUE;
            END_IF
        END_IF
    END_IF
    
    // Move plate to receiver
    IF move_to_receiver AND X23 THEN
        Y23 := FALSE; // Stop lifting
        IF NOT X21 THEN
            Y21 := TRUE; // Advance towards receiver
        ELSE
            Y21 := FALSE; // Stop horizontal movement
            IF X21 AND NOT X24 THEN
                // Prepare for rotation to match requested angle
                angle_difference := (requested_angle - D21) MOD 360;
                angle_error := ABS(angle_difference);
                IF angle_error > angle_error_margin THEN
                    IF angle_difference > 0 THEN
                        rotate_cw := angle_error <= 180;
                        rotate_ccw := NOT rotate_cw;
                    ELSE
                        rotate_ccw := angle_error <= 180;
                        rotate_cw := NOT rotate_ccw;
                    END_IF
                ELSE
                    rotation_complete := TRUE;
                END_IF
            END_IF

            // Perform rotation
            IF NOT rotation_complete THEN
                Y25 := rotate_cw;
                Y26 := rotate_ccw;
            ELSE
                Y25 := FALSE;
                Y26 := FALSE;
            END_IF
        END_IF
    END_IF
    
    // Prepare plate for release at receiver
    IF rotation_complete AND X21 AND X24 THEN
        Y24 := TRUE; // Lower tool
    END_IF

    IF X22 THEN
        Y24 := FALSE;
        IF X25 THEN
            Y20 := FALSE; // Release grip
        END_IF
        
        IF X26 THEN
            return_to_source := TRUE;
        END_IF
    END_IF
    
    // Return empty tool to source
    IF return_to_source THEN
        IF NOT X20 THEN
            Y22 := TRUE; // Return to source
        ELSE
            Y22 := FALSE;
            IF X20 AND NOT X24 THEN
                Y23 := TRUE; // Lift tool to initial position
            END_IF
            
            IF X23 THEN
                // Task completion conditions met
                Y23 := FALSE;
                Y2 := TRUE;
            END_IF
        END_IF
    END_IF
END_IF

END_PROGRAM