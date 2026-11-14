PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    req_active : BOOL;
    completion_met : BOOL;
    y2_latched : BOOL;
    maint_timer : TON;
END_VAR

IF X10 THEN
    req_active := TRUE;
END_IF;

Y20 := req_active;

IF req_active THEN
    D20 := LIMIT(-200000, D10, 200000);
ELSE
    D20 := 0;
END_IF;

IF req_active AND (ABS(D20 - D11) <= 20) AND (ABS(D12) <= 100) THEN
    completion_met := TRUE;
END_IF;

maint_timer(IN := completion_met, PT := T#30ms);

IF maint_timer.Q THEN
    y2_latched := TRUE;
END_IF;

Y2 := y2_latched;

END_PROGRAM