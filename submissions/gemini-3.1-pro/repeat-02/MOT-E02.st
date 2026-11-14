PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    step : INT := 0;
    timer : TON;
    completion_cond : BOOL;
END_VAR

IF step = 0 AND X10 THEN
    step := 1;
END_IF;

IF step = 1 AND X13 THEN
    step := 2;
END_IF;

Y21 := (step = 1);

(* 
   Completion requires new reference setting (X11), Home deactivation (NOT Y21), 
   and actual stop (speed within arrival tolerance of 1 mm/s, which is 100 in x0.01 units).
*)
completion_cond := (step >= 2) AND X11 AND NOT Y21 AND (ABS(D12) <= 100);
timer(IN := completion_cond, PT := T#30ms);

IF step = 2 AND timer.Q THEN
    step := 3;
END_IF;

Y2 := (step = 3);

END_PROGRAM