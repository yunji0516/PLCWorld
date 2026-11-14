PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    Hold_Timer : TON;
    Hold_Condition : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := 400000;
    
    Hold_Condition := (ABS(D12) <= 100);
    Hold_Timer(IN := Hold_Condition, PT := T#500ms);
    
    IF Hold_Timer.ET >= T#30ms THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    Hold_Timer(IN := FALSE, PT := T#500ms);
END_IF;

END_PROGRAM