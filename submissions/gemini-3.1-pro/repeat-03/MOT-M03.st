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

    active : BOOL;
    extend_cmd : BOOL;
    ref_p_high : DINT;
    ref_v : DINT;
    err_high : DINT;
    v_des : DINT;
    dv : DINT;
    max_dv : DINT := 8000;
    max_v : DINT := 100000;

    rel_pos : DINT;
    rel_spd : DINT;
    is_aligned : BOOL;
    result_ok : BOOL;

    align_timer : TON;
    y2_timer : TON;
END_VAR

IF X10 THEN
    IF NOT active THEN
        active := TRUE;
        ref_p_high := D11 * 100;
        ref_v := D12;
    END_IF;
    
    Y20 := TRUE;
    
    err_high := (D13 * 100) - ref_p_high;
    v_des := D14 + err_high / 10;
    
    IF v_des > max_v THEN
        v_des := max_v;
    ELSIF v_des < -max_v THEN
        v_des := -max_v;
    END_IF;
    
    dv := v_des - ref_v;
    IF dv > max_dv THEN
        dv := max_dv;
    ELSIF dv < -max_dv THEN
        dv := -max_dv;
    END_IF;
    
    ref_v := ref_v + dv;
    
    IF ref_p_high >= 0 THEN
        D20 := (ref_p_high + 50) / 100;
    ELSE
        D20 := (ref_p_high - 50) / 100;
    END_IF;
    
    D21 := ref_v;
    
    ref_p_high := ref_p_high + ref_v;
    
    rel_pos := D11 - D13;
    rel_spd := D12 - D14;
    
    is_aligned := (ABS(rel_pos) <= 20) AND (ABS(rel_spd) <= 100);
    
    align_timer(IN := is_aligned, PT := T#30ms);
    IF align_timer.Q THEN
        extend_cmd := TRUE;
    END_IF;
    
    Y21 := extend_cmd;
    
    result_ok := X11 AND is_aligned;
    y2_timer(IN := result_ok, PT := T#30ms);
    IF y2_timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    active := FALSE;
    extend_cmd := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    align_timer(IN := FALSE, PT := T#30ms);
    y2_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM