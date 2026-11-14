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

    req : BOOL;
    complete_cond : BOOL;
    done : BOOL;
    ton_settle : TON;
END_VAR

IF X10 THEN
    req := TRUE;
END_IF;

IF req THEN
    Y21 := TRUE;
    complete_cond := X11 AND X13 AND (NOT X12) AND (ABS(D12) <= 100);
ELSE
    Y21 := FALSE;
    complete_cond := FALSE;
END_IF;

ton_settle(IN := complete_cond, PT := T#30ms);

IF ton_settle.Q THEN
    done := TRUE;
END_IF;

Y2 := done;

END_PROGRAM