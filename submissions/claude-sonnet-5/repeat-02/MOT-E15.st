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

    (* Internal variables *)
    activated   : BOOL := FALSE;
    pi_const    : REAL := 3.14159265358979;

    angle_deg   : REAL;
    angle_rad   : REAL;
    ang_vel_deg : REAL;
    ang_vel_rad : REAL;

    target_b    : REAL;   (* desired counterweight position, mm *)
    ff_speed    : REAL;   (* desired feedforward speed, mm/s *)

    raw_pos     : DINT;
    raw_speed   : DINT;

    M_val       : REAL;   (* actual support moment, Nm *)

    stableTimer : TON;
END_VAR

(* ---- Activation latch : only after X10 request accepted ---- *)
IF X10 THEN
    activated := TRUE;
END_IF;

Y20 := activated;

(* ---- Control law : null the support moment via counterweight ---- *)
IF activated THEN
    angle_deg   := REAL(D13) * 0.01;
    angle_rad   := angle_deg * pi_const / 180.0;

    ang_vel_deg := REAL(D14) * 0.01;
    ang_vel_rad := ang_vel_deg * pi_const / 180.0;

    (* target counterweight position (mm) that nulls M *)
    target_b := -450.0 * SIN(angle_rad);

    (* feedforward speed = d(target_b)/dt *)
    ff_speed := -450.0 * COS(angle_rad) * ang_vel_rad;

    raw_pos   := DINT(ROUND(target_b * 100.0));
    raw_speed := DINT(ROUND(ff_speed * 100.0));

    (* clamp to permitted raw command bounds *)
    IF raw_pos > 200000 THEN
        raw_pos := 200000;
    ELSIF raw_pos < -200000 THEN
        raw_pos := -200000;
    END_IF;

    IF raw_speed > 200000 THEN
        raw_speed := 200000;
    ELSIF raw_speed < -200000 THEN
        raw_speed := -200000;
    END_IF;

    D20 := raw_pos;
    D21 := raw_speed;
ELSE
    D20 := 0;
    D21 := 0;
END_IF;

(* ---- Completion monitoring : |M| <= 1 Nm maintained for 30 ms ---- *)
M_val := REAL(D17) * 0.01;

stableTimer(IN := (activated AND (ABS(M_val) <= 1.0)), PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM