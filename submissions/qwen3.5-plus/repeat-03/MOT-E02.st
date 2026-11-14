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
    timer_complete : TON;
    comp_cond : BOOL;
END_VAR

IF X10 THEN
    req_latched := TRUE;
END_IF;

IF req_latched AND NOT Y2 THEN
    IF NOT X11 THEN
        Y21 := TRUE;
    ELSIF X13 THEN
        Y21 := FALSE;
    END_IF;
ELSE
    Y21 := FALSE;
END_IF;

comp_cond := X11 AND (NOT Y21) AND (ABS(D12) < 100);

timer_complete(IN := comp_cond, PT := T#30ms);

IF timer_complete.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM