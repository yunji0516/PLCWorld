PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;

    startEdge : R_TRIG;
    started   : BOOL := FALSE;
    completed : BOOL := FALSE;
END_VAR

startEdge(CLK := X10);

IF startEdge.Q THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    (* Do not initiate operation before Start *)
    Y20 := FALSE;
ELSIF NOT completed THEN
    IF D20 = 2 THEN
        (* New material has reached the outlet: stop pump immediately *)
        Y20 := FALSE;
        completed := TRUE;
    ELSE
        (* Old residue still present, keep pumping to recovery *)
        Y20 := TRUE;
    END_IF;
ELSE
    (* Completed: keep pump off, hold result *)
    Y20 := FALSE;
END_IF;

Y2 := completed;

END_PROGRAM