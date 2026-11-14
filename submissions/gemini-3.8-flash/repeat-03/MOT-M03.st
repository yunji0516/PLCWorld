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
    s_ref : REAL := 0.0;
    v_ref : REAL := 0.0;
    I_err : REAL := 0.0;
    align_count : INT := 0;
    result_count : INT := 0;

    u_act : REAL;
    v_u_act : REAL;
    s_act : REAL;
    v_s_act : REAL;

    e_p : REAL;
    abs_ep : REAL;
    v_rel_target : REAL;
    v_target : REAL;
    v_err : REAL;

    e_act_err : REAL;
    trim_pos : REAL;
    trim_vel : REAL;
    cmd_pos : REAL;
    cmd_vel : REAL;

    pos_err : REAL;
    vel_err : REAL;
END_VAR

u_act := REAL(D13) * 0.01;
v_u_act := REAL(D14) * 0.01;
s_act := REAL(D11) * 0.01;
v_s_act := REAL(D12) * 0.01;

pos_err := ABS(s_act - u_act);
vel_err := ABS(v_s_act - v_u_act);

IF NOT X10 AND (state = 0) THEN
    D20 := D11;
    D21 := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    align_count := 0;
    result_count := 0;
ELSE
    IF state = 0 THEN
        s_ref := s_act;
        v_ref := v_s_act;
        I_err := 0.0;
        align_count := 0;
        result_count := 0;
        state := 10;
    END_IF;

    e_p := s_ref - u_act;
    abs_ep := ABS(e_p);

    IF abs_ep <= 17.77778 THEN
        v_rel_target := -15.0 * e_p;
    ELSE
        IF e_p > 0.0 THEN
            v_rel_target := -SQRT(4000.0 * abs_ep);
        ELSE
            v_rel_target := SQRT(4000.0 * abs_ep);
        END_IF;
    END_IF;

    v_target := LIMIT(-300.0, v_u_act + v_rel_target, 950.0);
    v_err := v_target - v_ref;
    v_ref := v_ref + LIMIT(-30.0, v_err, 30.0);
    s_ref := s_ref + v_ref * 0.01;

    IF abs_ep < 5.0 THEN
        e_act_err := u_act - s_act;
        I_err := LIMIT(-5.0, I_err + e_act_err * 0.01, 5.0);
        trim_pos := LIMIT(-1.0, 0.5 * e_act_err + 4.0 * I_err, 1.0);
        trim_vel := LIMIT(-20.0, 2.0 * e_act_err, 20.0);
    ELSE
        I_err := 0.0;
        trim_pos := 0.0;
        trim_vel := 0.0;
    END_IF;

    cmd_pos := s_ref + trim_pos;
    cmd_vel := v_ref + trim_vel;

    D20 := DINT(ROUND(cmd_pos * 100.0));
    D21 := DINT(ROUND(cmd_vel * 100.0));
    Y20 := TRUE;

    IF state = 10 THEN
        Y21 := FALSE;
        IF (pos_err <= 0.12) AND (vel_err <= 0.6) THEN
            align_count := align_count + 1;
        ELSE
            align_count := 0;
        END_IF;

        IF align_count >= 4 THEN
            state := 20;
        END_IF;
    ELSIF state = 20 THEN
        Y21 := TRUE;
        IF X11 AND (pos_err <= 0.20) AND (vel_err <= 1.0) THEN
            result_count := result_count + 1;
        ELSE
            result_count := 0;
        END_IF;

        IF result_count >= 3 THEN
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM