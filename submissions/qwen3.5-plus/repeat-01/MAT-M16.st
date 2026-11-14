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
    
    start_edge : R_TRIG;
    state : INT := 0;
    target_len : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0: (* IDLE *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            target_len := D10;
            state := 1;
        END_IF;
        
    1: (* FEED *)
        (* Steering control *)
        IF D20 > 1 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSIF D20 < -1 THEN
            Y21 := TRUE;
            Y20 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF;
        
        (* Respect actuator limits *)
        IF D22 <= -100 THEN Y20 := FALSE; END_IF;
        IF D22 >= 100 THEN Y21 := FALSE; END_IF;
        
        (* Feed command *)
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := FALSE;
        
        (* Check length tolerance *)
        IF D21 >= target_len - 3 THEN
            Y22 := FALSE;
            state := 2;
        END_IF;
        
    2: (* CLAMP *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y2 := FALSE;
        
        IF X20 AND (D21 >= target_len - 3) AND (D21 <= target_len + 3) AND (D20 >= -12) AND (D20 <= 12) THEN
            state := 3;
        END_IF;
        
    3: (* DONE *)
        Y2 := TRUE;
        Y23 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
END_CASE;

END_PROGRAM