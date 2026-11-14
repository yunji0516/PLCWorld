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
    D102 : DINT;
    D103 : DINT;
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
    
    timer : TON;
    engageEdge : R_TRIG;
    disengageEdge : R_TRIG;
    stage : INT;
    safetyViolation : BOOL := FALSE;
    startTime : TIME;
    completionTime : TIME;
    
    // Constants
    FIRST_POSITION : DINT := 18000; // D101 (x100 scaling)
    SECOND_POSITION : DINT := 40000; // D102 (x100 scaling)
    MAX_DURATION : TIME := T#15100ms;
    SETTLING_TOLERANCE : DINT := 20; // 0.2 mm tolerance x 100 scaling
    SETTLING_SPEED : DINT := 100; // 1 mm/s tolerance x 100 scaling

END_VAR

// Initial Setup
IF NOT X0 THEN
    safetyViolation := FALSE;
    Y20 := FALSE; // Disable A
    Y21 := FALSE; // Disable B
    Y22 := FALSE; // Disable C
    Y23 := FALSE; // Disable D
    Y2 := FALSE;  // Completion signal
    stage := 0;
END_IF

// Detect Start Edge
engageEdge(CLK := X0);
disengageEdge(CLK := NOT X0);

IF engageEdge.Q THEN
    startTime := TIME();
    timer(IN := TRUE, PT := MAX_DURATION);
END_IF

// Timeout check
IF timer.Q THEN
    safetyViolation := TRUE;
END_IF

// Control Logic
CASE stage OF
    // Preparation Stage
    0:
        IF X0 THEN
            // Allow preparation of targets with axis disabled
            D28 := 0; // C target to work position
            D29 := 1000; // C rate to max
            D32 := D103; // D target to requested lane
            D33 := 1000; // D rate to max
            
            IF NOT safetyViolation THEN
                Y22 := TRUE; // Enable C
                Y23 := TRUE; // Enable D
                IF ABS(D14 - D28) <= SETTLING_TOLERANCE AND ABS(D15) <= SETTLING_SPEED AND 
                   ABS(D16 - D32) <= SETTLING_TOLERANCE AND ABS(D17) <= SETTLING_SPEED THEN
                    stage := 1;
                END_IF
            END_IF
        END_IF
    // First Positioning and Engage Guide
    1:
        D20 := FIRST_POSITION; // A target
        D21 := 1000; // A rate
        D24 := 7000; // B target - engage in groove
        D25 := 1000; // B rate
        
        Y20 := TRUE; // Enable A
        Y21 := TRUE; // Enable B
        
        IF ABS(D10 - D20) <= SETTLING_TOLERANCE AND ABS(D11) <= SETTLING_SPEED AND 
           ABS(D12 - D24) <= SETTLING_TOLERANCE AND ABS(D13) <= SETTLING_SPEED THEN
            stage := 2;
        END_IF

    // Second Positioning
    2:
        D20 := SECOND_POSITION;

        IF (ABS(D14) > SETTLING_TOLERANCE OR ABS(D16 - D32) > SETTLING_TOLERANCE) THEN
            stage := 0; // Revert to preparation if conditions fail
        ELSIF (ABS(D10 - D20) <= SETTLING_TOLERANCE AND ABS(D11) <= SETTLING_SPEED AND 
               ABS(D12 - D24) <= SETTLING_TOLERANCE AND ABS(D13) <= SETTLING_SPEED) THEN
            Y2 := TRUE;
            completionTime := TIME();
            stage := 3;
        END_IF

    // Completion Stage
    3:
        IF TIME() >= completionTime + T#100ms THEN
            // Retract B and return to initial
            D24 := 0; // Retract B
            D28 := 8000; // C to standby
            D32 := 0;   // D to initial position
            Y2 := FALSE; // Completion signal reset

            IF (ABS(D12 - D24) <= SETTLING_TOLERANCE AND ABS(D13) <= SETTLING_SPEED AND 
                ABS(D14 - D28) <= SETTLING_TOLERANCE AND ABS(D15) <= SETTLING_SPEED AND 
                ABS(D16 - D32) <= SETTLING_TOLERANCE AND ABS(D17) <= SETTLING_SPEED) THEN
                Y21 := FALSE; // Disable B
                Y22 := FALSE; // Disable C
                Y23 := FALSE; // Disable D
                stage := 0;
            END_IF
        END_IF
END_CASE

END_PROGRAM