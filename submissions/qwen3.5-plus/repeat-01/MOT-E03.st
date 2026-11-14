PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    dist : DINT;
    speed_abs : DINT;
    decel_calc : REAL;
    decel_raw : DINT;
    hold_timer : TON;
    obs_timer : TON;
    hold_acquired : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    speed_abs := ABS(D12);
    dist := ABS(D13 - D11);
    
    IF dist = 0 THEN
        decel_raw := 400000;
    ELSE
        decel_calc := REAL(speed_abs) * REAL(speed_abs) / (2.0 * REAL(dist));
        decel_raw := DINT(decel_calc);
    END_IF;
    
    IF decel_raw > 400000 THEN
        decel_raw := 400000;
    END_IF;
    
    D20 := decel_raw;
    
    IF ABS(D12) <= 100 THEN
        hold_timer(IN := TRUE, PT := T#30ms);
    ELSE
        hold_timer(IN := FALSE);
        hold_acquired := FALSE;
        obs_timer(IN := FALSE);
        Y2 := FALSE;
    END_IF;
    
    IF hold_timer.Q THEN
        hold_acquired := TRUE;
    END_IF;
    
    IF hold_acquired THEN
        obs_timer(IN := TRUE, PT := T#100ms);
        Y2 := TRUE;
    ELSE
        obs_timer(IN := FALSE);
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    hold_timer(IN := FALSE);
    obs_timer(IN := FALSE);
    hold_acquired := FALSE;
END_IF;

END_PROGRAM