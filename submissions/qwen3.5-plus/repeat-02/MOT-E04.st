PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    scan_count : DINT;
    accel_limit_raw : DINT := 1350;
    
    cmd_raw : DINT;
    hold_time_ms : REAL;
    obs_start : DINT;
    
    target_diff : DINT;
    speed_err : DINT;
    abs_err : DINT;
END_VAR

scan_count := scan_count + 1;

IF X10 AND (scan_count >= 3) THEN
    Y20 := TRUE;
    
    (* Ramp commanded speed toward target with acceleration limit *)
    target_diff := D10 - cmd_raw;
    
    IF target_diff > accel_limit_raw THEN
        cmd_raw := cmd_raw + accel_limit_raw;
    ELSIF target_diff < -accel_limit_raw THEN
        cmd_raw := cmd_raw - accel_limit_raw;
    ELSE
        cmd_raw := D10;
    END_IF;
    
    D20 := cmd_raw;
    
    (* Check speed error tolerance *)
    speed_err := D12 - cmd_raw;
    IF speed_err < 0 THEN
        abs_err := -speed_err;
    ELSE
        abs_err := speed_err;
    END_IF;
    
    IF abs_err <= 200 THEN
        (* Accumulate hold time within tolerance (2 deg/s = 200 raw) *)
        hold_time_ms := hold_time_ms + 10.0;
    ELSE
        hold_time_ms := 0.0;
    END_IF;
    
    (* Start 250ms observation after 30ms stable hold *)
    IF hold_time_ms >= 30.0 AND obs_start = 0 THEN
        obs_start := scan_count;
        Y2 := TRUE;
    END_IF;
    
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    cmd_raw := 0;
    hold_time_ms := 0.0;
    obs_start := 0;
END_IF;

END_PROGRAM