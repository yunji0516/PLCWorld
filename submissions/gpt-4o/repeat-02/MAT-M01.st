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
    D20 : INT;
    D21 : INT;
    D22 : INT;
    
    start_edge : R_TRIG;
    received_request : BOOL := FALSE;
    required_length : INT;
    process_complete : BOOL := FALSE;

    move_forward : BOOL := FALSE;
    move_reverse : BOOL := FALSE;
    close_grip : BOOL := FALSE;
    open_grip : BOOL := FALSE;
    close_receiver : BOOL := FALSE;
    open_receiver : BOOL := FALSE;
    unwind_web : BOOL := FALSE;
END_VAR

// Rising edge detection on start request X10
start_edge(CLK := X10);

// Process initiation
IF start_edge.Q AND NOT received_request THEN
    required_length := D10;
    received_request := TRUE;
END_IF

// Main control logic
IF received_request AND NOT process_complete THEN
    
    // Calculate remaining web required to be extracted
    IF D21 < required_length - 3 THEN
        // Forward carriage movement allowed with feed grip closed
        IF NOT X22 THEN
            close_grip := TRUE;
        ELSE
            IF D22 < required_length THEN
                move_forward := TRUE;
            ELSE
                move_forward := FALSE;
                unwind_web := TRUE;
            END_IF
        END_IF
    ELSIF D21 > required_length + 3 THEN
        // Reverse carriage if over extracted
        IF X23 THEN
            move_reverse := TRUE;
        END_IF
    ELSE
        move_forward := FALSE;
        move_reverse := FALSE;
        
        // Check for unwinding limit or closing receiver conditions
        IF D20 > 80 AND D20 < 900 THEN
            IF NOT X24 THEN
                close_receiver := TRUE;
            END_IF
            IF X24 AND X21 AND NOT move_forward AND NOT move_reverse THEN
                open_grip := TRUE;
                process_complete := TRUE;
                Y2 := TRUE; // Completion claim
            END_IF
        END_IF
    END_IF
END_IF

// Output assignments
Y20 := move_forward;
Y21 := move_reverse;
Y22 := close_grip;
Y23 := open_grip;
Y24 := close_receiver;
Y25 := open_receiver;
Y26 := unwind_web;

END_PROGRAM