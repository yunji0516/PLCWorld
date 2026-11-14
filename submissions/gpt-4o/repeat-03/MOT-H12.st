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
    current_request : DINT;
    current_step : DINT := 0;
    timer : TON;
    request_complete : BOOL := FALSE;
END_VAR

// Main control logic
(* Process the current request in steps *)

CASE current_step OF
    0:
        // Check for complete request
        IF X51 THEN
            request_complete := TRUE;
        END_IF;
        // If any request cancelled, retrieve and return
        IF (X31 OR X35) THEN
            D300 := D100; // Acknowledge cancellation
            D301 := 2; // Status: cancellation retrieval
            D302 := D120;
            D303 := 2;
            current_step := 99;
        ELSE
            // Proceed request from original lift
            current_step := 1;
        END_IF;
    
    1:
        // Position the lifts A and B
        D2008 := -3600;
        D2012 := -2300;
        D2009 := 1000; // Enable lift A drive
        D2013 := 1000; // Enable lift B drive
        Y42 := TRUE;
        Y43 := TRUE;
        IF (D1012 <= -2300 AND D1008 <= -3600) THEN
            current_step := 2;
        END_IF;
    
    2:
        // Process in cell 3
        D2016 := 0; // Cross head
        D2020 := 0; // Cross head
        D2018 := 500; // Drive ratio
        Y44 := TRUE;
        Y45 := TRUE;
        IF (ABS(D1016) <= 2 AND ABS(D1020) <= 2) THEN
            current_step := 3;
        END_IF;

    3:
        // Process in cell 4
        D2024 := 3600; // Exchange head movement
        D2028 := 3600;
        D2032 := 50;
        D2026 := 500; // Drive ratio
        Y46 := TRUE;
        Y47 := TRUE;
        Y48 := TRUE;
        IF (ABS(D1024 - 3600) <= 2 AND ABS(D1028 - 3600) <= 2 AND ABS(D1032 - 50) <= 2) THEN
            current_step := 4;
        END_IF;

    4:
        // Return and descend lifts to the original positions
        D2008 := 0;
        D2012 := 0;
        D2009 := 1000;
        D2013 := 1000;
        IF (D1008 <= 2 AND D1012 <= 2) THEN
            current_step := 5;
        END_IF;

    5:
        // Confirm completion
        D300 := D100; // Acknowledge completion
        D301 := 1; // Status: completion
        D302 := D120;
        D303 := 1;
        Y2 := request_complete;
        timer(IN := Y2, PT := T#100ms);
        IF timer.Q THEN
            current_step := 99;
        END_IF;

    99:
        // End state
        Y40 := FALSE;
        Y41 := FALSE;
        Y42 := FALSE;
        Y43 := FALSE;
        Y44 := FALSE;
        Y45 := FALSE;
        Y46 := FALSE;
        Y47 := FALSE;
        Y48 := FALSE;
END_CASE;

END_PROGRAM