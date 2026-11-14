PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT; // S actual position · deg ×0.01
    D12 : DINT; // S actual speed · deg/s ×0.01
    D13 : DINT; // U actual position · deg ×0.01
    D14 : DINT; // U actual velocity · deg/s ×0.01
    D10 : DINT; // Requested gear ratio ×0.001
    D17 : DINT; // Relationship error ×0.01
    Y20 : BOOL;
    D20 : DINT; // Gear ratio command ×0.001
    Y2 : BOOL;
    // Internal variables
    synched : BOOL := FALSE;
    ratio : REAL := 0.0;
    master_position_reference : DINT := 0;
    slave_position_reference : DINT := 0;
    gear_ratio_real : REAL;
    velocity_error_limit : REAL := 200.0; // 2.0 deg/s ×0.01
    phase_error_limit : REAL := 30.0; // 0.3 deg ×0.01
    timer_start : TIME := T#0ms;
    completion_observed : BOOL := FALSE;
    observation_time : TIME := T#0ms;
    is_within_limits : BOOL := TRUE;
END_VAR

// Synchronize the slave axis to the master axis
gear_ratio_real := DINT_TO_REAL(D10) * 0.001;

// Calculate desired slave position based on master position
IF synched THEN
    IF X10 AND (ABS(D17) <= phase_error_limit) THEN
        is_within_limits := (ABS(D12 - REAL_TO_INT(gear_ratio_real * REAL(D14))) <= velocity_error_limit);

        // Check completion conditions
        IF is_within_limits THEN
            IF NOT completion_observed THEN
                observation_time := TIME();
                completion_observed := TRUE;
            END_IF
        ELSE
            completion_observed := FALSE;
        END_IF

        // Retain outputs if conditions are met
        IF completion_observed AND (TIME() - observation_time >= T#250ms) THEN
            Y2 := TRUE;
            Y20 := FALSE; // Release function activation
        ELSE
            Y2 := FALSE;
            Y20 := TRUE; // Keep function activation
        END_IF
    ELSE
        Y2 := FALSE;
        Y20 := FALSE; // Function not active when limits exceeded or X10 deactivated
        completion_observed := FALSE;
    END_IF
ELSE
    // Set reference positions upon synchronization command
    IF X10 THEN
        synched := TRUE;
        master_position_reference := D13;
        slave_position_reference := D11;
        timer_start := TIME(); // Start the timer when the function request is first accepted
    END_IF
END_IF

// Keep D20 up-to-date to reflect the gear ratio command
D20 := D10;

END_PROGRAM