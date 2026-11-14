PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    Y20 : BOOL := FALSE;
    D20 : DINT := 0;
    D21 : DINT := 0;
    Y2 : BOOL := FALSE;
    
    // Internal variables
    wrist_target : DINT := 0;
    wrist_velocity : DINT := 0;
    total_angle : REAL := 0.0;
    request_accepted : BOOL := FALSE;
    stability_counter : INT := 0;
    completion_observation_counter : INT := 0;
END_VAR

// Function to check angle limits
FUNCTION CheckAngleLimits : BOOL
VAR_INPUT
    angle : REAL;
END_VAR
CONST
    LIMIT : REAL := 2.0; // allowable limit in degrees
END_CONST
BEGIN
    CheckAngleLimits := (ABS(angle) <= LIMIT);
END_FUNCTION

// Function to compute wrist target and velocity
FUNCTION ComputeWristControl : BOOL
VAR_INPUT
    joint_a : DINT;
    joint_b : DINT;
    joint_c : DINT;
END_VAR
VAR
    wrist_position_change : DINT;
END_VAR
CONST
    MULTIPLIER : REAL := 0.01; // Scaling factor for conversion
END_CONST
BEGIN
    // Calculate total orientation
    total_angle := REAL(joint_a + joint_b + joint_c) * MULTIPLIER;
    
    // Calculate necessary wrist adjustments
    wrist_position_change := -(joint_a + joint_b) / 2;
    wrist_target := DINT(wrist_position_change);
    wrist_velocity := -(D14 + D16) / 2;
    
    // Ensure commands stay within bounds
    wrist_target := LIMIT(wrist_target, -200000, 200000);
    wrist_velocity := LIMIT(wrist_velocity, -200000, 200000);

    RETURN CheckAngleLimits(total_angle);
END_FUNCTION

// Main logic
IF NOT request_accepted THEN
    IF X10 THEN
        // Accept the function request
        request_accepted := TRUE;
        Y20 := TRUE;
    END_IF;
ELSE
    // Maintain tool orientation
    IF ComputeWristControl(D13, D15, D11) THEN
        // Update D20 and D21 when within limits
        D20 := wrist_target;
        D21 := wrist_velocity;

        // Check if orientation can be retained for stability period
        IF stability_counter >= 3 THEN
            Y2 := TRUE; // Assert after 30ms
        ELSE
            stability_counter := stability_counter + 1;
        END_IF;
        
        // Handle completion observation interval
        IF Y2 THEN
            completion_observation_counter := completion_observation_counter + 1;
            IF completion_observation_counter >= 130 THEN
                // Task complete after 1300ms
                request_accepted := FALSE;
                Y20 := FALSE;
                Y2 := FALSE;
            END_IF;
        END_IF;
        
    ELSE
        // Reset counters if outside limits
        stability_counter := 0;
        completion_observation_counter := 0;
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM