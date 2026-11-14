PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    initial_height : DINT := 0;
    conditions_met : BOOL := FALSE;
    maintain_timer : TON;
END_VAR

IF NOT X10 THEN
    state := 0;
    Y20 := FALSE;
    Y2 := FALSE;
    conditions_met := FALSE;
    maintain_timer(IN := FALSE, PT := T#30ms);
ELSE
    IF state = 0 THEN
        initial_height := D11;
        state := 1;
    END_IF;
    
    Y20 := TRUE;
    
    conditions_met := X11 AND (NOT X12) AND (ABS(D11 - initial_height) <= 20);
    maintain_timer(IN := conditions_met, PT := T#30ms);
    
    IF maintain_timer.Q THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM