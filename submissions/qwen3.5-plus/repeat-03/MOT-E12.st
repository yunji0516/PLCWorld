PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    req_edge : R_TRIG;
    scan_count : DINT;
    request_accepted : BOOL;
    
    target_raw : REAL;
    target_phys : REAL;
    actual_phys : REAL;
    speed_phys : REAL;
    error_phys : REAL;
    
    kp : REAL;
    vel_cmd_raw : REAL;
    clamped_cmd : DINT;
    
    abs_error : REAL;
    abs_speed : REAL;
    
    stable_timer : TON;
    completion_held : BOOL;
    
    obs_timer : TON;
    obs_complete : BOOL;
    
    scan_period_ms : DINT := 10;
END_VAR

(* Edge detection for X10 request *)
req_edge(CLK := X10);

(* Count scans from start *)
scan_count := scan_count + 1;

(* Accept request when X10 is TRUE *)
IF NOT request_accepted AND X10 THEN
    request_accepted := TRUE;
END_IF;

IF request_accepted AND NOT obs_complete THEN
    (* Convert inputs from raw (x0.01) to physical units *)
    target_raw := REAL#D10;
    target_phys := target_raw / 100.0;
    actual_phys := REAL#D11 / 100.0;
    speed_phys := REAL#D12 / 100.0;
    
    (* Calculate position error *)
    error_phys := target_phys - actual_phys;
    
    (* Absolute values for threshold checks *)
    abs_error := ABS(error_phys);
    abs_speed := ABS(speed_phys);
    
    (* Proportional control: velocity command *)
    (* Max expected error ~1000mm, max speed 1000mm/s -> kp ~1.0 *)
    kp := 1.0;
    vel_cmd_raw := kp * error_phys;
    
    (* Clamp velocity to speed limit of 1000 mm/s *)
    IF vel_cmd_raw > 1000.0 THEN
        vel_cmd_raw := 1000.0;
    END_IF;
    IF vel_cmd_raw < -1000.0 THEN
        vel_cmd_raw := -1000.0;
    END_IF;
    
    (* Convert velocity command to raw output (x0.01) *)
    clamped_cmd := DINT(vel_cmd_raw * 100.0);
    
    (* Clamp output to permitted command range [-200000, 200000] *)
    IF clamped_cmd > 200000 THEN
        clamped_cmd := 200000;
    END_IF;
    IF clamped_cmd < -200000 THEN
        clamped_cmd := -200000;
    END_IF;
    
    D20 := clamped_cmd;
    Y20 := TRUE;
    
    (* Check completion: error <= 0.2 mm (20 raw) and speed <= 1 mm/s (100 raw) *)
    stable_timer(IN := (abs_error <= 20.0) AND (abs_speed <= 100.0), PT := T#30ms);
    
    (* After 30 ms of meeting criteria, set completion held flag *)
    completion_held := stable_timer.Q;
    
    (* Once completion is held, start observation timer for 100 ms *)
    obs_timer(IN := completion_held, PT := T#100ms);
    obs_complete := obs_timer.Q;
    
    (* Set Y2 when completion is achieved *)
    IF completion_held THEN
        Y2 := TRUE;
    END_IF;
    
    (* Safety: enforce deadline of 240 scans *)
    IF scan_count >= 240 THEN
        Y20 := FALSE;
    END_IF;
END_IF;

END_PROGRAM