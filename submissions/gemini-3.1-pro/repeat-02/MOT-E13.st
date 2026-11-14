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

    err_X : REAL;
    abs_err_X : REAL;
    err_Z : REAL;
    C_actual : REAL;
    err_C : REAL;
    C_ref : REAL;
    I_err_C : REAL;
    v_target_max : REAL;
    v_ref : REAL;
    w_ref : REAL;
    delta_v : REAL;
    v_left : REAL;
    v_right : REAL;

    abs_vX : REAL;
    abs_vC : REAL;

    cond_X : BOOL;
    cond_Z : BOOL;
    cond_C : BOOL;
    cond_vX : BOOL;
    cond_vC : BOOL;
    completion_cond : BOOL;

    completion_timer : TON;
END_VAR

IF NOT X10 THEN
    D20 := DINT(0);
    D21 := DINT(0);
    I_err_C := 0.0;
    Y2 := FALSE;
    completion_timer(IN := FALSE, PT := T#30ms);
ELSE
    err_X := (REAL(D10) - REAL(D11)) / 100.0;
    abs_err_X := ABS(err_X);

    IF abs_err_X > 80.0 THEN
        v_target_max := SQRT(2000.0 * abs_err_X);
    ELSE
        v_target_max := 5.0 * abs_err_X;
    END_IF;
    
    IF v_target_max > 1000.0 THEN 
        v_target_max := 1000.0; 
    END_IF;

    IF err_X > 0.0 THEN
        v_ref := v_target_max;
    ELSE
        v_ref := -v_target_max;
    END_IF;

    err_Z := -REAL(D13) / 100.0;
    C_ref := 0.2 * err_Z;
    IF C_ref > 15.0 THEN C_ref := 15.0; END_IF;
    IF C_ref < -15.0 THEN C_ref := -15.0; END_IF;

    C_actual := REAL(D15) / 100.0;
    err_C := C_ref - C_actual;

    I_err_C := I_err_C + err_C * 0.01;
    IF I_err_C > 5.0 THEN I_err_C := 5.0; END_IF;
    IF I_err_C < -5.0 THEN I_err_C := -5.0; END_IF;

    w_ref := 10.0 * err_C + 5.0 * I_err_C;
    IF w_ref > 100.0 THEN w_ref := 100.0; END_IF;
    IF w_ref < -100.0 THEN w_ref := -100.0; END_IF;

    delta_v := w_ref * 10.4719755;

    v_left := v_ref - delta_v / 2.0;
    v_right := v_ref + delta_v / 2.0;

    D20 := DINT(v_left * 100.0);
    D21 := DINT(v_right * 100.0);

    abs_vX := ABS(REAL(D12) / 100.0);
    abs_vC := ABS(REAL(D16) / 100.0);

    cond_X := abs_err_X <= 1.0;
    cond_Z := ABS(err_Z) <= 2.0;
    cond_C := ABS(C_actual) <= 0.3;
    cond_vX := abs_vX <= 2.0;
    cond_vC := abs_vC <= 1.0;

    completion_cond := cond_X AND cond_Z AND cond_C AND cond_vX AND cond_vC;
    completion_timer(IN := completion_cond, PT := T#30ms);

    IF completion_timer.Q THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM