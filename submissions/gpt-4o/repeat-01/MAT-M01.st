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
    D20 : INT;
    D21 : INT;
    D22 : INT;
    startRequest: BOOL := FALSE;
    deliveryComplete: BOOL := FALSE;
    targetPosition: INT;
    startTrigger: R_TRIG;
    gripClosed: BOOL;
    receiverOpen: BOOL;
END_VAR

// Initialize and trigger start request
startTrigger(CLK := X10);

// Start request on rising edge of X10
IF startTrigger.Q THEN
    startRequest := TRUE;
    targetPosition := D10;
END_IF

gripClosed := X22;
receiverOpen := X25;

// Control logic execution based on start request
IF startRequest AND NOT deliveryComplete THEN
    // Ensure carriage is home before starting
    IF X20 THEN
        // Ensure correct grip and receiver states before unwinding
        IF gripClosed AND receiverOpen THEN
            Y26 := TRUE; // Unwind
        ELSIF NOT gripClosed THEN
            Y22 := TRUE; // Close grip
        ELSIF NOT receiverOpen THEN
            Y25 := TRUE; // Open receiver
        END_IF

        // Deliver web until target position is reached
        IF D21 < (targetPosition - 3) THEN
            Y20 := TRUE; // Move forward
        ELSIF D21 >= (targetPosition - 3) AND D21 <= (targetPosition + 3) THEN
            // Stop moving, close receiver when within target range
            Y20 := FALSE;
            IF X21 AND NOT X24 THEN
                Y24 := TRUE; // Close receiver
            END_IF
        END_IF

        // Set delivery complete if conditions are met
        IF X24 AND X23 AND X25 AND X20 AND X21 AND D21 >= (targetPosition - 3) AND D21 <= (targetPosition + 3) THEN
            deliveryComplete := TRUE;
            Y2 := TRUE; // Set completion claim
            // Ensure all actuators are OFF
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
        END_IF
    ELSE
        // Return to home state if not at home or other checks fail
        Y21 := X23; // Move reverse if grip is open
    END_IF
END_IF

// Safety checks to ensure no opposed operations
IF (Y22 AND Y23) OR (Y24 AND Y25) THEN
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
END_IF

END_PROGRAM