PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;

    active : BOOL;
    initial_pos : DINT;
    cond : BOOL;
    t_hold : TON;
    result_latched : BOOL;
END_VAR

IF X10 AND NOT active THEN
    active := TRUE;
    initial_pos := D11;
END_IF;

IF active THEN
    Y20 := TRUE;
    cond := X11 AND (NOT X12) AND (ABS(D11 - initial_pos) <= 20);
    t_hold(IN := cond, PT := T#30ms);

    IF t_hold.Q THEN
        result_latched := TRUE;
    END_IF;

    IF result_latched THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    t_hold(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM