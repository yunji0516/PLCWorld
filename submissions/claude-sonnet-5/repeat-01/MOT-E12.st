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
    request_active : BOOL := FALSE;
    target_raw     : DINT := 0;
    cmd_raw        : DINT := 0;
    error_ok       : BOOL := FALSE;
    y2_latched     : BOOL := FALSE;

    min_cmd : DINT := -200000;
    max_cmd : DINT := 200000;

    stab_timer : TON;
END_VAR

(* Latch the request on first acceptance of X10 *)
IF NOT request_active AND X10 THEN
    request_active := TRUE;
    target_raw := D10;
END_IF;

(* Compute command, clamp to permitted raw command bounds *)
IF request_active THEN
    cmd_raw := target_raw;
ELSE
    cmd_raw := 0;
END_IF;

IF cmd_raw > max_cmd THEN
    cmd_raw := max_cmd;
ELSIF cmd_raw < min_cmd THEN
    cmd_raw := min_cmd;
END_IF;

D20 := cmd_raw;

(* Only activate/publish after request acceptance *)
Y20 := request_active;

(* Evaluate completion condition: error <=0.2mm (raw diff <=20), speed <=1mm/s (raw <=100) *)
IF request_active THEN
    error_ok := (ABS(D11 - target_raw) <= 20) AND (ABS(D12) <= 100);
ELSE
    error_ok := FALSE;
END_IF;

(* Stability timer: require condition held for 30 ms *)
stab_timer(IN := error_ok, PT := T#30ms);

IF stab_timer.Q THEN
    y2_latched := TRUE;
END_IF;

(* Keep Y2 TRUE once latched (retention) *)
Y2 := y2_latched;

END_PROGRAM