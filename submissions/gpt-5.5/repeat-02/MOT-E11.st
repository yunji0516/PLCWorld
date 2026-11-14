PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    request_accepted : BOOL;
    obstacle_latched : BOOL;
    target_raw : DINT;
    pos_error : DINT;
    pos_abs : DINT;
    speed_abs : DINT;
    bias_raw : DINT := 25000;
    bias_limit : DINT := 25000;
    cmd_calc : DINT;
    cmd_limited : DINT;
    open_limit : DINT;
    stable_count : INT;
    stable_condition : BOOL;
    permitted_hi : DINT := 200000;
    permitted_lo : DINT := -200000;
END_VAR

IF NOT request_accepted THEN
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    stable_count := 0;

    IF X10 THEN
        request_accepted := TRUE;
        target_raw := D10;
    END_IF;
END_IF;

IF request_accepted THEN
    IF X11 THEN
        obstacle_latched := TRUE;
    END_IF;

    IF obstacle_latched THEN
        Y20 := TRUE;

        pos_error := target_raw - D11;

        IF NOT Y2 THEN
            bias_raw := bias_raw + (pos_error / 2);

            IF bias_raw > bias_limit THEN
                bias_raw := bias_limit;
            ELSIF bias_raw < 0 THEN
                bias_raw := 0;
            END_IF;
        END_IF;

        open_limit := target_raw + bias_limit;
        IF open_limit > permitted_hi THEN
            open_limit := permitted_hi;
        ELSIF open_limit < permitted_lo THEN
            open_limit := permitted_lo;
        END_IF;

        cmd_calc := target_raw + bias_raw + (pos_error * 20) - D12;

        IF cmd_calc > open_limit THEN
            cmd_limited := open_limit;
        ELSIF cmd_calc < 0 THEN
            cmd_limited := 0;
        ELSE
            cmd_limited := cmd_calc;
        END_IF;

        IF cmd_limited > permitted_hi THEN
            cmd_limited := permitted_hi;
        ELSIF cmd_limited < permitted_lo THEN
            cmd_limited := permitted_lo;
        END_IF;

        D20 := cmd_limited;

        pos_abs := ABS(pos_error);
        speed_abs := ABS(D12);

        stable_condition := (pos_abs <= 19) AND (speed_abs <= 90);

        IF stable_condition THEN
            IF stable_count < 1000 THEN
                stable_count := stable_count + 1;
            END_IF;
        ELSE
            stable_count := 0;
        END_IF;

        IF stable_count >= 5 THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        Y20 := FALSE;
        D20 := 0;
        stable_count := 0;
    END_IF;
END_IF;

END_PROGRAM