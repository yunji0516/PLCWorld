PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL := FALSE;
    Y2 : BOOL := FALSE;
    initial_position : DINT := 0;
    brake_timer : TON;
    retention_timer : TON;
    edge_detector : R_TRIG;
    request_active : BOOL := FALSE;
    in_position : BOOL := FALSE;
END_VAR

(* Function to initialize and handle the function request. *)
brake_timer(IN := Y20, PT := T#80ms);
retention_timer(IN := in_position, PT := T#100ms);
edge_detector(CLK := X10);

(* Handle the request and engage the function. *)
IF edge_detector.Q THEN
    initial_position := D11;
    request_active := TRUE;
    Y20 := TRUE;
END_IF

IF request_active THEN
    (* Engage the mechanical brake with Y20. *)
    IF X11 AND NOT X12 THEN
        (* Check if actual height is maintained within ±0.2 mm of initial position. *)
        IF ABS(D11 - initial_position) <= 20 THEN
            in_position := TRUE;
        ELSE
            in_position := FALSE;
        END_IF
    END_IF
    
    (* Maintain function retention if the position is held. *)
    IF in_position THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
END_IF

(* Reset function activation/retention after completion observation. *)
IF retention_timer.Q THEN
    Y20 := FALSE;
    Y2 := FALSE;
    request_active := FALSE;
END_IF

END_PROGRAM