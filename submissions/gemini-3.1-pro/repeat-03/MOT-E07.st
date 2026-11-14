PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    hold_timer : TON;
    vel_ref : DINT;
    cond_met : BOOL;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

vel_ref := (D10 * D14) / 1000;

cond_met := Y20 AND (ABS(D17) <= 30) AND (ABS(D12 - vel_ref) <= 200);

hold_timer(IN := cond_met, PT := T#30ms);

IF hold_timer.Q THEN
    Y2 := TRUE;
END_IF;

IF NOT X10 THEN
    Y2 := FALSE;
END_IF;

END_PROGRAM