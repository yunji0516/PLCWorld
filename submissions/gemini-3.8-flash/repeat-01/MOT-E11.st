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
    in_zone : BOOL;
    stab_timer : TON;
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

in_zone := detected AND (ABS(D11 - D10) <= 18) AND (ABS(D12) <= 90);

stab_timer(IN := in_zone, PT := T#30ms);

IF stab_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM