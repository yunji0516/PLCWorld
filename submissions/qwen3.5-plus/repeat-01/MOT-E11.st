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
    y2_latched : BOOL;
    timer_stable : TON;
END_VAR

IF X11 THEN
    detected := TRUE;
END_IF;

IF X10 AND detected THEN
    Y20 := TRUE;
    D20 := D10;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

timer_stable(IN := (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100), PT := T#30ms);
IF timer_stable.Q THEN
    y2_latched := TRUE;
END_IF;
Y2 := y2_latched;

END_PROGRAM