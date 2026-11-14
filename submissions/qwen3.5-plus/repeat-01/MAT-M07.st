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
    
    state : INT := 0;
    startEdge : R_TRIG;
    acceptedSpacing : INT := 0;
END_VAR

startEdge(CLK := X10);

CASE state OF
    0: (* IDLE - wait for start request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF startEdge.Q THEN
            acceptedSpacing := D10;
            state := 1;
        END_IF;
        
    1: (* DOWN to acquisition position *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X23 THEN
            state := 2;
        END_IF;
        
    2: (* GRIP materials at low *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X24 THEN
            state := 3;
        END_IF;
        
    3: (* UP after grip *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := TRUE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X22 THEN
            state := 4;
        END_IF;
        
    4: (* FORWARD to target *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := TRUE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X21 THEN
            state := 5;
        END_IF;
        
    5: (* SPACING adjustment to target D10 *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := TRUE;
        
        IF D20 < acceptedSpacing - 2 THEN
            Y25 := TRUE;
            Y26 := FALSE;
        ELSIF D20 > acceptedSpacing + 2 THEN
            Y25 := FALSE;
            Y26 := TRUE;
        ELSE
            Y25 := FALSE;
            Y26 := FALSE;
            state := 6;
        END_IF;
        
    6: (* DOWN to release position *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := TRUE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X23 THEN
            state := 7;
        END_IF;
        
    7: (* RELEASE materials at low *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X25 THEN
            state := 8;
        END_IF;
        
    8: (* UP after release *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X22 THEN
            state := 9;
        END_IF;
        
    9: (* BACK to source *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        
        IF X20 THEN
            state := 10;
        END_IF;
        
    10: (* DONE - claim completion *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM