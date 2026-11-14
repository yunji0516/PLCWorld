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
    D21 : DINT;
    Y2 : BOOL;

    ton_stable : TON;
    latched_y2 : BOOL;
    v_cmd : REAL;
    c_integral : REAL;
    X_target : REAL;
    X_pos : REAL;
    Z_pos : REAL;
    Z_vel : REAL;
    C_pos : REAL;
    C_vel : REAL;
    err_X : REAL;
    v_target : REAL;
    C_des : REAL;
    err_c : REAL;
    delta_v : REAL;
    v_left : REAL;
    v_right : REAL;
    raw_left : DINT;
    raw_right : DINT;
    cond_hold : BOOL;
END_VAR

IF NOT X10 THEN
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    latched_y2 := FALSE;
    v_cmd := 0.0;
    c_integral := 0.0;
    ton_stable(IN := FALSE, PT := T#30ms);
ELSE
    cond_hold := (ABS(D11 - D10) <= 100) AND
                 (ABS(D13) <= 200) AND
                 (ABS(D15) <= 30) AND
                 (ABS(D12) <= 200) AND
                 (ABS(D16) <= 100);

    ton_stable(IN := cond_hold, PT := T#30ms);

    IF ton_stable.Q THEN
        latched_y2 := TRUE;
    END_IF;

    IF latched_y2 THEN
        Y2 := TRUE;
        D20 := 0;
        D21 := 0;
    ELSE
        Y2 := FALSE;

        X_target := REAL(D10) / 100.0;
        X_pos    := REAL(D11) / 100.0;
        Z_pos    := REAL(D13) / 100.0;
        Z_vel    := REAL(D14) / 100.0;
        C_pos    := REAL(D15) / 100.0;
        C_vel    := REAL(D16) / 100.0;

        err_X := X_target - X_pos;

        IF err_X >= 0.0 THEN
            v_target := MIN(550.0, MIN(SQRT(4400.0 * err_X), 15.0 * err_X));
        ELSE
            v_target := - MIN(550.0, MIN(SQRT(4400.0 * (-err_X)), 15.0 * (-err_X)));
        END_IF;

        IF ABS(err_X) < 0.02 THEN
            v_target := 0.0;
        END_IF;

        IF v_target > v_cmd THEN
            v_cmd := MIN(v_target, v_cmd + 22.0);
        ELSE
            v_cmd := MAX(v_target, v_cmd - 22.0);
        END_IF;

        IF ABS(v_cmd) < 0.05 AND ABS(err_X) < 0.05 THEN
            v_cmd := 0.0;
        END_IF;

        C_des := - (0.4 * Z_pos + 0.05 * Z_vel);
        C_des := LIMIT(-6.0, 6.0, C_des);

        IF ABS(err_X) < 80.0 THEN
            C_des := C_des * (ABS(err_X) / 80.0);
        END_IF;

        err_c := C_des - C_pos;
        c_integral := LIMIT(-10.0, 10.0, c_integral + err_c * 0.01);

        delta_v := 25.0 * err_c - 1.2 * C_vel + 15.0 * c_integral;
        delta_v := LIMIT(-120.0, 120.0, delta_v);

        v_left := v_cmd - delta_v;
        v_right := v_cmd + delta_v;

        raw_left := DINT(v_left * 100.0);
        raw_right := DINT(v_right * 100.0);

        D20 := LIMIT(-200000, 200000, raw_left);
        D21 := LIMIT(-200000, 200000, raw_right);
    END_IF;
END_IF;

END_PROGRAM