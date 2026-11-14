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
    (* Add internal variables here. *)
    start_triggered : BOOL := FALSE;
    offer_armed : BOOL := FALSE;
    docked_and_ready : BOOL := FALSE;
    transfer_complete : BOOL := FALSE;
    transaction_started : BOOL := FALSE;
    ack_reset_timer : TON;
    offer_timer : TON;
    grip_timer : TON;
    home_position : BOOL := FALSE;
    receiver_ownership : BOOL := FALSE;
    ack_reset_delay : TIME := T#120ms;
    clamping_duration : TIME := T#200ms;
    grip_response_time : TIME := T#300ms;
    sender_position : REAL := -650.0;
END_VAR

(* Implement the control logic here. *)

(* Monitor for rising edge of start request *)
IF X10 AND NOT start_triggered THEN
    start_triggered := TRUE;
    offer_armed := FALSE;
    docked_and_ready := FALSE;
END_IF

(* Monitoring acknowledged reset conditions *)
IF NOT X23 THEN
    ack_reset_timer(IN := NOT X23, PT := ack_reset_delay);
    IF ack_reset_timer.Q THEN
        offer_armed := FALSE;
    END_IF
END_IF

(* Arm the offer when conditions are met *)
IF start_triggered AND X21 AND X24 AND NOT offer_armed THEN
    offer_armed := TRUE;
    offer_timer(IN := TRUE, PT := clamping_duration);
    Y23 := TRUE;
    transaction_started := TRUE;
ELSE
    Y23 := FALSE;
END_IF

(* Monitoring receipt of the material when armed offer is present *)
IF transaction_started THEN
    IF offer_timer.Q AND NOT docked_and_ready THEN
        docked_and_ready := TRUE;
        Y23 := FALSE; (* Stop offering once clamping is complete *)
    END_IF
END_IF

(* Release material only after receiver has clamped it *)
IF docked_and_ready AND X23 THEN
    Y22 := TRUE; (* Release sender grip *)
    grip_timer(IN := TRUE, PT := grip_response_time);

    IF grip_timer.Q AND X25 THEN
        Y22 := FALSE; (* Stop release after verification *)
        transfer_complete := TRUE;
    END_IF
END_IF

(* Ensure movement stops when both grips constrain item *)
IF NOT Y22 AND NOT X22 THEN
    Y20 := FALSE;
    Y21 := FALSE;
END_IF

(* Once transfer is confirmed, set completion flag *)
IF transfer_complete AND X20 THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
END_IF

(* Maintain completion *)
IF Y2 THEN
    IF NOT receiver_ownership THEN
        receiver_ownership := X25;
    END_IF
END_IF

END_PROGRAM