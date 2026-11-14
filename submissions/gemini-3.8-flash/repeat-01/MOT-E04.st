PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    speed_ok : BOOL;
    t_stable : TON;
    done : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, 200000, D10);
    speed_ok := ABS(D12 - D10) <= 200;
ELSE
    Y20 := FALSE;
    D20 := 0;
    speed_ok := FALSE;
END_IF;

t_stable(IN := speed_ok, PT := T#30ms);

IF t_stable.Q THEN
    done := TRUE;
END_IF;

IF NOT X10 THEN
    done := FALSE;
END_IF;

Y2 := done;

END_PROGRAM