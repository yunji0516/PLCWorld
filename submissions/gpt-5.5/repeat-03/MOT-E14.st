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
    Y2 : BOOL;
    active : BOOL;
    result_latched : BOOL;
    stable_timer : TON;
    target_mm : REAL;
    trolley_pos_mm : REAL;
    trolley_speed_mm_s : REAL;
    pos_error_mm : REAL;
    length_m : REAL;
    sway_deg : REAL;
    sway_speed_deg_s : REAL;
    w0_sq : REAL;
    k_sway_pos : REAL;
    k_sway_speed : REAL;
    acc_cmd_mm_s2 : REAL;
    acc_raw : REAL;
    stable_condition : BOOL;
END_VAR

IF X10 THEN
    active := TRUE;
END_IF;

IF active THEN
    target_mm := REAL(D10) * 0.01;
    trolley_pos_mm := REAL(D11) * 0.01;
    trolley_speed_mm_s := REAL(D12) * 0.01;
    pos_error_mm := trolley_pos_mm - target_mm;

    length_m := REAL(D13) * 0.00001;
    IF length_m < 0.8 THEN
        length_m := 0.8;
    ELSIF length_m > 1.1 THEN
        length_m := 1.1;
    END_IF;

    sway_deg := REAL(D15) * 0.01;
    sway_speed_deg_s := REAL(D16) * 0.01;

    w0_sq := 9.80665 / length_m;

    k_sway_pos := (25.0 - w0_sq) * length_m * 17.453293;
    k_sway_speed := 12.0 * length_m * 17.453293;

    acc_cmd_mm_s2 := (k_sway_pos * sway_deg)
                     + (k_sway_speed * sway_speed_deg_s)
                     - (3.0 * pos_error_mm)
                     - (4.0 * trolley_speed_mm_s);

    IF acc_cmd_mm_s2 > 1800.0 THEN
        acc_cmd_mm_s2 := 1800.0;
    ELSIF acc_cmd_mm_s2 < -1800.0 THEN
        acc_cmd_mm_s2 := -1800.0;
    END_IF;

    acc_raw := acc_cmd_mm_s2 * 100.0;

    IF acc_raw > 180000.0 THEN
        D20 := 180000;
    ELSIF acc_raw < -180000.0 THEN
        D20 := -180000;
    ELSE
        D20 := DINT(acc_raw);
    END_IF;

    stable_condition := (ABS(pos_error_mm) <= 0.5)
                        AND (ABS(trolley_speed_mm_s) <= 0.4)
                        AND (ABS(sway_deg) <= 0.1)
                        AND (ABS(sway_speed_deg_s) <= 0.4);

    stable_timer(IN := stable_condition, PT := T#30ms);

    IF stable_timer.Q THEN
        result_latched := TRUE;
    END_IF;

    Y2 := result_latched;
ELSE
    D20 := 0;
    Y2 := FALSE;
    stable_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM