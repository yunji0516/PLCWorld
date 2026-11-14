PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    timer : TON;
    stable_cond : BOOL;
    pos_err : DINT;
    vel_err : DINT;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D13 + D10, 200000);
    D21 := LIMIT(-200000, D14, 200000);

    pos_err := ABS(D11 - (D13 + D10));
    vel_err := ABS(D12 - D14);

    stable_cond := (pos_err <= 30) AND (vel_err <= 200);
    timer(IN := stable_cond, PT := T#30ms);

    IF timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
    timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM