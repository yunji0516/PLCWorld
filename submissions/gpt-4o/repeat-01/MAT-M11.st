PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;
    start_trigger : R_TRIG;
    state : INT := 0;
END_VAR

(* Implement the control logic here. *)

start_trigger(CLK := X10);

IF start_trigger.Q THEN
    state := 1; (* Move to initialization state. *)
END_IF

CASE state OF
    0: 
        (* Idle state, waiting for start request. *)

    1: (* Initialization after start trigger. *)
        IF X23 THEN  (* Ensure slide is home before starting. *)
            Y22 := TRUE; (* Open the receiver. *)
            Y20 := TRUE; (* Activate left vacuum. *)
            Y21 := TRUE; (* Activate right vacuum. *)
            IF X20 AND X21 THEN
                state := 2; (* Move to next state when both vacuums are held. *)
            END_IF
        END_IF

    2: (* Open receiver and prepare for insertion. *)
        IF X22 AND D20 >= 160 THEN (* Ensure receiver is open. *)
            Y24 := TRUE; (* Start inserting content. *)
            Y22 := FALSE; (* Stop the open command to preserve state. *)
            IF X24 THEN (* When insertion reaches end. *)
                Y24 := FALSE; 
                Y25 := TRUE; (* Start retracting tool. *)
                IF X25 THEN (* When content is seated. *)
                    Y20 := FALSE; (* Release left vacuum. *)
                    Y21 := FALSE; (* Release right vacuum. *)
                    state := 3; (* Move to completion check state. *)
                END_IF
            END_IF
        END_IF

    3: (* Completion state verification. *)
        IF X22 AND X23 AND NOT X24 AND X25 AND X26 THEN
            Y2 := TRUE; (* Completion claim. *)
        END_IF

    ELSE
        (* Default action for unexpected states. Safety first. *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
END_CASE

END_PROGRAM