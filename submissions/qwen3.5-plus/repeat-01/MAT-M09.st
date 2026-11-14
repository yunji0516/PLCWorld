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
    
    state : INT := 0;
    startEdge : R_TRIG;
END_VAR

startEdge(CLK := X10);

CASE state OF
    0: (* Idle - Wait for Start request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF startEdge.Q THEN
            state := 1;
        END_IF;
        
    1: (* Clear stale Ack - Ensure Offer is OFF and wait for interface reset *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF NOT X23 THEN
            state := 2;
        END_IF;
        
    2: (* Move Forward to Dock *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X21 THEN
            state := 3;
        END_IF;
        
    3: (* Wait for Receiver Ready *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X24 THEN
            state := 4;
        END_IF;
        
    4: (* Offer Transaction - Wait for Receiver Ack *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X23 THEN
            state := 5;
        END_IF;
        
    5: (* Ack Received - Turn OFF Offer to reset Ack *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF NOT X23 THEN
            state := 6;
        END_IF;
        
    6: (* Release Sender Grip *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X22 THEN
            state := 7;
        END_IF;
        
    7: (* Wait for Receiver Ownership *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X25 THEN
            state := 8;
        END_IF;
        
    8: (* Move Back to Source *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := FALSE;
        IF X20 THEN
            state := 9;
        END_IF;
        
    9: (* Complete - Maintain terminal result *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM