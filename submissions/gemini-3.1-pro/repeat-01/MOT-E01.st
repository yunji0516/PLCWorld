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
    in_pos : BOOL;
END_VAR

Y20 := X10;

IF X10 THEN
    D20 := LIMIT(-200000, D10, 200000);
ELSE
    D20 := LIMIT(-200000, D11, 200000);
END_IF;

in_pos := Y20 AND (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100);

timer(IN := in_pos, PT := T#30ms);

IF timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM