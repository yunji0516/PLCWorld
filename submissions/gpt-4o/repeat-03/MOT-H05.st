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
    // Internal variables
    phase : INT;
    request_id0 : DINT;
    request_id1 : DINT;
    capture_done0, capture_done1 : BOOL;
    rotation_done0, rotation_done1 : BOOL;
    timer : TON;
    process_complete : BOOL;
END_VAR

// Initialize internal variables and process states
IF NOT process_complete THEN
    // Initialize states
    phase := 0;
    request_id0 := 0;
    request_id1 := 0;
    capture_done0 := FALSE;
    capture_done1 := FALSE;
    rotation_done0 := FALSE;
    rotation_done1 := FALSE;
    process_complete := FALSE;

    // Initialize outputs
    Y40 := FALSE;
    Y41 := FALSE;
    Y42 := FALSE;
    Y43 := FALSE;
    Y44 := FALSE;
    Y45 := FALSE;
    Y46 := FALSE;
    Y47 := FALSE;
    Y48 := FALSE;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
END_IF

// Main control logic
CASE phase OF
    0:
        // Monitor for request initiation
        IF D100 <> 0 THEN
            request_id0 := D100;
            phase := 1;
        ELSIF D120 <> 0 THEN
            request_id1 := D120;
            phase := 1;
        END_IF
    
    1:
        // Handle request initiation and progression
        IF request_id0 <> 0 AND NOT capture_done0 THEN
            Y70 := TRUE; // Configure register for request 0
            D700 := request_id0;
            D701 := D520; // Use current route
            D702 := 100; // Set acceleration
            capture_done0 := TRUE;
        ELSIF request_id1 <> 0 AND NOT capture_done1 THEN
            Y75 := TRUE; // Configure index for request 1
            D710 := request_id1;
            D711 := D620; // Use current route
            D712 := 100; // Set acceleration
            capture_done1 := TRUE;
        END_IF
        
        // Transition if both captures are done
        IF capture_done0 AND capture_done1 THEN
            phase := 2;
        END_IF
    
    2:
        // Handle rotation
        IF capture_done0 THEN
            D2024 := D600 + 4000; // Adjust s4_0 target by 40 mm from goal
            D2025 := 850; // Set drive ratio
            Y46 := TRUE; // Enable s4_0
            
            IF ABS(D1024 - D600 - 4000) < 20 THEN
                rotation_done0 := TRUE;
            END_IF
        END_IF
        
        IF capture_done1 THEN
            D2032 := D602 + 4000; // Adjust s4_2 target by 40 mm from goal
            D2033 := 850; // Set drive ratio
            Y48 := TRUE; // Enable s4_2

            IF ABS(D1032 - D602 - 4000) < 20 THEN
                rotation_done1 := TRUE;
            END_IF
        END_IF
            
        // Transition if both rotations are complete
        IF rotation_done0 AND rotation_done1 THEN
            phase := 3;
        END_IF

    3:
        // Return both to initial position
        D2000 := D92; // Set target to initial dock position for shuttle X
        D2001 := 850; // Drive ratio for shuttle X
        Y40 := TRUE; // Enable driving for shuttle X

        D2008 := D92; // Set target to initial position for lift A
        D2009 := 850; // Drive ratio for lift A
        Y42 := TRUE; // Enable driving for lift A
        
        D2012 := D92; // Set target to initial position for lift B
        D2013 := 850; // Drive ratio for lift B
        Y43 := TRUE; // Enable driving for lift B

        // Check completeness
        IF ABS(D1000 - D92) < 20 AND ABS(D1008 - D92) < 20 AND ABS(D1012 - D92) < 20 THEN
            phase := 4;
        END_IF
    
    4:
        // Check for completion status and maintain output for 100 ms
        IF NOT process_complete THEN
            if X51 AND X52 THEN
                Y2 := TRUE;
                timer(IN := TRUE, PT := T#100ms);
                process_complete := TRUE;
            END_IF
        ELSE
            if timer.Q THEN
                Y2 := FALSE;
                phase := 0; // Reset phase for next cycle
                process_complete := FALSE; // Reset process complete status
            END_IF
        END_IF
END_CASE

END_PROGRAM