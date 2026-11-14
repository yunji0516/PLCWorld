PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    maint_timer : TON;
    obs_timer : TON;
    y2_latched : BOOL := FALSE;
    exec_done : BOOL := FALSE;
END_VAR

Y20 := X10;

IF Y20 AND NOT exec_done THEN
    D20 := D13 + D10;
    D21 := D14;
    
    IF D20 > 200000 THEN D20 := 200000;
    ELSIF D20 < -200000 THEN D20 := -200000;
    END_IF;
    
    IF D21 > 200000 THEN D21 := 200000;
    ELSIF D21 < -200000 THEN D21 := -200000;
    END_IF;
    
    maint_timer(IN := (ABS(D13 + D10 - D11) <= 30) AND (ABS(D14 - D12) <= 200), PT := T#30ms);
    
    IF maint_timer.Q AND NOT y2_latched THEN
        y2_latched := TRUE;
        Y2 := TRUE;
        obs_timer(IN := TRUE, PT := T#250ms);
    END_IF;
    
    IF y2_latched THEN
        obs_timer(IN := TRUE, PT := T#250ms);
        IF obs_timer.Q THEN
            exec_done := TRUE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM