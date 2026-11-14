PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    t_stable : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, 200000, D10);
    t_stable(IN := (ABS(D12 - D10) <= 200), PT := T#30ms);
    IF t_stable.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    t_stable(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM