PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    (* Add internal variables here. *)
    start_trig : R_TRIG;
    started : BOOL;
    completed : BOOL;
END_VAR

start_trig(CLK := X10);

IF start_trig.Q THEN
    started := TRUE;
END_IF;

(* Grip command: only after a Start rising edge has occurred, then held ON *)
Y20 := started;

(* Completion: product held (physical observation) while grip commanded ON *)
IF started AND X20 AND (D10 = 1) THEN
    completed := TRUE;
END_IF;

(* Retain result once achieved *)
Y2 := completed;

END_PROGRAM