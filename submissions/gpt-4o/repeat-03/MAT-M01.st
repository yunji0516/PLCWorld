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
    // Internal variables
    start_trigger : R_TRIG;
    timer : TON;
    state : INT;
    requested_web_length : INT;
END_VAR

// Initialize internal variables
start_trigger(CLK := X10);
timer(IN := FALSE, PT := T#0ms);

IF start_trigger.Q THEN
    // Capture the requested web length
    requested_web_length := D10;
    state := 1; // Start the state machine
END_IF

CASE state OF
    0: // Idle state, waiting for start signal
        // Ensure all outputs are off
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        
    1: // Ensure initial conditions
        IF X22 AND X25 AND X20 AND X21 THEN
            state := 2; // Move to grip closing
        END_IF

    2: // Close feed grip
        IF NOT X22 THEN
            Y22 := TRUE; // Command grip close
        ELSE
            Y22 := FALSE;
            state := 3; // Move to unwinding
        END_IF

    3: // Unwind to fill buffer if necessary
        IF D20 < 850 THEN
            Y26 := TRUE; // Command unwind
        ELSE
            Y26 := FALSE;
            state := 4; // Buffer sufficiently full, move to delivery
        END_IF

    4: // Move forward with feed grip closed
        IF X22 THEN
            Y20 := TRUE; // Command forward
        END_IF
        IF D21 >= requested_web_length - 3 AND D21 <= requested_web_length + 3 THEN
            Y20 := FALSE; // Stop forward movement
            state := 5; // Move to receiver closing
        END_IF
    
    5: // Close the receiver
        IF NOT X24 THEN
            Y24 := TRUE; // Command receiver close
        ELSE
            Y24 := FALSE;
            state := 6; // Move to open feed grip
        END_IF
    
    6: // Open the feed grip
        IF NOT X23 THEN
            Y23 := TRUE; // Command grip open
        ELSE
            Y23 := FALSE;
            state := 7; // Move to home position
        END_IF

    7: // Reverse to home position
        IF X23 THEN
            Y21 := TRUE; // Command reverse
        END_IF
        IF X20 THEN
            Y21 := FALSE; // Stop reverse movement
            state := 8; // Prepare for completion
        END_IF
    
    8: // Ensure everything is off for completion
        IF X20 AND X21 AND X24 AND X23 THEN 
            Y2 := TRUE; // Completion claim
            state := 0; // Reset state for next cycle
        END_IF

END_CASE

// Safety and interlock conditions
// Ensure opposing commands are not set at the same time
IF Y22 AND Y23 THEN
    Y22 := FALSE;
    Y23 := FALSE;
END_IF

IF Y24 AND Y25 THEN
    Y24 := FALSE;
    Y25 := FALSE;
END_IF

IF Y20 AND Y21 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF

END_PROGRAM