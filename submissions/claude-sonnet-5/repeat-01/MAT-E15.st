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
    (* internal variables *)
    started : BOOL := FALSE;
    completed : BOOL := FALSE;
    trig : R_TRIG;
END_VAR

(* Vacuum attachments must be ON from the first scan and stay ON *)
Y20 := TRUE;
Y21 := TRUE;

(* Detect start request rising edge *)
trig(CLK := X10);
IF trig.Q THEN
    started := TRUE;
END_IF;

(* Open command logic: only after start, only while gap is insufficient *)
IF started AND (D20 < D10) THEN
    Y22 := TRUE;
    Y23 := FALSE;
ELSE
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

(* Completion evaluation and latch *)
IF NOT completed THEN
    IF X20 AND X21 AND (D20 >= D10) AND (NOT Y22) AND (NOT Y23) AND Y20 AND Y21 THEN
        completed := TRUE;
    END_IF;
END_IF;

Y2 := completed;

END_PROGRAM