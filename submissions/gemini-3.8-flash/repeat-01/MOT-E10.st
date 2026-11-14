PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    started : BOOL;
    target : DINT;
    done : BOOL;
    stable_timer : TON;
END_VAR

IF X10 AND NOT started THEN
    started := TRUE;
    target := D10;
END_IF;

IF started THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, target, 200000);

    stable_timer(IN := (ABS(D11 - target) <= 20) AND (ABS(D12) <= 100), PT := T#30ms);

    IF stable_timer.Q THEN
        done := TRUE;
    END_IF;

    IF done THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := LIMIT(-200000, D11, 200000);
    stable_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM