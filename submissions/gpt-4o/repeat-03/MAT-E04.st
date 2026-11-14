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

    start_edge : R_TRIG;
    offer_timer, ack_timer, release_timer : TON;
    offer_duration_achieved : BOOL := FALSE;
    transaction_valid : BOOL := FALSE;
    transaction_complete : BOOL := FALSE;
    scan_count : INT := 0;
END_VAR

(* Implement the control logic here. *)

start_edge(CLK := X10);

(* Initial transaction sequence *)
IF start_edge.Q AND D10 = 1 THEN
    IF NOT transaction_valid THEN
        offer_timer(IN := TRUE, PT := T#1.5s);
        Y21 := TRUE; (* Start offer *)
        
        IF offer_timer.ET >= T#0.12s THEN
            offer_duration_achieved := TRUE;
        END_IF

        IF offer_duration_achieved AND X22 THEN
            ack_timer(IN := TRUE, PT := T#0.6s);

            IF ack_timer.Q THEN
                transaction_valid := TRUE;
                ack_timer(IN := FALSE);
            END_IF
        END_IF
    END_IF
END_IF

(* Process valid transaction *)
IF transaction_valid THEN
    IF X21 THEN
        release_timer(IN := TRUE, PT := T#0.12s);
        Y20 := TRUE; (* Start release *)
        
        IF release_timer.Q THEN
            transaction_complete := TRUE;
            release_timer(IN := FALSE);
            Y21 := FALSE; (* Stop offer *)
        END_IF
    ELSE
        Y20 := FALSE;
    END_IF
END_IF

(* Completion logic *)
IF transaction_complete AND X23 AND X20 THEN
    Y2 := TRUE;
    scan_count := scan_count + 1;
    IF scan_count >= 1550 THEN
        Y2 := FALSE; (* Result retention check *)
    END_IF
END_IF

(* Safety and reset conditions *)
IF NOT X21 THEN
    Y20 := FALSE; (* Ensure release is off without valid acknowledgment *)
END_IF

IF scan_count >= 1600 THEN
    offer_timer(IN := FALSE);
    ack_timer(IN := FALSE);
    release_timer(IN := FALSE);
    Y2 := FALSE;
    transaction_valid := FALSE;
    transaction_complete := FALSE;
    offer_duration_achieved := FALSE;
    scan_count := 0;
END_IF

END_PROGRAM