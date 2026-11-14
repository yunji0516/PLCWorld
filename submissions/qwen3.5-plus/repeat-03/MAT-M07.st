PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    D20 : INT;
    
    edge : R_TRIG;
    state : INT := 0;
    targetSpacing : INT := 0;
END_VAR

edge(CLK := X10);

CASE state OF
    0: (* IDLE - Wait for start request *)
        Y2 := FALSE;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
        IF edge.Q THEN
            targetSpacing := D10;
            state := 1;
        END_IF;
        
    1: (* GO_LOW - Lower to pick up materials *)
        Y23 := TRUE;
        Y2 := FALSE; Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
        IF X23 THEN
            state := 2;
        END_IF;
        
    2: (* GRIP - Close grips and wait for holding confirmation *)
        Y24 := TRUE;
        Y2 := FALSE; Y23 := FALSE; Y22 := FALSE; Y20 := FALSE; Y21 := FALSE; Y25 := FALSE; Y26 := FALSE;
        IF X24 THEN
            state := 3;
        END_IF;
        
    3: (* RAISE - Lift to safe height for horizontal/spacing motion *)
        Y22 := TRUE;
        Y2 := FALSE; Y23 := FALSE; Y20 := FALSE; Y21 := FALSE; Y24 := TRUE; Y25 := FALSE; Y26 := FALSE;
        IF X22 THEN
            state := 4;
        END_IF;
        
    4: (* MOVE_TO_TARGET - Translate to receiver position *)
        Y22 := TRUE; Y24 := TRUE;
        Y2 := FALSE; Y23 := FALSE; Y25 := FALSE; Y26 := FALSE;
        IF X21 THEN
            Y20 := FALSE; Y21 := FALSE;
            state := 5;
        ELSE
            Y20 := TRUE; Y21 := FALSE;
        END_IF;
        
    5: (* ADJUST_SPACING - Match target spacing while high *)
        Y22 := TRUE; Y24 := TRUE;
        Y2 := FALSE; Y23 := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF ABS(D20 - targetSpacing) <= 1 THEN
            Y25 := FALSE; Y26 := FALSE;
            state := 6;
        ELSIF D20 < targetSpacing THEN
            Y25 := TRUE; Y26 := FALSE;
        ELSE
            Y25 := FALSE; Y26 := TRUE;
        END_IF;
        
    6: (* LOWER_REL - Lower to release position at target *)
        Y23 := TRUE;
        Y2 := FALSE; Y22 := FALSE; Y20 := FALSE; Y21 := FALSE; Y24 := TRUE; Y25 := FALSE; Y26 := FALSE;
        IF X23 THEN
            state := 7;
        END_IF;
        
    7: (* RELEASE - Open grips and wait for release confirmation *)
        Y24 := FALSE;
        Y2 := FALSE; Y23 := FALSE; Y22 := FALSE; Y20 := FALSE; Y21 := FALSE; Y25 := FALSE; Y26 := FALSE;
        IF X25 THEN
            state := 8;
        END_IF;
        
    8: (* RAISE_BACK - Lift to safe height *)
        Y22 := TRUE;
        Y2 := FALSE; Y23 := FALSE; Y20 := FALSE; Y21 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
        IF X22 THEN
            state := 9;
        END_IF;
        
    9: (* MOVE_HOME - Return to source position *)
        Y22 := TRUE; Y21 := TRUE;
        Y2 := FALSE; Y23 := FALSE; Y20 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
        IF X20 THEN
            state := 10;
        END_IF;
        
    10: (* DONE - Completion *)
        Y2 := TRUE;
        Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y25 := FALSE; Y26 := FALSE;
END_CASE;

END_PROGRAM