PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    timer_stable : TON;
    stable_cond : BOOL;
    done : BOOL;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    Y2 := FALSE;
    done := FALSE;
    D20 := D11;
    stable_cond := FALSE;
ELSE
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);
    stable_cond := (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100);
END_IF;

timer_stable(IN := stable_cond, PT := T#30ms);

IF X10 AND timer_stable.Q THEN
    done := TRUE;
END_IF;

IF X10 THEN
    Y2 := done;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM