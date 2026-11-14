PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    active : BOOL := FALSE;
    ref_p : REAL := 0.0;
    ref_v : REAL := 0.0;
    
    u_p_tout : REAL;
    u_v_tout : REAL;
    err_p : REAL;
    v_des_rel : REAL;
    v_rel_limit : REAL;
    v_des : REAL;
    v_cmd : REAL;
    
    act_err_p : REAL;
    act_err_v : REAL;
    aligned : BOOL := FALSE;
    
    align_timer : TON;
END_VAR

IF NOT X10 THEN
    active := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    D20 := D11;
    D21 := 0;
    align_timer(IN := FALSE, PT := T#30ms);
ELSE
    IF NOT active THEN
        active := TRUE;
        (* Initialize S reference state projected 1 scan (10ms) forward,
           since the first outputs take effect at the end of the current scan. *)
        ref_v := REAL(D12) * 0.01;
        ref_p := REAL(D11) * 0.01 + ref_v * 0.01;
    END_IF;

    (* Predict U's state at the end of the current scan when outputs are applied *)
    u_v_tout := REAL(D14) * 0.01;
    u_p_tout := REAL(D13) * 0.01 + u_v_tout * 0.01;

    (* Position error between the target U and our reference trajectory *)
    err_p := u_p_tout - ref_p;

    (* Desired relative velocity with proportional gain *)
    v_des_rel := 20.0 * err_p;

    (* Limit relative velocity based on a safe catch-up deceleration profile (2000 mm/s^2) *)
    v_rel_limit := SQRT(2.0 * 2000.0 * ABS(err_p));
    IF v_des_rel > v_rel_limit THEN
        v_des_rel := v_rel_limit;
    ELSIF v_des_rel < -v_rel_limit THEN
        v_des_rel := -v_rel_limit;
    END_IF;

    (* Desired absolute velocity *)
    v_des := u_v_tout + v_des_rel;

    (* S axis absolute speed limits (-1000 to 1000 mm/s) *)
    IF v_des > 1000.0 THEN
        v_des := 1000.0;
    ELSIF v_des < -1000.0 THEN
        v_des := -1000.0;
    END_IF;

    (* S axis acceleration limit (max 5000 mm/s^2 => 50.0 mm/s per 10ms scan) *)
    IF v_des > ref_v + 50.0 THEN
        v_cmd := ref_v + 50.0;
    ELSIF v_des < ref_v - 50.0 THEN
        v_cmd := ref_v - 50.0;
    ELSE
        v_cmd := v_des;
    END_IF;

    (* Output commands to the axis feedforward buffer *)
    D20 := DINT(ref_p * 100.0);
    D21 := DINT(v_cmd * 100.0);
    Y20 := TRUE;

    (* Update internal reference states for the next PLC scan's evaluation *)
    ref_p := ref_p + v_cmd * 0.01;
    ref_v := v_cmd;

    (* Evaluate actual physical alignment *)
    act_err_p := ABS(REAL(D11) - REAL(D13));
    act_err_v := ABS(REAL(D12) - REAL(D14));
    
    IF act_err_p <= 20.0 AND act_err_v <= 100.0 THEN
        aligned := TRUE;
    ELSE
        aligned := FALSE;
    END_IF;
    
    (* Monitor alignment stability over a 30ms settling window *)
    align_timer(IN := aligned, PT := T#30ms);
    IF align_timer.Q THEN
        Y21 := TRUE;
    END_IF;
    
    (* Check complete insertion mapping onto proper alignment *)
    IF Y21 AND X11 AND aligned THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM