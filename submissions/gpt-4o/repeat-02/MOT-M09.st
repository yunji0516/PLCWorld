PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    
    // Internal variables
    state : INT := 0;
    lock_position : DINT := 6000; // 60 mm in position units
    target_depth : DINT;
    timer : TON;
    trigger : R_TRIG;
    
END_VAR

// Main program logic
trigger(CLK := X0);

CASE state OF
    0: // Wait for start command
        IF trigger.Q THEN
            target_depth := MIN(MAX(D101, 5500), 6500); // Clamp depth to [55, 65] mm
            state := 1;
        END_IF

    1: // Move to locking position
        Y20 := TRUE; // Enable A
        D20 := 10000; // A target 100 mm
        D21 := 1000; // Full speed

        Y21 := TRUE; // Enable B
        D24 := lock_position; // B target 60 mm
        D25 := 1000; // Full speed

        Y22 := TRUE; // Enable C
        D28 := lock_position; // C target 60 mm
        D29 := 1000; // Full speed

        IF (ABS(D10 - 10000) <= 20) AND (D11 <= 100) AND 
           (ABS(D12 - lock_position) <= 20) AND (D13 <= 100) AND
           (ABS(D14 - lock_position) <= 20) AND (D15 <= 100) THEN
            // All positions arrived and speeds at stop
            state := 2;
        END_IF

    2: // Enable D movement to depth
        Y23 := TRUE; // Enable D
        D32 := target_depth; // D target to requested depth
        D33 := 1000; // Full speed

        IF (D16 >= 500) AND (ABS(D16 - target_depth) <= 20) AND (D17 <= 100) THEN
            // Locking posture maintained and depth reached
            state := 3;
        ELSIF (ABS(D12 - lock_position) > 20) OR (ABS(D14 - lock_position) > 20) THEN
            // Locking posture broken
            state := 5;
        END_IF

    3: // Hold the position for 100ms
        timer(IN := TRUE, PT := T#100ms);
        
        IF timer.Q THEN
            state := 4;
        END_IF

    4: // Retract all axes to origin
        D20 := 0;
        D24 := 0;
        D28 := 0;
        D32 := 0;

        IF (ABS(D10) <= 20) AND (D11 <= 100) AND 
           (ABS(D12) <= 20) AND (D13 <= 100) AND
           (ABS(D14) <= 20) AND (D15 <= 100) AND
           (ABS(D16) <= 20) AND (D17 <= 100) THEN
            // All axes retracted to the start position
            state := 6;
        END_IF

    5: // Functional failure if locking posture breaks while D > 5
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

    6: // Completion state
        Y2 := TRUE;
        timer(IN := TRUE, PT := T#100ms);
        
        IF timer.Q THEN
            // Completion condition fulfilled, reset state
            Y2 := FALSE;
            state := 0;
        END_IF
END_CASE

END_PROGRAM