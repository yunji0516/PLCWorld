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
    stability_timer : TON;
    completion_ready : BOOL;
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

IF X10 AND detected AND ABS(D11 - D10) <= 20 AND ABS(D12) <= 100 THEN
    stability_timer(IN := TRUE, PT := T#30ms);
    IF stability_timer.Q OR completion_ready THEN
        completion_ready := TRUE;
    END_IF;
ELSE
    stability_timer(IN := FALSE);
    IF NOT completion_ready THEN
        completion_ready := FALSE;
    END_IF;
END_IF;

Y2 := completion_ready;

END_PROGRAM