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
    D20 : DINT;
    Y2 : BOOL;
    
    sway_angle : REAL;
    sway_velocity : REAL;
    trolley_pos : REAL;
    trolley_vel : REAL;
    target_pos : REAL;
    accel_cmd : REAL;
    
    kp_sway : REAL := 300.0;
    kd_sway : REAL := 200.0;
    kp_pos : REAL := 5.0;
    kd_pos : REAL := 20.0;
    
    max_accel : REAL := 1800.0;
    
    result_timer : TON;
    request_received : BOOL;
    result_ready : BOOL;
END_VAR

// Read inputs and convert to physical units
sway_angle := REAL(D15) * 0.01;
sway_velocity := REAL(D16) * 0.01;
trolley_pos := REAL(D11) * 0.01;
trolley_vel := REAL(D12) * 0.01;
target_pos := REAL(D10) * 0.01;

// Detect function request
IF X10 THEN
    request_received := TRUE;
END_IF;

// Apply sway-reduction PD control with position correction
IF request_received THEN
    accel_cmd := kp_sway * sway_angle + kd_sway * sway_velocity
                 - kp_pos * (trolley_pos - target_pos) - kd_pos * trolley_vel;
    
    // Clamp to maximum acceleration limit
    IF accel_cmd > max_accel THEN
        accel_cmd := max_accel;
    ELSIF accel_cmd < -max_accel THEN
        accel_cmd := -max_accel;
    END_IF;
    
    // Convert to D20 output (physical acceleration × 100)
    D20 := DINT(accel_cmd * 100.0);
ELSE
    D20 := 0;
END_IF;

// Check completion conditions and apply 30 ms stability requirement
IF request_received AND NOT result_ready THEN
    IF ABS(sway_angle) <= 0.2 AND ABS(sway_velocity) <= 1.0 
       AND ABS(trolley_pos - target_pos) <= 1.0 AND ABS(trolley_vel) <= 1.0 THEN
        result_timer(IN := TRUE, PT := T#30ms);
    ELSE
        result_timer(IN := FALSE, PT := T#30ms);
    END_IF;
    
    IF result_timer.Q THEN
        result_ready := TRUE;
    END_IF;
END_IF;

// Set function result output
IF result_ready THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

// Ensure D20 stays within permitted raw bounds
IF D20 > 200000 THEN D20 := 200000; END_IF;
IF D20 < -200000 THEN D20 := -200000; END_IF;

END_PROGRAM