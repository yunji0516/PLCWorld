PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    accepted      : BOOL := FALSE;   (* request has been accepted / latched *)
    target_raw    : DINT := 0;       (* latched target position, raw x0.01 deg *)
    cmd_min       : DINT := -200000;
    cmd_max       : DINT := 200000;
    req_min       : DINT := -4500;   (* -45 deg x100 *)
    req_max       : DINT := 9000;    (*  90 deg x100 *)
    ang_tol       : DINT := 20;      (* 0.2 deg x100 *)
    spd_tol       : DINT := 100;     (* 1 deg/s x100 *)
    err           : DINT;
    spd_abs       : DINT;
    stable_cond   : BOOL;
    stableTimer   : TON;
    latched_target : DINT;
END_VAR

(* ---- Accept the request on first X10 true ---- *)
IF (NOT accepted) AND X10 THEN
    accepted := TRUE;
    latched_target := D10;
    (* clamp latched target to request range *)
    IF latched_target < req_min THEN
        latched_target := req_min;
    ELSIF latched_target > req_max THEN
        latched_target := req_max;
    END_IF;
    target_raw := latched_target;
END_IF;

(* ---- Output activation / retention ---- *)
IF accepted THEN
    Y20 := TRUE;

    (* clamp command to permitted raw command bounds *)
    IF target_raw < cmd_min THEN
        D20 := cmd_min;
    ELSIF target_raw > cmd_max THEN
        D20 := cmd_max;
    ELSE
        D20 := target_raw;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* ---- Completion evaluation ---- *)
IF accepted THEN
    err := D11 - target_raw;
    IF err < 0 THEN
        err := -err;
    END_IF;

    spd_abs := D12;
    IF spd_abs < 0 THEN
        spd_abs := -spd_abs;
    END_IF;

    stable_cond := (err <= ang_tol) AND (spd_abs <= spd_tol);
ELSE
    stable_cond := FALSE;
END_IF;

stableTimer(IN := stable_cond, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

(* Y2 remains latched TRUE once set; no reset logic provided,
   preserving result retention through the observation window. *)

END_PROGRAM