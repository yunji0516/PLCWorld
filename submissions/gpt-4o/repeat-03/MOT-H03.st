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
    D502 : DINT;
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
    state : INT := 0;
    new_sequence : DINT;
    sync_timer : TON;
    sync_error_position : BOOL;
    sync_error_speed : BOOL;
    master_speed : DINT;
    relative_position : DINT;
    relative_speed : DINT;
    progress_done : BOOL;
END_VAR

// Initialization
IF state = 0 THEN
    new_sequence := 1; // Initialize sequence number
    sync_timer(IN := FALSE); // Reset sync timer
    state := 1;
END_IF

// Main sequence control logic
CASE state OF
    1: // Prepare for first request
        IF NOT X31 AND NOT X30 THEN
            // Setup for lift A
            D2008 := D1004; // Set lift A to current fork position
            D2009 := 1000; // Enable lift A
            Y42 := TRUE;
            state := 2;
        END_IF

    2: // Move to connection point
        IF D1008 = D100 AND D101 = 1 THEN
            Y42 := FALSE; // Disable lift A
            D2000 := D403; // Move shuttle X
            D2001 := 850; // Set drive ratio
            Y40 := TRUE;
            state := 3;
        END_IF

    3: // Insert connection fork
        IF (ABS(D1000 - D403) <= 2) AND (ABS(D1001) <= 10) THEN
            D2004 := D406 + 150; // Target position for connection fork
            D2005 := 700;
            Y41 := TRUE;
            state := 4;
        END_IF

    4: // Synchronize and connect
        IF X62 THEN
            Y41 := FALSE;
            state := 5;
        END_IF

    5: // Connection sequence done
        IF NOT X72 THEN
            Y70 := FALSE; // disable configuration
            state := 6; // Prepare for second request
        END_IF

    6: // Move shuttle back and complete action
        D2000 := D401; // Back to starting position
        D2001 := 850; // Drive ratio
        Y40 := TRUE;
        
        IF (ABS(D1000 - D401) <= 2) THEN
            D82 := new_sequence; // Update sequence number
            D300 := D104; // Set completion ID
            D301 := 1;
            state := 7;
        END_IF
        
    7: // Wait for completion and return
        IF X51 THEN
            D2000 := 0; // Reset shuttle
            D2001 := 0;
            Y40 := FALSE;
            sync_timer(IN := TRUE, PT := T#50ms);
            IF sync_timer.Q THEN
                Y2 := TRUE;
                state := 0; // Reset and wait for new requests
            END_IF
        END_IF
END_CASE

END_PROGRAM