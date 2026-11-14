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
    D21 : DINT;
    Y2 : BOOL;
    
    target_X : REAL;
    current_X : REAL;
    current_Z : REAL;
    current_heading_deg : REAL;
    current_heading_vel_deg_s : REAL;
    current_X_vel : REAL;
    
    distance_to_target : REAL;
    forward_speed : REAL;
    yaw_rate_cmd : REAL;
    left_speed : REAL;
    right_speed : REAL;
    heading_rad : REAL;
    
    stable_timer : TON;
    obs_timer : TON;
    completion_met : BOOL;
    obs_complete : BOOL;
    
    Kz : REAL := 0.015;
    Kh : REAL := 5.5;
    HALF_WHEELBASE : REAL := 300.0;
    DEG_TO_RAD : REAL := 0.0174532925;
END_VAR

target_X := DINT_TO_REAL(D10) / 100.0;
current_X := DINT_TO_REAL(D11) / 100.0;
current_Z := DINT_TO_REAL(D13) / 100.0;
current_heading_deg := DINT_TO_REAL(D15) / 100.0;
current_heading_vel_deg_s := DINT_TO_REAL(D16) / 100.0;
current_X_vel := DINT_TO_REAL(D12) / 100.0;

IF X10 THEN
    distance_to_target := target_X - current_X;
    
    IF distance_to_target > 60.0 THEN
        forward_speed := 600.0;
    ELSIF distance_to_target > 0.0 THEN
        forward_speed := SQRT(6000.0 * distance_to_target);
    ELSE
        forward_speed := MAX(-20.0, distance_to_target * 2.0);
    END_IF;
    
    heading_rad := current_heading_deg * DEG_TO_RAD;
    yaw_rate_cmd := -Kz * current_Z - Kh * heading_rad;
    
    left_speed := forward_speed - yaw_rate_cmd * HALF_WHEELBASE;
    right_speed := forward_speed + yaw_rate_cmd * HALF_WHEELBASE;
    
    left_speed := MAX(-2000.0, MIN(2000.0, left_speed));
    right_speed := MAX(-2000.0, MIN(2000.0, right_speed));
    
    D20 := DINT(left_speed * 100.0);
    D21 := DINT(right_speed * 100.0);
    
    IF (ABS(target_X - current_X) <= 1.0) 
       AND (ABS(current_Z) <= 2.0) 
       AND (ABS(current_heading_deg) <= 0.3) 
       AND (ABS(current_X_vel) <= 2.0) 
       AND (ABS(current_heading_vel_deg_s) <= 1.0) THEN
        stable_timer(IN := TRUE, PT := T#30ms);
    ELSE
        stable_timer(IN := FALSE, PT := T#30ms);
        IF completion_met THEN
            completion_met := FALSE;
        END_IF;
        IF obs_complete THEN
            obs_complete := FALSE;
        END_IF;
    END_IF;
ELSE
    D20 := 0;
    D21 := 0;
    stable_timer(IN := FALSE, PT := T#30ms);
    IF completion_met THEN
        completion_met := FALSE;
    END_IF;
    IF obs_complete THEN
        obs_complete := FALSE;
    END_IF;
END_IF;

IF stable_timer.Q AND NOT completion_met THEN
    completion_met := TRUE;
END_IF;

IF completion_met AND NOT obs_complete THEN
    Y2 := TRUE;
    obs_timer(IN := TRUE, PT := T#100ms);
    IF obs_timer.Q THEN
        obs_complete := TRUE;
    END_IF;
ELSIF obs_complete THEN
    Y2 := TRUE;
    obs_timer(IN := FALSE, PT := T#100ms);
ELSE
    Y2 := FALSE;
    obs_timer(IN := FALSE, PT := T#100ms);
END_IF;

END_PROGRAM