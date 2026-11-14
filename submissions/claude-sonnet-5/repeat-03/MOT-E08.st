PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    activated   : BOOL;
    cmd_pos     : DINT;
    cmd_vel     : DINT;
    pos_err     : REAL;
    vel_err     : REAL;
    cond_ok     : BOOL;
    y2_latched  : BOOL;
    stable_timer : TON;
    maint_timer  : TON;
END_VAR

(* Latch activation once the request is accepted (X10 true) *)
IF X10 THEN
    activated := TRUE;
END_IF;

Y20 := activated;

(* Compute following command: target = master position (D11) + requested interval (D10) *)
IF activated THEN
    cmd_pos := D11 + D10;
    cmd_vel := D12;
ELSE
    cmd_pos := 0;
    cmd_vel := 0;
END_IF;

(* Clamp to permitted raw command bounds *)
cmd_pos := LIMIT(-200000, cmd_pos, 200000);
cmd_vel := LIMIT(-200000, cmd_vel, 200000);

D20 := cmd_pos;
D21 := cmd_vel;

(* Relative position / velocity error in physical units (mm, mm/s) *)
pos_err := (REAL(D13) - REAL(D11 + D10)) * 0.01;
vel_err := (REAL(D14) - REAL(D12)) * 0.01;

cond_ok := activated AND (ABS(pos_err) <= 0.3) AND (ABS(vel_err) <= 2.0);

(* Require 30 ms of continuous conformance before declaring completion *)
stable_timer(IN := cond_ok, PT := T#30ms);

IF stable_timer.Q THEN
    y2_latched := TRUE;
END_IF;

Y2 := y2_latched;

(* Post-claim maintenance / result retention observation window (250 ms) *)
maint_timer(IN := y2_latched, PT := T#250ms);

END_PROGRAM