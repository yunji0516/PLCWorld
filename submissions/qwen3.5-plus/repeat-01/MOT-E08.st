PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    active : BOOL;
    maintain_time : TON;
    obs_time : TON;
    scan_cnt : INT;
    pos_err_raw : DINT;
    vel_err_raw : DINT;
    pos_err_abs : DINT;
    vel_err_abs : DINT;
    cond_met : BOOL;
END_VAR

// Scan counter (max 220 scans)
IF scan_cnt < 220 THEN
    scan_cnt := scan_cnt + 1;
END_IF;

// Activation on request acceptance
IF X10 AND NOT active THEN
    active := TRUE;
    Y20 := TRUE;
END_IF;

// Command generation when active
IF active THEN
    // Main command: U position + requested interval
    D20 := D13 + D10;
    // Auxiliary command: feedforward velocity (U velocity)
    D21 := D14;
    
    // Clamp to permitted command raw bounds
    IF D20 > 200000 THEN
        D20 := 200000;
    ELSIF D20 < -200000 THEN
        D20 := -200000;
    END_IF;
    
    IF D21 > 200000 THEN
        D21 := 200000;
    ELSIF D21 < -200000 THEN
        D21 := -200000;
    END_IF;
ELSE
    D20 := 0;
    D21 := 0;
END_IF;

// Error calculation and condition check
IF active THEN
    // Position error: S position - (U position + requested interval)
    pos_err_raw := D11 - D13 - D10;
    IF pos_err_raw < 0 THEN
        pos_err_abs := -pos_err_raw;
    ELSE
        pos_err_abs := pos_err_raw;
    END_IF;
    
    // Velocity error: S velocity - U velocity
    vel_err_raw := D12 - D14;
    IF vel_err_raw < 0 THEN
        vel_err_abs := -vel_err_raw;
    ELSE
        vel_err_abs := vel_err_raw;
    END_IF;
    
    // Condition met: position error <= 0.3mm (30 scaled) and velocity error <= 2mm/s (200 scaled)
    cond_met := pos_err_abs <= 30 AND vel_err_abs <= 200;
ELSE
    cond_met := FALSE;
END_IF;

// Maintain timer: accumulate 30ms of condition met before Y2 activation
maintain_time(IN := cond_met AND NOT Y2 AND active, PT := T#30ms);

// Set Y2 TRUE when maintain timer completes (30ms of maintained tracking)
IF maintain_time.Q THEN
    Y2 := TRUE;
END_IF;

// Observation timer: accumulate 250ms of maintained condition after Y2 set
IF Y2 THEN
    obs_time(IN := cond_met AND active, PT := T#250ms);
END_IF;

// Reset Y2 if condition is lost (restart maintain and observation)
IF NOT cond_met AND active THEN
    Y2 := FALSE;
END_IF;

END_PROGRAM