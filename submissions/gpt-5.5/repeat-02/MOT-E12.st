PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    accepted : BOOL;
    target_raw : DINT;
    pos_raw : DINT;
    speed_raw : DINT;
    error_raw : DINT;
    abs_error_raw : DINT;
    abs_speed_raw : DINT;
    remaining_raw : DINT;
    speed_mmps : DINT;
    stop_raw : DINT;
    command_raw : DINT;
    integral_raw : DINT;
    stable_ms : DINT;
    result_ok : BOOL;
    fast_retract : BOOL;
END_VAR

pos_raw := D11;
speed_raw := D12;

IF (NOT accepted) THEN
    IF X10 THEN
        accepted := TRUE;
        IF D10 < 10000 THEN
            target_raw := 10000;
        ELSIF D10 > 15000 THEN
            target_raw := 15000;
        ELSE
            target_raw := D10;
        END_IF;
        stable_ms := 0;
        integral_raw := 0;
        Y2 := FALSE;
    END_IF;
END_IF;

IF accepted THEN
    Y20 := TRUE;

    error_raw := target_raw - pos_raw;
    abs_error_raw := ABS(error_raw);
    abs_speed_raw := ABS(speed_raw);

    result_ok := (abs_error_raw <= 20) AND (abs_speed_raw <= 100);

    IF result_ok THEN
        IF stable_ms < 100000 THEN
            stable_ms := stable_ms + 10;
        END_IF;
    ELSE
        IF NOT Y2 THEN
            stable_ms := 0;
        END_IF;
    END_IF;

    IF (NOT Y2) AND (stable_ms >= 30) THEN
        Y2 := TRUE;
    END_IF;

    fast_retract := FALSE;
    remaining_raw := 0;
    speed_mmps := 0;
    stop_raw := 0;

    IF error_raw < 0 THEN
        remaining_raw := -error_raw;
        IF speed_raw < 0 THEN
            speed_mmps := (-speed_raw) / 100;
        ELSE
            speed_mmps := 0;
        END_IF;
        stop_raw := (speed_mmps * speed_mmps) / 160;
        IF remaining_raw > (stop_raw + 3000) THEN
            fast_retract := TRUE;
        END_IF;
    END_IF;

    IF fast_retract THEN
        command_raw := 0;
        integral_raw := 0;
    ELSE
        IF (NOT result_ok) AND (abs_error_raw < 5000) AND (abs_speed_raw < 10000) THEN
            integral_raw := integral_raw + (error_raw / 2);
            IF integral_raw > 60000 THEN
                integral_raw := 60000;
            ELSIF integral_raw < -30000 THEN
                integral_raw := -30000;
            END_IF;
        END_IF;

        command_raw := target_raw + (4 * error_raw) - (speed_raw / 2) + integral_raw;

        IF command_raw < 0 THEN
            command_raw := 0;
        ELSIF command_raw > 120000 THEN
            command_raw := 120000;
        END_IF;
    END_IF;

    D20 := command_raw;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    stable_ms := 0;
END_IF;

END_PROGRAM