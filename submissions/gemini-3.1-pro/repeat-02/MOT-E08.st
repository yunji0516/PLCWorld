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
    timer : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D13 + D10, 200000);
    D21 := LIMIT(-200000, D14, 200000);
    
    timer(IN := (ABS(D11 - (D13 + D10)) <= 30) AND (ABS(D12 - D14) <= 200), PT := T#30ms);
    
    IF timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM