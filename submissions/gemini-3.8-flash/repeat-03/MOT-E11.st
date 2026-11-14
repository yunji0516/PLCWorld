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
    stable_cond : BOOL;
    stable_timer : TON;
    result_latched : BOOL;
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

stable_cond := detected AND (ABS(D11 - D10) <= 15) AND (ABS(D12) <= 50);

stable_timer(IN := stable_cond, PT := T#40ms);

IF stable_timer.Q THEN
    result_latched := TRUE;
END_IF;

Y2 := result_latched;

END_PROGRAM