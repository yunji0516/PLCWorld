PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    (* Add internal variables here. *)
    start_request : BOOL := FALSE;
    span_limit : INT;
    edge_detector : R_TRIG;
END_VAR

(* Implement the control logic here. *)

(* Detect start request on rising edge of X10 *)
edge_detector(CLK := X10);
IF edge_detector.Q THEN
    start_request := TRUE;
    IF D10 = 1 THEN
        span_limit := 150;  (* Use the stricter span constraint by default *)
    ELSE
        span_limit := 180;  (* Otherwise, use the maximum allowable span *)
    END_IF;
END_IF;

(* Control logic to start the operation only after start_request is true *)
IF start_request THEN
    (* Ensure bridge is raised before starting the push operation *)
    IF NOT X20 AND NOT X21 THEN
        Y20 := TRUE;
        Y21 := FALSE;
    ELSIF X20 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        
        (* Push the board while maintaining the unsupported span constraint *)
        IF X22 THEN
            Y22 := TRUE;  (* Start pushing *)
            Y23 := FALSE;
        END_IF;
        
        (* Ensure the pusher does not overrun *)
        IF X23 THEN
            Y22 := FALSE;
            Y23 := FALSE;
        END_IF;
        
        (* Check for front receipt to manage unsupported span *)
        IF X24 THEN
            (* Calculate unsupported span *)
            IF D20 - (-700) > span_limit THEN
                Y22 := FALSE;  (* Stop pushing if span exceeded before whole receipt *)
            END_IF;
        END_IF;
    END_IF;
    
    (* Once whole reception confirmed, retract pusher and lower bridge *)
    IF X25 THEN
        Y22 := FALSE;
        Y23 := TRUE;  (* Retract only *)
        
        IF X22 THEN
            Y23 := FALSE;
            Y21 := TRUE;  (* Lower the bridge *)
        END_IF;
    END_IF;
    
    (* Completion check and assert Y2 *)
    IF X23 AND X21 AND (D20 >= 699 AND D20 <= 700) THEN
        Y2 := TRUE;  (* Successfully completed conditions *)
        Y20 := FALSE;  (* Ensure no further actuator commands post-completion *)
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
    END_IF;
END_IF;

END_PROGRAM