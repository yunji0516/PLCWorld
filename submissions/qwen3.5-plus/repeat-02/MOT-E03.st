PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    speed_ok : BOOL;
    result_held : BOOL;
    t30 : TON;
    t100 : TON;
    req_decel : DINT;
    dist : DINT;
    moving_towards : BOOL;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    speed_ok := FALSE;
    result_held := FALSE;
    t30(IN := FALSE);
    t100(IN := FALSE);
ELSE
    Y20 := TRUE;

    dist := D13 - D11;
    moving_towards := (D12 > 0 AND dist > 0) OR (D12 < 0 AND dist < 0);

    IF moving_towards THEN
        IF ABS(dist) >= 1 THEN
            req_decel := DINT(REAL(D12) * REAL(D12) / (2.0 * REAL(ABS(dist))));
        ELSE
            req_decel := 400000;
        END_IF
    ELSE
        req_decel := 400000;
    END_IF

    D20 := LIMIT(0, req_decel, 400000);

    IF ABS(D12) <= 100 THEN
        speed_ok := TRUE;
    ELSE
        speed_ok := FALSE;
    END_IF

    t30(IN := speed_ok, PT := T#30ms);
    result_held := t30.Q;

    IF result_held THEN
        Y2 := TRUE;
        t100(IN := TRUE, PT := T#100ms);
    ELSE
        Y2 := FALSE;
        t100(IN := FALSE);
    END_IF
END_IF

END_PROGRAM