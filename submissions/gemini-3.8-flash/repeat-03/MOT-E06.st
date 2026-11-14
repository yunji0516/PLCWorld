PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;

    req_latched : BOOL;
    initial_pos : DINT;
    stable_timer : TON;
    completed : BOOL;
END_VAR

IF X10 THEN
    IF NOT req_latched THEN
        req_latched := TRUE;
        initial_pos := D11;
    END_IF;
END_IF;

IF req_latched THEN
    Y20 := TRUE;

    stable_timer(IN := (X11 AND (NOT X12) AND (ABS(D11 - initial_pos) <= 20)), PT := T#30ms);

    IF stable_timer.Q THEN
        completed := TRUE;
    END_IF;

    IF completed THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    stable_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM