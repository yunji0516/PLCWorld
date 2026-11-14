PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    (* Add internal variables here. *)
    syncPointSet : BOOL := FALSE;
    u0 : DINT := 0;
    s0 : DINT := 0;
    positionError : REAL;
    velocityError : REAL;
    ratio : REAL;
    requestedRatio : REAL;
    phaseErrorMet : BOOL := FALSE;
    velocityErrorMet : BOOL := FALSE;
    resultTimer : TON;
    retentionTimer : TON;
    scansCounter : DINT := 0;
END_VAR

(* Implement the control logic here. *)

requestedRatio := REAL(D10) * 0.001;

(* Set synchronization point *)
IF X10 AND NOT syncPointSet THEN
    u0 := D13;
    s0 := D11;
    syncPointSet := TRUE;
    Y20 := TRUE; (* Activate function *)
END_IF

(* Calculate errors if synchronized *)
IF syncPointSet THEN
    positionError := REAL(D11 - s0) - requestedRatio * REAL(D13 - u0);
    velocityError := ABS(REAL(D12) - requestedRatio * REAL(D14));

    phaseErrorMet := ABS(positionError) <= 0.3;
    velocityErrorMet := velocityError <= 2.0;

    IF phaseErrorMet AND velocityErrorMet THEN
        resultTimer(IN := TRUE, PT := T#30ms);
        IF resultTimer.Q THEN
            Y2 := TRUE; (* Set result retention *)
            scansCounter := scansCounter + 1;
            retentionTimer(IN := TRUE, PT := T#250ms);
        ELSE
            retentionTimer(IN := FALSE);
        END_IF
    ELSE
        resultTimer(IN := FALSE);
        retentionTimer(IN := FALSE);
        Y2 := FALSE;
        scansCounter := 0;
    END_IF

    IF retentionTimer.Q THEN
        (* End function after 250ms of result retention *)
        syncPointSet := FALSE;
        Y20 := FALSE;
    END_IF
    
    IF scansCounter >= 220 THEN
        Y20 := FALSE; (* Stop execution after 220 scans if not complete *)
        syncPointSet := FALSE;
    END_IF
END_IF

(* Update outputs *)
D20 := D10; (* Set gear ratio command matching the input *)

END_PROGRAM