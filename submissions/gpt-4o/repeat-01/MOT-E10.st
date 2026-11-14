PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    // Internal variables
    requested_angle : DINT;
    actual_position : DINT;
    actual_speed : DINT;
    error : REAL;
    command_value : DINT;
    timer_maintain : TON;
    timer_retention : TON;
    activation_edge : R_TRIG;
    target_reached : BOOL := FALSE;
END_VAR

// Read current inputs
requested_angle := D10;
actual_position := D11;
actual_speed := D12;

// Calculate error in degrees
error := REAL(actual_position) * 0.01 - REAL(requested_angle) * 0.01;

// Detect rising edge of function request
activation_edge(CLK := X10);

// Control logic
IF activation_edge.Q THEN
    // Start function activation
    Y20 := TRUE;
END_IF

IF Y20 THEN
    // Calculate command value
    command_value := requested_angle;

    // Limit command value within allowed range
    command_value := LIMIT(-200000, command_value, 200000);

    // Set command output
    D20 := command_value;
    
    // Check if target is reached
    IF ABS(error) <= 0.2 AND ABS(REAL(actual_speed) * 0.01) <= 1.0 THEN
        target_reached := TRUE;
        timer_maintain(IN := TRUE, PT := T#30ms);
    ELSE
        target_reached := FALSE;
        timer_maintain(IN := FALSE);
    END_IF
    
    IF target_reached AND timer_maintain.Q THEN
        Y2 := TRUE;  // Function result retention
        timer_retention(IN := TRUE, PT := T#100ms);
    ELSE
        timer_retention(IN := FALSE);
    END_IF
    
    // Check retention timer
    IF timer_retention.Q THEN
        Y20 := FALSE;  // Deactivate function
    END_IF
ELSE
    // Reset outputs if function is not active
    Y2 := FALSE;
    D20 := 0;
END_IF

END_PROGRAM