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

    (* Internal variables *)
    start_edge : INT;
    active : BOOL := FALSE;
    scan_count : INT := 0;
    edge_valid : BOOL := TRUE;
END_VAR

(* Implement the control logic here. *)
IF X10 AND NOT active THEN
    (* Rising edge on Start *)
    active := TRUE;
    start_edge := D20; (* Capture initial edge error *)
    scan_count := 0;   (* Reset scan counter *)
    Y2 := FALSE;       (* Ensure completion claim is not active *)
END_IF

IF active THEN
    scan_count := scan_count + 1;

    (* Calculate actual edge as initial edge error plus actuator displacement plus edge drift *)
    actual_edge : REAL := start_edge + D21 + REAL(D20) * 0.065; (* Assume approximate drift *)

    (* Check if the edge is within ±12 mm during the feed *)
    IF (scan_count <= 150) AND (ABS(INT(actual_edge)) > 12) THEN
        edge_valid := FALSE;
    END_IF

    (* Steering logic *)
    IF D20 < -2 THEN
        (* Error is negative (left), steer right *)
        Y20 := FALSE;
        Y21 := TRUE;
    ELSIF D20 > 2 THEN
        (* Error is positive (right), steer left *)
        Y20 := TRUE;
        Y21 := FALSE;
    ELSE
        (* Error within tolerance, stop steering *)
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF

    (* Check for completion conditions *)
    IF X20 AND (scan_count >= 150) THEN
        (* If external_done signal is reached and valid, check final conditions *)
        IF edge_valid AND NOT Y20 AND NOT Y21 THEN
            Y2 := TRUE; (* Assert completion claim *)
        ELSE
            Y2 := FALSE; (* Ensure completion claim is not active if conditions are not met *)
        END_IF
        active := FALSE; (* End operation *)
    END_IF

    (* Stop steering after feed interval *)
    IF scan_count > 150 THEN
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF
END_IF

END_PROGRAM