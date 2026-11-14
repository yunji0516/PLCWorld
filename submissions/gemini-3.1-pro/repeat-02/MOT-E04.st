PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    speed_error : DINT;
    in_band : BOOL;
    timer1 : TON;
    
    min_cmd : DINT := -200000;
    max_cmd : DINT := 200000;
    err_limit : DINT := 200;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(min_cmd, D10, max_cmd);
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
END_IF

speed_error := ABS(D12 - D10);
in_band := (speed_error <= err_limit) AND Y20 AND X10;

timer1(IN := in_band, PT := T#30ms);

IF timer1.Q THEN
    Y2 := TRUE;
END_IF

END_PROGRAM