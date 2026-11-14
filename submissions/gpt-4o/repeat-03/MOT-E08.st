PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    // Internal Variables
    target_position : DINT;
    feedforward_velocity : DINT;
    request_accepted : BOOL := FALSE;
    stability_timer : TON;
    completion_timer : TON;
    edge_trigger : R_TRIG;
END_VAR

// Accept the function request
edge_trigger(CLK := X10);
IF edge_trigger.Q THEN
    request_accepted := TRUE;
END_IF

// Main Command Calculation
IF request_accepted THEN
    target_position := D13 + D10;
    feedforward_velocity := D12;
    
    // Clamp the values within the permissible range
    target_position := LIMIT(-200000, target_position, 200000);
    feedforward_velocity := LIMIT(-200000, feedforward_velocity, 200000);
    
    // Activation/Retaining of the function
    Y20 := TRUE;
    D20 := target_position;
    D21 := feedforward_velocity;

    // Check for Errors and Stability
    IF ABS(D11 - target_position) <= 30 AND ABS(D12 - feedforward_velocity) <= 200 THEN
        // Stability observed for 30 ms
        stability_timer(IN := TRUE, PT := T#30ms);
        IF stability_timer.Q THEN
            Y2 := TRUE;
            completion_timer(IN := TRUE, PT := T#250ms);
        END_IF
    ELSE
        // Reset stability timer if conditions are not met
        stability_timer(IN := FALSE);
    END_IF

    // Completion handling
    IF completion_timer.Q THEN
        Y20 := FALSE;
        request_accepted := FALSE; // Reset for the next request
    END_IF
ELSE
    Y20 := FALSE;
    stability_timer(IN := FALSE);
    completion_timer(IN := FALSE);
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
END_IF

END_PROGRAM