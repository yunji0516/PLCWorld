PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    sum_pos : DINT;
    is_stable : BOOL;
    stab_timer : TON;
END_VAR

IF X10 THEN
    Y20 := TRUE;
    
    (* Calculate target position and feedforward velocity for the wrist (C) to maintain A+B+C = D10 *)
    D20 := LIMIT(-200000, D10 - D13 - D15, 200000);
    D21 := LIMIT(-200000, -(D14 + D16), 200000);
    
    (* Check if the actual tool orientation is within +/- 2 degrees (200 in 0.01 deg units) of the requested target *)
    sum_pos := D11 + D13 + D15;
    is_stable := ABS(sum_pos - D10) <= 200;
    
    (* Monitor pre-claim stability interval of 30 ms *)
    stab_timer(IN := is_stable, PT := T#30ms);
    Y2 := stab_timer.Q;
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
    stab_timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM