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

    stab_timer : TON;
    sync_ok : BOOL;
    v_target : REAL;
    v_err : REAL;
    y2_latched : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := D10;

    v_target := REAL(D10) * REAL(D14) / 1000.0;
    v_err := ABS(REAL(D12) - v_target);
    sync_ok := (ABS(D17) <= 30) AND (v_err <= 200.0);

    stab_timer(IN := sync_ok, PT := T#30ms);
    IF stab_timer.Q THEN
        y2_latched := TRUE;
    END_IF;
    Y2 := y2_latched;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    y2_latched := FALSE;
    stab_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM