PROGRAM Main
VAR
    D1000 : DINT;
    D1001 : DINT;
    D1004 : DINT;
    D1005 : DINT;
    D1008 : DINT;
    D1009 : DINT;
    D1012 : DINT;
    D1013 : DINT;
    D1016 : DINT;
    D1017 : DINT;
    D1020 : DINT;
    D1021 : DINT;
    D1024 : DINT;
    D1025 : DINT;
    D1028 : DINT;
    D1029 : DINT;
    D1032 : DINT;
    D1033 : DINT;
    D100 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    X30 : BOOL;
    X31 : BOOL;
    D120 : DINT;
    D121 : DINT;
    D122 : DINT;
    D123 : DINT;
    D124 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    D403 : DINT;
    D404 : DINT;
    X61 : BOOL;
    D406 : DINT;
    D407 : DINT;
    X62 : BOOL;
    D409 : DINT;
    D410 : DINT;
    X63 : BOOL;
    D412 : DINT;
    D413 : DINT;
    X64 : BOOL;
    D500 : DINT;
    D501 : DINT;
    D520 : DINT;
    D521 : DINT;
    D522 : DINT;
    D523 : DINT;
    D524 : DINT;
    D525 : DINT;
    D526 : DINT;
    D527 : DINT;
    X70 : BOOL;
    X71 : BOOL;
    X72 : BOOL;
    D600 : DINT;
    D601 : DINT;
    D602 : DINT;
    D620 : DINT;
    D621 : DINT;
    D622 : DINT;
    D623 : DINT;
    D624 : DINT;
    D625 : DINT;
    D626 : DINT;
    D627 : DINT;
    X75 : BOOL;
    X76 : BOOL;
    X77 : BOOL;
    D2000 : DINT;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL;
    D2004 : DINT;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL;
    D2008 : DINT;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL;
    D2012 : DINT;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL;
    D2016 : DINT;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL;
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
    D2024 : DINT;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL;
    D2028 : DINT;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL;
    D2032 : DINT;
    D2033 : DINT;
    D2034 : DINT;
    Y48 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    Y70 : BOOL;
    Y71 : BOOL;
    D700 : DINT;
    D701 : DINT;
    D702 : DINT;
    Y75 : BOOL;
    Y76 : BOOL;
    D710 : DINT;
    D711 : DINT;
    D712 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y30 : BOOL;
    Y2 : BOOL;

    current_state : INT := 0; // State machine variable
    request_completed : BOOL := FALSE; // Flag to indicate request completion
    shared_shuttle_ready : BOOL := FALSE; // Flag to indicate if the shared shuttle is ready
    lift_ready_A : BOOL := FALSE;
    lift_ready_B : BOOL := FALSE;
    
    elapsed_time : TIME := T#0ms; // Timer for state transitions
    timer : TON; // Timer instance for tracking completion conditions
    
    s3_balance_moment : REAL := 0.0; // Moment calculation for balance
END_VAR

// State definitions
CONST
    STATE_IDLE : INT := 0;
    STATE_PREPARE_MOVE : INT := 1;
    STATE_PERFORM_MOVE : INT := 2;
    STATE_RELEASE_BRAKE : INT := 3;
    STATE_VERIFY_POSITION : INT := 4;
    STATE_COMPLETE : INT := 5;
END_CONST

// State machine logic
CASE current_state OF
    STATE_IDLE:
        // Check if any new requests are pending
        IF (NOT request_completed) THEN
            // Verify if the shared shuttle and lifts are ready
            shared_shuttle_ready := X63;
            lift_ready_A := (ABS(D1009) <= 10) AND (ABS(D1013) <= 10);
            
            IF shared_shuttle_ready AND lift_ready_A THEN
                current_state := STATE_PREPARE_MOVE;
            END_IF
        END_IF
        
    STATE_PREPARE_MOVE:
        // Set targets for shared shuttle and lifts
        D2000 := D90; // Use holding shuttle fixture request ID for target
        D2008 := D500; // Target for lift A
        D2012 := D600; // Target for lift B
        
        // Enable the axes
        Y40 := TRUE; // Shared shuttle
        Y42 := TRUE; // Lift A
        Y43 := TRUE; // Lift B
        
        current_state := STATE_PERFORM_MOVE;
        
    STATE_PERFORM_MOVE:
        // Check if axes have reached their targets
        IF (ABS(D1000 - D2000) <= 2) AND (ABS(D1004 - D2004) <= 2) AND
           (ABS(D1008 - D2008) <= 2) AND (ABS(D1012 - D2012) <= 2) THEN
            current_state := STATE_RELEASE_BRAKE;
        END_IF

    STATE_RELEASE_BRAKE:
        // Check if common brake can be released
        IF NOT X52 THEN
            Y30 := TRUE; // Engage common brake
            current_state := STATE_VERIFY_POSITION;
        END_IF
        
    STATE_VERIFY_POSITION:
        // Verify position conditions for balance and sway
        s3_balance_moment := (20.0 * 9.81 / 1000) * (450.0 * SIN(D1016 * 0.01) + D1020);

        IF (ABS(s3_balance_moment) <= 1.0) THEN
            current_state := STATE_COMPLETE;
        END_IF
        
    STATE_COMPLETE:
        // Completion condition: Verify Y2 holding for 100 ms
        timer(IN := TRUE, PT := T#100ms);
        
        IF timer.Q THEN
            request_completed := TRUE;
            Y2 := TRUE; // Set completion output
            current_state := STATE_IDLE; // Return to IDLE for next request
        END_IF
        
ELSE
    // Default handling for undefined states
    current_state := STATE_IDLE;
END_CASE

END_PROGRAM