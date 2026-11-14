PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    (* Add internal variables here. *)
    startEdge : R_TRIG;
    started : BOOL;
    seenBlocked : BOOL;
    passageDone : BOOL;
END_VAR

(* Implement the control logic here. *)

startEdge(CLK := X10);

IF startEdge.Q THEN
    started := TRUE;
END_IF;

IF started AND X20 THEN
    seenBlocked := TRUE;
END_IF;

IF started AND seenBlocked AND (NOT X20) THEN
    passageDone := TRUE;
END_IF;

IF passageDone THEN
    Y20 := FALSE;
    Y2 := TRUE;
ELSIF started THEN
    Y20 := TRUE;
    Y2 := FALSE;
ELSE
    Y20 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM