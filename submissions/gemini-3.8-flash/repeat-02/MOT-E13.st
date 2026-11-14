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

    target_x : REAL;
    x_mm : REAL;
    vx_mm_s : REAL;
    b_mm : REAL;
    vb_mm_s : REAL;
    c_deg : REAL;
    vc_deg_s : REAL;

    error_x : REAL;
    v_raw : REAL;
    v_target : REAL;
    v_cmd : REAL;

    weight : REAL;
    c_des : REAL;
    err_c : REAL;
    int_c : REAL;
    delta_v : REAL;

    v_l_cmd : REAL;
    v_r_cmd : REAL;
    raw_left : DINT;
    raw_right : DINT;

    condition_met : BOOL;
    completed : BOOL;
    ton_stable : TON;
END_VAR

IF NOT X10 THEN
    v_cmd := 0.0;
    int_c := 0.0;
    completed := FALSE;
    ton_stable(IN := FALSE, PT := T#30ms);
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
ELSE
    target_x := REAL(D10) / 100.0;
    x_mm := REAL(D11) / 100.0;
    vx_mm_s := REAL(D12) / 100.0;
    b_mm := REAL(D13) / 100.0;
    vb_mm_s := REAL(D14) / 100.0;
    c_deg := REAL(D15) / 100.0;
    vc_deg_s := REAL(D16) / 100.0;

    condition_met := (ABS(x_mm - target_x) <= 1.0) AND
                     (ABS(b_mm) <= 2.0) AND
                     (ABS(c_deg) <= 0.3) AND
                     (ABS(vx_mm_s) <= 2.0) AND
                     (ABS(vc_deg_s) <= 1.0);

    ton_stable(IN := condition_met, PT := T#30ms);

    IF ton_stable.Q THEN
        completed := TRUE;
    END_IF;

    IF completed THEN
        Y2 := TRUE;
        D20 := 0;
        D21 := 0;
    ELSE
        Y2 := FALSE;
        error_x := target_x - x_mm;

        IF ABS(error_x) <= 0.2 THEN
            v_target := 0.0;
        ELSIF error_x > 0.2 THEN
            v_raw := SQRT(2.0 * 1600.0 * (error_x - 0.2));
            IF v_raw > 700.0 THEN
                v_raw := 700.0;
            END_IF;
            IF v_raw > (12.0 * error_x) THEN
                v_raw := 12.0 * error_x;
            END_IF;
            v_target := v_raw;
        ELSE
            v_raw := SQRT(2.0 * 1600.0 * (-error_x - 0.2));
            IF v_raw > 700.0 THEN
                v_raw := 700.0;
            END_IF;
            IF v_raw > (12.0 * (-error_x)) THEN
                v_raw := 12.0 * (-error_x);
            END_IF;
            v_target := -v_raw;
        END_IF;

        IF (error_x < 150.0) AND (ABS(b_mm) > 1.0) THEN
            IF v_target > 150.0 THEN
                v_target := 150.0;
            END_IF;
        END_IF;

        IF v_target > v_cmd THEN
            v_cmd := MIN(v_target, v_cmd + 22.0);
        ELSE
            v_cmd := MAX(v_target, v_cmd - 22.0);
        END_IF;

        IF error_x > 80.0 THEN
            weight := 1.0;
        ELSIF error_x > 0.0 THEN
            weight := error_x / 80.0;
        ELSE
            weight := 0.0;
        END_IF;

        c_des := LIMIT(-6.0, weight * (-0.35 * b_mm), 6.0);
        err_c := c_des - c_deg;

        IF ABS(v_cmd) > 20.0 THEN
            int_c := int_c + 60.0 * err_c * 0.010;
            int_c := LIMIT(-40.0, int_c, 40.0);
        ELSE
            int_c := int_c * 0.90;
        END_IF;

        delta_v := 70.0 * err_c - 3.5 * vc_deg_s + int_c;
        delta_v := LIMIT(-300.0, delta_v, 300.0);

        v_l_cmd := v_cmd - (delta_v * 0.5);
        v_r_cmd := v_cmd + (delta_v * 0.5);

        raw_left := DINT(v_l_cmd * 100.0);
        raw_right := DINT(v_r_cmd * 100.0);

        raw_left := LIMIT(-200000, raw_left, 200000);
        raw_right := LIMIT(-200000, raw_right, 200000);

        D20 := raw_left;
        D21 := raw_right;
    END_IF;
END_IF;

END_PROGRAM