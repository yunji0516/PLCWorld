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
    D20 : INT;
    D21 : INT;
    D22 : INT;
    start_request : BOOL := FALSE;
    requested_length : INT := 0;
    edge_tolerance : INT := 12;
    length_tolerance : INT := 3;
    controller_edge : R_TRIG;
END_VAR

(* Implement the control logic here. *)

controller_edge(CLK := X10);
IF controller_edge.Q THEN
    (* Accept the request length on a rising edge X10 *)
    start_request := TRUE;
    requested_length := D10;
END_IF

IF start_request THEN
    (* Check if feeding is within error bounds *)
    IF ABS(D20) > edge_tolerance THEN
        IF D20 > 0 THEN
            Y20 := FALSE;
            Y21 := TRUE; (* Move right *)
        ELSE
            Y20 := TRUE; (* Move left *)
            Y21 := FALSE;
        END_IF
    ELSE
        Y20 := FALSE;
        Y21 := FALSE; (* Hold steering position *)
    END_IF

    IF D21 < requested_length THEN
        Y23 := FALSE; (* Ensure clamp is open for feeding *)
        IF ABS(D20) <= edge_tolerance THEN
            Y22 := TRUE; (* Start feeding *)
        ELSE
            Y22 := FALSE; (* Stop feeding if out of bounds *)
        END_IF
    ELSE
        Y22 := FALSE; (* Stop feeding when length reached *)
        
        IF ABS(D21 - requested_length) <= length_tolerance THEN
            Y23 := TRUE; (* Close clamp if within tolerance *)
            IF X20 THEN (* Check if secured *)
                Y2 := TRUE; (* Set completion claim *)
            ELSE
                Y2 := FALSE;
            END_IF
        ELSE
            Y23 := FALSE; (* Keep clamp open if length tolerance not met *)
        END_IF
    END_IF
ELSE
    (* Ensure no actuator operation before accepting start *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
END_IF

END_PROGRAM