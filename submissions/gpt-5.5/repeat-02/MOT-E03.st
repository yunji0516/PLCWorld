PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    requestAccepted : BOOL;
    positiveDirection : BOOL;
    withinLimit : BOOL;
    speedStopped : BOOL;
    resultPresent : BOOL;
    holdTimer : TON;
END_VAR

(* Implement the control logic here. *)

IF X10 AND NOT requestAccepted THEN
    requestAccepted := TRUE;
    positiveDirection := (D12 >= 0);
END_IF;

IF requestAccepted THEN
    Y20 := TRUE;
    D20 := 400000;
ELSE
    Y20 := FALSE;
    D20 := 0;
END_IF;

IF positiveDirection THEN
    withinLimit := (D11 <= D13);
ELSE
    withinLimit := (D11 >= D13);
END_IF;

speedStopped := (ABS(D12) <= 99);
resultPresent := requestAccepted AND speedStopped AND withinLimit;

holdTimer(IN := resultPresent, PT := T#30ms);

IF holdTimer.Q THEN
    Y2 := TRUE;
END_IF;

IF NOT requestAccepted THEN
    Y2 := FALSE;
END_IF;

END_PROGRAM