PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    Y2 : BOOL;
    D20 : INT;
    
    startEdge : R_TRIG;
    step : INT := 0;
    itemsDelivered : INT := 0;
    totalItems : INT := 0;
    storedClass : INT := 0;
END_VAR

CASE step OF
    0: // IDLE - wait for start request and item at source
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        startEdge(CLK := X10);
        IF startEdge.Q THEN
            totalItems := D10;
            itemsDelivered := 0;
        END_IF;
        IF totalItems > 0 AND X26 AND X31 THEN
            storedClass := D20;
            step := 1;
        END_IF;
        
    1: // GO_DOWN to pickup position
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y25 := FALSE;
        Y24 := TRUE;
        IF X22 THEN
            step := 2;
        END_IF;
        
    2: // GRIP_CLOSE - acquire at low contact pose
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X24 THEN
            step := 3;
        END_IF;
        
    3: // GO_UP for travel (safety: >=360mm lift before swinging)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            step := 4;
        END_IF;
        
    4: // SWING_OUT to target (accept or reject based on storedClass)
        Y20 := TRUE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y21 := TRUE;
        Y25 := (storedClass = 1);
        IF X21 THEN
            Y21 := FALSE;
            step := 5;
        END_IF;
        
    5: // GO_DOWN at target - lower before release
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y25 := FALSE;
        Y24 := TRUE;
        IF X22 THEN
            step := 6;
        END_IF;
        
    6: // RELEASE - open grip onto receiver
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X25 THEN
            step := 7;
        END_IF;
        
    7: // GO_UP after release
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            step := 8;
        END_IF;
        
    8: // RETURN to source
        Y20 := FALSE;
        Y21 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y22 := TRUE;
        IF X20 THEN
            Y22 := FALSE;
            step := 9;
        END_IF;
        
    9: // WAIT_AND_COUNT - check for more items
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        itemsDelivered := itemsDelivered + 1;
        IF itemsDelivered < totalItems THEN
            IF X26 AND X31 THEN
                storedClass := D20;
                step := 1;
            END_IF;
        ELSE
            step := 10;
        END_IF;
        
    10: // FINAL - all actuator outputs OFF, claim completion
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF X20 AND X23 AND NOT Y20 THEN
            Y2 := TRUE;
        END_IF;
        
    ELSE
        step := 0;
END_CASE;

END_PROGRAM