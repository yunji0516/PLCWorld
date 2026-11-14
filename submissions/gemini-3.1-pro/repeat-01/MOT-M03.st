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

    init : BOOL := FALSE;
    p_ref : REAL;
    v_ref : REAL;
    p_u : REAL;
    v_u : REAL;
    dp : REAL;
    abs_dp : REAL;
    v_rel_des : REAL;
    v_desired : REAL;
    dv : REAL;
    dv_max : REAL;

    aligned : BOOL;
    enable_timer : TON;
    align_timer : TON;
END_VAR

IF NOT X10 THEN
    init := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    D20 := D11;
    D21 := 0;
    enable_timer(IN := FALSE, PT := T#40ms);
    align_timer(IN := FALSE, PT := T#30ms);
    RETURN;
END_IF;

Y20 := TRUE;
enable_timer(IN := TRUE, PT := T#40ms);

IF NOT enable_timer.Q THEN
    D20 := D11;
    D21 := D12;
    align_timer(IN := FALSE, PT := T#30ms);
ELSE
    IF NOT init THEN
        p_ref := REAL(D11) / 100.0;
        v_ref := REAL(D12) / 100.0;
        init := TRUE;
    END_IF;

    p_u := REAL(D13) / 100.0;
    v_u := REAL(D14) / 100.0;

    dp := p_u - p_ref;
    abs_dp := ABS(dp);

    (* If close enough, snap exactly to target to eliminate quantization ripple *)
    IF abs_dp < 0.05 AND ABS(v_ref - v_u) < 1.0 THEN
        v_desired := v_u;
        v_ref := v_u;
        p_ref := p_u;
        dv := 0.0;
    ELSE
        (* Smooth continuous P-control merged with a dynamically optimal sqrt deceleration profile *)
        IF abs_dp < 5.0 THEN
            v_rel_des := 40.0 * abs_dp;
        ELSE
            v_rel_des := SQRT(16000.0 * (abs_dp - 2.5));
        END_IF;

        IF dp < 0.0 THEN
            v_rel_des := -v_rel_des;
        END_IF;

        v_desired := v_u + v_rel_des;

        (* Enforce drive velocity limit *)
        IF v_desired > 1100.0 THEN
            v_desired := 1100.0;
        ELSIF v_desired < -1100.0 THEN
            v_desired := -1100.0;
        END_IF;

        dv := v_desired - v_ref;
        dv_max := 100.0; (* Equivalent to bounded acceleration of 10000 mm/s^2 *)

        IF dv > dv_max THEN
            dv := dv_max;
        ELSIF dv < -dv_max THEN
            dv := -dv_max;
        END_IF;

        v_ref := v_ref + dv;
    END_IF;

    D20 := DINT(p_ref * 100.0);
    D21 := DINT(v_ref * 100.0);

    p_ref := p_ref + v_ref * 0.01;

    (* Assess operational alignment against standard limits *)
    aligned := ABS(D11 - D13) <= 20 AND ABS(D12 - D14) <= 100;
    align_timer(IN := aligned, PT := T#30ms);

    IF align_timer.Q THEN
        Y21 := TRUE;
    END_IF;

    Y2 := (Y21 AND X11 AND aligned);
END_IF;

END_PROGRAM