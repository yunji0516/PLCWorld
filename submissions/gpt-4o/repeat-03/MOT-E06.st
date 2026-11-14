PROGRAM Main
VAR
    X10 : BOOL;      // Function request
    D11 : DINT;      // V actual position · mm ×0.01
    D12 : DINT;      // V actual velocity · mm/s ×0.01
    X11 : BOOL;      // Brake engagement
    X12 : BOOL;      // External torque support
    Y20 : BOOL;      // Function activation/retention
    Y2 : BOOL;       // Function result retention

    // Internal variables
    requestAccepted : BOOL := FALSE;
    heightMaintained : BOOL := FALSE;
    initialPosition : DINT := 0;
    heightTimer : TON;     // Timer to maintain height for 30 ms
    resultTimer : TON;     // Timer to observe result retention for 100 ms
    brakeTimer : TON;      // Timer for brake engagement time
END_VAR

// Implement the control logic
IF requestAccepted = FALSE THEN
    IF X10 THEN
        // Accept function request
        requestAccepted := TRUE;
        
        // Record initial position
        initialPosition := D11;
        
        // Activate the function and engage the brake
        Y20 := TRUE;
        
        // Start brake timer
        brakeTimer(IN := TRUE, PT := T#80ms); // Full brake response time 80 ms
    END_IF
END_IF

// Check brake engagement and loss of external torque support
IF requestAccepted AND X11 AND NOT X12 THEN
    // Engage the brake fully and ensure position is stable
    brakeTimer(IN := FALSE);

    // Check and maintain height within ±0.2 mm
    IF (D11 >= initialPosition - 20) AND (D11 <= initialPosition + 20) THEN
        heightMaintained := TRUE;
    END_IF
END_IF

// Maintain height for 30 ms
heightTimer(IN := heightMaintained, PT := T#30ms);

// Result retention logic
IF heightTimer.Q THEN
    Y2 := TRUE;
    // Start observation timer for result retention
    resultTimer(IN := TRUE, PT := T#100ms);
ELSE
    resultTimer(IN := FALSE);
END_IF

// Completion: if the result is observed for 100 ms, retain final state
IF resultTimer.Q THEN
    Y20 := FALSE;    // Disengage function activation
END_IF

END_PROGRAM