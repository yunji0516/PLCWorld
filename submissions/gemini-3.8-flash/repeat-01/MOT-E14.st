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

    PI : REAL := 3.14159265;
    GRAVITY : REAL := 9806.65;

    r_pos : REAL;
    r_target : REAL;
    r_vel : REAL;
    r_sway : REAL;
    r_ang_vel : REAL;
    r_len : REAL;

    w0_sq : REAL;
    w0 : REAL;
    a_p : REAL;
    a_t : REAL;
    b_t : REAL;
    k1 : REAL;
    k2 : REAL;
    k3 : REAL;
    k4 : REAL;

    c_rad : REAL;
    c_vel_rad : REAL;
    u_cmd : REAL;

    cond_met : BOOL;
    result_retained : BOOL;
    ton_hold : TON;
END_VAR

IF NOT X10 THEN
    D20 := 0;
    Y2 := FALSE;
    result_retained := FALSE;
    ton_hold(IN := FALSE, PT := T#30ms);
ELSE
    r_pos := REAL(D11) * 0.01;
    r_target := REAL(D10) * 0.01;
    r_vel := REAL(D12) * 0.01;
    r_len := REAL(D13) * 0.01;
    r_sway := REAL(D15) * 0.01;
    r_ang_vel := REAL(D16) * 0.01;

    IF r_len < 100.0 THEN
        r_len := 1000.0;
    END_IF;

    w0_sq := GRAVITY / r_len;
    w0 := SQRT(w0_sq);

    a_p := 2.0 * 0.75 * w0;
    b_t := 1.7 * 1.7;
    a_t := 2.0 * 0.85 * 1.7;

    k1 := b_t;
    k2 := a_t + (a_p * b_t) / w0_sq;
    k3 := - r_len * a_p * a_t;
    k4 := r_len * a_p * (b_t / w0_sq - 1.0);

    c_rad := r_sway * (PI / 180.0);
    c_vel_rad := r_ang_vel * (PI / 180.0);

    u_cmd := - (k1 * (r_pos - r_target) + k2 * r_vel + k3 * c_rad + k4 * c_vel_rad);

    IF u_cmd > 1800.0 THEN
        u_cmd := 1800.0;
    ELSIF u_cmd < -1800.0 THEN
        u_cmd := -1800.0;
    END_IF;

    D20 := DINT(u_cmd * 100.0);

    cond_met := (ABS(r_pos - r_target) <= 1.0) AND
                (ABS(r_vel) <= 1.0) AND
                (ABS(r_sway) <= 0.2) AND
                (ABS(r_ang_vel) <= 1.0);

    ton_hold(IN := cond_met, PT := T#30ms);

    IF ton_hold.Q THEN
        result_retained := TRUE;
    END_IF;

    Y2 := result_retained;
END_IF;

END_PROGRAM