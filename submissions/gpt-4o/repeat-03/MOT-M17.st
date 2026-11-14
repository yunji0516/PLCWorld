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
    isActive : BOOL := FALSE;
    stage : INT := 0;
    
    aPositionTarget : DINT := 0;
    bPositionTarget : DINT := 9000; // B = 90 degrees
    cPositionTarget : DINT;
    dPositionTarget : DINT := 0;
    completionTimer : TON;
END_VAR

// Control logic implementation
IF X0 THEN
    isActive := TRUE;
END_IF

IF isActive THEN
    CASE stage OF
        // Stage 0: Check feeder at A=0
        0:
            Y20 := TRUE; // Enable A axis
            D20 := aPositionTarget;
            D21 := 1000; // 100% rate
            
            IF ABS(D10 - aPositionTarget) <= 20 AND ABS(D11) <= 100 THEN
                // Feeder A is at 0, move to next stage
                stage := 1;
            END_IF
            
        // Stage 1: Head approach B=90, C=request_target, D=0
        1:
            Y21 := TRUE; // Enable B axis
            D24 := bPositionTarget;
            D25 := 1000; // 100% rate
            
            Y22 := TRUE; // Enable C axis
            D28 := D101; // Target position from request_target
            D29 := 1000; // 100% rate
            
            Y23 := TRUE; // Enable D axis
            D32 := dPositionTarget;
            D33 := 1000; // 100% rate
            
            // Check if B, C, D have reached targets
            IF ABS(D12 - bPositionTarget) <= 20 AND ABS(D13) <= 100 AND
               ABS(D14 - D101) <= 20 AND ABS(D15) <= 100 AND
               ABS(D16 - dPositionTarget) <= 20 AND ABS(D17) <= 100 THEN
                // All targets reached, move to next stage
                stage := 2;
            END_IF
        
        // Stage 2: Return to initial conditions
        2:
            Y20 := TRUE;
            D20 := 28000; // Return A to 280 mm
            D21 := 1000;
            
            Y21 := TRUE;
            D24 := 0; // Return B to 0 degrees
            D25 := 1000;
            
            Y22 := TRUE;
            D28 := 0; // Return C to 0 mm
            D29 := 1000;
            
            Y23 := TRUE;
            D32 := 10000; // Return D to 100 mm
            D33 := 1000;
            
            // Check if A, B, C, D have returned
            IF ABS(D10 - 28000) <= 20 AND ABS(D11) <= 100 AND
               ABS(D12) <= 20 AND ABS(D13) <= 100 AND
               ABS(D14) <= 20 AND ABS(D15) <= 100 AND
               ABS(D16 - 10000) <= 20 AND ABS(D17) <= 100 THEN
                // Set completion and initialise timer
                Y2 := TRUE;
                completionTimer(IN := TRUE, PT := T#100ms); 
                stage := 3;
            END_IF
        
        // Stage 3: Completion hold for 100ms
        3:
            IF completionTimer.Q THEN
                Y2 := FALSE; // Clear completion after hold
                isActive := FALSE; // Cycle complete, stop process
                stage := 0; // Reset for next cycle
            END_IF
    END_CASE
ELSE
    // Disable all axes when not active
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
END_IF

END_PROGRAM