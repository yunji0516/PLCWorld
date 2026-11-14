PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    startEdge : R_TRIG;
    started   : BOOL := FALSE;
    completed : BOOL := FALSE;
    target    : INT := 0;
    tolerance : INT := 2;
END_VAR

(* Detect rising edge of start request *)
startEdge(CLK := X10);

IF NOT started THEN
    IF startEdge.Q THEN
        started := TRUE;
        target := D10;
    END_IF;
END_IF;

(* Control logic: only act once started and not yet completed *)
IF started AND NOT completed THEN
    IF D20 < (target - tolerance) THEN
        (* Need more liquid: open valve first, then pump once fully open *)
        Y20 := TRUE;
        IF X20 THEN
            Y21 := TRUE;
        ELSE
            Y21 := FALSE;
        END_IF;
    ELSE
        (* Close enough or overshoot: stop pump and close valve *)
        Y21 := FALSE;
        Y20 := FALSE;
    END_IF;
ELSE
    (* Not started yet, or already completed: actuators OFF *)
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

(* Evaluate completion conditions *)
IF started AND NOT completed THEN
    IF (D20 >= (target - tolerance)) AND (D20 <= (target + tolerance))
       AND (Y21 = FALSE) AND (X21 = TRUE) THEN
        completed := TRUE;
        Y2 := TRUE;
    END_IF;
END_IF;

IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM