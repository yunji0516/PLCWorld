PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    D20 : INT;
    
    start_edge : R_TRIG;
    started : BOOL := FALSE;
    completed : BOOL := FALSE;
END_VAR

(* Maintain both vacuum commands ON from the first scan to preserve initial attachment *)
Y20 := TRUE;
Y21 := TRUE;

(* Detect start request *)
start_edge(CLK := X10);
IF start_edge.Q THEN
    started := TRUE;
END_IF;

(* Control logic *)
IF NOT started THEN
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
ELSIF started AND NOT completed THEN
    IF D20 < D10 THEN
        Y22 := TRUE;
        Y23 := FALSE;
    ELSE
        Y22 := FALSE;
        Y23 := FALSE;
        completed := TRUE;
    END_IF;
END_IF;

(* Completion holding *)
IF completed THEN
    Y22 := FALSE;
    Y23 := FALSE;
    
    (* Claim completion only when conditions are physically observed, then latch it *)
    IF X20 AND X21 AND (D20 >= D10) THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM