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
    moving_positive : BOOL;
    limit_violated : BOOL;
    done : BOOL;
    ton_hold : TON;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    init_done := FALSE;
    limit_violated := FALSE;
    done := FALSE;
    ton_hold(IN := FALSE, PT := T#30ms);
ELSE
    IF NOT init_done THEN
        IF D12 > 0 THEN
            moving_positive := TRUE;
        ELSIF D12 < 0 THEN
            moving_positive := FALSE;
        ELSE
            moving_positive := (D13 >= D11);
        END_IF;
        init_done := TRUE;
    END_IF;

    Y20 := TRUE;
    D20 := 400000;

    IF moving_positive THEN
        IF D11 > D13 THEN
            limit_violated := TRUE;
        END_IF;
    ELSE
        IF D11 < D13 THEN
            limit_violated := TRUE;
        END_IF;
    END_IF;

    ton_hold(IN := (ABS(D12) <= 100) AND NOT limit_violated, PT := T#30ms);

    IF ton_hold.Q THEN
        done := TRUE;
    END_IF;

    Y2 := done;
END_IF;

END_PROGRAM