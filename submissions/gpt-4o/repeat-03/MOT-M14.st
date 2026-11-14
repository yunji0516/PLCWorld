PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    // Internal variables
    state : INT := 0;
    slide_ret_timer : TON;
    table_settle_timer : TON;
    completion_timer : TON;
    slide_retract_target : DINT;
    slide_approach_target : DINT;
END_VAR

// State machine to handle slide retraction, table positioning, and re-approach
CASE state OF
    0: // Initial state, wait for work request
        IF X10 THEN
            slide_retract_target := MIN(D16, 500 * 100);
            slide_approach_target := D15;
            D21 := slide_retract_target; // Set slide retraction target
            Y21 := TRUE; // Activate slide drive
            state := 1;
        END_IF

    1: // Wait for slide retraction
        IF X11 THEN
            Y21 := FALSE; // Deactivate slide drive
            D20 := D14; // Set table target
            Y20 := TRUE; // Activate table drive
            state := 2;
        END_IF

    2: // Wait for table to reach target
        IF X12 THEN
            Y20 := FALSE; // Deactivate table drive
            slide_ret_timer(IN := TRUE, PT := T#30ms);
            IF slide_ret_timer.Q THEN
                D21 := slide_approach_target; // Set slide approach target
                Y21 := TRUE; // Activate slide drive
                state := 3;
            END_IF
        ELSE
            slide_ret_timer(IN := FALSE); // Reset timer if out of condition
        END_IF

    3: // Wait for slide approach
        IF NOT X12 THEN // Ensure table condition holds
            state := 2; // Return to waiting for table settled condition
        ELSIF (ABS(D12 - D15) <= 2) AND (ABS(D13) <= 100) THEN
            Y21 := FALSE; // Deactivate slide drive
            table_settle_timer(IN := TRUE, PT := T#30ms);
            IF table_settle_timer.Q THEN
                Y2 := TRUE; // Maintain work completion
                completion_timer(IN := TRUE, PT := T#100ms);
            END_IF
        ELSE
            table_settle_timer(IN := FALSE); // Reset timer if out of condition
        END_IF

    4: // Maintain completion
        IF completion_timer.Q THEN
            state := 0; // Reset to initial state after maintaining completion
            Y2 := FALSE; // Reset completion
        END_IF
END_CASE

END_PROGRAM