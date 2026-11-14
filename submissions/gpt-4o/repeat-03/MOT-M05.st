PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    requestedPositionA : REAL;
    requestedPositionB : REAL;
    currentPositionA : REAL;
    currentPositionB : REAL;
    currentSpeedA : REAL;
    currentSpeedB : REAL;
    m : REAL;
    brakeEngageTimer : TON;
    requestX10Prev : BOOL := FALSE;
    completionTimer : TON;
    positionTolerance : REAL := 0.2;
    speedTolerance : REAL := 1.0;
    completed : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

requestedPositionA := DINT_TO_REAL(D10) * 0.01;
currentPositionA := DINT_TO_REAL(D11) * 0.01;
currentSpeedA := DINT_TO_REAL(D12) * 0.01;
currentPositionB := DINT_TO_REAL(D13) * 0.01;
currentSpeedB := DINT_TO_REAL(D14) * 0.01;
requestedPositionB := DINT_TO_REAL(D17) * 0.01;

(* Calculate the moment M. *)
m := 30.0 * 9.81 * 0.3 * SIN(currentPositionA) + 20.0 * 9.81 * currentPositionB / 1000.0;

(* Check work request X10. *)
IF X10 AND NOT requestX10Prev THEN
    (* New request detected, initiate tilt control. *)
    Y20 := TRUE;  (* Activate head drive *)
    Y22 := FALSE; (* Ensure brake is not engaged while head is moving *)
    completed := FALSE;
END_IF
requestX10Prev := X10;

(* Movement constraints and completion checks. *)

IF ABS(m) <= 25.0 THEN
    (* Set target positions to requested positions while maintaining balance. *)
    D20 := D10;
    D21 := D17;

    IF Y20 AND ABS(D12) <= 100 THEN
        (* Stop condition, activate brake *)
        Y20 := FALSE;  (* Deactivate head drive *)
        brakeEngageTimer(IN := TRUE, PT := T#80ms);
    ELSE
        brakeEngageTimer(IN := FALSE);
    END_IF

    IF brakeEngageTimer.Q THEN
        Y22 := TRUE;  (* Engage brake *)
        IF (ABS(currentPositionA - requestedPositionA) <= positionTolerance) AND
           (ABS(currentPositionB - requestedPositionB) <= positionTolerance) AND
           (ABS(currentSpeedA) <= speedTolerance) AND
           (ABS(currentSpeedB) <= speedTolerance) AND
           ABS(m) <= 1.0 THEN

            completionTimer(IN := TRUE, PT := T#30ms);
        ELSE
            completionTimer(IN := FALSE);
        END_IF

        IF completionTimer.Q THEN
            completed := TRUE;
        ELSE
            completed := FALSE;
        END_IF
    END_IF
END_IF

IF completed THEN
    Y2 := TRUE;  (* Hold completion indication. *)
    Y21 := TRUE; (* Maintain counterweight drive. *)
END_IF

END_PROGRAM