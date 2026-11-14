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

    req_active : BOOL;
    done_latched : BOOL;
    complete_cond : BOOL;
    t_settle : TON;
END_VAR

IF X10 THEN
    req_active := TRUE;
END_IF;

IF req_active THEN
    Y21 := TRUE;
    complete_cond := X11 AND X13 AND (NOT X12) AND (ABS(D12) <= 100);
    t_settle(IN := complete_cond, PT := T#30ms);
    IF t_settle.Q THEN
        done_latched := TRUE;
    END_IF;
ELSE
    Y21 := FALSE;
    t_settle(IN := FALSE, PT := T#30ms);
END_IF;

Y2 := done_latched;

END_PROGRAM