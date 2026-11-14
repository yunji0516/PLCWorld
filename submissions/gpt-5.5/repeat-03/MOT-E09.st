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
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    request_active : BOOL;
    result_latched : BOOL;
    stable_condition : BOOL;
    stable_timer : TON;
    orientation_raw : DINT;
    orientation_rate_raw : DINT;
    ideal_c_raw : DINT;
    cmd_pos_raw : DINT;
    cmd_vel_raw : DINT;
    integral_raw : DINT;
    command_high : DINT := 200000;
    command_low : DINT := -200000;
    integral_high : DINT := 30000;
    integral_low : DINT := -30000;
END_VAR

IF X10 THEN
    request_active := TRUE;
END_IF;

orientation_raw := D13 + D15 + D11 - D10;
orientation_rate_raw := D14 + D16 + D12;

IF request_active THEN
    Y20 := TRUE;

    integral_raw := integral_raw - (orientation_raw / 4);
    IF integral_raw > integral_high THEN
        integral_raw := integral_high;
    ELSIF integral_raw < integral_low THEN
        integral_raw := integral_low;
    END_IF;

    ideal_c_raw := D10 - D13 - D15;

    cmd_pos_raw := ideal_c_raw + integral_raw - (3 * orientation_raw);
    cmd_vel_raw := 0 - D14 - D16 - (20 * orientation_raw) - orientation_rate_raw;

    IF cmd_pos_raw > command_high THEN
        D20 := command_high;
    ELSIF cmd_pos_raw < command_low THEN
        D20 := command_low;
    ELSE
        D20 := cmd_pos_raw;
    END_IF;

    IF cmd_vel_raw > command_high THEN
        D21 := command_high;
    ELSIF cmd_vel_raw < command_low THEN
        D21 := command_low;
    ELSE
        D21 := cmd_vel_raw;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    integral_raw := 0;
END_IF;

stable_condition := request_active AND (ABS(orientation_raw) <= 190);

stable_timer(IN := stable_condition, PT := T#30ms);

IF stable_timer.Q THEN
    result_latched := TRUE;
END_IF;

Y2 := result_latched;

END_PROGRAM