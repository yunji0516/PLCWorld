PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    startConditionMet : BOOL := FALSE;
    supportMomentM : REAL;
    headAngle : REAL;
    counterweightPosition : REAL;
    a_sin_headAngle : REAL;
    targetCounterweightPosition : REAL;
    auxiliarySpeedCommand : REAL;
    
    retentionTimer : TIME := T#0ms;
    positionCommand : DINT;
    speedCommand : DINT;
    
    completionTimer : TON;
    maintenanceTimer : TON;
    requestAccepted : BOOL := FALSE;
    
END_VAR

(* Control logic *)
headAngle := REAL(D13) / 100.0;
counterweightPosition := REAL(D11) / 100.0;

// Calculate the support moment M
a_sin_headAngle := 30.0 * 9.81 * 0.3 * SIN(headAngle);
supportMomentM := a_sin_headAngle + 20.0 * 9.81 * counterweightPosition / 1000.0;

// Ensure the absolute support moment M is within safe limits
IF ABS(supportMomentM) > 25.0 THEN
    // Safety violation; do not proceed
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    RETURN;
END_IF

// Check if function request is accepted
IF X10 AND NOT requestAccepted THEN
    requestAccepted := TRUE;
END_IF

// Act only if the function request is active
IF requestAccepted THEN
    Y20 := TRUE;
    
    // Calculate target counterweight position to maintain |M| ≤ 1 Nm
    targetCounterweightPosition := (-a_sin_headAngle / (20.0 * 9.81)) * 1000.0;
    
    // Calculate feedforward speed for smooth positioning
    auxiliarySpeedCommand := (targetCounterweightPosition - counterweightPosition) / 0.01; // Assuming 0.01s move time
    
    // Convert commands to integer values
    positionCommand := DINT(ROUND(targetCounterweightPosition * 100.0));
    speedCommand := DINT(ROUND(auxiliarySpeedCommand * 100.0));
    
    // Limit the command outputs to within specified bounds
    positionCommand := LIMIT(-200000, positionCommand, 200000);
    speedCommand := LIMIT(-200000, speedCommand, 200000);
    
    // Apply the commands
    D20 := positionCommand;
    D21 := speedCommand;

    // Start and monitor completion and maintenance times
    IF NOT completionTimer.Q THEN
        completionTimer(IN := TRUE, PT := T#1400ms);
    END_IF

    IF completionTimer.Q THEN
        IF NOT maintenanceTimer.Q THEN
            maintenanceTimer(IN := TRUE, PT := T#1400ms);
        END_IF
    END_IF

    // Confirm result retention and end observation
    IF maintenanceTimer.Q AND ABS(supportMomentM) <= 1.0 THEN
        Y2 := TRUE;
    END_IF
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    // Reset timers and state if request ceases
    completionTimer(IN := FALSE);
    maintenanceTimer(IN := FALSE);
    requestAccepted := FALSE;
END_IF

END_PROGRAM