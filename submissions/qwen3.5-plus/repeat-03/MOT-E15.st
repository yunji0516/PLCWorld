PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    request_active : BOOL;
    balance_stable_scans : INT;
    y2_set : BOOL;
    pi : REAL := 3.14159265358979;
    a_deg : REAL;
    a_rad : REAL;
    b_target : REAL;
    ff_speed : REAL;
    a_speed_deg_s : REAL;
    a_speed_rad_s : REAL;
END_VAR

// Detect request acceptance
IF X10 THEN
    request_active := TRUE;
END_IF;

// Before request: safe defaults within permitted command bounds
IF NOT request_active THEN
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
ELSE
    Y20 := TRUE;
    
    // Convert actual head angle from 0.01 deg to degrees, then radians
    a_deg := INT_TO_REAL(D13) / 100.0;
    a_rad := a_deg * pi / 180.0;
    
    // Balanced counterweight position: b = -450 * sin(a)
    // Derivation: 30*9.81*0.3*sin(a) + 20*9.81*b/1000 = 0
    //           => b = -9*sin(a) / 0.02 = -450*sin(a)
    b_target := -450.0 * SIN(a_rad);
    D20 := DINT(b_target * 100.0);
    
    // Clamp D20 to permitted command range [-200000, 200000]
    IF D20 > 200000 THEN D20 := 200000; END_IF;
    IF D20 < -200000 THEN D20 := -200000; END_IF;
    
    // Feedforward speed: db/dt = -450 * cos(a) * da/dt_rad
    // da/dt_rad = da/dt_deg * pi/180
    a_speed_deg_s := INT_TO_REAL(D14) / 100.0;
    a_speed_rad_s := a_speed_deg_s * pi / 180.0;
    ff_speed := -450.0 * COS(a_rad) * a_speed_rad_s;
    D21 := DINT(ff_speed * 100.0);
    
    // Clamp D21 to permitted command range [-200000, 200000]
    IF D21 > 200000 THEN D21 := 200000; END_IF;
    IF D21 < -200000 THEN D21 := -200000; END_IF;
    
    // Completion detection: |D17| <= 100 corresponds to |M| <= 1 Nm
    IF ABS(D17) <= 100 THEN
        balance_stable_scans := balance_stable_scans + 1;
    ELSE
        balance_stable_scans := 0;
    END_IF;
    
    // Set Y2 after maintaining balance for 30 ms (3 scans at 10 ms period)
    IF balance_stable_scans >= 3 AND NOT y2_set THEN
        y2_set := TRUE;
    END_IF;
    
    // Y2 retention once set
    IF y2_set THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM