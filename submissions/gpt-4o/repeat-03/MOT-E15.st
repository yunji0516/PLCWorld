PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    Y20 : BOOL := FALSE;
    D20 : DINT := 0;
    D21 : DINT := 0;
    Y2 : BOOL := FALSE;
    (* Internal variables *)
    targetPosition : REAL;
    targetSpeed : REAL;
    supportMoment : REAL;
    headAngleRad : REAL;
    errorFilter : REAL := 0.0;
    timer : TON;
    retentionTimer : TON;
    requestAccepted : BOOL := FALSE;
END_VAR

(* Calculate M *)
headAngleRad := REAL(D13) * 0.01 * 3.14159 / 180.0; (* Convert to radians *)
supportMoment := 30.0 * 9.81 * 0.3 * SIN(headAngleRad) + 20.0 * 9.81 * (REAL(D11) * 0.01);

(* Filter error signal (D17 can be noisy) *)
errorFilter := 0.9 * errorFilter + 0.1 * (REAL(D17) * 0.01);

(* Activate the function if X10 is TRUE and the request has been accepted *)
IF X10 THEN
    requestAccepted := TRUE;
END_IF

(* Only proceed if request is accepted *)
IF requestAccepted THEN
    Y20 := TRUE;
    
    (* Calculate target position for the counterweight *)
    targetPosition := ((1.0 - (supportMoment / 25.0)) * 225.0);  (* Scale support moment to position range *)
    
    (* Calculate the feedforward speed based on error in support moment *)
    targetSpeed := errorFilter * 100.0; (* Scale error to speed command *)
    
    (* Limit target position and speed within allowable range *)
    targetPosition := LIMIT(-2000.0, 2000.0, targetPosition);
    targetSpeed := LIMIT(-100000.0, 100000.0, targetSpeed);
    
    (* Convert to DINT for output *)
    D20 := DINT(targetPosition * 100.0);
    D21 := DINT(targetSpeed);
    
    (* Check for completion conditions *)
    IF ABS(supportMoment) <= 1.0 THEN
        IF NOT timer.Q THEN
            timer(IN := TRUE, PT := T#30ms);
        END_IF
    ELSE
        timer(IN := FALSE);
        timer.Q := FALSE;
    END_IF
    
    (* Maintain result retention *)
    IF timer.Q THEN
        Y2 := TRUE;
        retentionTimer(IN := TRUE, PT := T#1400ms);
    ELSE
        Y2 := FALSE;
        retentionTimer(IN := FALSE);
    END_IF
ELSE
    Y20 := FALSE;
    D20 := 0;
    D21 := 0;
    Y2 := FALSE;
END_IF

END_PROGRAM