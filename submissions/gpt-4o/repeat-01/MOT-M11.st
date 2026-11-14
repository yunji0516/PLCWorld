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
    
    // Internal state management
    state : INT := 0;

    // Timer for measuring completion time
    completionTimer : TON;

    // Edge detection for start signal
    startEdge : R_TRIG;

    // Auxiliary variables for process
    toolBPositionReached : BOOL;
    toolCPositionReached : BOOL;
    toolBInitialRetract : BOOL;
    toolCInitialRetract : BOOL;
    toolBFinalRetract : BOOL;
    toolCFinalRetract : BOOL;

END_VAR

// Edge detection for X0 Start signal
startEdge(CLK := X0);

// State machine
CASE state OF
    0: // Initial state, waiting for start signal
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        
        IF startEdge.Q THEN
            state := 1;
        END_IF
    
    1: // Enable and move tool B to position
        Y20 := TRUE;
        D20 := D101;  // Set target position for A
        D21 := 1000;  // Set speed to 100%
        Y21 := TRUE;
        D24 := D103;  // Set target position for B
        D25 := 1000;  // Set speed to 100%
        
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 THEN
            toolBPositionReached := TRUE;
        END_IF

        IF toolBPositionReached AND ABS(D12 - D103) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF
        
    2: // Retract tool B
        D24 := 0;
        D25 := 1000;
        
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            toolBInitialRetract := TRUE;
        END_IF

        IF toolBInitialRetract THEN
            state := 3;
        END_IF
        
    3: // Enable and move tool C to position
        Y22 := TRUE;
        D20 := D102;  // Set target position for A
        D21 := 1000;  // Set speed to 100%
        D28 := D104;  // Set target position for C
        D29 := 1000;  // Set speed to 100%

        IF ABS(D10 - D102) <= 20 AND ABS(D11) <= 100 THEN
            toolCPositionReached := TRUE;
        END_IF

        IF toolCPositionReached AND ABS(D14 - D104) <= 20 AND ABS(D15) <= 100 THEN
            state := 4;
        END_IF
        
    4: // Retract tool C
        D28 := 0;
        D29 := 1000;
        
        IF ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            toolCInitialRetract := TRUE;
        END_IF
        
        IF toolCInitialRetract THEN
            state := 5;
        END_IF
        
    5: // Completion and cleanup
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;

        completionTimer(IN := TRUE, PT := T#100ms);
        
        IF completionTimer.Q THEN
            Y2 := TRUE;
            state := 6;
        END_IF
        
    6: // Maintain completion signal for 100 ms
        // Already handled in the previous state

END_CASE

END_PROGRAM