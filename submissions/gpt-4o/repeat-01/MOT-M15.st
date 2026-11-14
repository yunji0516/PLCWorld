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

    side_selected : BOOL := FALSE;
    upper_tool_approach_started : BOOL := FALSE;
    retract_complete : BOOL := FALSE;

    side_target_A : DINT;
    side_target_B : DINT;
    C_target : DINT;
    D_target : DINT;
    side_criteria_met : BOOL := FALSE;
    C_position_valid : BOOL := FALSE;
    D_position_valid : BOOL := FALSE;

    start_edge : R_TRIG;

    C_start_position : DINT;
    D_start_position : DINT;
    
    approach_timer : TON;
    completion_timer : TON;
    total_time_elapsed : TIME := T#0ms;
    
    initial_setup_done : BOOL := FALSE;
END_VAR

// Edge detection for start input
start_edge(CLK := X0);

// Set target based on side selection
IF start_edge.Q THEN
    IF D101 = 100 THEN // Side 1
        side_criteria_met := (ABS(D10 - 6000) <= 200) AND (ABS(D12 - 0) <= 200);
        side_target_A := 6000;
        side_target_B := 0;
    ELSIF D101 = 200 THEN // Side 2
        side_criteria_met := (ABS(D10 - 0) <= 200) AND (ABS(D12 - 6000) <= 200);
        side_target_A := 0;
        side_target_B := 6000;
    ELSE
        side_criteria_met := FALSE;
    END_IF;

    // Setup initial conditions for targets and enable axes
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := TRUE;
    
    IF NOT initial_setup_done THEN
        C_start_position := D14;
        D_start_position := D16;
        initial_setup_done := TRUE;
    END_IF;
    
    D20 := side_target_A * 100; // Set A target
    D24 := side_target_B * 100; // Set B target
    D28 := D102; // Set C target as request_target
    D32 := D103; // Set D target as request_stroke

    D21 := 1000; // Full speed
    D25 := 1000; // Full speed
    D29 := 1000; // Full speed
    D33 := 1000; // Full speed
    
    // Check if at the requested side and targets 
    IF side_criteria_met AND (D14 > C_start_position + 1000) THEN
        C_position_valid := ABS(D14 - D28) <= 200 AND ABS(D15) <= 100;
    ELSE
        C_position_valid := FALSE;
    END_IF;
    
    // Start upper tool approach
    IF C_position_valid AND NOT upper_tool_approach_started THEN
        C_position_valid := FALSE; // Reset until restart
        upper_tool_approach_started := TRUE;
        approach_timer(IN := TRUE, PT := T#10s);
    END_IF;
END_IF;

// During upper tool approach
IF upper_tool_approach_started THEN
    D_position_valid := ABS(D16 - D32) <= 200 AND ABS(D17) <= 100;
    
    // Retracting upper tool
    IF D_position_valid THEN
        Y23 := FALSE; // Disable D while retract
        D32 := D_start_position; // Retract
        total_time_elapsed := total_time_elapsed + T#10ms; // Time accumulation
        
        IF D16 = D_start_position THEN
            retract_complete := TRUE;
        END_IF;
    ELSE
        retract_complete := FALSE;
    END_IF;
    
    // Once retraction is complete and time allows, complete the process
    IF retract_complete THEN
        completion_timer(IN := TRUE, PT := T#100ms);
        
        IF completion_timer.Q THEN
            Y2 := TRUE;
            // Reset all references, disabling axes
            D20 := 0;
            D24 := 0;
            D28 := C_start_position; // Retract C
            D32 := D_start_position; // Reset D
        
            D21 := 0;
            D25 := 0;
            D29 := 0;
            D33 := 0;
        
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
        
            upper_tool_approach_started := FALSE;
            retract_complete := FALSE;
            initial_setup_done := FALSE; 
        
            side_criteria_met := FALSE;
            approach_timer(IN := FALSE);
            completion_timer(IN := FALSE);
            total_time_elapsed := T#0ms;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM