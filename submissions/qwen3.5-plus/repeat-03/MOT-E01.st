PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    stability_timer : TON;
    error_ok : BOOL;
    speed_ok : BOOL;
    cmd_val : DINT;
END_VAR

cmd_val := D10;
IF cmd_val > 200000 THEN
    cmd_val := 200000;
ELSIF cmd_val < -200000 THEN
    cmd_val := -200000;
END_IF;

IF X10 THEN
    Y20 := TRUE;
    D20 := cmd_val;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

error_ok := ABS(D11 - D10) <= 20;
speed_ok := ABS(D12) <= 100;

stability_timer(IN := error_ok AND speed_ok, PT := T#30ms);

IF stability_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM