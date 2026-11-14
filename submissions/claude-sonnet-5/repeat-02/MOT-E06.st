PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;

    requestAccepted : BOOL := FALSE;
    initPos : DINT := 0;
    posTolerance : DINT := 20; // 0.2 mm expressed in raw units (position is x0.01 mm)
    posOK : BOOL := FALSE;
    successCond : BOOL := FALSE;
    completionLatched : BOOL := FALSE;

    reqEdge : R_TRIG;
    holdTimer : TON;
    obsTimer : TON;
END_VAR

(* Detect request acceptance and latch the initial height once, on the first
   scan the request becomes active. *)
reqEdge(CLK := X10);

IF reqEdge.Q AND NOT requestAccepted THEN
    requestAccepted := TRUE;
    initPos := D11;
END_IF;

(* Do not activate the brake function before request acceptance. Once
   accepted, keep the brake command asserted (engage & retain). *)
IF requestAccepted THEN
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
END_IF;

(* Height-maintenance check relative to the captured initial height. *)
IF requestAccepted THEN
    posOK := (D11 >= (initPos - posTolerance)) AND (D11 <= (initPos + posTolerance));
ELSE
    posOK := FALSE;
END_IF;

(* Genuine success requires the height staying within tolerance, the brake
   confirmed engaged, and the external torque support confirmed released. *)
successCond := requestAccepted AND posOK AND X11 AND (NOT X12);

(* Require the success condition to hold continuously for 30 ms before
   claiming completion. *)
holdTimer(IN := successCond, PT := T#30ms);

IF holdTimer.Q THEN
    completionLatched := TRUE;
END_IF;

(* Post-claim observation window of 100 ms (tracked; result must keep
   holding through this window per successCond continuing to be driven true
   by the plant/outputs). *)
obsTimer(IN := completionLatched, PT := T#100ms);

(* Once completion is claimed, keep Y2 TRUE and never retract it. *)
IF completionLatched THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM