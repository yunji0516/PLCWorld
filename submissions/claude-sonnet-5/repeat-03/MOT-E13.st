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

    (* Internal working variables *)
    target_x   : REAL := 0.0;
    x_actual   : REAL := 0.0;
    x_vel      : REAL := 0.0;
    z_actual   : REAL := 0.0;
    z_vel      : REAL := 0.0;
    c_actual   : REAL := 0.0;
    c_vel      : REAL := 0.0;

    x_err          : REAL := 0.0;
    desired_heading: REAL := 0.0;
    heading_err    : REAL := 0.0;

    forward_cmd : REAL := 0.0;
    yaw_cmd_deg : REAL := 0.0;
    yaw_rad     : REAL := 0.0;
    delta_spd   : REAL := 0.0;

    left_speed  : REAL := 0.0;
    right_speed : REAL := 0.0;

    Kp_x   : REAL := 0.6;
    max_speed : REAL := 150.0;

    Kz     : REAL := 0.15;
    max_head : REAL := 10.0;

    Kh     : REAL := 3.0;
    max_yaw_deg : REAL := 30.0;

    half_wheelbase : REAL := 300.0;
    deg2rad : REAL := 0.017453293;

    conditions_met : BOOL := FALSE;
    stable_timer : TON;
END_VAR

(* ---- Read / scale inputs ---- *)
target_x := REAL(D10) / 100.0;
x_actual := REAL(D11) / 100.0;
x_vel    := REAL(D12) / 100.0;
z_actual := REAL(D13) / 100.0;
z_vel    := REAL(D14) / 100.0;
c_actual := REAL(D15) / 100.0;
c_vel    := REAL(D16) / 100.0;

x_err := target_x - x_actual;

(* ---- Steering law: aim heading to reduce lateral error, then track heading ---- *)
desired_heading := LIMIT(-max_head, -Kz * z_actual, max_head);
heading_err := desired_heading - c_actual;

(* ---- Forward speed proportional to remaining distance ---- *)
forward_cmd := LIMIT(-max_speed, Kp_x * x_err, max_speed);

(* ---- Yaw rate command from heading error ---- *)
yaw_cmd_deg := LIMIT(-max_yaw_deg, Kh * heading_err, max_yaw_deg);
yaw_rad := yaw_cmd_deg * deg2rad;
delta_spd := yaw_rad * half_wheelbase;

left_speed  := forward_cmd - delta_spd;
right_speed := forward_cmd + delta_spd;

left_speed  := LIMIT(-2000.0, left_speed, 2000.0);
right_speed := LIMIT(-2000.0, right_speed, 2000.0);

(* ---- Output gating: wheel motion only after X10 accepted ---- *)
IF X10 THEN
    D20 := DINT(left_speed * 100.0);
    D21 := DINT(right_speed * 100.0);
ELSE
    D20 := 0;
    D21 := 0;
END_IF;

(* ---- Completion check ---- *)
conditions_met := (ABS(x_err) <= 1.0)
              AND (ABS(z_actual) <= 2.0)
              AND (ABS(c_actual) <= 0.3)
              AND (ABS(x_vel) <= 2.0)
              AND (ABS(c_vel) <= 1.0);

stable_timer(IN := conditions_met, PT := T#30ms);

IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM