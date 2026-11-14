PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    ton_maintain : TON;
    error : DINT;
    speed : DINT;
    in_target : BOOL;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    D20 := D11;
    Y2 := FALSE;
    in_target := FALSE;
ELSE
    Y20 := TRUE;
    D20 := D10;
    
    error := ABS(D10 - D11);
    speed := ABS(D12);
    
    in_target := (error <= 20) AND (speed <= 100);
END_IF;

ton_maintain(IN := in_target, PT := T#30ms);

IF ton_maintain.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM