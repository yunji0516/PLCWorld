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
    
    timer30 : TON;
    timer250 : TON;
    sync_ok : BOOL;
    vel_err : DINT;
    result_achieved : BOOL := FALSE;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := D10;
    
    vel_err := ABS(D12 * 1000 - D10 * D14);
    
    IF ABS(D17) <= 30 AND vel_err <= 200000 THEN
        sync_ok := TRUE;
    ELSE
        sync_ok := FALSE;
    END_IF;
    
    IF result_achieved THEN
        Y2 := TRUE;
        timer30(IN := FALSE);
        timer250(IN := TRUE, PT := T#250ms);
    ELSIF sync_ok THEN
        timer30(IN := TRUE, PT := T#30ms);
        IF timer30.Q THEN
            result_achieved := TRUE;
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
    ELSE
        timer30(IN := FALSE);
        timer250(IN := FALSE);
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    result_achieved := FALSE;
    timer30(IN := FALSE);
    timer250(IN := FALSE);
END_IF;

END_PROGRAM