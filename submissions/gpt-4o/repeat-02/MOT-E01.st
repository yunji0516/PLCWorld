PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    targetPosition : REAL;
    actualPosition : REAL;
    positionError : REAL;
    actualSpeed : REAL;
    requestGranted : BOOL;
    withinErrorLimit : BOOL;
    stableTimer : TON;
    resultRetentionTimer : TON;
END_VAR

(* Implement the control logic here. *)

(* Convert DINT inputs to REAL for processing *)
targetPosition := REAL(D10) * 0.01;
actualPosition := REAL(D11) * 0.01;
actualSpeed := REAL(D12) * 0.01;

(* Check if the request is within accepted range *)
IF X10 AND targetPosition >= -350 AND targetPosition <= 450 THEN
    requestGranted := TRUE;
ELSE
    requestGranted := FALSE;
END_IF;

(* Function activation/retention logic *)
IF requestGranted THEN
    Y20 := TRUE;
    D20 := D10;  (* Set command to requested position value *)
ELSE
    Y20 := FALSE;
    D20 := 0;    (* Ensure D20 is within command limits when inactive *)
END_IF;

(* Calculate position error *)
positionError := ABS(actualPosition - targetPosition);

(* Determine if the position and speed are within limits *)
withinErrorLimit := (positionError <= 0.2) AND (ABS(actualSpeed) <= 1.0);

(* Timing for stability observation and retention *)
stableTimer(IN := withinErrorLimit, PT := T#30ms);
resultRetentionTimer(IN := stableTimer.Q, PT := T#100ms);

(* Function result retention *)
IF resultRetentionTimer.Q THEN
    Y2 := TRUE;  (* Maintain result *)
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM