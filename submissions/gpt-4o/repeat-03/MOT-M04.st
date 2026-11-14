PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    D15 : DINT;
    D16 : DINT;
    D18 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y2 : BOOL;
    
    targetLength : DINT;
    targetTrolley : DINT;
    targetSway : DINT;
    acceleration : DINT;
    
    timer : TON;
    resultTimer : TON;

    lengthError : DINT;
    trolleyError : DINT;
    swayError : DINT;
    posTolerance : DINT := 100;
    swayTolerance : DINT := 20;
    speedTolerance : DINT := 100;
    
    settlingTimeMet : BOOL := FALSE;
    resultStable : BOOL := FALSE;
    
    cmdIssued : BOOL := FALSE;
END_VAR

(* Initialize targets based on inputs *)
targetLength := D10;
targetTrolley := D17;
targetSway := D18;
(* Calculate errors *)
lengthError := ABS(D11 - targetLength);
trolleyError := ABS(D13 - targetTrolley);
swayError := ABS(D15 - targetSway);

(* Command hoist if within permissible ranges and the task request is active *)
IF X10 AND NOT cmdIssued THEN
    D20 := SEL(lengthError > posTolerance, targetLength, D11);
    D21 := SEL(lengthError > posTolerance, 3500, 0);
    Y20 := TRUE;
    cmdIssued := TRUE;
END_IF

(* Check if the movement has settled within tolerances *)
settlingTimeMet :=
    (lengthError <= posTolerance) AND
    (trolleyError <= posTolerance) AND
    (swayError <= swayTolerance) AND
    (ABS(D12) <= speedTolerance) AND
    (ABS(D14) <= speedTolerance) AND
    (ABS(D16) <= speedTolerance);

(* Use a timer to ensure stability after settling *)
timer(IN := settlingTimeMet, PT := T#30ms);
resultStable := timer.Q;

(* Maintain result stability for a minimum period and confirm completion *)
resultTimer(IN := resultStable, PT := T#100ms);
Y2 := resultTimer.Q;

(* Ensure outputs are cleared if the task is not active or completed *)
IF NOT X10 OR (X10 AND Y2) THEN
    Y20 := FALSE;
    cmdIssued := FALSE;
END_IF

END_PROGRAM