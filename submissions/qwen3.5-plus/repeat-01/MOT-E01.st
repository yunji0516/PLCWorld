PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    stable_timer : TON;
    y2_set : BOOL := FALSE;
    cmd_raw : DINT;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    cmd_raw := D10;
    IF cmd_raw > 200000 THEN cmd_raw := 200000; END_IF;
    IF cmd_raw < -200000 THEN cmd_raw := -200000; END_IF;
    D20 := cmd_raw;
    
    IF NOT y2_set THEN
        stable_timer(IN := (ABS(D20 - D11) <= 20) AND (ABS(D12) <= 100), PT := T#30ms);
        IF stable_timer.Q THEN
            y2_set := TRUE;
        END_IF;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    stable_timer(IN := FALSE);
END_IF;

Y2 := y2_set;
END_PROGRAM