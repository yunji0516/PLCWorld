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

    timer : TON;
    y2_latched : BOOL;
    cond_met : BOOL;

    x_pos : REAL;
    v_spd : REAL;
    L_len : REAL;
    x_tgt : REAL;
    e_x : REAL;
    c_deg : REAL;
    c_vel : REAL;
    theta_rad : REAL;
    dot_theta : REAL;

    omega0_sq : REAL;
    omega0 : REAL;
    a1 : REAL;
    a2 : REAL;
    b2 : REAL;
    k1 : REAL;
    k2 : REAL;
    k3 : REAL;
    k4 : REAL;
    u_cmd : REAL;
    cmd_dint : DINT;

    G_ACC : REAL := 9806.65;
    PI : REAL := 3.141592653589793;
    ZETA1 : REAL := 0.65;
    OMEGA2 : REAL := 2.0;
    ZETA2 : REAL := 0.85;
END_VAR

IF X10 THEN
    x_tgt := REAL(D10) * 0.01;
    x_pos := REAL(D11) * 0.01;
    v_spd := REAL(D12) * 0.01;
    L_len := REAL(D13) * 0.01;
    c_deg := REAL(D15) * 0.01;
    c_vel := REAL(D16) * 0.01;

    IF L_len < 100.0 THEN
        L_len := 1000.0;
    END_IF;

    e_x := x_pos - x_tgt;
    theta_rad := c_deg * (PI / 180.0);
    dot_theta := c_vel * (PI / 180.0);

    omega0_sq := G_ACC / L_len;
    omega0 := SQRT(omega0_sq);

    a1 := 2.0 * ZETA1 * omega0;
    b2 := OMEGA2 * OMEGA2;
    a2 := 2.0 * ZETA2 * OMEGA2;

    k1 := b2;
    k2 := a2 + a1 * (b2 / omega0_sq);
    k3 := - L_len * a1 * a2;
    k4 := L_len * a1 * (b2 / omega0_sq - 1.0);

    u_cmd := - (k1 * e_x + k2 * v_spd + k3 * theta_rad + k4 * dot_theta);
    u_cmd := LIMIT(-1750.0, u_cmd, 1750.0);

    cmd_dint := DINT(ROUND(u_cmd * 100.0));
    cmd_dint := LIMIT(-180000, cmd_dint, 180000);
    D20 := cmd_dint;

    cond_met := (ABS(e_x) <= 1.0) AND (ABS(v_spd) <= 1.0) AND (ABS(c_deg) <= 0.2) AND (ABS(c_vel) <= 1.0);

    timer(IN := cond_met, PT := T#30ms);

    IF timer.Q THEN
        y2_latched := TRUE;
    END_IF;

    Y2 := y2_latched;
ELSE
    timer(IN := FALSE, PT := T#30ms);
    y2_latched := FALSE;
    Y2 := FALSE;
    D20 := 0;
END_IF;

END_PROGRAM