PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;

    req_latched : BOOL;
    completed : BOOL;
    home_done_cond : BOOL;
    stable_timer : TON;
END_VAR

IF X10 THEN
    req_latched := TRUE;
END_IF;

IF req_latched THEN
    Y21 := TRUE;
ELSE
    Y21 := FALSE;
END_IF;

home_done_cond := req_latched AND X11 AND (NOT X12) AND X13 AND (ABS(D12) <= 100);

stable_timer(IN := home_done_cond, PT := T#30ms);

IF stable_timer.Q THEN
    completed := TRUE;
END_IF;

Y2 := completed;

END_PROGRAM