PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    homeRequestInitiated : BOOL := FALSE;
    homeCompleteStabilityTimer : TON;
    observationTimer : TON;
    observingCompletion : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* Home process initiation *)
IF X10 AND NOT homeRequestInitiated THEN
    Y21 := TRUE; (* Start home operation *)
    homeRequestInitiated := TRUE;
END_IF

(* Monitor home in progress and completion *)
IF homeRequestInitiated THEN
    IF X13 THEN
        Y21 := FALSE; (* Deactivate Home execution upon completion *)
        observingCompletion := TRUE;
        homeCompleteStabilityTimer(IN := TRUE, PT := T#30ms);
    ELSE
        observingCompletion := FALSE;
        homeCompleteStabilityTimer(IN := FALSE);
    END_IF
END_IF

(* Check if the home process has been stable for 30 ms *)
IF homeCompleteStabilityTimer.Q THEN
    Y2 := TRUE; (* Keep result retention active after stability is confirmed *)
    observationTimer(IN := TRUE, PT := T#100ms);
    
    IF observationTimer.Q THEN
        (* Observation period complete, reset everything for next request *)
        homeRequestInitiated := FALSE;
        observingCompletion := FALSE;
        Y2 := FALSE;
        observationTimer(IN := FALSE);
    END_IF
ELSE
    observationTimer(IN := FALSE);
END_IF

(* Ensure safety constraints and reset on aborted operation *)
IF NOT X10 AND homeRequestInitiated THEN
    Y21 := FALSE; (* Deactivate during interruption *)
    homeRequestInitiated := FALSE;
    Y2 := FALSE;
    homeCompleteStabilityTimer(IN := FALSE);
    observationTimer(IN := FALSE);
END_IF

END_PROGRAM