PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;

    // Internal variables
    state : INT := 0;
    a_target : DINT;
    a_rate : DINT;
    b_target : DINT;
    b_rate : DINT;
    request_target_valid : BOOL := FALSE;

    // Function block instances
    move_timer : TON;
    corner_timer : TON;
    edge_start: R_TRIG;
    corner_start: R_TRIG;

END_VAR

// Edge detectors
edge_start(CLK := X0);
corner_start(CLK := (state = 1 AND ABS(D10 - 500) <= 20)); 

// Main state machine
CASE state OF
    0: // Idle, waiting for start
        IF edge_start.Q THEN
            request_target_valid := (D101 >= 840 AND D101 <= 850);
            IF request_target_valid THEN
                state := 1; // Start moving
            END_IF;
        END_IF;
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;

    1: // Moving to the requested s position with B=90
        a_target := D101 * 100;
        a_rate := 500;  // Move at 50% rate
        b_target := 90 * 100;
        b_rate := 500;
        Y20 := TRUE;
        Y21 := TRUE;

        IF ABS(D10 - a_target) <= INT(0.2 * 100) AND ABS(D12 - b_target) <= INT(0.2 * 100) THEN
            state := 2;
        END_IF;
        
        // Check for s=500 corner stop
        IF corner_start.Q THEN
            Y20 := FALSE;  // Disable A axis at s=500
            corner_timer(IN := TRUE, PT := T#1s);
        END_IF;

    2: // At the requested position, move to B=270
        b_target := 270 * 100;
        IF ABS(D12 - b_target) <= INT(0.2 * 100) THEN
            state := 3;
        END_IF;

    3: // Returning to start position s=200
        a_target := 200 * 100;
        a_rate := 500;
        Y20 := TRUE;

        IF ABS(D10 - a_target) <= INT(0.2 * 100) THEN
            state := 4;
        END_IF;

    4: // Completion
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;      // Signal completion
        move_timer(IN := TRUE, PT := T#100ms);

        // Complete if Y2 has been valid for 100ms
        IF move_timer.Q THEN
            Y2 := FALSE;
            state := 0;  // Return to Idle
        END_IF;

    ELSE
        // Default case, should not reach
        state := 0;
END_CASE;

// Output Scaling and Assignments
D20 := a_target;
D21 := a_rate;
D24 := b_target;
D25 := b_rate;

END_PROGRAM