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

    (* physical scaled values *)
    target_x   : REAL;
    a_pos      : REAL;
    a_vel      : REAL;
    b_pos      : REAL;
    b_vel      : REAL;
    c_pos      : REAL;
    c_vel      : REAL;

    error_x    : REAL;
    abs_err_x  : REAL;
    v_mag      : REAL;
    v_cmd      : REAL;

    theta_desired : REAL;
    theta_error   : REAL;
    yaw_cmd_deg   : REAL;
    yaw_rad       : REAL;

    left_speed  : REAL;
    right_speed : REAL;

    raw_left  : DINT;
    raw_right : DINT;

    (* control gains / constants *)
    a_dec      : REAL := 1000.0;   (* mm/s^2 - target deceleration for range-based speed law *)
    vmax       : REAL := 600.0;    (* mm/s *)
    Kp_b       : REAL := 0.5;
    theta_max  : REAL := 15.0;     (* deg *)
    Kp_theta   : REAL := 3.0;
    Kd_theta   : REAL := 0.5;
    yaw_max    : REAL := 40.0;     (* deg/s *)
    half_wb    : REAL := 300.0;    (* mm, half of wheelbase 600 *)
    pi_c       : REAL := 3.1415926;

    (* acceptance / completion logic *)
    accepted     : BOOL := FALSE;
    abs_z        : REAL;
    abs_head     : REAL;
    abs_xvel     : REAL;
    abs_headvel  : REAL;
    condition_ok : BOOL := FALSE;
    stable_timer : TON;
    y2_latch     : BOOL := FALSE;
END_VAR

(* ---- scale inputs to physical units ---- *)
target_x := REAL(D10) / 100.0;
a_pos    := REAL(D11) / 100.0;
a_vel    := REAL(D12) / 100.0;
b_pos    := REAL(D13) / 100.0;
b_vel    := REAL(D14) / 100.0;
c_pos    := REAL(D15) / 100.0;
c_vel    := REAL(D16) / 100.0;

(* ---- latch acceptance of request ---- *)
IF X10 THEN
    accepted := TRUE;
END_IF;

(* ---- forward speed command : range-based deceleration law ---- *)
error_x   := target_x - a_pos;
abs_err_x := ABS(error_x);

v_mag := SQRT(2.0 * a_dec * abs_err_x);

IF error_x >= 0.0 THEN
    v_cmd := v_mag;
ELSE
    v_cmd := -v_mag;
END_IF;

v_cmd := MAX(-vmax, MIN(vmax, v_cmd));

(* ---- lateral / heading correction ---- *)
theta_desired := -Kp_b * b_pos;
theta_desired := MAX(-theta_max, MIN(theta_max, theta_desired));

theta_error := theta_desired - c_pos;
yaw_cmd_deg := Kp_theta * theta_error - Kd_theta * c_vel;
yaw_cmd_deg := MAX(-yaw_max, MIN(yaw_max, yaw_cmd_deg));

yaw_rad := yaw_cmd_deg * pi_c / 180.0;

(* ---- differential wheel speeds ---- *)
left_speed  := v_cmd - yaw_rad * half_wb;
right_speed := v_cmd + yaw_rad * half_wb;

raw_left  := DINT(ROUND(left_speed  * 100.0));
raw_right := DINT(ROUND(right_speed * 100.0));

raw_left  := MAX(-200000, MIN(200000, raw_left));
raw_right := MAX(-200000, MIN(200000, raw_right));

(* ---- gate outputs until request accepted ---- *)
IF accepted THEN
    D20 := raw_left;
    D21 := raw_right;
ELSE
    D20 := 0;
    D21 := 0;
END_IF;

(* ---- completion evaluation ---- *)
abs_z       := ABS(b_pos);
abs_head    := ABS(c_pos);
abs_xvel    := ABS(a_vel);
abs_headvel := ABS(c_vel);

condition_ok := (abs_err_x   <= 1.0) AND
                (abs_z       <= 2.0) AND
                (abs_head    <= 0.3) AND
                (abs_xvel    <= 2.0) AND
                (abs_headvel <= 1.0);

stable_timer(IN := condition_ok, PT := T#30ms);

IF stable_timer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM