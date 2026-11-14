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

    latched : BOOL;
    timer_stab : TON;
    in_pos : BOOL;
END_VAR

IF X10 AND X11 THEN
    latched := TRUE;
END_IF;

IF latched THEN
    Y20 := TRUE;
    D20 := D10;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

in_pos := latched AND (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100);

timer_stab(IN := in_pos, PT := T#30ms);

IF timer_stab.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM