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

    ton_stab : TON;
    y2_latched : BOOL;
    orient_err : DINT;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10 - D13 - D15, 200000);
    D21 := LIMIT(-200000, - D14 - D16, 200000);

    orient_err := (D13 + D15 + D11) - D10;
    ton_stab(IN := (ABS(orient_err) <= 200), PT := T#30ms);

    IF ton_stab.Q THEN
        y2_latched := TRUE;
    END_IF;

    Y2 := y2_latched;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    y2_latched := FALSE;
    ton_stab(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM