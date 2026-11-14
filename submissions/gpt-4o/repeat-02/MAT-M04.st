PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
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
    Y2 : BOOL;
    D20 : INT;
    
    // Internal variables
    start_trigger : R_TRIG;
    current_task : INT := 0; (* 0: waiting for start, 1: delivering first item, 2: delivering second item, 3: complete *)
    reject_mode : BOOL := FALSE;
    task_done : BOOL := FALSE;
    grip_time : TON;
    vertical_time : TON;
    swing_time : TON;
    start_accepted : BOOL := FALSE;
    
END_VAR

// Implement the control logic here
start_trigger(CLK := X10);

// Handle start request
IF start_trigger.Q THEN
    IF D10 = 2 THEN
        start_accepted := TRUE;
        current_task := 1; // Start delivering first item
    END_IF
END_IF

CASE current_task OF
    0: // Waiting for start
        Y20 := FALSE; // Grip OFF
        Y21 := FALSE; // Advance OFF
        Y22 := FALSE; // Return OFF
        Y23 := FALSE; // Up OFF
        Y24 := FALSE; // Down OFF
        Y25 := FALSE; // Reject OFF
    
    1: // Delivering first item
        IF start_accepted THEN
            IF X26 AND X31 AND X22 THEN // Ensure source is present, valid and arm is low
                Y20 := TRUE; // Close grip
                grip_time(IN := TRUE, PT := T#120ms); // Grip closure time
            END_IF

            IF grip_time.Q THEN
                Y24 := FALSE; // Down OFF
                Y23 := TRUE; // Up ON
                vertical_time(IN := TRUE, PT := T#830ms); // 550 mm / 0.65 m/s
            END_IF

            IF vertical_time.Q THEN
                IF D20 = 1 THEN
                    Y25 := TRUE; // Reject ON
                    reject_mode := TRUE;
                ELSE
                    Y25 := FALSE; // Reject OFF
                    reject_mode := FALSE;
                END_IF
                Y23 := FALSE; // Up OFF
                Y21 := TRUE; // Start advance
                swing_time(IN := TRUE, PT := T#188ms); // (45/2.4) * 1000 ms/s
            END_IF

            IF swing_time.Q AND X21 THEN
                Y21 := FALSE; // Advance OFF
                Y23 := FALSE; // Up OFF
                Y24 := TRUE; // Down ON
                IF X22 THEN // At low position on target
                    Y20 := FALSE; // Open grip
                END_IF
                IF X25 THEN // Released
                    Y20 := FALSE; // Grip OFF
                    Y24 := FALSE; // Down OFF
                    Y22 := TRUE; // Start return
                    swing_time(IN := TRUE, PT := T#188ms); // Swing return time
                END_IF

                IF swing_time.Q AND X20 THEN
                    Y22 := FALSE; // Return OFF
                    Y23 := TRUE; // Start lifting to source upper position
                    vertical_time(IN := TRUE, PT := T#830ms); // Return to lift time
                END_IF

                IF vertical_time.Q THEN
                    Y23 := FALSE; // Up OFF
                    current_task := 2; // Move to delivering second item
                END_IF
            END_IF
        END_IF
    
    2: // Delivering second item
        IF X27 THEN
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
        ELSE
            current_task := 1;
        END_IF

    3: // Complete
        task_done := TRUE;
END_CASE

// Check for completion
IF current_task = 3 AND NOT task_done THEN
    Y2 := TRUE; // Completion claim
END_IF

END_PROGRAM