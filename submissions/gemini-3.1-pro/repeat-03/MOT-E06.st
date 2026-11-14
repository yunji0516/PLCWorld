PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;
    
    active : BOOL;
    init_pos : DINT;
    maintain_timer : TON;
END_VAR

IF X10 THEN
    IF NOT active THEN
        active := TRUE;
        init_pos := D11;
    END_IF;
    
    Y20 := TRUE;
    
    maintain_timer(IN := X11 AND NOT X12 AND (ABS(D11 - init_pos) <= 20), PT := T#30ms);
    
    IF maintain_timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    active := FALSE;
    Y20 := FALSE;
    Y2 := FALSE;
    maintain_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM