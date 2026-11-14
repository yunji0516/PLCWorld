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
    X24 : BOOL;
    X25 : BOOL;
    
    start_triggered : BOOL := FALSE;
    ack_reset_timer : TON;
    offer_timer : TON;
    release_grip_timer : TON;
    transfer_started : BOOL := FALSE;
    clamping_complete : BOOL := FALSE;
    
END_VAR

// Control Logic Implementation
IF NOT start_triggered THEN
    // Check for Start request
    IF X10 THEN
        start_triggered := TRUE;
        ack_reset_timer(IN := FALSE);
    END_IF;
END_IF;

// If Start accepted and Ack is reset, proceed to offer
IF start_triggered AND NOT X23 THEN
    // Make the Offer if docked and ready
    IF X21 AND X24 THEN
        Y23 := TRUE;
        
        offer_timer(IN := TRUE, PT := T#650ms);
        IF offer_timer.Q THEN
            // Receiver has acquired the material, set Ack
            clamping_complete := TRUE;
        END_IF;
    END_IF;
    
    // Disable Offer if not docked
    IF NOT X21 THEN
        Y23 := FALSE;
        offer_timer(IN := FALSE);
    END_IF;
END_IF;

// Handle Ack reset when Offer is OFF for a certain time
IF NOT start_triggered OR NOT Y23 THEN
    ack_reset_timer(IN := TRUE, PT := T#3500ms);
    
    IF ack_reset_timer.Q THEN
        clamping_complete := FALSE;
        Y23 := FALSE;
        start_triggered := FALSE;
    END_IF;
ELSE
    ack_reset_timer(IN := FALSE);
END_IF;

// Release the material from sender once clamping is done
IF clamping_complete THEN
    Y22 := TRUE;
    
    release_grip_timer(IN := TRUE, PT := T#300ms);
    IF release_grip_timer.Q THEN
        IF X25 THEN
            // Material ownership changed to receiver
            Y2 := TRUE;
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE; // Sender grip open
            Y23 := FALSE; // Disable Offer
            transfer_started := FALSE;
        END_IF;
    END_IF;
    
ELSE
    release_grip_timer(IN := FALSE);
END_IF;

// Ensure Completion Conditions are maintained
IF Y2 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
END_IF;

END_PROGRAM