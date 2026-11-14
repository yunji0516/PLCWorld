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
    state : INT := 0;
    start_edge : R_TRIG;
    grip_timer : TON;
    complete : BOOL := FALSE;
END_VAR

start_edge(CLK := X10);

// Main state machine logic
CASE state OF
    0 : // Waiting for start
        IF start_edge.Q AND D10 = 2 THEN
            state := 1; // Move to pick up first item
        END_IF

    1 : // Move to source position
        IF X20 AND X23 THEN // At source and high
            Y24 := TRUE; // Command down
            state := 2; // Prepare to grip
        ELSE
            Y24 := FALSE;
            Y23 := NOT X23; // Keep raising until high
        END_IF

    2 : // Gripping at source
        IF X22 THEN // At low position
            Y20 := TRUE; // Close grip
            grip_timer(IN := TRUE, PT := T#120ms);
            IF grip_timer.Q THEN
                Y20 := FALSE; // Finish grip
                Y24 := FALSE; // Stop down
                state := 3; // Start lifting
            END_IF
        END_IF

    3 : // Lifting after picking
        IF X23 THEN // At high position
            Y23 := FALSE;
            state := 4; // Determine target
        ELSE
            Y23 := TRUE; // Command up
        END_IF

    4 : // Select target based on D20
        IF D20 = 0 THEN
            Y25 := FALSE; // Select accept target
        ELSE
            Y25 := TRUE; // Select reject target
        END_IF
        state := 5; // Command arm advance
    
    5 : // Advance to target
        IF X21 THEN // At target
            Y21 := FALSE;
            Y24 := TRUE; // Command down to release
            state := 6; // Prepare to release
        ELSE
            Y21 := TRUE; // Command advance
        END_IF

    6 : // Releasing at receiver
        IF X22 THEN // At low position
            Y20 := FALSE; // Open grip
            grip_timer(IN := FALSE);
            IF X25 THEN // Confirm release
                Y24 := FALSE; // Stop down
                state := 7; // Start lifting after placing
            END_IF
        END_IF

    7 : // Lifting to return
        IF X23 THEN // At high position
            Y23 := FALSE;
            Y22 := TRUE; // Command return
            state := 8; // Start returning
        ELSE
            Y23 := TRUE; // Command up
        END_IF

    8 : // Returning to source position
        IF X20 THEN // At source
            Y22 := FALSE;
            Y23 := FALSE;
            state := 9; // Prepare to pick second item
        END_IF

    9 : // Move to second item
        IF X26 THEN // Source has another item
            D20 := 0; // Reset item class placeholder
            state := 1; // Reuse pickup process
        ELSE
            // No second item, Process complete
            complete := TRUE;
            state := 10; // Completion state
        END_IF

    10 : // Completion
        IF complete THEN
            Y2 := TRUE;
        END_IF
END_CASE
END_PROGRAM