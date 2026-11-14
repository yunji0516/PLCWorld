PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    timer_30ms : TON;
    in_target : BOOL;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
ELSE
    Y20 := TRUE;
    IF D10 > 200000 THEN
        D20 := 200000;
    ELSIF D10 < -200000 THEN
        D20 := -200000;
    ELSE
        D20 := D10;
    END_IF;
END_IF;

in_target := Y20 AND (ABS(D12 - D10) <= 200);

timer_30ms(IN := in_target, PT := T#30ms);

IF timer_30ms.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM