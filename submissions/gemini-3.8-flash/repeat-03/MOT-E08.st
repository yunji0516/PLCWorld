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

    accepted : BOOL;
    pos_err : DINT;
    vel_err : DINT;
    ton_stable : TON;
END_VAR

IF X10 THEN
    accepted := TRUE;
END_IF;

IF accepted THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D13 + D10, 200000);
    D21 := LIMIT(-200000, D14, 200000);

    pos_err := D11 - (D13 + D10);
    IF pos_err < 0 THEN
        pos_err := -pos_err;
    END_IF;

    vel_err := D12 - D14;
    IF vel_err < 0 THEN
        vel_err := -vel_err;
    END_IF;

    ton_stable(IN := (pos_err <= 30) AND (vel_err <= 200), PT := T#30ms);

    IF ton_stable.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    ton_stable(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM