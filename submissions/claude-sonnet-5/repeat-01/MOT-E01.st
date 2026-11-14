PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal state *)
    activated   : BOOL := FALSE;   (* latched once X10 request accepted *)
    y2_latched  : BOOL := FALSE;   (* latched once completion has been stably observed *)

    err_raw     : DINT;
    abs_err_raw : DINT;
    abs_spd_raw : DINT;

    posOk       : BOOL;
    speedOk     : BOOL;

    stableTimer : TON;

    cmd_raw     : DINT;

    (* Raw-unit thresholds (values are already x100 scaled, matching D-word scaling) *)
    pos_tol_raw : DINT := 20;   (* 0.2 mm * 100 *)
    spd_tol_raw : DINT := 100;  (* 1 mm/s * 100 *)
    cmd_min     : DINT := -200000;
    cmd_max     : DINT := 200000;
END_VAR

(* --- Latch activation on X10 request acceptance --- *)
IF X10 THEN
    activated := TRUE;
END_IF;

Y20 := activated;

(* --- Compute and clamp command value --- *)
IF activated THEN
    cmd_raw := D10;
    IF cmd_raw > cmd_max THEN
        cmd_raw := cmd_max;
    ELSIF cmd_raw < cmd_min THEN
        cmd_raw := cmd_min;
    END_IF;
    D20 := cmd_raw;
ELSE
    D20 := 0;
END_IF;

(* --- Evaluate completion condition (position error and speed) --- *)
err_raw := D11 - D10;
IF err_raw < 0 THEN
    abs_err_raw := -err_raw;
ELSE
    abs_err_raw := err_raw;
END_IF;

IF D12 < 0 THEN
    abs_spd_raw := -D12;
ELSE
    abs_spd_raw := D12;
END_IF;

posOk := abs_err_raw <= pos_tol_raw;
speedOk := abs_spd_raw <= spd_tol_raw;

(* --- Stability timer: must hold condition for 30 ms continuously --- *)
stableTimer(IN := activated AND posOk AND speedOk, PT := T#30ms);

IF stableTimer.Q THEN
    y2_latched := TRUE;
END_IF;

Y2 := y2_latched;

END_PROGRAM