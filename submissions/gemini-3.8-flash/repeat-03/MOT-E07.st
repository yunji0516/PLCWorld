PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    target_v : REAL;
    actual_v : REAL;
    sync_ok : BOOL;
    t_sync : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);

    target_v := REAL(D14) * REAL(D10) / 1000.0;
    actual_v := REAL(D12);

    sync_ok := (ABS(D17) <= 30) AND (ABS(actual_v - target_v) <= 200.0);

    t_sync(IN := sync_ok, PT := T#30ms);
    IF t_sync.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    t_sync(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM