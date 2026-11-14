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

    ton_maintain : TON;
    claimed : BOOL;
    initialized : BOOL;

    theta : REAL;
    omega : REAL;
    omega_prev : REAL;
    alpha : REAL;
    theta_next : REAL;
    omega_next : REAL;
    b_ff : REAL;
    v_ff : REAL;
    moment : REAL;
    b_cmd : REAL;
    r_pos : REAL;
    r_vel : REAL;
    is_balanced : BOOL;

    DEG_TO_RAD : REAL := 0.017453292519943295;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := D11;
    D21 := 0;
    claimed := FALSE;
    initialized := FALSE;
    ton_maintain(IN := FALSE, PT := T#30ms);
ELSE
    Y20 := TRUE;

    theta := REAL(D13) * 0.01;
    omega := REAL(D14) * 0.01;

    IF NOT initialized THEN
        omega_prev := omega;
        initialized := TRUE;
    END_IF;

    alpha := (omega - omega_prev) / 0.010;
    alpha := LIMIT(-350.0, alpha, 350.0);
    omega_prev := omega;

    theta_next := theta + (omega * 0.010) + (0.5 * alpha * 0.0001);
    omega_next := omega + (alpha * 0.010);
    omega_next := LIMIT(-70.0, omega_next, 70.0);

    b_ff := -450.0 * SIN(theta_next * DEG_TO_RAD);
    v_ff := -450.0 * COS(theta_next * DEG_TO_RAD) * (omega_next * DEG_TO_RAD);

    moment := REAL(D17) * 0.01;
    b_cmd := b_ff - (2.0 * moment);

    r_pos := b_cmd * 100.0;
    IF r_pos >= 0.0 THEN
        D20 := DINT(r_pos + 0.5);
    ELSE
        D20 := DINT(r_pos - 0.5);
    END_IF;
    D20 := LIMIT(-200000, D20, 200000);

    r_vel := v_ff * 100.0;
    IF r_vel >= 0.0 THEN
        D21 := DINT(r_vel + 0.5);
    ELSE
        D21 := DINT(r_vel - 0.5);
    END_IF;
    D21 := LIMIT(-200000, D21, 200000);

    is_balanced := (ABS(D17) <= 100);
    ton_maintain(IN := is_balanced, PT := T#30ms);

    IF ton_maintain.Q THEN
        claimed := TRUE;
    END_IF;

    IF claimed THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM