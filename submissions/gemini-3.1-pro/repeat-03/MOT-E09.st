PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    stab_ton : TON;
    err : DINT;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    D20 := -(D13 + D15);
    D21 := -(D14 + D16);
    
    D20 := LIMIT(-200000, D20, 200000);
    D21 := LIMIT(-200000, D21, 200000);
    
    err := ABS(D13 + D15 + D11);
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    err := 999999;
END_IF

stab_ton(IN := X10 AND (err <= 200), PT := T#30ms);
Y2 := stab_ton.Q;

END_PROGRAM