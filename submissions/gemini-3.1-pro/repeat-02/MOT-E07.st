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
    
    condition_met : BOOL;
    maintain_timer : TON;
    retention_timer : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    D20 := LIMIT(-200000, D10, 200000);
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
END_IF;

condition_met := Y20 AND (ABS(D17) <= 30) AND (ABS(D12 - (D14 * D10) / 1000) <= 200);

maintain_timer(IN := condition_met AND NOT Y2, PT := T#30ms);
IF maintain_timer.Q THEN
    Y2 := TRUE;
END_IF;

retention_timer(IN := Y2, PT := T#250ms);

END_PROGRAM