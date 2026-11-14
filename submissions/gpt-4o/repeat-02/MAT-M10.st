PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
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
    D20 : INT;
    
    start_edge : R_TRIG;
    started : BOOL := FALSE;
    selected_mask : INT := 0;
    current_position : INT := 0; // 0: source upper, 1: target, 2: returning
    completed : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    started := TRUE;
    selected_mask := D10 AND 7; // Extract only the last 3 bits representing the selected materials
END_IF

IF started AND NOT completed THEN
    CASE current_position OF
        0: // At source upper, ready to move
            IF NOT (X22 OR X23) THEN // Ensure lift is not active
                Y22 := TRUE; // Begin lift
                IF X22 THEN // If high position is reached
                    Y22 := FALSE; // Stop lift
                    Y20 := TRUE; // Move forward
                END_IF
            END_IF
            
        1: // At target position
            IF X21 THEN // Check target position
                Y20 := FALSE; // Stop forward motion
                Y23 := TRUE; // Begin lowering
                IF X23 THEN // If low position is reached
                    Y23 := FALSE; // Stop lowering
                    // Release selected materials
                    Y24 := INT_TO_BOOL(selected_mask AND 1);
                    Y25 := INT_TO_BOOL(selected_mask AND 2);
                    Y26 := INT_TO_BOOL(selected_mask AND 4);
                    current_position := 2; // Prepare to return
                END_IF
            END_IF
            
        2: // Returning to source position
            IF NOT (Y24 OR Y25 OR Y26) THEN // Ensure materials are released
                Y21 := TRUE;
                IF X20 THEN // Check home position
                    Y21 := FALSE; // Stop back motion
                    Y23 := TRUE; // Begin lowering
                    IF X23 THEN // If low position is reached
                        Y23 := FALSE; // Stop lowering
                        // Release unselected materials
                        Y24 := NOT INT_TO_BOOL(selected_mask AND 1);
                        Y25 := NOT INT_TO_BOOL(selected_mask AND 2);
                        Y26 := NOT INT_TO_BOOL(selected_mask AND 4);
                        completed := TRUE; // Completed the task
                    END_IF
                END_IF
            END_IF
    END_CASE
END_IF

IF completed THEN
    Y2 := TRUE;
END_IF

END_PROGRAM