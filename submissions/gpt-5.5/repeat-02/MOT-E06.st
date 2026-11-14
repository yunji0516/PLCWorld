PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    requestAccepted : BOOL;
    initialPosition : DINT;
    heightError : DINT;
    heightOK : BOOL;
    resultCondition : BOOL;
    stableTimer : TON;
END_VAR

(* Implement the control logic here. *)

IF X10 AND NOT requestAccepted THEN
    requestAccepted := TRUE;
    initialPosition := D11;
END_IF;

Y20 := requestAccepted;

heightError := D11 - initialPosition;
heightOK := requestAccepted AND (ABS(heightError) <= 20);

resultCondition := requestAccepted AND Y20 AND X11 AND (NOT X12) AND heightOK;

stableTimer(IN := resultCondition, PT := T#30ms);

IF stableTimer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM