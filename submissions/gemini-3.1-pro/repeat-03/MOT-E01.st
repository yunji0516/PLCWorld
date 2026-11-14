PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    timer : TON;
    pos_err : DINT;
    spd_err : DINT;
    in_window : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);
ELSE
    Y20 := FALSE;
    D20 := LIMIT(-200000, D11, 200000);
    Y2 := FALSE;
END_IF;

pos_err := ABS(D11 - D10);
spd_err := ABS(D12);
in_window := (pos_err <= 20) AND (spd_err <= 100);

timer(IN := X10 AND Y20 AND in_window, PT := T#30ms);

IF timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM