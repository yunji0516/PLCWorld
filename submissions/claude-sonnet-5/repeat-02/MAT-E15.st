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
    (* Internal variables *)
    started    : BOOL;
    completed  : BOOL;
    trig       : R_TRIG;
END_VAR

(* Detect the single rising edge of the start request *)
trig(CLK := X10);
IF trig.Q THEN
    started := TRUE;
END_IF;

(* Vacuum attachments must remain established from the first scan onward *)
Y20 := TRUE;
Y21 := TRUE;

(* Never issue the opening command before Start; never assert open and close together *)
IF NOT started THEN
    Y22 := FALSE;
    Y23 := FALSE;
ELSE
    Y23 := FALSE;  (* closing is never required for this task *)
    IF D20 < D10 THEN
        Y22 := TRUE;
    ELSE
        Y22 := FALSE;
    END_IF;
END_IF;

(* Latch completion once all conditions are satisfied, and retain it afterward *)
IF (NOT completed) AND started AND X20 AND X21 AND (D20 >= D10) AND (NOT Y22) AND (NOT Y23) AND Y20 AND Y21 THEN
    completed := TRUE;
END_IF;

Y2 := completed;

END_PROGRAM