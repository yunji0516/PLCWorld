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
    start_edge : R_TRIG;
    span_limit : INT;
    accepted_request : BOOL := FALSE;
    pusher_active : BOOL := FALSE;
END_VAR

(* Initialize and configure edge detection. *)
start_edge(CLK := X10);

(* Accept start request and configure span limit. *)
IF start_edge.Q THEN
    accepted_request := TRUE;
    IF D10 = 1 THEN
        span_limit := 150; (* Example of handling a stricter span limit; modify as needed. *)
    ELSE
        span_limit := 180; (* Default span limit. *)
    END_IF;
END_IF;

(* Main control logic. Proceed only if request is accepted. *)
IF accepted_request THEN
    IF NOT (Y20 OR Y21) THEN
        (* Raise the bridge if not already raised. *)
        IF NOT X20 THEN
            Y20 := TRUE;
        ELSE
            Y20 := FALSE;
        END_IF;
    END_IF;
    
    (* Ensure not to overload commands. *)
    IF Y20 AND NOT X20 THEN
        Y21 := FALSE;
    END_IF;
    
    (* Once the bridge is raised, manage board transfer. *)
    IF X20 AND NOT pusher_active THEN
        (* Start pushing the board. *)
        IF NOT X23 THEN
            Y22 := TRUE; (* Command pusher forward. *)
            pusher_active := TRUE;
        END_IF;
    END_IF;
    
    (* Monitor unsupported span and position. *)
    IF pusher_active THEN
        IF Y22 THEN
            (* Ensure not to exceed span limit at any scan. *)
            IF D20 > -700 + span_limit THEN
                Y22 := FALSE;
            END_IF;
        END_IF;

        (* Check for covered states to retract. *)
        IF X23 OR X25 THEN
            Y22 := FALSE;
            pusher_active := FALSE;
        END_IF;
    END_IF;

    (* Once whole received, retract pusher and lower bridge. *)
    IF X25 AND X23 THEN
        Y21 := TRUE;   (* Command lower bridge. *)
        IF X21 THEN
            Y23 := TRUE; (* Command retract pusher. *)
        END_IF;
    END_IF;
    
    (* Completion Conditions: Check all final conditions are met. *)
    IF X25 AND X23 AND X21 AND D20 >= 699 THEN
        Y2 := TRUE; (* Completion claim. *)
        (* Keep outputs off after claiming completion. *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
    END_IF;
END_IF;

END_PROGRAM