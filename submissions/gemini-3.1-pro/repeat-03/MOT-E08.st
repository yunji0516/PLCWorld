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
    
    pos_err : DINT;
    vel_err : DINT;
    maintain_timer : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    D20 := D13 + D10;
    D21 := D14;
    
    pos_err := ABS(D11 - D20);
    vel_err := ABS(D12 - D21);
    
    maintain_timer(IN := (pos_err <= 30 AND vel_err <= 200), PT := T#30ms);
    
    IF maintain_timer.Q THEN
        Y2 := TRUE;
    END_IF;
    
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
    maintain_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM