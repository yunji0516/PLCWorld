PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    // Internal variables
    referenceSet : BOOL := FALSE;
    U0 : DINT := 0;
    S0 : DINT := 0;
    ratio : REAL;
    phaseError : REAL;
    velocityError : REAL;
    syncComplete : BOOL := FALSE;
    completionTime : DINT := 0;
    retentionTime : DINT := 0;
    scanCounter : DINT := 0;
END_VAR

// Implement the control logic
IF X10 THEN
    // Convert requested ratio to a usable floating point value
    ratio := REAL(D10) * 0.001;
    
    // On rising edge of Y20, set the synchronization reference
    IF NOT referenceSet THEN
        U0 := D13;
        S0 := D11;
        Y20 := TRUE;  // Set Y20 to indicate function activation
        referenceSet := TRUE;
    END_IF
    
    // Calculate the current phase and velocity errors
    phaseError := REAL(D11 - S0) - ratio * REAL(D13 - U0);
    velocityError := REAL(D12) - ratio * REAL(D14);
    
    // Check phase and velocity error limits
    IF ABS(phaseError) <= 30.0 AND ABS(velocityError) <= 200.0 THEN
        syncComplete := TRUE;
        RETAIN Y2 := TRUE;
    ELSE
        syncComplete := FALSE;
    END_IF
    
    // If synchronization is complete, start completion counting
    IF syncComplete AND retentionTime = 0 THEN
        retentionTime := scanCounter;
    END_IF
    
    // Check if the synchronization result has been maintained for 30 ms
    IF syncComplete AND ((scanCounter - retentionTime) * 10 >= 30) THEN
        IF completionTime = 0 THEN
            completionTime := scanCounter;
        END_IF
    END_IF
    
    // Check if result retention observation of 250 ms is complete
    IF Y2 AND completionTime > 0 AND ((scanCounter - completionTime) * 10 >= 250) THEN
        // Execution ends
    END_IF
    
ELSE
    // Reset the synchronization if X10 is not active
    referenceSet := FALSE;
    Y20 := FALSE;
    Y2 := FALSE;
    syncComplete := FALSE;
    retentionTime := 0;
    completionTime := 0;
END_IF

// Update gear ratio command
D20 := D10;

// Increment the scan counter
scanCounter := scanCounter + 1;

END_PROGRAM