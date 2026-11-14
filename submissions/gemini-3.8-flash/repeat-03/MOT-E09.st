PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;

    t_stable : TON;
    cond : BOOL;
    target_pos : DINT;
    target_vel : DINT;
    y2_latched : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;

    target_pos := D10 - D13 - D15;
    target_vel := -D14 - D16;

    D20 := LIMIT(-200000, target_pos, 200000);
    D21 := LIMIT(-200000, target_vel, 200000);

    cond := ABS(D13 + D15 + D11 - D10) <= 200;
    t_stable(IN := cond, PT := T#30ms);

    IF y2_latched OR t_stable.Q THEN
        y2_latched := TRUE;
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    y2_latched := FALSE;
    t_stable(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM