PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    timer : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := D10;
ELSE
    Y20 := FALSE;
    D20 := D11;
    Y2 := FALSE;
END_IF

timer(IN := X10 AND (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100), PT := T#30ms);

IF X10 AND timer.Q THEN
    Y2 := TRUE;
END_IF

END_PROGRAM