PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    stab_timer : TON;
    stable : BOOL;
    
    CMD_MIN : DINT := -200000;
    CMD_MAX : DINT := 200000;
    ERR_TOL : DINT := 20;
    SPD_TOL : DINT := 100;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(CMD_MIN, D10, CMD_MAX);
ELSE
    Y20 := FALSE;
    D20 := LIMIT(CMD_MIN, D11, CMD_MAX);
    Y2 := FALSE;
END_IF;

stable := X10 AND (ABS(D11 - D10) <= ERR_TOL) AND (ABS(D12) <= SPD_TOL);

stab_timer(IN := stable, PT := T#30ms);

IF stab_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM