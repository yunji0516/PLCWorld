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
    // Internal variables
    request_in_progress : BOOL := FALSE;
    timer_settle : TON;
    timer_observe : TON;
    timer_completion : TON;
END_VAR

// Reset outputs and intermediate variables
Y40 := FALSE;
Y41 := FALSE;
Y42 := FALSE;
Y43 := FALSE;
Y44 := FALSE;
Y45 := FALSE;
Y46 := FALSE;
Y47 := FALSE;
Y48 := FALSE;
Y30 := FALSE;
Y2 := FALSE;
D300 := 0;
D301 := 0;
D302 := 0;
D303 := 0;

// If all requests are completed, engage completion
IF X51 THEN
    D300 := D100;
    D301 := 1; // Completion status
    D302 := D120;
    D303 := 1; // Completion status
    Y2 := TRUE;
    timer_completion(IN := NOT X51, PT := T#100ms);
    IF timer_completion.Q THEN
        request_in_progress := FALSE;
    END_IF;
ELSE
    // Logic for handling requests and movements here

    // Handle request 1
    IF NOT X31 AND r0_location = 1 AND NOT request_in_progress THEN
        // Move to the lift A location
        D2004 := -4050 * 100; // target position for shuttle
        D2005 := 850; // rate for movement
        Y41 := TRUE; // enable movement
        // Set lift A position
        D2008 := 10000; // Target height for lift A
        D2009 := 850; // Drive rate
        Y42 := TRUE;
        
        IF NOT X52 AND D2004 - D1000 < 20 THEN
            request_in_progress := TRUE;
        ELSE
            request_in_progress := FALSE;
        END_IF;
    END_IF;

    // Handle request 2
    IF NOT X35 AND r1_location = 2 AND NOT request_in_progress THEN
        // Move to the lift B location
        D2004 := -1850 * 100; // target position for shuttle
        D2005 := 850; // rate for movement
        Y41 := TRUE; // enable movement
        // Set lift B position
        D2012 := 10000; // Target height for lift B
        D2013 := 850; // Drive rate
        Y43 := TRUE;
        
        IF NOT X52 AND D2004 - D1000 < 20 THEN
            request_in_progress := TRUE;
        ELSE
            request_in_progress := FALSE;
        END_IF;
    END_IF;

    // Check brake conditions and request vibrations settling
    IF X52 AND NOT X53 THEN
        Y30 := TRUE; // Engage brake
    END_IF;

    // Settling vibration logic
    timer_settle(IN := (ABS(D1001) < 10 AND ABS(D1005) < 10 AND ABS(D1009) < 10 AND ABS(D1013) < 10 AND Y30), PT := T#30ms);
    IF timer_settle.Q THEN
        Y30 := FALSE; // Disengage brake
    END_IF;

    // Posture check for connection and set sequential operations if ready
    IF X61 AND X62 AND X63 AND X64 THEN
        D81 := 3; // Station ID for connection
        D82 := D91; // sequential ID
    END_IF;
    
END_IF;

END_PROGRAM