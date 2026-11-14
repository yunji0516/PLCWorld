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
    req_mem : BOOL;
    stability_timer : TON;
    home_done : BOOL;
    completion_cond : BOOL;
END_VAR

IF X10 THEN
    req_mem := TRUE;
END_IF;

home_done := X11 AND X13 AND (ABS(D12) < 100);

IF req_mem AND NOT home_done THEN
    Y21 := TRUE;
ELSE
    Y21 := FALSE;
END_IF;

completion_cond := X11 AND (NOT Y21) AND X13 AND (ABS(D12) < 100);

stability_timer(IN := completion_cond, PT := T#30ms);

IF stability_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM