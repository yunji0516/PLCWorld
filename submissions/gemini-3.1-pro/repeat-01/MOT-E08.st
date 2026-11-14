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

    active : BOOL;
    pos_target : DINT;
    pos_err : DINT;
    vel_err : DINT;
    in_range : BOOL;
    stable_timer : TON;
END_VAR

IF X10 THEN
    active := TRUE;
END_IF;

IF active THEN
    Y20 := TRUE;
    
    pos_target := D13 + D10;
    
    D20 := LIMIT(-200000, pos_target, 200000);
    D21 := LIMIT(-200000, D14, 200000);
    
    pos_err := ABS(D11 - pos_target);
    vel_err := ABS(D12 - D14);
    
    in_range := (pos_err <= 30) AND (vel_err <= 200);
    
    stable_timer(IN := in_range, PT := T#30ms);
    
    IF stable_timer.Q THEN
        Y2 := TRUE;
    END_IF;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
    stable_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM