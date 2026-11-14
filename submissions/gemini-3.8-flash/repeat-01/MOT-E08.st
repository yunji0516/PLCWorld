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
    target_pos : DINT;
    pos_err : DINT;
    vel_err : DINT;
    condition : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    target_pos := D13 + D10;
    D20 := LIMIT(-200000, target_pos, 200000);
    D21 := LIMIT(-200000, D14, 200000);

    pos_err := ABS(D11 - target_pos);
    vel_err := ABS(D12 - D14);
    condition := (pos_err <= 30) AND (vel_err <= 200);

    timer(IN := condition, PT := T#30ms);
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