PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    reqAccepted : BOOL;
    ratio_r     : REAL;
    vel_err_r   : REAL;
    phase_ok    : BOOL;
    vel_ok      : BOOL;
    cond_ok     : BOOL;
    D20_cmd     : DINT;
    stableTimer : TON;
    holdTimer   : TON;
END_VAR

(* Latch request acceptance: activation/publication only after X10 accepted *)
IF X10 THEN
    reqAccepted := TRUE;
END_IF;

(* Activate function output once request accepted; no separation afterwards *)
IF reqAccepted THEN
    Y20 := TRUE;
END_IF;

(* Compute ratio command only while function active; otherwise keep it neutral/zero *)
IF Y20 THEN
    D20_cmd := D10;
ELSE
    D20_cmd := 0;
END_IF;

(* Enforce raw command bounds every scan *)
IF D20_cmd > 200000 THEN
    D20_cmd := 200000;
ELSIF D20_cmd < -200000 THEN
    D20_cmd := -200000;
END_IF;

D20 := D20_cmd;

(* Compute real ratio for error evaluation *)
ratio_r := REAL(D10) / 1000.0;

(* Velocity error: (S speed - ratio * U speed), raw units (x0.01 deg/s) *)
vel_err_r := REAL(D12) - ratio_r * REAL(D14);

(* Tolerances: phase <=0.3 deg -> raw (x0.01) <=30 ; velocity <=2 deg/s -> raw (x0.01) <=200 *)
phase_ok := ABS(D17) <= 30;
vel_ok   := ABS(vel_err_r) <= 200.0;

cond_ok := Y20 AND phase_ok AND vel_ok;

(* Require the actual result to be maintained for 30 ms before claiming completion *)
stableTimer(IN := cond_ok, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

(* Post-claim maintenance / observation window of 250 ms *)
holdTimer(IN := Y2, PT := T#250ms);

END_PROGRAM