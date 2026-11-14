PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;

    traj_started : BOOL;
    t_traj : REAL;
    x_start : REAL;
    x_goal : REAL;
    dist : REAL;
    dir : REAL;
    t_acc : REAL;
    t_cruise : REAL;
    T_total : REAL;
    s_acc : REAL;
    s_cruise : REAL;
    v_peak : REAL;
    tau : REAL;
    a_prof : REAL;
    v_prof : REAL;
    s_prof : REAL;
    x_ref : REAL;
    v_ref : REAL;
    a_ref : REAL;
    theta_ref : REAL;
    omega_ref : REAL;
    L_mm : REAL;
    k1 : REAL;
    k2 : REAL;
    k3 : REAL;
    k4 : REAL;
    x_act : REAL;
    v_act : REAL;
    theta_act : REAL;
    omega_act : REAL;
    error_x : REAL;
    error_v : REAL;
    error_theta : REAL;
    error_omega : REAL;
    ax_cmd : REAL;
    ax_dint : DINT;
    cond_len : BOOL;
    cond_trolley : BOOL;
    cond_sway : BOOL;
    cond_spd_a : BOOL;
    cond_spd_b : BOOL;
    cond_spd_c : BOOL;
    all_stable : BOOL;
    stable_count : DINT;

    V_MAX : REAL := 300.0;
    A_MAX : REAL := 500.0;
    GRAV : REAL := 9810.0;
    DAMP : REAL := 0.2;
    C3 : REAL := 6.6426;
    C2 : REAL := 20.6222;
    C1 : REAL := 27.7093;
    C0 : REAL := 12.96;
    DEG_TO_RAD : REAL := 0.0174532925;
END_VAR

IF NOT X10 THEN
    traj_started := FALSE;
    t_traj := 0.0;
    stable_count := 0;
    Y2 := FALSE;
    Y20 := FALSE;
    D20 := LIMIT(60000, D11, 160000);
    D21 := 0;
ELSE
    Y20 := TRUE;
    D20 := LIMIT(60000, D10, 160000);

    IF NOT traj_started THEN
        traj_started := TRUE;
        t_traj := 0.0;
        x_start := REAL(D13) * 0.01;
        x_goal := REAL(D17) * 0.01;
        dist := ABS(x_goal - x_start);
        IF x_goal >= x_start THEN
            dir := 1.0;
        ELSE
            dir := -1.0;
        END_IF;

        IF dist < 0.1 THEN
            t_acc := 0.0;
            t_cruise := 0.0;
            T_total := 0.0;
            s_acc := 0.0;
        ELSE
            s_acc := 0.5 * V_MAX * V_MAX / A_MAX;
            IF dist < (2.0 * s_acc) THEN
                v_peak := SQRT(dist * A_MAX);
                t_acc := v_peak / A_MAX;
                t_cruise := 0.0;
                T_total := 2.0 * t_acc;
                s_acc := 0.5 * dist;
            ELSE
                t_acc := V_MAX / A_MAX;
                s_acc := 0.5 * A_MAX * t_acc * t_acc;
                s_cruise := dist - (2.0 * s_acc);
                t_cruise := s_cruise / V_MAX;
                T_total := (2.0 * t_acc) + t_cruise;
            END_IF;
        END_IF;
    END_IF;

    t_traj := t_traj + 0.01;

    IF t_traj < t_acc THEN
        a_prof := A_MAX;
        v_prof := A_MAX * t_traj;
        s_prof := 0.5 * A_MAX * t_traj * t_traj;
    ELSIF t_traj < (t_acc + t_cruise) THEN
        tau := t_traj - t_acc;
        a_prof := 0.0;
        v_prof := V_MAX;
        s_prof := s_acc + (V_MAX * tau);
    ELSIF t_traj < T_total THEN
        tau := t_traj - (t_acc + t_cruise);
        a_prof := -A_MAX;
        v_prof := V_MAX - (A_MAX * tau);
        s_prof := s_acc + (V_MAX * t_cruise) + (V_MAX * tau) - (0.5 * A_MAX * tau * tau);
    ELSE
        a_prof := 0.0;
        v_prof := 0.0;
        s_prof := dist;
    END_IF;

    x_ref := x_start + (dir * s_prof);
    v_ref := dir * v_prof;
    a_ref := dir * a_prof;
    theta_ref := - a_ref / GRAV;
    omega_ref := 0.0;

    L_mm := REAL(D11) * 0.01;
    IF L_mm < 500.0 THEN
        L_mm := 500.0;
    END_IF;

    k1 := C0 * L_mm / GRAV;
    k2 := (C1 - (k1 * DAMP)) * L_mm / GRAV;
    k3 := GRAV - (L_mm * (C2 - k1 - (k2 * DAMP)));
    k4 := L_mm * (k2 + DAMP - C3);

    x_act := REAL(D13) * 0.01;
    v_act := REAL(D14) * 0.01;
    theta_act := (REAL(D15) * 0.01) * DEG_TO_RAD;
    omega_act := (REAL(D16) * 0.01) * DEG_TO_RAD;

    error_x := x_act - x_ref;
    error_v := v_act - v_ref;
    error_theta := theta_act - theta_ref;
    error_omega := omega_act - omega_ref;

    ax_cmd := a_ref - ((k1 * error_x) + (k2 * error_v) + (k3 * error_theta) + (k4 * error_omega));
    ax_cmd := LIMIT(-4000.0, ax_cmd, 4000.0);

    ax_dint := DINT(ax_cmd * 100.0);
    D21 := LIMIT(-400000, ax_dint, 400000);

    cond_len := ABS(D11 - D10) <= 100;
    cond_trolley := ABS(D13 - D17) <= 100;
    cond_sway := ABS(D15 - D18) <= 20;
    cond_spd_a := ABS(D12) <= 100;
    cond_spd_b := ABS(D14) <= 100;
    cond_spd_c := ABS(D16) <= 100;

    all_stable := cond_len AND cond_trolley AND cond_sway AND cond_spd_a AND cond_spd_b AND cond_spd_c;

    IF all_stable THEN
        stable_count := stable_count + 1;
    ELSE
        stable_count := 0;
    END_IF;

    IF stable_count >= 3 THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM