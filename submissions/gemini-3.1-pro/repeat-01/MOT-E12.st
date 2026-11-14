PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    started : BOOL;
    pos_ref : REAL;
    v_ref : REAL;
    pos_cmd : REAL;
    
    target : REAL;
    pos : REAL;
    step_err : REAL;
    dir : REAL;
    stop_dist : REAL;
    dv_ref : REAL;
    
    trk_err : REAL;
    v_cmd : REAL;
    
    err_mm : REAL;
    spd_mms : REAL;
    in_condition : BOOL;
    
    timer_maintenance : TON;
    timer_observation : TON;
END_VAR

IF NOT X10 THEN
    started := FALSE;
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    timer_maintenance(IN := FALSE, PT := T#30ms);
    timer_observation(IN := FALSE, PT := T#100ms);
    RETURN;
END_IF;

IF NOT started THEN
    pos_ref := REAL(D11) / 100.0;
    v_ref := 0.0;
    pos_cmd := pos_ref;
    started := TRUE;
END_IF;

Y20 := TRUE;

target := REAL(D10) / 100.0;
pos := REAL(D11) / 100.0;

// Time-optimal trajectory generator for physical limits (Max Speed 800 mm/s, Max Accel 4000 mm/s^2)
step_err := target - pos_ref;
dir := 1.0;
IF step_err < 0.0 THEN
    dir := -1.0;
    step_err := -step_err;
END_IF;

stop_dist := (v_ref * v_ref) / 8000.0; 

IF step_err <= stop_dist THEN
    dv_ref := -dir * 40.0; 
ELSE
    dv_ref := dir * 40.0;
END_IF;

v_ref := v_ref + dv_ref;

IF v_ref > 800.0 THEN
    v_ref := 800.0;
ELSIF v_ref < -800.0 THEN
    v_ref := -800.0;
END_IF;

IF (dir > 0.0 AND v_ref < 0.0) OR (dir < 0.0 AND v_ref > 0.0) THEN
    v_ref := 0.0;
END_IF;

pos_ref := pos_ref + v_ref * 0.01;

IF (dir > 0.0 AND pos_ref > target) OR (dir < 0.0 AND pos_ref < target) THEN
    pos_ref := target;
    v_ref := 0.0;
END_IF;

// Pure I-controller tracking to eliminate unknown plant DC gain response [0.8 .. 1.0]
trk_err := pos_ref - pos;
v_cmd := 7.5 * trk_err;

IF v_cmd > 1200.0 THEN
    v_cmd := 1200.0;
ELSIF v_cmd < -1200.0 THEN
    v_cmd := -1200.0;
END_IF;

pos_cmd := pos_cmd + v_cmd * 0.01;

D20 := DINT(pos_cmd * 100.0);

// Result Maintenance and Observation
err_mm := ABS(target - pos);
spd_mms := ABS(REAL(D12) / 100.0);

in_condition := (err_mm <= 0.2) AND (spd_mms <= 1.0);

timer_maintenance(IN := in_condition, PT := T#30ms);

IF timer_maintenance.Q THEN
    Y2 := TRUE;
END_IF;

timer_observation(IN := Y2 AND in_condition, PT := T#100ms);

END_PROGRAM