PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    active : BOOL;
    y2_latched : BOOL;
    cmd_pos : REAL;
    cmd_vel : REAL;
    target_pos : REAL;
    diff : REAL;
    dist : REAL;
    v_limit : REAL;
    v_target : REAL;
    step : REAL;
    cond_met : BOOL;
    t_stable : TON;

    a_accel : REAL := 3500.0;
    a_decel : REAL := 3000.0;
    v_max : REAL := 750.0;
    dt : REAL := 0.01;
END_VAR

IF X10 THEN
    IF NOT active THEN
        active := TRUE;
        cmd_pos := REAL(D11) * 0.01;
        cmd_vel := 0.0;
    END_IF;

    target_pos := REAL(D10) * 0.01;
    diff := target_pos - cmd_pos;
    dist := ABS(diff);

    IF dist < 0.01 THEN
        cmd_pos := target_pos;
        cmd_vel := 0.0;
    ELSE
        v_limit := SQRT(2.0 * a_decel * dist);
        v_target := MIN(v_max, v_limit);
        IF cmd_vel < v_target THEN
            cmd_vel := MIN(v_target, cmd_vel + a_accel * dt);
        ELSE
            cmd_vel := MAX(v_target, cmd_vel - a_decel * dt);
        END_IF;

        step := cmd_vel * dt;
        IF step >= dist THEN
            cmd_pos := target_pos;
            cmd_vel := 0.0;
        ELSE
            IF diff > 0.0 THEN
                cmd_pos := cmd_pos + step;
            ELSE
                cmd_pos := cmd_pos - step;
            END_IF;
        END_IF;
    END_IF;

    IF ABS(cmd_pos - target_pos) < 0.001 THEN
        D20 := D10;
    ELSE
        IF cmd_pos >= 0.0 THEN
            D20 := DINT(cmd_pos * 100.0 + 0.5);
        ELSE
            D20 := DINT(cmd_pos * 100.0 - 0.5);
        END_IF;
    END_IF;
    D20 := LIMIT(-200000, D20, 200000);
    Y20 := TRUE;

    cond_met := (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100);
    t_stable(IN := cond_met, PT := T#30ms);

    IF t_stable.Q THEN
        y2_latched := TRUE;
    END_IF;
    Y2 := y2_latched;
ELSE
    active := FALSE;
    y2_latched := FALSE;
    cmd_vel := 0.0;
    cmd_pos := REAL(D11) * 0.01;
    D20 := D11;
    Y20 := FALSE;
    Y2 := FALSE;
    t_stable(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM