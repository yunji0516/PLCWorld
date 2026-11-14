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
    target_raw     : DINT := 0;   (* clamped command value, raw units (mm*100) *)
    condition_ok   : BOOL := FALSE;
    stability_timer : TON;
    cmd_min        : DINT := -200000;
    cmd_max        : DINT := 200000;
    pos_err_limit  : DINT := 20;   (* 0.2 mm in raw units (mm*100) *)
    spd_limit      : DINT := 100;  (* 1 mm/s in raw units (mm/s*100) *)
END_VAR

(* --- Activation / command logic --- *)
IF X10 THEN
    Y20 := TRUE;

    target_raw := D10;

    (* Clamp command to permitted raw command bounds *)
    IF target_raw > cmd_max THEN
        target_raw := cmd_max;
    ELSIF target_raw < cmd_min THEN
        target_raw := cmd_min;
    END_IF;

    D20 := target_raw;
ELSE
    (* Do not activate or publish function before X10 request acceptance *)
    Y20 := FALSE;
    D20 := 0;
END_IF;

(* --- Completion / stability evaluation --- *)
condition_ok := X10
                 AND (ABS(D11 - D10) <= pos_err_limit)
                 AND (ABS(D12) <= spd_limit);

stability_timer(IN := condition_ok, PT := T#30ms);

IF stability_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM