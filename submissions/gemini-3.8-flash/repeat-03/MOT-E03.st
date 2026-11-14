PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    init_done : BOOL;
    dir_pos : BOOL;
    limit_ok : BOOL;
    speed_ok : BOOL;
    target_met : BOOL;
    result_latched : BOOL;
    t_stable : TON;
END_VAR

IF X10 THEN
    IF NOT init_done THEN
        dir_pos := (D12 >= 0);
        init_done := TRUE;
    END_IF;

    IF dir_pos THEN
        limit_ok := (D11 <= D13);
    ELSE
        limit_ok := (D11 >= D13);
    END_IF;

    speed_ok := (ABS(D12) <= 100);
    target_met := speed_ok AND limit_ok;

    Y20 := TRUE;
    D20 := 400000;
ELSE
    init_done := FALSE;
    dir_pos := FALSE;
    limit_ok := FALSE;
    speed_ok := FALSE;
    target_met := FALSE;
    result_latched := FALSE;
    Y20 := FALSE;
    D20 := 0;
END_IF;

t_stable(IN := target_met, PT := T#30ms);

IF X10 AND t_stable.Q THEN
    result_latched := TRUE;
END_IF;

Y2 := X10 AND result_latched;

END_PROGRAM