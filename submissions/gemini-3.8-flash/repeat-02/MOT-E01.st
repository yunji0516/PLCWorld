PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    pos_diff : DINT;
    pos_err : DINT;
    speed_abs : DINT;
    cond_stable : BOOL;
    t_stable : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);

    pos_diff := D11 - D10;
    IF pos_diff < 0 THEN
        pos_err := -pos_diff;
    ELSE
        pos_err := pos_diff;
    END_IF;

    IF D12 < 0 THEN
        speed_abs := -D12;
    ELSE
        speed_abs := D12;
    END_IF;

    cond_stable := (pos_err <= 20) AND (speed_abs <= 100);
    t_stable(IN := cond_stable, PT := T#30ms);

    IF t_stable.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := LIMIT(-200000, D11, 200000);
    t_stable(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM