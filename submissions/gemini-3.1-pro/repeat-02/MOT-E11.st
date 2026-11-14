PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    detected : BOOL;
    in_range : BOOL;
    timer : TON;
END_VAR

IF X10 AND X11 THEN
    detected := TRUE;
END_IF;

IF detected THEN
    Y20 := TRUE;
    D20 := D10;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

IF detected THEN
    in_range := (ABS(D11 - D10) <= 19) AND (ABS(D12) <= 99);
ELSE
    in_range := FALSE;
END_IF;

timer(IN := in_range, PT := T#30ms);

IF timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM