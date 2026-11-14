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
    started   : BOOL;
    completed : BOOL;
    r_trig1   : R_TRIG;
END_VAR

(* Vacuum attachments must stay ON from the first scan and forever after *)
Y20 := TRUE;
Y21 := TRUE;

(* Detect the single Start rising edge *)
r_trig1(CLK := X10);
IF r_trig1.Q THEN
    started := TRUE;
END_IF;

(* Only command opening after Start, and only until target gap reached *)
IF started AND (NOT completed) THEN
    IF D20 < D10 THEN
        Y22 := TRUE;
        Y23 := FALSE;
    ELSE
        Y22 := FALSE;
        Y23 := FALSE;
    END_IF;
ELSE
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

(* Evaluate completion; once achieved, latch it and keep result through remaining budget *)
IF (NOT completed) AND X20 AND X21 AND (D20 >= D10) AND (NOT Y22) AND (NOT Y23) AND Y20 AND Y21 THEN
    completed := TRUE;
END_IF;

Y2 := completed;

END_PROGRAM