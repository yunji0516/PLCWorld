PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    gearInEdge : R_TRIG;
    gearOutEdge : R_TRIG;
    syncTimer : TON;
    completionTimer : TON;
    
    uOriginPos : DINT;
    sOriginPos : DINT;
    currentSpan : DINT;
    parkTarget : DINT;
    synchronized : BOOL;
    gearInLatch : BOOL;
END_VAR

(* Rising edge detection for gear_in *)
gearInEdge(CLK := X10);
gearOutEdge(CLK := NOT X10);

(* Synchronization logic *)
IF gearInEdge.Q THEN
    Y20 := TRUE;
    gearInLatch := TRUE;

    uOriginPos := D10;
    sOriginPos := D11;
    currentSpan := D14;

    D20 := D15; (* Assign requested rotation ratio *)
    D21 := D11; (* Initialize target at the current position of S *)

    synchronized := FALSE;

END_IF

(* Maintaining gear coupling *)
IF gearInLatch THEN
    IF (ABS(DINT(D10 - uOriginPos) * D15 / 1000) > ABS(DINT(D11 - sOriginPos)) + 40) OR
       (ABS(D16 * D15 / 1000 - D12) > 200) THEN

        Y20 := FALSE;
        gearInLatch := FALSE;
    ELSE
        synchronized := TRUE;
    END_IF

    (* Check if the reference rotation has completed the required span *)
    IF (ABS(D10 - uOriginPos) >= currentSpan) THEN
        Y21 := TRUE; (* Start separation process *)
    END_IF
ELSE
    IF synchronized THEN
        IF gearOutEdge.Q THEN
            Y21 := TRUE;

            parkTarget := D13;
            Y22 := TRUE; (* Indicate independent position control *)

            D21 := sOriginPos + parkTarget;
        END_IF

        (* Verify final parking position and speed constraints *)
        IF (ABS(D11 - D21) <= 20) AND (ABS(D12) <= 100) THEN
            Y2 := TRUE;

            completionTimer(IN := TRUE, PT := T#100MS);
            IF completionTimer.Q THEN
                Y2 := FALSE;
            END_IF
        ELSE
            Y2 := FALSE;
        END_IF
    END_IF
END_IF

(* Indicate gear separation *)
IF Y21 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    gearInLatch := FALSE;
    synchronized := FALSE;
END_IF

END_PROGRAM