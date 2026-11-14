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
    (* Internal variables. *)
    homeRequest : BOOL := FALSE;
    homeCompleteTimer : TON;
    resultRetentionTimer : TON;
    homeActive : BOOL := FALSE;
    stopDetected : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* Edge detection for X10 work request *)
homeRequest := homeRequest OR X10;

(* Initiate Home process when X10 is true and reference is not valid *)
IF homeRequest AND NOT X11 THEN
    Y21 := TRUE; (* Engage Home process *)
    homeActive := TRUE;
ELSE
    Y21 := FALSE;
END_IF

(* Monitor Home execution and stop status *)
IF X12 THEN
    stopDetected := FALSE; (* Home is in progress, not yet stopped *)
ELSIF homeActive AND NOT X12 THEN
    stopDetected := TRUE; (* Stopped after Home execution deactivated *)
END_IF

(* Check if Home is complete *)
IF stopDetected AND X13 THEN
    homeCompleteTimer(IN := TRUE, PT := T#30ms);
ELSE
    homeCompleteTimer(IN := FALSE);
END_IF

(* Maintain result retention for 100ms after completion *)
resultRetentionTimer(IN := homeCompleteTimer.Q, PT := T#100ms);

IF resultRetentionTimer.Q THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF

(* Ensure home request can only be reset after completion and result retention *)
IF X13 AND Y2 THEN
    homeRequest := FALSE; (* Reset request when successfully retained result *)
END_IF

END_PROGRAM