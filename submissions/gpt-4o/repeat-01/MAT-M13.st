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
    D20 : INT;
    D21 : INT;
    requestAccepted : BOOL := FALSE;
    targetIndex : INT := -1;
    currentItemId : INT := 0;
    edge : R_TRIG;
    carouselAligned : BOOL;
END_VAR

(* Helper function to calculate the target index *)
FUNCTION CalculateTargetIndex : INT
    VAR_INPUT
        requestedId : INT;
    END_VAR

    VAR
        idx : INT;
    END_VAR

    (* Check each pocket for the requested ID *)
    idx := 0;

    WHILE idx < 4 DO
        IF D20 = requestedId THEN
            RETURN idx;
        END_IF
        idx := idx + 1;
    END_WHILE

    RETURN -1; (* Not found *)
END_FUNCTION

(* Main logic *)
edge(CLK := X10);

IF edge.Q THEN
    requestAccepted := TRUE;
    targetIndex := CalculateTargetIndex(requestedId := D10);
END_IF

(* Determine if carousel is aligned *)
carouselAligned := X20;

IF requestAccepted THEN
    IF targetIndex <> -1 THEN
        (* Rotate the carousel to the target index *)
        IF D21 <> targetIndex THEN
            IF (D21 + 1) MOD 4 = targetIndex THEN
                Y20 := TRUE; (* CW to target *)
                Y21 := FALSE;
            ELSE
                Y20 := FALSE;
                Y21 := TRUE; (* CCW to target *)
            END_IF
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            
            (* Align the carousel if it's not already aligned *)
            IF carouselAligned THEN
                (* Eject the item *)
                IF NOT X22 THEN
                    Y22 := TRUE; (* push *)
                    Y23 := FALSE;
                ELSE
                    Y22 := FALSE;
                    Y23 := TRUE; (* retract *)
                END_IF
            END_IF
        END_IF
    END_IF

    (* Check completion conditions *)
    IF X22 AND (targetIndex = D21) AND carouselAligned THEN
        (* Disable all actuators and claim completion *)
        Y2 := TRUE;
        requestAccepted := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
    END_IF
END_IF

END_PROGRAM