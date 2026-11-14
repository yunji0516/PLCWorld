PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    active : BOOL;
    done : BOOL;
    in_position : BOOL;
    ton_stable : TON;
END_VAR

IF X10 THEN
    active := TRUE;
END_IF;

IF active THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);

    in_position := (ABS(D11 - D10) <= 20) AND (ABS(D12) <= 100);

    ton_stable(IN := in_position, PT := T#30ms);

    IF ton_stable.Q THEN
        done := TRUE;
    END_IF;

    Y2 := done;
ELSE
    Y20 := FALSE;
    D20 := LIMIT(-200000, D11, 200000);
    Y2 := FALSE;
    done := FALSE;
    ton_stable(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM