PROGRAM Main
VAR
    // Input variables
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
    // Output variables
    D2000 : DINT;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL := FALSE;
    D2004 : DINT;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL := FALSE;
    D2008 : DINT;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL := FALSE;
    D2012 : DINT;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL := FALSE;
    D2016 : DINT;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL := FALSE;
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL := FALSE;
    D2024 : DINT;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL := FALSE;
    D2028 : DINT;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL := FALSE;
    D2032 : DINT;
    D2033 : DINT;
    D2034 : DINT;
    Y48 : BOOL := FALSE;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    Y70 : BOOL := FALSE;
    Y71 : BOOL := FALSE;
    D700 : DINT;
    D701 : DINT;
    D702 : DINT;
    Y75 : BOOL := FALSE;
    Y76 : BOOL := FALSE;
    D710 : DINT;
    D711 : DINT;
    D712 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y30 : BOOL := FALSE;
    Y2 : BOOL := FALSE;
    // Internal variables
    currentRequest : DINT;
    isCompleted : BOOL := FALSE;
    timer : TON;
    cycle_count : DINT := 0;
    maxCycles : DINT := 16000; // 320000ms at 20ms per cycle
END_VAR

// Initialize on first scan
IF cycle_count = 0 THEN
    currentRequest := D100; // Starting request
END_IF

// Main control logic
IF NOT isCompleted THEN
    // Process requests
    IF (currentRequest = D100 OR currentRequest = D120) AND (D103 <= D101 + D123) THEN
        // Connect and execute requests
        Y40 := TRUE; // Enable shuttle
        D2000 := D500 + 250; // Move shuttle to new request position
        D2001 := 900; // Set speed ratio
        IF ABS(D1000 - D2000) <= 20 THEN
            // Cell 3 processing
            Y44 := TRUE; // Enable Cell 3 axis s3_0
            D2016 := D500; // Target for s3_0
            D2017 := 900;
            IF ABS(D1016 - D2016) <= 20 THEN
                // Cell 4 processing
                Y46 := TRUE; // Enable Cell 4 axis s4_0
                D2024 := D600; // Target for s4_0
                D2025 := 900;
                IF ABS(D1024 - D2024) <= 20 THEN
                    // Complete process
                    Y71 := TRUE; // Retain position register values
                    IF X64 THEN // Ensure cell 4 is ready
                        // Return to original position
                        D2000 := 0; // Return shuttle
                        D2001 := 900;
                        IF ABS(D1000 - 0) <= 20 THEN
                            Y2 := TRUE; // Completion signal
                            cycle_count := cycle_count + 1;
                        END_IF
                    END_IF
                END_IF
            END_IF
        END_IF
    END_IF
ELSE
    // Completion handling
    timer(IN := TRUE, PT := T#100ms);
    IF timer.Q THEN
        isCompleted := TRUE;
        // Reset outputs after 100ms
        Y2 := FALSE;
        Y40 := FALSE;
        Y44 := FALSE;
        Y46 := FALSE;
    END_IF
END_IF

// Tracking elapsed cycles
IF cycle_count >= maxCycles THEN
    isCompleted := TRUE; // Execution ends after maximum cycles are reached
END_IF

END_PROGRAM