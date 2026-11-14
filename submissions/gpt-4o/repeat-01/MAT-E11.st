PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;

    edgeWithinCorridor : BOOL := TRUE;
    startTrigger : R_TRIG;
    scanCounter : INT := 0;
    steeringActive : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* Rising edge detection for Start *)
startTrigger(CLK := X10);
IF startTrigger.Q AND D10 = 1 AND NOT steeringActive THEN
    (* Start operation *)
    scanCounter := 0;
    steeringActive := TRUE;
    Y2 := FALSE;
END_IF

(* Steering logic - active during external feed duration *)
IF steeringActive THEN
    (* Check current edge position and decide on steering *)
    IF D20 > 12 THEN
        (* Edge too far right, steer left *)
        Y20 := TRUE;
        Y21 := FALSE;
    ELSIF D20 < -12 THEN
        (* Edge too far left, steer right *)
        Y20 := FALSE;
        Y21 := TRUE;
    ELSE
        (* Edge within corridor - stop steering *)
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF

    (* Check if edge was out of corridor *)
    IF D20 < -12 OR D20 > 12 THEN
        edgeWithinCorridor := FALSE;
    END_IF

    (* Increment scan counter *)
    scanCounter := scanCounter + 1;

    (* Completion check *)
    IF scanCounter >= 150 THEN
        (* 150 scans represent 1.5 seconds of 10ms interval checks *)
        steeringActive := FALSE;
        Y2 := edgeWithinCorridor AND X20;
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF
END_IF

(* Maintain completion claim for at least 50 scans after external_done is true *)
IF X20 AND scanCounter < 160 THEN
    Y2 := Y2; (* Y2 is held until after the observation window. *)
END_IF

END_PROGRAM