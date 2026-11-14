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
    pi_const      : REAL := 3.14159265358979;
    scan_period_s : REAL := 0.01; (* 10 ms scan period *)

    theta_deg     : REAL;
    theta_rad     : REAL;
    target_b      : REAL;
    prev_target_b : REAL := 0.0;
    speed_ff      : REAL;
    first_calc    : BOOL := TRUE;

    M_val         : REAL;

    request_accepted : BOOL := FALSE;

    stable_timer  : TON;

    cmd_raw       : DINT;
    aux_raw       : DINT;
END_VAR

(* --- Accept request once, latch activation --- *)
IF X10 AND NOT request_accepted THEN
    request_accepted := TRUE;
END_IF;

IF request_accepted THEN
    Y20 := TRUE;

    (* Read current actual head angle (deg) *)
    theta_deg := REAL(D13) * 0.01;
    theta_rad := theta_deg * pi_const / 180.0;

    (* Compute counterweight target position that zeros the moment *)
    target_b := -450.0 * SIN(theta_rad);

    IF first_calc THEN
        speed_ff := 0.0;
        first_calc := FALSE;
    ELSE
        speed_ff := (target_b - prev_target_b) / scan_period_s;
    END_IF;

    prev_target_b := target_b;

    cmd_raw := DINT(target_b * 100.0);
    aux_raw := DINT(speed_ff * 100.0);

    (* Clamp to permitted raw command bounds *)
    IF cmd_raw > 200000 THEN
        cmd_raw := 200000;
    ELSIF cmd_raw < -200000 THEN
        cmd_raw := -200000;
    END_IF;

    IF aux_raw > 200000 THEN
        aux_raw := 200000;
    ELSIF aux_raw < -200000 THEN
        aux_raw := -200000;
    END_IF;

    D20 := cmd_raw;
    D21 := aux_raw;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
END_IF;

(* --- Evaluate moment and completion stability --- *)
M_val := REAL(D17) * 0.01;

stable_timer(IN := (request_accepted AND (ABS(M_val) <= 1.0)), PT := T#30ms);

IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM