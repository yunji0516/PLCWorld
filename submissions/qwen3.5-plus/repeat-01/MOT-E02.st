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
    completion_timer : INT;
END_VAR

IF X10 THEN
    req_latched := TRUE;
END_IF;

IF req_latched THEN
    IF X11 AND X13 THEN
        Y21 := FALSE;
    ELSE
        Y21 := TRUE;
    END_IF;
END_IF;

IF req_latched AND X11 AND X13 AND (NOT Y21) AND (ABS(D12) <= 100) THEN
    IF completion_timer < 30 THEN
        completion_timer := completion_timer + 10;
    END_IF;
    IF completion_timer >= 30 THEN
        Y2 := TRUE;
    END_IF;
ELSE
    completion_timer := 0;
END_IF;

END_PROGRAM