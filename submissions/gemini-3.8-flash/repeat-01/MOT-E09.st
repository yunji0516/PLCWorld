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

    orient_err : DINT;
    is_stable : BOOL;
    latched_done : BOOL;
    ton_stable : TON;
END_VAR

IF NOT X10 THEN
    Y20 := FALSE;
    Y2 := FALSE;
    latched_done := FALSE;
    D20 := D11;
    D21 := 0;
    ton_stable(IN := FALSE, PT := T#30ms);
ELSE
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10 - D13 - D15, 200000);
    D21 := LIMIT(-200000, - (D14 + D16), 200000);

    orient_err := ABS(D13 + D15 + D11 - D10);
    is_stable := (orient_err <= 200);

    ton_stable(IN := is_stable, PT := T#30ms);
    IF ton_stable.Q THEN
        latched_done := TRUE;
    END_IF;
    Y2 := latched_done;
END_IF;

END_PROGRAM