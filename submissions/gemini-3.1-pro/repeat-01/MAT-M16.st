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

    state : INT := 0;
    req_len : INT := 0;
    x10_prev : BOOL := FALSE;
END_VAR

(* Handle Start Request *)
IF X10 AND NOT x10_prev THEN
    IF state = 0 THEN
        req_len := D10;
        state := 1;
    END_IF;
END_IF;
x10_prev := X10;

(* Main State Machine *)
CASE state OF
    0:
        (* Idle - ensure all outputs are safely OFF *)
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

    1:
        (* Feeding and Steering control *)
        (* Target length minus 2 mm ensures final D21 lands exactly within +/- 3 mm of D10 *)
        IF D21 >= req_len - 2 THEN
            Y22 := FALSE;
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        ELSE
            Y22 := TRUE;
            
            (* Edge guiding with a deadband of +/- 1 mm to strictly remain inside +/- 12 mm *)
            IF D20 > 1 THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 < -1 THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF;
        END_IF;

    2:
        (* Secure the material with the clamp *)
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y23 := TRUE;

        (* Wait for the physical clamp secured feedback *)
        IF X20 THEN
            state := 3;
        END_IF;

    3:
        (* Terminal completion state *)
        Y2 := TRUE;
        Y23 := TRUE;
        Y22 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;

END_CASE;

END_PROGRAM