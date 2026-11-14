PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    req_active : BOOL;
    target_pos : DINT;
    pos_err : DINT;
    spd_err : DINT;
    in_tol : BOOL;
    completed : BOOL;
    ton_stable : TON;
END_VAR

IF X10 THEN
    req_active := TRUE;
    target_pos := D10;
END_IF;

IF req_active THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, target_pos, 200000);
    pos_err := ABS(D11 - target_pos);
    spd_err := ABS(D12);
    in_tol := (pos_err <= 20) AND (spd_err <= 100);
ELSE
    Y20 := FALSE;
    D20 := 0;
    pos_err := 0;
    spd_err := 0;
    in_tol := FALSE;
END_IF;

ton_stable(IN := in_tol, PT := T#30ms);

IF ton_stable.Q THEN
    completed := TRUE;
END_IF;

IF req_active AND completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM