PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    requested : BOOL := FALSE;
    synchronized : BOOL := FALSE;
    moving_together : BOOL := FALSE;
    request_time : TIME;
    position_difference : REAL;
    speed_difference : REAL;
    follow_active : BOOL := FALSE;
    insertion : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

IF X10 THEN
    IF NOT requested THEN
        requested := TRUE;
        request_time := TIME(); (* Capture the time of the request *)
    END_IF
END_IF

(* Calculate the differences for alignment *)
position_difference := REAL(D11) * 0.01 - REAL(D13) * 0.01; (* mm scale *)
speed_difference := REAL(D12) * 0.01 - REAL(D14) * 0.01; (* mm/s scale *)

(* Check alignment conditions *)
IF ABS(position_difference) <= 0.2 AND ABS(speed_difference) <= 1.0 THEN
    Y20 := TRUE;
    synchronized := TRUE;
ELSE
    Y20 := FALSE;
    synchronized := FALSE;
END_IF

(* If synchronized, proceed with fork insertion *)
IF synchronized AND NOT moving_together THEN
    IF X12 THEN (* Ensure retraction endpoint is reached before extending *)
        Y21 := TRUE; (* Start insertion *)
        insertion := TRUE;
    END_IF
END_IF

(* Check if the fork is fully inserted *)
IF X11 THEN
    moving_together := TRUE;
END_IF

(* Set reference position and speed when following *)
IF follow_active THEN
    D20 := D13; (* Synchronize with U position *)
    D21 := D14; (* Follow U speed *)
ENDIF

(* Check for task completion *)
IF moving_together THEN
    IF TIME() - request_time <= T#3440ms THEN
        Y2 := TRUE; (* Task marked as complete for 30ms *)
    END_IF
ENDIF

(* Ensure completion retention *)
IF Y2 THEN
    Y2 := (TIME() - request_time <= T#3470ms); (* Maintain completion signal for 30 ms *)
END_IF

END_PROGRAM