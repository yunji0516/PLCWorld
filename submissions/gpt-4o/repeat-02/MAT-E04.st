PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    
    transaction_active : BOOL := FALSE;
    start_edge : R_TRIG;
    offer_timer : TON;
    ack_delay_timer : TON;
    release_timer : TON;
    offer_duration_met : BOOL := FALSE;
    ack_valid : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* Detect the rising edge of the Start request signal *)
start_edge(CLK := X10);

(* Start transaction when Start is detected and product is present *)
IF start_edge.Q AND D10 = 1 THEN
    transaction_active := TRUE;
END_IF

(* Manage offer timing and rearment *)
IF transaction_active THEN
    (* Lower Offer if acknowledge is high initially *)
    IF X21 THEN
        Y21 := FALSE;
    ELSE
        Y21 := TRUE;
        offer_timer(IN := Y21, PT := T#1500ms);
    END_IF
END_IF

IF offer_timer.Q THEN
    offer_duration_met := TRUE;
END_IF

(* Once ready, start the ack delay timing *)
IF offer_duration_met AND X22 THEN
    ack_delay_timer(IN := TRUE, PT := T#600ms);
ELSE
    ack_delay_timer(IN := FALSE);
END_IF

IF ack_delay_timer.Q THEN
    ack_valid := TRUE;
END_IF

(* Valid transaction acceptance by receiver *)
IF transaction_active AND ack_valid THEN
    (* Start the release process if not already released *)
    IF NOT X20 THEN
        Y20 := TRUE;
        release_timer(IN := TRUE, PT := T#120ms);
    ELSE
        release_timer(IN := FALSE);
    END_IF
    
    (* Release the product and reset Offer when released *)
    IF release_timer.Q THEN
        Y20 := FALSE;
        Y21 := FALSE;
        transaction_active := FALSE;
        ack_valid := FALSE;
        offer_duration_met := FALSE;
    END_IF
END_IF

(* Check if the product has been received *)
IF X23 THEN
    Y2 := TRUE; (* Completion claim is held after the transaction is acknowledged and product is received *)
END_IF

END_PROGRAM