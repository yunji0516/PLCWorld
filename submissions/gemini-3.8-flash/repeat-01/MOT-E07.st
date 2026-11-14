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

    v_diff : REAL;
    pos_ok : BOOL;
    v_ok : BOOL;
    sync_ok : BOOL;
    y2_latched : BOOL;
    t_sync : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := D10;

    v_diff := REAL(D12) - (REAL(D14) * REAL(D10) / 1000.0);
    pos_ok := (D17 >= -30) AND (D17 <= 30);
    v_ok := (v_diff >= -200.0) AND (v_diff <= 200.0);
    sync_ok := pos_ok AND v_ok;

    t_sync(IN := sync_ok, PT := T#30ms);
    IF t_sync.Q THEN
        y2_latched := TRUE;
    END_IF;

    Y2 := y2_latched;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    y2_latched := FALSE;
    t_sync(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM