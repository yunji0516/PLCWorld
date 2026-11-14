PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;
    
    state : DINT := 0;
    master_pos : REAL := 0.0;
    last_master_vel : REAL := 0.0;
    target_pos : REAL := 0.0;
    dist : REAL := 0.0;
    desired_vel : REAL := 0.0;
    abs_dist : REAL := 0.0;
    master_vel : REAL := 0.0;
    c_target_internal : DINT := 10000;
END_VAR

IF NOT X0 AND state = 0 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y31 := FALSE;
    Y2 := FALSE;
    D21 := 0;
    D25 := 0;
    D29 := 0;
    RETURN;
END_IF;

IF state = 0 AND X0 THEN
    target_pos := REAL(D101) / 100.0;
    master_pos := REAL(D10) / 100.0; 
    last_master_vel := 0.0;
    c_target_internal := 53000;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    D21 := 1000;
    D25 := 1000;
    D29 := 1000;
    state := 1;
END_IF;

IF state = 1 THEN
    IF X4 AND ABS(D14 - 53000) <= 20 AND ABS(D15) <= 100 THEN
        state := 2;
    END_IF;
END_IF;

IF state = 2 THEN
    Y30 := TRUE;
    Y31 := FALSE;
    IF X2 THEN
        state := 3;
        c_target_internal := D102;
    END_IF;
END_IF;

IF state = 3 THEN
    IF ABS(D14 - D102) <= 20 AND ABS(D15) <= 100 THEN
        state := 4;
    END_IF;
END_IF;

IF state = 4 THEN
    Y30 := FALSE;
    Y31 := TRUE;
    IF X1 THEN
        state := 5;
        target_pos := 0.0;
    END_IF;
END_IF;

IF state = 5 THEN
    IF ABS(D10) <= 20 AND ABS(D12) <= 20 AND ABS(D11) <= 100 AND ABS(D13) <= 100 THEN
        state := 6;
    END_IF;
END_IF;

IF state = 6 THEN
    Y2 := TRUE;
END_IF;

IF state >= 1 THEN
    dist := target_pos - master_pos;
    IF dist > 0.0 THEN
        abs_dist := dist;
        desired_vel := 0.85 * SQRT(800.0 * abs_dist);
        IF 20.0 * abs_dist < desired_vel THEN
            desired_vel := 20.0 * abs_dist;
        END_IF;
        IF desired_vel > 100.0 THEN
            desired_vel := 100.0;
        END_IF;
    ELSIF dist < 0.0 THEN
        abs_dist := -dist;
        desired_vel := 0.85 * SQRT(800.0 * abs_dist);
        IF 20.0 * abs_dist < desired_vel THEN
            desired_vel := 20.0 * abs_dist;
        END_IF;
        IF desired_vel > 100.0 THEN
            desired_vel := 100.0;
        END_IF;
        desired_vel := -desired_vel;
    ELSE
        desired_vel := 0.0;
    END_IF;

    IF desired_vel > last_master_vel + 4.0 THEN
        master_vel := last_master_vel + 4.0;
    ELSIF desired_vel < last_master_vel - 4.0 THEN
        master_vel := last_master_vel - 4.0;
    ELSE
        master_vel := desired_vel;
    END_IF;

    master_pos := master_pos + master_vel * 0.01;
    last_master_vel := master_vel;

    D20 := DINT(master_pos * 100.0);
    D24 := DINT(master_pos * 100.0);
    
    D28 := c_target_internal;
END_IF;

END_PROGRAM