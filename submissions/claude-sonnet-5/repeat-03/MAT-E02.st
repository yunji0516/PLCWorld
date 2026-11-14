PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    (* Internal variables *)
    startEdge : R_TRIG;
    started : BOOL := FALSE;
    completed : BOOL := FALSE;
    scan_count : DINT := 0;
END_VAR

(* Track scan count, though not strictly required for logic timing here *)
scan_count := scan_count + 1;

(* Detect rising edge of start request *)
startEdge(CLK := X10);

IF startEdge.Q AND (D10 = 1) AND NOT started THEN
    started := TRUE;
END_IF;

(* Maintain grip ON until start; release (grip OFF) once started, and never reacquire *)
IF NOT started THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

(* Completion: product released onto receiver, no longer held, and support confirms receipt *)
IF NOT completed THEN
    IF started AND X21 AND X22 AND (NOT X20) THEN
        completed := TRUE;
    END_IF;
END_IF;

(* Latch and hold completion claim through remaining execution budget *)
Y2 := completed;

END_PROGRAM