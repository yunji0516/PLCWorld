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
    (* Add internal variables here. *)
    start_edge : R_TRIG;
    push_timer : TON;
    retract_timer : TON;
    task_started : BOOL := FALSE;
    eject_complete : BOOL := FALSE;
    evaluation_window : INT := 0;
END_VAR

(* Implement the control logic here. *)

start_edge(CLK := X10);

// Start the task on the rising edge of the start request signal
IF start_edge.Q THEN
    task_started := TRUE;
    Y2 := FALSE;
    evaluation_window := 0;
END_IF

IF task_started THEN
    // Check if the pusher is not at the end position and initiate push
    IF NOT X21 AND NOT eject_complete THEN
        Y20 := TRUE;
        Y21 := FALSE;
    END_IF

    // Use a timer for the pushing
    push_timer(IN := Y20, PT := T#1s);
    IF push_timer.Q THEN
        // Complete the push action and start retraction
        Y20 := FALSE;
        Y21 := TRUE;
    END_IF

    // Use a timer for the retraction
    retract_timer(IN := Y21, PT := T#1s);
    IF retract_timer.Q THEN
        // Complete retraction action
        Y21 := FALSE;
        IF X20 THEN
            // Confirm pusher is home
            eject_complete := TRUE;
        END_IF
    END_IF

    // If product received and pusher is home
    IF eject_complete AND X22 AND X20 THEN
        Y2 := TRUE; // Completion claim
    END_IF

    // Increment evaluation window counter
    evaluation_window := evaluation_window + 1;

    // Check if the task evaluation window has reached its limit
    IF evaluation_window >= 1600 THEN
        task_started := FALSE;
    END_IF
ELSE
    // Ensure outputs are off initially or after task completion
    Y20 := FALSE;
    Y21 := FALSE;
END_IF

END_PROGRAM