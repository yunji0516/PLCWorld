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
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        
        IF start_edge.Q AND (D10 = 1) THEN
            state := 1;
        END_IF;

    1:
        // Travel forward. Offer OFF to reset potentially stale Ack.
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y20 := NOT X21; // Stop movement once docked
        
        // Wait until docked, Ack is reset, and receiver is Ready
        IF X21 AND NOT X23 AND X24 THEN
            state := 2;
        END_IF;

    2:
        // Present the offer to start transaction
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE; 
        
        // Wait for receiver to physically clamp and acknowledge
        IF X23 THEN
            state := 3;
        END_IF;

    3:
        // Release sender grip now that receiver has clamped
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE; 
        Y23 := TRUE;
        
        // Wait for sender to fully release and receiver to take final ownership
        IF X22 AND X25 THEN
            state := 4;
        END_IF;

    4:
        // Return sender to home. Turn Offer OFF to trigger Ack reset.
        Y20 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y21 := NOT X20; // Stop movement once home
        
        // Wait for sender to reach home and receiver to reset Ack
        IF X20 AND NOT X23 THEN
            state := 5;
        END_IF;

    5:
        // Completion claim
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        Y23 := FALSE;
        Y2 := TRUE;

END_CASE;

END_PROGRAM