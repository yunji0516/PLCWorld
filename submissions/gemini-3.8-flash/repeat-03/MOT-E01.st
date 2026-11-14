PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    target : DINT;
    pos_err : DINT;
    spd : DINT;
    in_pos : BOOL;
    done : BOOL;
    t_stable : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    target := D10;
    D20 := LIMIT(-200000, target, 200000);

    pos_err := D11 - target;
    IF pos_err < 0 THEN
        pos_err := -pos_err;
    END_IF;

    spd := D12;
    IF spd < 0 THEN
        spd := -spd;
    END_IF;

    in_pos := (pos_err <= 20) AND (spd <= 100);

    t_stable(IN := in_pos, PT := T#30ms);
    IF t_stable.Q THEN
        done := TRUE;
    END_IF;

    Y2 := done;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    done := FALSE;
    D20 := LIMIT(-200000, D11, 200000);
    t_stable(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM