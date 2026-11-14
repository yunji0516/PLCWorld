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
    
    stable_cnt : INT := 0;
    claimed : BOOL := FALSE;
    
    x_phys : REAL;
    z_phys : REAL;
    h_phys : REAL;
    vx_phys : REAL;
    vh_phys : REAL;
    target_x_phys : REAL;
    
    forward_cmd : REAL;
    yaw_cmd : REAL;
    left_cmd_phys : REAL;
    right_cmd_phys : REAL;
    
    left_raw : DINT;
    right_raw : DINT;
END_VAR

x_phys := D11 / 100.0;
z_phys := D13 / 100.0;
h_phys := D15 / 100.0;
vx_phys := D12 / 100.0;
vh_phys := D16 / 100.0;
target_x_phys := D10 / 100.0;

IF X10 THEN
    IF x_phys < target_x_phys - 1.0 THEN
        forward_cmd := target_x_phys - x_phys;
        IF forward_cmd > 380.0 THEN forward_cmd := 380.0; END_IF;
    ELSIF x_phys > target_x_phys + 1.0 THEN
        forward_cmd := target_x_phys - x_phys;
        IF forward_cmd < -380.0 THEN forward_cmd := -380.0; END_IF;
    ELSE
        forward_cmd := 0.0;
    END_IF;
    
    yaw_cmd := -(0.025 * z_phys + 0.15 * h_phys);
    IF yaw_cmd > 0.4 THEN yaw_cmd := 0.4; END_IF;
    IF yaw_cmd < -0.4 THEN yaw_cmd := -0.4; END_IF;
ELSE
    forward_cmd := 0.0;
    yaw_cmd := 0.0;
END_IF;

left_cmd_phys := forward_cmd - yaw_cmd * 300.0;
right_cmd_phys := forward_cmd + yaw_cmd * 300.0;

left_raw := DINT(ROUND(left_cmd_phys * 100.0));
right_raw := DINT(ROUND(right_cmd_phys * 100.0));

IF left_raw > 200000 THEN left_raw := 200000; END_IF;
IF left_raw < -200000 THEN left_raw := -200000; END_IF;
IF right_raw > 200000 THEN right_raw := 200000; END_IF;
IF right_raw < -200000 THEN right_raw := -200000; END_IF;

D20 := left_raw;
D21 := right_raw;

IF ABS(x_phys - target_x_phys) <= 1.0 AND
   ABS(z_phys) <= 2.0 AND
   ABS(h_phys) <= 0.3 AND
   ABS(vx_phys) <= 2.0 AND
   ABS(vh_phys) <= 1.0 THEN
    stable_cnt := stable_cnt + 1;
ELSE
    stable_cnt := 0;
END_IF;

IF stable_cnt >= 3 THEN
    claimed := TRUE;
END_IF;

Y2 := claimed;

END_PROGRAM