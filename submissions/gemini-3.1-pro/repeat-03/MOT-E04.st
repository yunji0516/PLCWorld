PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    T1 : TON;
    in_target : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);
    in_target := ABS(D12 - D20) <= 200;
ELSE
    Y20 := FALSE;
    D20 := 0;
    in_target := FALSE;
    Y2 := FALSE;
END_IF;

T1(IN := in_target, PT := T#30ms);

IF T1.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM