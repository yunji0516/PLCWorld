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
    target : INT := 0;
    prevX10 : BOOL := FALSE;
    clampTimer : TON;
END_VAR

(* Rising edge detection on X10 to accept request *)
IF X10 AND NOT prevX10 THEN
    IF state = 0 THEN
        target := D10;
        state := 1;
    END_IF;
END_IF;
prevX10 := X10;

CASE state OF
    0: (* IDLE - wait for start request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        
    1: (* FEEDING - steer to keep edge in corridor, feed to target *)
        IF D20 > 12 THEN
            (* Emergency: edge beyond right limit, steer left, stop feed *)
            Y20 := TRUE;
            Y21 := FALSE;
            Y22 := FALSE;
        ELSIF D20 < -12 THEN
            (* Emergency: edge beyond left limit, steer right, stop feed *)
            Y21 := TRUE;
            Y20 := FALSE;
            Y22 := FALSE;
        ELSIF D20 > 6 THEN
            (* Edge right of deadband, steer left *)
            Y20 := TRUE;
            Y21 := FALSE;
            Y22 := (D21 < target - 3);
        ELSIF D20 < -6 THEN
            (* Edge left of deadband, steer right *)
            Y21 := TRUE;
            Y20 := FALSE;
            Y22 := (D21 < target - 3);
        ELSE
            (* Edge within deadband, no steering *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := (D21 < target - 3);
        END_IF;
        
        Y23 := FALSE;
        
        (* Transition to clamping when length within tolerance and edge in corridor *)
        IF D21 >= target - 3 AND D20 >= -12 AND D20 <= 12 THEN
            state := 2;
        END_IF;
        
    2: (* CLAMPING - close clamp and wait for secured feedback *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        
        clampTimer(IN := TRUE, PT := T#100ms);
        IF clampTimer.Q OR X20 THEN
            state := 3;
        END_IF;
        
    3: (* COMPLETE - hold terminal state *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM