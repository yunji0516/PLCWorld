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
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    
    X10_prev : BOOL;
    State : INT;
    target_pos : INT;
END_VAR

CASE State OF
    0:
        Y2 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X10 AND NOT X10_prev AND D10 = 1 THEN
            target_pos := 0;
            State := 1;
        END_IF;
        
    1:
        (* Ensure pusher is retracted before moving rack *)
        IF X22 THEN
            IF D20 < target_pos - 2 THEN
                Y20 := TRUE;
                Y21 := FALSE;
            ELSIF D20 > target_pos + 2 THEN
                Y20 := FALSE;
                Y21 := TRUE;
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
                State := 10;
            END_IF;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
        
    10:
        (* Wait for physical alignment confirmation *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF D20 < target_pos - 2 OR D20 > target_pos + 2 THEN
            State := 1;
        ELSIF X25 THEN
            State := 2;
        END_IF;
        
    2:
        (* Check occupancy of the aligned slot *)
        IF X24 THEN
            target_pos := target_pos + 160;
            IF target_pos > 480 THEN
                target_pos := 480;
            END_IF;
            State := 1;
        ELSE
            State := 3;
        END_IF;
        
    3:
        (* Push new plate into vacant slot *)
        Y22 := TRUE;
        Y23 := FALSE;
        IF X23 THEN
            State := 4;
        END_IF;
        
    4:
        (* Retract pusher *)
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            State := 5;
        END_IF;
        
    5:
        (* Task complete *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
END_CASE;

X10_prev := X10;

END_PROGRAM