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
    accepted        : BOOL;
    stable_timer    : TON;
    angle_deg       : REAL;
    angle_rad       : REAL;
    angle_rate_deg  : REAL;
    angle_rate_rad  : REAL;
    b_target_mm     : REAL;
    bdot_mm_s       : REAL;
    cmd_raw         : DINT;
    aux_raw         : DINT;
    abs_M           : REAL;
    pi_c            : REAL := 3.141592653589793;
    min_cmd         : DINT := -200000;
    max_cmd         : DINT := 200000;
END_VAR

(* Latch request acceptance once X10 request is seen *)
IF X10 THEN
    accepted := TRUE;
END_IF;

IF accepted THEN
    Y20 := TRUE;

    (* Compute head angle in radians from measured actual position *)
    angle_deg := REAL(D13) * 0.01;
    angle_rad := angle_deg * pi_c / 180.0;

    (* Counterweight position that cancels the moment:
       30*9.81*0.3*sin(angle) + 20*9.81*b/1000 = 0  =>  b = -450*sin(angle) [mm] *)
    b_target_mm := -450.0 * SIN(angle_rad);

    (* Feedforward speed: derivative of b_target with respect to time *)
    angle_rate_deg := REAL(D14) * 0.01;
    angle_rate_rad := angle_rate_deg * pi_c / 180.0;
    bdot_mm_s := -450.0 * COS(angle_rad) * angle_rate_rad;

    cmd_raw := DINT(ROUND(b_target_mm * 100.0));
    aux_raw := DINT(ROUND(bdot_mm_s * 100.0));

    (* Clamp to permitted raw command bounds *)
    IF cmd_raw > max_cmd THEN
        cmd_raw := max_cmd;
    ELSIF cmd_raw < min_cmd THEN
        cmd_raw := min_cmd;
    END_IF;

    IF aux_raw > max_cmd THEN
        aux_raw := max_cmd;
    ELSIF aux_raw < min_cmd THEN
        aux_raw := min_cmd;
    END_IF;

    D20 := cmd_raw;
    D21 := aux_raw;
ELSE
    (* Before acceptance: do not activate/publish the function *)
    Y20 := FALSE;
    D20 := D11;   (* hold at current actual position, safe/no-op *)
    D21 := 0;
END_IF;

(* Completion monitoring: |M| <= 1 Nm maintained for 30 ms *)
abs_M := ABS(REAL(D17) * 0.01);

stable_timer(IN := (accepted AND (abs_M <= 1.0)), PT := T#30ms);

IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM