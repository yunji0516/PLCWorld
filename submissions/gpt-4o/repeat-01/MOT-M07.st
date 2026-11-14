PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    // Internal state variables
    state : INT := 0; // 0 = idle, 1 = move to first port, 2 = move to second port, 3 = return to zero, 4 = complete
    timer : TON;
    start_time : TIME; // This will keep track of start time for timing the task.
    a_target : DINT;
    b_target : DINT;
    c_target : DINT;
    rate : INT := 1000; // Full speed rate

    first_reached : BOOL := FALSE;
    second_reached : BOOL := FALSE;
    
END_VAR

// Reset outputs initially
D20 := 0;
D21 := 0;
Y20 := FALSE;
D24 := 0;
D25 := 0;
Y21 := FALSE;
D28 := 0;
D29 := 0;
Y22 := FALSE;
Y2 := FALSE;

// Time to reset the completion flag on task completion
timer(IN := Y2, PT := T#100ms);

// Main control logic
CASE state OF
    0: // Idle state
        IF X0 THEN
            // Begin execution upon start command and ensure enable conditions
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            a_target := D101; // Set initial target to first port
            b_target := 0;
            c_target := 0;
            state := 1;
            start_time := TIME(); // Record the start time
        END_IF
        
    1: // Move to first port
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := a_target * 100; // Convert to required scale
        D21 := rate;
        D24 := b_target * 100;
        D25 := rate;
        D28 := c_target * 100;
        D29 := rate;
        
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14 - D28) <= 20 AND ABS(D15) <= 100 THEN
           first_reached := TRUE;
           state := 2;
        END_IF

    2: // Move to second port
        IF first_reached THEN
            a_target := D102; // Set target to second port
            b_target := D103;
            c_target := D104;
            first_reached := FALSE;
            second_reached := FALSE;
        END_IF

        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := a_target * 100;
        D21 := rate;
        D24 := b_target * 100;
        D25 := rate;
        D28 := c_target * 100;
        D29 := rate;

        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14 - D28) <= 20 AND ABS(D15) <= 100 THEN
           second_reached := TRUE;
           state := 3;
        END_IF

    3: // Return to initial position (A = B = C = 0)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := 0;
        D21 := rate;
        D24 := 0;
        D25 := rate;
        D28 := 0;
        D29 := rate;

        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
           state := 4; // Move to completion state
        END_IF

    4: // Complete
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE; // Indicate task complete
        start_time := TIME(); // Record the completion time
        IF timer.Q THEN
            Y2 := FALSE; // Reset after holding for 100 ms
            state := 0; // Return to idle state
        END_IF
END_CASE

END_PROGRAM