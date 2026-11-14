PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    req_edge        : R_TRIG;
    requested       : BOOL := FALSE;
    a_target        : DINT := 0;
    b_target_calc   : DINT := 0;
    a_target_deg    : REAL := 0.0;
    a_target_rad    : REAL := 0.0;
    pi_const        : REAL := 3.141592653589793;

    torque_released    : BOOL := FALSE;
    brake_engaged_cmd   : BOOL := FALSE;
    completion_latched  : BOOL := FALSE;

    pos_tol   : DINT := 20;   (* 0.2 deg / mm  x100 *)
    spd_tol   : DINT := 100;  (* 1 unit/s x100 *)
    b_tol     : DINT := 20;   (* 0.2 mm x100 *)

    pos_ok      : BOOL;
    spd_ok_a    : BOOL;
    spd_ok_b    : BOOL;
    b_ok        : BOOL;
    brake_ok    : BOOL;
    torque_ok   : BOOL;
    stable_cond : BOOL;
    can_brake_cond : BOOL;

    stable_timer : TON;
END_VAR

(* Detect a new work request - single-shot latch, ignore repeats *)
req_edge(CLK := X10);

IF req_edge.Q AND NOT requested THEN
    requested := TRUE;
    a_target := D10;
    a_target_deg := REAL(a_target) / 100.0;
    a_target_rad := a_target_deg * pi_const / 180.0;
    b_target_calc := DINT(ROUND(-450.0 * SIN(a_target_rad) * 100.0));
    torque_released := FALSE;
    brake_engaged_cmd := FALSE;
END_IF;

(* Drive command outputs - hold constant target once latched *)
IF requested THEN
    D20 := a_target;
    D21 := D17;
ELSE
    D20 := 0;
    D21 := 0;
END_IF;
D22 := 0;

(* Evaluate arrival / stability conditions using actual feedback *)
pos_ok   := ABS(D11 - a_target) <= pos_tol;
spd_ok_a := ABS(D12) <= spd_tol;
spd_ok_b := ABS(D14) <= spd_tol;
b_ok     := ABS(D13 - b_target_calc) <= b_tol;
brake_ok := X11;

(* Decide to engage brake only when head is at target and slow enough
   (<=1 deg/s) so brake engagement never occurs above the speed limit *)
can_brake_cond := requested AND pos_ok AND spd_ok_a;
IF can_brake_cond THEN
    brake_engaged_cmd := TRUE;
END_IF;

(* Release head torque only after brake reports full physical engagement *)
IF brake_engaged_cmd AND X11 THEN
    torque_released := TRUE;
END_IF;

Y20 := requested AND NOT torque_released;
Y21 := requested;
Y22 := brake_engaged_cmd;

torque_ok := NOT Y20;

(* Completion stability: must hold true continuously for 30 ms *)
stable_cond := requested AND pos_ok AND spd_ok_a AND b_ok AND spd_ok_b
               AND brake_ok AND torque_ok;

stable_timer(IN := stable_cond, PT := T#30ms);

IF stable_timer.Q THEN
    completion_latched := TRUE;
END_IF;

Y2 := completion_latched;

END_PROGRAM