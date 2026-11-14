PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    cond_met : BOOL;
    maintain_timer : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := D10;
    
    cond_met := (ABS(D17) <= 30) AND (ABS(D12 * 1000 - D14 * D10) <= 200000);
    maintain_timer(IN := cond_met, PT := T#30ms);
    
    IF maintain_timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    maintain_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM