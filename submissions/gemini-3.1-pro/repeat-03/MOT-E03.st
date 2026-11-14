PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    t30 : TON;
    t100 : TON;
    is_stopped : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := 400000;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
END_IF;

is_stopped := Y20 AND (ABS(D12) <= 100);

t30(IN := is_stopped, PT := T#30ms);

IF t30.Q THEN
    Y2 := TRUE;
END_IF;

t100(IN := Y2, PT := T#100ms);

END_PROGRAM