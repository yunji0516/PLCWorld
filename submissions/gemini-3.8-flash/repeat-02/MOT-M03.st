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

    state : INT := 0;
    wait_count : INT := 0;
    align_count : INT := 0;
    result_count : INT := 0;

    r : REAL := 0.0;
    v : REAL := 0.0;
    a_cmd : REAL := 0.0;
    v_next : REAL := 0.0;

    u_pos : REAL := 0.0;
    u_vel : REAL := 0.0;
    p_err : REAL := 0.0;
    w : REAL := 0.0;
    d_stop : REAL := 0.0;
    d_acc : REAL := 0.0;
    margin : REAL := 0.0;

    s_act_p : REAL := 0.0;
    s_act_v : REAL := 0.0;
    u_act_p : REAL := 0.0;
    u_act_v : REAL := 0.0;
    err_act_p : REAL := 0.0;
    err_act_v : REAL := 0.0;
    int_err : REAL := 0.0;
    trim_p : REAL := 0.0;
    trim_v : REAL := 0.0;
    cmd_p : REAL := 0.0;
    cmd_v : REAL := 0.0;

    pos_diff : DINT := 0;
    vel_diff : DINT := 0;
    aligned : BOOL := FALSE;

    dt : REAL := 0.01;
    a_acc : REAL := 2000.0;
    a_dec : REAL := 1000.0;
    v_max : REAL := 750.0;
END_VAR

pos_diff := ABS(D11 - D13);
vel_diff := ABS(D12 - D14);
aligned := (pos_diff <= 20) AND (vel_diff <= 100);

u_act_p := REAL(D13) * 0.01;
u_act_v := REAL(D14) * 0.01;
s_act_p := REAL(D11) * 0.01;
s_act_v := REAL(D12) * 0.01;

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        D20 := D11;
        D21 := 0;
        int_err := 0.0;
        align_count := 0;
        result_count := 0;
        IF X10 THEN
            Y20 := TRUE;
            wait_count := 0;
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        D20 := D11;
        D21 := 0;
        wait_count := wait_count + 1;
        IF wait_count >= 9 THEN
            r := s_act_p;
            v := 0.0;
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        u_pos := u_act_p;
        u_vel := u_act_v;
        p_err := u_pos - r;
        w := v - u_vel;

        IF p_err > 0.0 THEN
            IF w < 0.0 THEN
                a_cmd := a_acc;
            ELSE
                d_stop := 0.5 * w * w / a_dec;
                margin := w * dt + 0.5 * a_acc * dt * dt;
                IF p_err > (d_stop + margin) THEN
                    IF v < v_max THEN
                        a_cmd := a_acc;
                    ELSE
                        a_cmd := 0.0;
                    END_IF;
                ELSE
                    a_cmd := -a_dec;
                    IF (v + a_cmd * dt) < u_vel THEN
                        a_cmd := (u_vel - v) / dt;
                    END_IF;
                END_IF;
            END_IF;
        ELSE
            d_acc := 0.5 * u_vel * u_vel / a_acc;
            IF (-p_err) > d_acc THEN
                IF v > 0.0 THEN
                    a_cmd := -a_dec;
                ELSE
                    a_cmd := 0.0;
                END_IF;
            ELSE
                IF (v + a_acc * dt) >= u_vel THEN
                    a_cmd := (u_vel - v) / dt;
                ELSE
                    a_cmd := a_acc;
                END_IF;
            END_IF;
        END_IF;

        v_next := v + a_cmd * dt;
        IF v_next > v_max THEN
            v_next := v_max;
        ELSIF v_next < 0.0 THEN
            v_next := 0.0;
        END_IF;

        r := r + 0.5 * (v + v_next) * dt;
        v := v_next;

        IF r > 1000.0 THEN
            r := 1000.0;
        ELSIF r < -1000.0 THEN
            r := -1000.0;
        END_IF;

        D20 := DINT(ROUND(r * 100.0));
        D21 := DINT(ROUND(v * 100.0));

        IF (ABS(p_err) < 3.0) AND (ABS(w) < 10.0) THEN
            align_count := 0;
            int_err := 0.0;
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;

        err_act_p := u_act_p - s_act_p;
        err_act_v := u_act_v - s_act_v;

        int_err := int_err + err_act_p * dt;
        IF int_err > 2.0 THEN
            int_err := 2.0;
        ELSIF int_err < -2.0 THEN
            int_err := -2.0;
        END_IF;

        trim_p := 0.8 * err_act_p + 2.5 * int_err;
        trim_v := 0.5 * err_act_v;

        IF trim_p > 2.0 THEN
            trim_p := 2.0;
        ELSIF trim_p < -2.0 THEN
            trim_p := -2.0;
        END_IF;

        cmd_p := u_act_p + trim_p;
        cmd_v := u_act_v + trim_v;

        IF cmd_p > 1000.0 THEN
            cmd_p := 1000.0;
        ELSIF cmd_p < -1000.0 THEN
            cmd_p := -1000.0;
        END_IF;

        IF cmd_v > 300.0 THEN
            cmd_v := 300.0;
        ELSIF cmd_v < -300.0 THEN
            cmd_v := -300.0;
        END_IF;

        D20 := DINT(ROUND(cmd_p * 100.0));
        D21 := DINT(ROUND(cmd_v * 100.0));

        IF aligned THEN
            align_count := align_count + 1;
        ELSE
            align_count := 0;
        END_IF;

        IF align_count >= 4 THEN
            result_count := 0;
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;

        err_act_p := u_act_p - s_act_p;
        err_act_v := u_act_v - s_act_v;

        int_err := int_err + err_act_p * dt;
        IF int_err > 2.0 THEN
            int_err := 2.0;
        ELSIF int_err < -2.0 THEN
            int_err := -2.0;
        END_IF;

        trim_p := 0.8 * err_act_p + 2.5 * int_err;
        trim_v := 0.5 * err_act_v;

        IF trim_p > 2.0 THEN
            trim_p := 2.0;
        ELSIF trim_p < -2.0 THEN
            trim_p := -2.0;
        END_IF;

        cmd_p := u_act_p + trim_p;
        cmd_v := u_act_v + trim_v;

        IF cmd_p > 1000.0 THEN
            cmd_p := 1000.0;
        ELSIF cmd_p < -1000.0 THEN
            cmd_p := -1000.0;
        END_IF;

        IF cmd_v > 300.0 THEN
            cmd_v := 300.0;
        ELSIF cmd_v < -300.0 THEN
            cmd_v := -300.0;
        END_IF;

        D20 := DINT(ROUND(cmd_p * 100.0));
        D21 := DINT(ROUND(cmd_v * 100.0));

        IF X11 AND aligned THEN
            result_count := result_count + 1;
        ELSE
            result_count := 0;
        END_IF;

        IF result_count >= 3 THEN
            Y2 := TRUE;
            state := 5;
        END_IF;

    5:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;

        err_act_p := u_act_p - s_act_p;
        err_act_v := u_act_v - s_act_v;

        int_err := int_err + err_act_p * dt;
        IF int_err > 2.0 THEN
            int_err := 2.0;
        ELSIF int_err < -2.0 THEN
            int_err := -2.0;
        END_IF;

        trim_p := 0.8 * err_act_p + 2.5 * int_err;
        trim_v := 0.5 * err_act_v;

        IF trim_p > 2.0 THEN
            trim_p := 2.0;
        ELSIF trim_p < -2.0 THEN
            trim_p := -2.0;
        END_IF;

        cmd_p := u_act_p + trim_p;
        cmd_v := u_act_v + trim_v;

        IF cmd_p > 1000.0 THEN
            cmd_p := 1000.0;
        ELSIF cmd_p < -1000.0 THEN
            cmd_p := -1000.0;
        END_IF;

        IF cmd_v > 300.0 THEN
            cmd_v := 300.0;
        ELSIF cmd_v < -300.0 THEN
            cmd_v := -300.0;
        END_IF;

        D20 := DINT(ROUND(cmd_p * 100.0));
        D21 := DINT(ROUND(cmd_v * 100.0));
END_CASE;

END_PROGRAM