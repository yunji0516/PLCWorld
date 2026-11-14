PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    ton_hold : TON;
    completed : BOOL;
    a_rad : REAL;
    target_pos : REAL;
    target_vel : REAL;
END_VAR

IF X10 THEN
    Y20 := TRUE;

    a_rad := REAL(D13) * 0.000174532925;
    target_pos := -45000.0 * SIN(a_rad);
    target_vel := -7.85398163 * COS(a_rad) * REAL(D14);

    IF target_pos >= 0.0 THEN
        D20 := DINT(target_pos + 0.5);
    ELSE
        D20 := DINT(target_pos - 0.5);
    END_IF;

    IF target_vel >= 0.0 THEN
        D21 := DINT(target_vel + 0.5);
    ELSE
        D21 := DINT(target_vel - 0.5);
    END_IF;

    D20 := LIMIT(-200000, D20, 200000);
    D21 := LIMIT(-200000, D21, 200000);

    ton_hold(IN := (D17 >= -100) AND (D17 <= 100), PT := T#30ms);
    IF ton_hold.Q THEN
        completed := TRUE;
    END_IF;
    Y2 := completed;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    completed := FALSE;
    D20 := D11;
    D21 := 0;
    ton_hold(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM