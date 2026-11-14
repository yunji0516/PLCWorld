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

    x_target : REAL;
    x_val : REAL;
    x_vel : REAL;
    z_val : REAL;
    z_vel : REAL;
    c_val : REAL;
    c_vel : REAL;
    e_x : REAL;
    e_c : REAL;
    v_brake : REAL;
    v_desired : REAL;
    v_cmd : REAL;
    v_cmd_prev : REAL;
    c_des : REAL;
    int_c : REAL;
    omega_cmd : REAL;
    diff : REAL;
    v_left : REAL;
    v_right : REAL;

    cond_x : BOOL;
    cond_z : BOOL;
    cond_c : BOOL;
    cond_vx : BOOL;
    cond_vc : BOOL;
    all_ok : BOOL;
    completed : BOOL;
    t_stable : TON;
END_VAR

IF NOT X10 THEN
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    v_cmd := 0.0;
    v_cmd_prev := 0.0;
    int_c := 0.0;
    completed := FALSE;
    t_stable(IN := FALSE, PT := T#30ms);
ELSE
    x_target := REAL(D10) / 100.0;
    x_val := REAL(D11) / 100.0;
    x_vel := REAL(D12) / 100.0;
    z_val := REAL(D13) / 100.0;
    z_vel := REAL(D14) / 100.0;
    c_val := REAL(D15) / 100.0;
    c_vel := REAL(D16) / 100.0;

    cond_x := ABS(D11 - D10) <= 100;
    cond_z := ABS(D13) <= 200;
    cond_c := ABS(D15) <= 30;
    cond_vx := ABS(D12) <= 200;
    cond_vc := ABS(D16) <= 100;

    all_ok := cond_x AND cond_z AND cond_c AND cond_vx AND cond_vc;

    t_stable(IN := all_ok, PT := T#30ms);
    IF t_stable.Q THEN
        completed := TRUE;
    END_IF;

    IF completed THEN
        Y2 := TRUE;
        D20 := 0;
        D21 := 0;
        v_cmd_prev := 0.0;
    ELSE
        Y2 := FALSE;
        e_x := x_target - x_val;

        IF ABS(e_x) <= 0.05 THEN
            v_desired := 0.0;
        ELSIF e_x > 0.05 THEN
            v_brake := SQRT(2.0 * 1200.0 * e_x);
            v_desired := MIN(650.0, MIN(v_brake, 10.0 * e_x));
        ELSE
            v_brake := SQRT(2.0 * 1200.0 * ABS(e_x));
            v_desired := - MIN(650.0, MIN(v_brake, 10.0 * ABS(e_x)));
        END_IF;

        IF v_desired > v_cmd_prev + 18.0 THEN
            v_cmd := v_cmd_prev + 18.0;
        ELSIF v_desired < v_cmd_prev - 18.0 THEN
            v_cmd := v_cmd_prev - 18.0;
        ELSE
            v_cmd := v_desired;
        END_IF;
        v_cmd_prev := v_cmd;

        IF ABS(e_x) <= 25.0 THEN
            c_des := 0.0;
        ELSE
            c_des := LIMIT(-8.0, -0.25 * z_val - 0.03 * z_vel, 8.0);
        END_IF;

        e_c := c_val - c_des;

        IF ABS(v_cmd) > 10.0 THEN
            int_c := LIMIT(-3.0, int_c + e_c * 0.01, 3.0);
        ELSE
            int_c := int_c * 0.95;
        END_IF;

        omega_cmd := - 6.0 * e_c - 0.15 * c_vel - 9.0 * int_c;
        diff := LIMIT(-200.0, omega_cmd * 10.4719755, 200.0);

        v_left := v_cmd - diff / 2.0;
        v_right := v_cmd + diff / 2.0;

        D20 := LIMIT(-200000, DINT(v_left * 100.0), 200000);
        D21 := LIMIT(-200000, DINT(v_right * 100.0), 200000);
    END_IF;
END_IF;

END_PROGRAM