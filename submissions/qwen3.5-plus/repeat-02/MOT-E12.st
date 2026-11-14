PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    req_accepted : BOOL;
    stable_met : BOOL;
    
    tmr_stable : TON;
END_VAR

IF X10 AND NOT req_accepted THEN
    req_accepted := TRUE;
    Y20 := TRUE;
END_IF;

IF req_accepted THEN
    D20 := D10;
    IF D20 > 200000 THEN D20 := 200000;
    ELSIF D20 < -200000 THEN D20 := -200000;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

IF req_accepted THEN
    IF (ABS(D10 - D11) <= 20) AND (ABS(D12) <= 100) THEN
        tmr_stable(IN := TRUE, PT := T#30ms);
        IF tmr_stable.Q THEN
            stable_met := TRUE;
            Y2 := TRUE;
            tmr_stable(IN := FALSE);
        END_IF;
    ELSE
        tmr_stable(IN := FALSE);
        IF NOT stable_met THEN
            Y2 := FALSE;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM