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
    target : DINT;
    in_pos : BOOL;
    hold_timer : TON;
END_VAR

IF X10 THEN
    active := TRUE;
    target := LIMIT(-200000, D10, 200000);
END_IF;

IF active THEN
    Y20 := TRUE;
    D20 := target;
    in_pos := (ABS(D11 - target) <= 20) AND (ABS(D12) <= 100);
    hold_timer(IN := in_pos, PT := T#30ms);
    IF hold_timer.Q THEN
        done := TRUE;
    END_IF;
    Y2 := done;
ELSE
    Y20 := FALSE;
    D20 := LIMIT(-200000, D11, 200000);
    Y2 := FALSE;
    hold_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM