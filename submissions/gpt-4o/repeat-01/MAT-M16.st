PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    (* Add internal variables here. *)
    startEdge: R_TRIG;         (* Rising-edge detector for start request *)
    requestedLength : INT;     (* To store the request value after start *)
    feeding : BOOL;            (* Status flag for feeding process *)
    steeringLeft : BOOL;       (* Status flag for steering left *)
    steeringRight : BOOL;      (* Status flag for steering right *)
    clampClosed : BOOL;        (* Status flag for clamp closure *)
    withinTolerance : BOOL;    (* Check if delivered length is within tolerance *)
    edgeWithinLimits : BOOL;   (* Check if edge is within ±12 mm *)
END_VAR

(* Implement the control logic here. *)

(* Initialize edge detector and check for start request *)
startEdge(CLK := X10);

(* Accept the start request and store the requested length *)
IF startEdge.Q THEN
    requestedLength := D10;
    feeding := TRUE;
    steeringLeft := FALSE;
    steeringRight := FALSE;
    clampClosed := FALSE;
END_IF

(* Check safety constraints *)
edgeWithinLimits := (D20 >= -12) AND (D20 <= 12);

(* Process feeding if within edge limits and request active *)
IF feeding AND NOT clampClosed AND edgeWithinLimits THEN
    (* Check delivered length against requested length *)
    IF D21 < requestedLength THEN
        (* Decide steering direction based on edge error *)
        IF D20 > 8 THEN
            Y20 := FALSE; (* Don't steer left if out of left limit *)
            Y21 := TRUE;  (* Steer right *)
            steeringRight := TRUE;
            steeringLeft := FALSE;
        ELSIF D20 < -8 THEN
            Y20 := TRUE;  (* Steer left *)
            Y21 := FALSE; (* Don't steer right if out of right limit *)
            steeringLeft := TRUE;
            steeringRight := FALSE;
        ELSE
            Y20 := FALSE; (* Within the acceptable range *)
            Y21 := FALSE;
            steeringLeft := FALSE;
            steeringRight := FALSE;
        END_IF

        (* Command feed *)
        Y22 := TRUE;
    ELSE
        (* Target length reached or exceeded, stop feeding *)
        Y22 := FALSE;
        feeding := FALSE;
        clampClosed := TRUE;
    END_IF
ELSE
    (* If feeding not active or edge out of limits; stop all operations *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF

(* Command clamp if required and criteria is met *)
IF clampClosed THEN
    Y23 := TRUE;  (* Close clamp *)
    IF X20 THEN   (* Check if secured feedback is true *)
        Y2 := TRUE;  (* Completion claim active *)
    END_IF
ELSE
    Y23 := FALSE;  (* Keep the clamp open otherwise *)
END_IF

(* Ensure outputs turn off when not needed *)
IF NOT feeding THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF

(* Check if all completion conditions are met *)
withinTolerance := (ABS(D21 - requestedLength) <= 3);
IF withinTolerance AND edgeWithinLimits AND X20 THEN
    Y2 := TRUE; (* Maintain completion claim and clamp *)
ELSE
    Y2 := FALSE;
END_IF

END_PROGRAM