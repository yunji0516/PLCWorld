PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    X20 : BOOL;
    D20 : INT;
    
    start_triggered : BOOL := FALSE;
    external_withdrawal_active : BOOL := FALSE;
    completion_held : BOOL := FALSE;
    
    scan_counter : INT := 0;
    buffer_within_limits : BOOL := TRUE;
    
    unwind_timer : TON;
    start_edge : R_TRIG;
END_VAR

// Implement the control logic here.
start_edge(CLK := X10);

// Start operation when Start edge detected
IF start_edge.Q THEN
    start_triggered := TRUE;
    scan_counter := 0;
END_IF

// Begin external withdrawal when operation is triggered and D10 is 1
IF start_triggered AND D10 = 1 THEN
    external_withdrawal_active := TRUE;
END_IF

// Control unwind based on buffer inventory status while withdrawal is active
IF external_withdrawal_active THEN
    // Check buffer status
    buffer_within_limits := (D20 >= 200) AND (D20 <= 700);
    
    // Start the unwind with a 4-second timer
    unwind_timer(IN := TRUE, PT := T#4s);
    
    // Control the unwind actuator
    IF (NOT unwind_timer.Q) AND buffer_within_limits THEN
        Y20 := TRUE;
    ELSE
        Y20 := FALSE;
    END_IF
    
    // End external withdrawal after 4 seconds
    IF unwind_timer.Q THEN
        external_withdrawal_active := FALSE;
    END_IF
END_IF

// Complete the task and test conditions for claim
IF NOT external_withdrawal_active AND NOT completion_held THEN
    IF buffer_within_limits AND X20 THEN
        // Check for completion state
        Y20 := FALSE; // Turn off unwind
        Y2 := TRUE;   // Claim completion
        completion_held := TRUE; // Set flag to hold completion
    END_IF
END_IF

// Maintain completion state for at least 50 scans
IF completion_held THEN
    scan_counter := scan_counter + 1;
    IF scan_counter > 50 THEN
        // After 50 scans of completion hold
        Y2 := FALSE;
    END_IF
END_IF

END_PROGRAM