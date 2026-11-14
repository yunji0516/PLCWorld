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
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    activated    : BOOL := FALSE;
    condition_ok : BOOL := FALSE;
    sum_pos      : DINT := 0;
    cmd_pos      : DINT := 0;
    cmd_vel      : DINT := 0;
    stable_timer : TON;
    cmd_min      : DINT := -200000;
    cmd_max      : DINT := 200000;
    tol_raw      : DINT := 200; (* 2 deg * 100 *)
END_VAR

(* Latch activation only after request acceptance - never before *)
IF X10 THEN
    activated := TRUE;
END_IF;

Y20 := activated;

(* Compute wrist commands to hold sum of joint angles at 0 deg *)
IF activated THEN
    cmd_pos := -(D13 + D15);
    cmd_vel := -(D14 + D16);
ELSE
    cmd_pos := 0;
    cmd_vel := 0;
END_IF;

(* Clamp to permitted raw command bounds every scan *)
IF cmd_pos > cmd_max THEN
    cmd_pos := cmd_max;
ELSIF cmd_pos < cmd_min THEN
    cmd_pos := cmd_min;
END_IF;

IF cmd_vel > cmd_max THEN
    cmd_vel := cmd_max;
ELSIF cmd_vel < cmd_min THEN
    cmd_vel := cmd_min;
END_IF;

D20 := cmd_pos;
D21 := cmd_vel;

(* Evaluate actual tool orientation from actual joint feedback *)
sum_pos := D11 + D13 + D15;
condition_ok := (sum_pos >= -tol_raw) AND (sum_pos <= tol_raw);

(* Require 30 ms continuous in-tolerance stability before claiming completion *)
stable_timer(IN := activated AND condition_ok, PT := T#30ms);

(* Latch completion once stability achieved; drop if condition later breaks *)
Y2 := stable_timer.Q OR (Y2 AND condition_ok);

END_PROGRAM