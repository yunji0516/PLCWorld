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
    D20 : DINT;
    Y2 : BOOL;

    ton_hold : TON;
    cond_ok : BOOL;
    err_x : DINT;
    err_v : DINT;
    err_c : DINT;
    err_w : DINT;

    target_b : REAL;
    b_pos : REAL;
    b_vel : REAL;
    L_hoist : REAL;
    c_ang : REAL;
    c_vel : REAL;

    g : REAL;
    w0_sq : REAL;
    w0 : REAL;
    w_t : REAL;
    z_t : REAL;
    z_p : REAL;
    k1 : REAL;
    k2 : REAL;
    k3 : REAL;
    k4 : REAL;
    e_x : REAL;
    v_x : REAL;
    theta_rad : REAL;
    omega_rad : REAL;
    u : REAL;
    u_clamped : REAL;
END_VAR

IF NOT X10 THEN
    D20 := 0;
    Y2 := FALSE;
    ton_hold(IN := FALSE, PT := T#30ms);
ELSE
    target_b := REAL(D10) * 0.01;
    b_pos := REAL(D11) * 0.01;
    b_vel := REAL(D12) * 0.01;
    L_hoist := REAL(D13) * 0.01;
    c_ang := REAL(D15) * 0.01;
    c_vel := REAL(D16) * 0.01;

    IF L_hoist < 100.0 THEN
        L_hoist := 1000.0;
    END_IF;

    g := 9810.0;
    w0_sq := g / L_hoist;
    w0 := SQRT(w0_sq);

    w_t := 1.7;
    z_t := 0.75;
    z_p := 0.70;

    k1 := w_t * w_t;
    k2 := 2.0 * z_t * w_t + 2.0 * z_p * (w_t * w_t) / w0;
    k3 := -4.0 * z_t * z_p * w_t * w0 * L_hoist;
    k4 := 2.0 * z_p * L_hoist * ((w_t * w_t) / w0 - w0);

    e_x := b_pos - target_b;
    v_x := b_vel;
    theta_rad := c_ang * 0.017453292519943295;
    omega_rad := c_vel * 0.017453292519943295;

    u := - (k1 * e_x + k2 * v_x + k3 * theta_rad + k4 * omega_rad);
    u_clamped := LIMIT(-1800.0, u, 1800.0);

    D20 := LIMIT(-180000, DINT(ROUND(u_clamped * 100.0)), 180000);

    err_x := ABS(D11 - D10);
    err_v := ABS(D12);
    err_c := ABS(D15);
    err_w := ABS(D16);

    cond_ok := (err_x <= 100) AND (err_v <= 100) AND (err_c <= 20) AND (err_w <= 100);

    ton_hold(IN := cond_ok, PT := T#30ms);

    IF ton_hold.Q THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM