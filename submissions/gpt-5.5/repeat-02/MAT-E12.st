PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    started : BOOL;
    completed : BOOL;
END_VAR

(* Implement the control logic here. *)

startEdge(CLK := X10);

IF startEdge.Q THEN
    started := TRUE;
END_IF;

IF completed THEN
    Y20 := FALSE;
    Y2 := TRUE;
ELSE
    Y2 := FALSE;

    IF started THEN
        IF D20 = D10 THEN
            completed := TRUE;
            Y20 := FALSE;
            Y2 := TRUE;
        ELSE
            Y20 := TRUE;
        END_IF;
    ELSE
        Y20 := FALSE;
    END_IF;
END_IF;

END_PROGRAM