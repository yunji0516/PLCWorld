PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    side_criteria_met : BOOL := FALSE;
    c_target_reached : BOOL := FALSE;
    tool_positioned : BOOL := FALSE;
    d_retracted : BOOL := FALSE;
    start_time : DINT := 0;
    task_complete : BOOL := FALSE;
    edge_start : R_TRIG;
    timer : TON;
    
END_VAR

(* Evaluate Side Criteria *)
IF D101 = 1 THEN
    side_criteria_met := (D10 = 6000) AND (D12 = 0);
ELSIF D101 = 2 THEN
    side_criteria_met := (D10 = 0) AND (D12 = 6000);
END_IF

(* Start Process *)
edge_start(CLK := X0);
IF edge_start.Q THEN
    start_time := 0;  // Reset the timer
END_IF

timer(IN := NOT task_complete AND X0, PT := T#15000ms);
IF timer.Q THEN
    // Timeout condition
    Y2 := FALSE;
    task_complete := TRUE;
END_IF

(* Control Logic *)
IF X0 AND NOT task_complete THEN
    // Set targets
    D20 := 6000;  // A target
    D24 := 6000;  // B target for side criteria
    D28 := D102;  // C target
    D32 := D103;  // D target (stroke)
    
    // Set rates to maximum
    D21 := 1000;
    D25 := 1000;
    D29 := 1000;
    D33 := 1000;
    
    // Enable axes
    IF NOT Y20 AND side_criteria_met THEN
        Y20 := TRUE;
    END_IF
    IF NOT Y21 AND side_criteria_met THEN
        Y21 := TRUE;
    END_IF
    IF NOT Y22 AND (D14 > 1000) THEN
        Y22 := TRUE;
    END_IF
    IF NOT Y23 AND c_target_reached THEN
        Y23 := TRUE;
    END_IF
    
    // Check for completion of tasks
    c_target_reached := ABS(D14 - D102) <= 20 AND ABS(D15) <= 100;
    tool_positioned := ABS(D16 - D103) <= 20 AND ABS(D17) <= 100;
    d_retracted := D16 = 0;
    
    IF c_target_reached AND tool_positioned AND d_retracted THEN
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := TRUE;
        task_complete := TRUE;
        start_time := start_time + 1;
    END_IF
    
    // Maintain conditions during operation
    IF D16 > 3500 THEN
        IF NOT (c_target_reached AND side_criteria_met) THEN
            // Safety condition violated
            Y2 := FALSE;
            task_complete := TRUE;
        END_IF
    END_IF
ELSE
    // Reset outputs if X0 is not triggered
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D24 := 0;
    D28 := 0;
    D32 := 0;
    start_time := 0;
END_IF

(* Completion Condition *)
IF task_complete AND start_time > 10 THEN
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
    D24 := 0;
    D25 := 0;
    D28 := 0;
    D29 := 0;
    D32 := 0;
    D33 := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
END_IF

END_PROGRAM