PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    func_active : BOOL;
    speed_maintained : BOOL;
    stable_count : DINT;
    
    dist_raw : DINT;
    dist : REAL;
    speed_abs : REAL;
    decel_needed : REAL;
    decel_raw : REAL;
    within_limit : BOOL;
    approach_dir : INT;
END_VAR

IF X10 AND NOT func_active THEN
    func_active := TRUE;
    Y20 := TRUE;
    IF D12 > 0 THEN
        approach_dir := 1;
    ELSIF D12 < 0 THEN
        approach_dir := -1;
    ELSE
        approach_dir := 0;
    END_IF;
END_IF;

IF NOT func_active THEN
    D20 := 0;
END_IF;

IF func_active THEN
    IF D12 > 0 THEN
        IF D13 > D11 THEN
            dist_raw := D13 - D11;
        ELSE
            dist_raw := 0;
        END_IF;
    ELSIF D12 < 0 THEN
        IF D11 > D13 THEN
            dist_raw := D11 - D13;
        ELSE
            dist_raw := 0;
        END_IF;
    ELSE
        dist_raw := 0;
    END_IF;
    
    IF dist_raw > 0 THEN
        dist := DINT_TO_REAL(dist_raw) / 100.0;
        speed_abs := ABS(DINT_TO_REAL(D12)) / 100.0;
        decel_needed := (speed_abs * speed_abs) / (2.0 * dist);
        decel_raw := decel_needed * 100.0;
    ELSE
        decel_raw := 0.0;
    END_IF;
    
    IF decel_raw < 0.0 THEN
        decel_raw := 0.0;
    ELSIF decel_raw > 400000.0 THEN
        decel_raw := 400000.0;
    END_IF;
    
    D20 := DINT(decel_raw);
    
    speed_abs := ABS(DINT_TO_REAL(D12)) / 100.0;
    
    IF approach_dir = 1 THEN
        within_limit := D11 <= D13;
    ELSIF approach_dir = -1 THEN
        within_limit := D11 >= D13;
    ELSE
        within_limit := TRUE;
    END_IF;
    
    IF speed_abs <= 1.0 AND within_limit THEN
        IF NOT speed_maintained THEN
            stable_count := 1;
            speed_maintained := TRUE;
        ELSE
            stable_count := stable_count + 1;
            IF stable_count >= 3 THEN
                Y2 := TRUE;
            END_IF;
        END_IF;
    ELSE
        speed_maintained := FALSE;
        stable_count := 0;
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM