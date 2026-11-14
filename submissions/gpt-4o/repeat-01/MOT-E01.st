PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    target_position : REAL;
    actual_position : REAL;
    actual_speed : REAL;
    position_error : REAL;
    request_accepted : BOOL := FALSE;
    position_stable_timer : TON;
    result_retention : TON;
    retaining_result : BOOL := FALSE;
END_VAR

// Convert the input values to REAL for computation
target_position := REAL(D10) * 0.01;
actual_position := REAL(D11) * 0.01;
actual_speed := REAL(D12) * 0.01;

// Compute the position error
position_error := ABS(target_position - actual_position);

// Start accepting the request when X10 is TRUE
IF X10 THEN
    request_accepted := TRUE;
END_IF

// Handle the function request and control logic
IF request_accepted THEN
    // Activate the axis function
    Y20 := TRUE;

    // Compute the command value, ensuring it stays within bounds
    D20 := DINT(target_position * 100);
    D20 := LIMIT(-200000, D20, 200000);

    // Check if we have achieved position and speed stability
    IF position_error <= 0.2 AND actual_speed <= 1.0 THEN
        // Start the position stable timer
        position_stable_timer(IN := TRUE, PT := T#30ms);

        // If the position stability has been maintained for 30ms, set Y2 TRUE
        IF position_stable_timer.Q THEN
            Y2 := TRUE;
            retaining_result := TRUE;
        END_IF
    ELSE
        // Reset the position stable timer if conditions are not met
        position_stable_timer(IN := FALSE);
        Y2 := FALSE;
    END_IF
ELSE
    // Ensure D20 output is zero if the request is not accepted
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    retaining_result := FALSE;
END_IF

// Handle result retention when stability is achieved
IF retaining_result THEN
    result_retention(IN := TRUE, PT := T#100ms);

    // Reset the system state once retention observation is completed
    IF result_retention.Q THEN
        Y20 := FALSE;
        D20 := 0;
        Y2 := FALSE;
        request_accepted := FALSE;
        retaining_result := FALSE;
    END_IF
ELSE
    result_retention(IN := FALSE);
END_IF

END_PROGRAM