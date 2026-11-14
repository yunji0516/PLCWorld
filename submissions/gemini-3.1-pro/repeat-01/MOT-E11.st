PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    detected : BOOL;
    stable_timer : TON;
    stable_cond : BOOL;
END_VAR

IF X10 AND X11 THEN
    detected := TRUE;
END_IF;

IF detected THEN
    Y20 := TRUE;
    D20 := D10;
ELSE
    Y20 := FALSE;
    D20 := DINT#0;
END_IF;

(* 
   Account for feedback quantization: 
   To guarantee continuous physical state is within 0.2 mm (20) and 1 mm/s (100),
   use strictly tighter bounds <= 19 and <= 99.
*)
stable_cond := detected AND (ABS(D11 - D10) <= 19) AND (ABS(D12) <= 99);

stable_timer(IN := stable_cond, PT := T#30ms);

IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM