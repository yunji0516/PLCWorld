PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    started : BOOL;
    init_spd : DINT;
    init_pos : DINT;
    limit_ok : BOOL;
    stop_ok : BOOL;
    y2_latched : BOOL;
    t_stable : TON;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    y2_latched := FALSE;
    started := FALSE;
    init_spd := 0;
    init_pos := 0;
    t_stable(IN := FALSE, PT := T#30ms);
ELSE
    IF NOT started THEN
        init_spd := D12;
        init_pos := D11;
        started := TRUE;
    END_IF;

    Y20 := TRUE;
    D20 := 400000;

    IF init_spd > 0 THEN
        limit_ok := (D11 <= D13);
    ELSIF init_spd < 0 THEN
        limit_ok := (D11 >= D13);
    ELSE
        IF D13 >= init_pos THEN
            limit_ok := (D11 <= D13);
        ELSE
            limit_ok := (D11 >= D13);
        END_IF;
    END_IF;

    stop_ok := (ABS(D12) <= 100) AND limit_ok;

    t_stable(IN := stop_ok, PT := T#30ms);
    IF t_stable.Q THEN
        y2_latched := TRUE;
    END_IF;

    Y2 := y2_latched;
END_IF;

END_PROGRAM