PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2  : BOOL;

    (* internal variables *)
    target_raw   : DINT;
    pos_actual   : REAL;
    speed_actual : REAL;
    req_actual   : REAL;
    err          : REAL;
    spd_abs      : REAL;
    within_tol   : BOOL;
    stable_timer : TON;
    y2_latch     : BOOL;

    cmd_min      : DINT := -200000;
    cmd_max      : DINT := 200000;
END_VAR

(* ---- Activation / command publication ---- *)
IF X10 THEN
    target_raw := D10;

    (* clamp raw command to permitted bounds *)
    IF target_raw > cmd_max THEN
        target_raw := cmd_max;
    ELSIF target_raw < cmd_min THEN
        target_raw := cmd_min;
    END_IF;

    D20 := target_raw;
    Y20 := TRUE;
ELSE
    (* function must not be activated or published before request acceptance *)
    D20 := 0;
    Y20 := FALSE;
END_IF;

(* ---- Completion evaluation ---- *)
pos_actual   := INT_TO_REAL(D11) * 0.01;
speed_actual := INT_TO_REAL(D12) * 0.01;
req_actual   := INT_TO_REAL(D10) * 0.01;

err     := ABS(pos_actual - req_actual);
spd_abs := ABS(speed_actual);

within_tol := (err <= 0.2) AND (spd_abs <= 1.0);

stable_timer(IN := within_tol, PT := T#30ms);

IF stable_timer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM