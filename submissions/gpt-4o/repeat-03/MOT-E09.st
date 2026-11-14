PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    
    // Internal variables
    request_accepted : BOOL := FALSE;
    wrist_target : DINT;
    wrist_feedforward : DINT;
    tool_orientation_error : REAL;
    stability_timer : TON;
    post_claim_timer : TON;
    stability_met : BOOL := FALSE;
END_VAR

// Initialize timers
stability_timer(IN := FALSE, PT := T#30MS);
post_claim_timer(IN := FALSE, PT := T#1300MS);

(* Implement the control logic here. *)
IF X10 THEN
    request_accepted := TRUE;
END_IF

IF request_accepted THEN
    // Calculate the tool orientation error
    tool_orientation_error := REAL(D13 + D15 + D11) * 0.01; // Convert from x0.01 to degrees

    // Calculate wrist target and feedforward values to maintain orientation
    wrist_target := D-INT((tool_orientation_error) - (D13 + D15)) * 100;
    wrist_feedforward := -(D14 + D16);

    // Limit wrist command within permitted bounds
    wrist_target := LIMIT(-200000, 200000, wrist_target);
    wrist_feedforward := LIMIT(-200000, 200000, wrist_feedforward);

    // Command wrist position and velocity
    D20 := wrist_target;
    D21 := wrist_feedforward;

    // Enable function
    Y20 := TRUE;
    
    // Check if the tool orientation is within the acceptable range
    IF ABS(tool_orientation_error) <= 2.0 THEN
        IF NOT stability_met THEN
            stability_timer(IN := TRUE);
            IF stability_timer.Q THEN
                stability_met := TRUE;
                post_claim_timer(IN := TRUE);
            END_IF
        ELSE
            stability_timer(IN := FALSE);
        END_IF
    ELSE
        stability_met := FALSE;
        stability_timer(IN := FALSE);
        post_claim_timer(IN := FALSE);
    END_IF
END_IF

// Set Y2 based on post claim observation
IF stability_met AND post_claim_timer.Q THEN
    Y2 := TRUE;
END_IF

END_PROGRAM