PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    
    (* Internal variables *)
    start_rising_edge : R_TRIG;
    ack_rising_edge : R_TRIG;
    ready_timer : TON;
    offer_timer : TON;
    is_transaction_valid : BOOL := FALSE;
    has_started : BOOL := FALSE;
    transaction_accepted : BOOL := FALSE;
    handoff_completed : BOOL := FALSE;
END_VAR

(* Detect rising edge of Start request *)
start_rising_edge(CLK := X10);

(* Detect rising edge of ack *)
ack_rising_edge(CLK := X21);

(* Handle start logic *)
IF start_rising_edge.Q THEN
    has_started := TRUE;
    transaction_accepted := FALSE;
    is_transaction_valid := FALSE;
    Y21 := FALSE;       // Ensure Offer is rearmed
END_IF

(* Timer to wait for Ready after Start *)
ready_timer(IN := has_started AND NOT X22, PT := T#2s);

(* Check if Ready has become true in time *)
IF ready_timer.Q THEN
    IF X22 THEN
        is_transaction_valid := TRUE;
    ELSE
        has_started := FALSE;  // Reset start if not ready on time
    END_IF
END_IF

(* Control Offer signal *)
IF is_transaction_valid THEN
    IF NOT Y21 THEN
        offer_timer(IN := TRUE, PT := T#150ms);  // Timer for Offer to be ON between 0.12s and 1.5s
        IF offer_timer.Q AND X22 THEN  // Offer can go high if Ready is true
            Y21 := TRUE;
            offer_timer(IN := FALSE); // Stop the offer timer
        END_IF
    END_IF
END_IF

(* Detect valid transaction acceptance via ack *)
IF ack_rising_edge.Q AND is_transaction_valid AND X22 AND Y21 THEN
    transaction_accepted := TRUE;
    Y21 := FALSE;   // Turn off Offer
END_IF

(* Handle release logic after valid transaction acceptance *)
IF transaction_accepted THEN
    Y20 := TRUE;   // Initiate release
    IF X20 THEN   // Check if released
        handoff_completed := TRUE;
    END_IF
END_IF

(* Completion claim logic *)
IF handoff_completed AND X23 THEN
    Y2 := TRUE;
END_IF

(* Maintain the completion status for the evaluation window *)
IF handoff_completed THEN
    transaction_accepted := FALSE;  // Reset transactional variables
    is_transaction_valid := FALSE;
    has_started := FALSE;
END_IF

END_PROGRAM