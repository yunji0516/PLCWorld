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

    (* Internal variables *)
    accepted     : BOOL;
    req_trig     : R_TRIG;

    target_x     : REAL;
    x_pos        : REAL;
    x_vel        : REAL;
    z_pos        : REAL;
    z_vel        : REAL;
    c_pos        : REAL;
    c_vel        : REAL;

    x_err        : REAL;
    heading_target : REAL;
    heading_err  : REAL;
    yaw_rate_cmd : REAL;
    yaw_rate_rad : REAL;
    fwd_speed    : REAL;

    left_speed   : REAL;
    right_speed  : REAL;
    left_raw     : DINT;
    right_raw    : DINT;

    stable_cond  : BOOL;
    stable_timer : TON;

    pi_const     : REAL := 3.14159265;
    Kx           : REAL := 5.0;
    max_speed    : REAL := 800.0;
    Kz           : REAL := 0.3;
    max_heading_target : REAL := 15.0;
    Kh           : REAL := 5.0;
    max_yaw_rate : REAL := 90.0;
END_VAR

(* ---- request acceptance latch ---- *)
req_trig(CLK := X10);
IF req_trig.Q THEN
    accepted := TRUE;
END_IF;

(* ---- read scaled feedback ---- *)
x_pos   := REAL(D11) / 100.0;
x_vel   := REAL(D12) / 100.0;
z_pos   := REAL(D13) / 100.0;
z_vel   := REAL(D14) / 100.0;
c_pos   := REAL(D15) / 100.0;
c_vel   := REAL(D16) / 100.0;
target_x := REAL(D10) / 100.0;

(* ---- longitudinal control ---- *)
x_err := target_x - x_pos;

fwd_speed := Kx * x_err;
IF fwd_speed > max_speed THEN
    fwd_speed := max_speed;
END_IF;
IF fwd_speed < -max_speed THEN
    fwd_speed := -max_speed;
END_IF;

(* ---- lateral / heading control ---- *)
heading_target := -Kz * z_pos;
IF heading_target > max_heading_target THEN
    heading_target := max_heading_target;
END_IF;
IF heading_target < -max_heading_target THEN
    heading_target := -max_heading_target;
END_IF;

heading_err := heading_target - c_pos;

yaw_rate_cmd := Kh * heading_err;
IF yaw_rate_cmd > max_yaw_rate THEN
    yaw_rate_cmd := max_yaw_rate;
END_IF;
IF yaw_rate_cmd < -max_yaw_rate THEN
    yaw_rate_cmd := -max_yaw_rate;
END_IF;

yaw_rate_rad := yaw_rate_cmd * pi_const / 180.0;

(* ---- differential wheel speeds ---- *)
left_speed  := fwd_speed - yaw_rate_rad * 300.0;
right_speed := fwd_speed + yaw_rate_rad * 300.0;

IF accepted THEN
    left_raw  := DINT(left_speed * 100.0);
    right_raw := DINT(right_speed * 100.0);
ELSE
    left_raw  := 0;
    right_raw := 0;
END_IF;

(* ---- clip to published raw command bounds ---- *)
IF left_raw > 200000 THEN
    left_raw := 200000;
END_IF;
IF left_raw < -200000 THEN
    left_raw := -200000;
END_IF;
IF right_raw > 200000 THEN
    right_raw := 200000;
END_IF;
IF right_raw < -200000 THEN
    right_raw := -200000;
END_IF;

D20 := left_raw;
D21 := right_raw;

(* ---- completion / stability check ---- *)
stable_cond := accepted
    AND (ABS(target_x - x_pos) <= 1.0)
    AND (ABS(z_pos) <= 2.0)
    AND (ABS(c_pos) <= 0.3)
    AND (ABS(x_vel) <= 2.0)
    AND (ABS(c_vel) <= 1.0);

stable_timer(IN := stable_cond, PT := T#30ms);

IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM