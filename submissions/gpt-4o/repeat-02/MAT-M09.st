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
    
    (* Internal variables *)
    start_edge : R_TRIG;
    offer_timer : TON;
    ready_timer : TON;
    release_timer : TON;
    state : INT := 0;
END_VAR

(* Implement the control logic here. *)

(* Detect Start Request *)
start_edge(CLK := X10);

(* State Machine for Material Transfer *)
CASE state OF
    0: (* Idle, waiting for start signal *)
        IF start_edge.Q THEN
            (* Verify the start request and initialize transfer *)
            IF D10 = 1 THEN
                state := 1;
                Y20 := TRUE; (* Start moving forward *)
            END_IF
        END_IF

    1: (* Moving to docking position *)
        IF X21 THEN (* Check if docked *)
            Y20 := FALSE; (* Stop moving forward *)
            Y23 := TRUE; (* Send offer signal *)
            state := 2;
            offer_timer(IN := TRUE, PT := T#3500ms); (* Arm for up to 3.5 seconds *)
        END_IF

    2: (* Offer signal is active, waiting for Ready *)
        IF X23 THEN
            Y23 := FALSE; (* Stop sending offer *)
            ready_timer(IN := TRUE, PT := T#650ms); (* Wait for receiver clamping up to 0.65 seconds *)
            IF ready_timer.Q THEN
                Y22 := TRUE; (* Release sender grip *)
                state := 3;
                release_timer(IN := TRUE, PT := T#300ms); (* Delay for sender grip to fully release *)
            END_IF
        END_IF
        
    3: (* Wait for successful transfer confirmation *)
        IF release_timer.Q THEN
            IF X25 AND X20 THEN
                Y22 := FALSE; (* Keep release command *)
                Y2 := TRUE;  (* Signal completion *)
                state := 4; (* Transition to completion state *)
            END_IF
        END_IF

    4: (* Completed, maintaining result *)
        (* Maintain Y2 and all outputs for the remainder of the evaluation. *)
        (* Scanner does not perform further actions as all conditions are satisfied. *)
        
ELSE
    (* Default handler for unexpected cases: Reset to idle state *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    state := 0;
END_CASE

(* Reset conditions when Offer is withdrawn *)
IF NOT X10 THEN
    IF NOT X21 THEN
        Y23 := FALSE;
        offer_timer(IN := FALSE);
        ready_timer(IN := FALSE);
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        IF NOT X23 THEN
            state := 0;
            Y2 := FALSE;
        END_IF
    END_IF
END_IF

END_PROGRAM