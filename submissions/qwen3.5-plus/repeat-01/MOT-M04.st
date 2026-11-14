PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;
    
    edge_req : R_TRIG;
    timer_stable : TON;
    
    req_active : BOOL := FALSE;
    complete_flag : BOOL := FALSE;
    
    target_a : DINT := 0;
    target_b : DINT := 0;
    
    scan_period_ms : REAL := 10.0;
    
    pos_b : REAL;
    vel_b : REAL;
    pos_c : REAL;
    vel_c : REAL;
    
    accel_raw : REAL;
    accel_scaled : DINT;
    
    Kp : REAL := 1225.0;
    Kd : REAL := 70.0;
END_VAR

edge_req(CLK := X10);

IF edge_req.Q AND NOT req_active THEN
    req_active := TRUE;
    complete_flag := FALSE;
    target_a := D10;
    target_b := D17;
END_IF;

IF NOT req_active THEN
    D20 := 0;
    D21 := 0;
    Y20 := FALSE;
    Y2 := FALSE;
    RETURN;
END_IF;

pos_b := DINT_TO_REAL(D13) * 0.01;
vel_b := DINT_TO_REAL(D14) * 0.01;
pos_c := DINT_TO_REAL(D15) * 0.01;
vel_c := DINT_TO_REAL(D16) * 0.01;

D20 := target_a;
Y20 := TRUE;

accel_raw := Kp * (DINT_TO_REAL(target_b) * 0.01 - pos_b) + Kd * (0.0 - vel_b);
accel_scaled := REAL_TO_INT(accel_raw * 100.0);
IF accel_scaled > 400000 THEN
    accel_scaled := 400000;
ELSIF accel_scaled < -400000 THEN
    accel_scaled := -400000;
END_IF;
D21 := accel_scaled;

IF ABS(DINT_TO_REAL(D13) * 0.01 - DINT_TO_REAL(target_b) * 0.01) <= 1.0
   AND ABS(vel_b) <= 1.0 THEN
    IF NOT complete_flag THEN
        complete_flag := TRUE;
    END_IF;
    Y20 := FALSE;
    
    timer_stable(IN := TRUE, PT := T#30ms);
    
    IF timer_stable.Q THEN
        Y2 := TRUE;
        IF NOT req_active THEN
            req_active := FALSE;
        END_IF;
    END_IF;
ELSE
    complete_flag := FALSE;
    timer_stable(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM