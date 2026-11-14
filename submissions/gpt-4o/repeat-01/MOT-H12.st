```iec
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
    request_in_progress : BOOL := FALSE;
    cancel_request : BOOL := FALSE;
    complete_request : BOOL := FALSE;
    allowable_move : BOOL := FALSE;
    move_complete : BOOL := FALSE;
    retract_to_initial : BOOL := FALSE;
    safety_check_passed : BOOL := FALSE;
    timer_safety : TON;

END_VAR

// Read all inputs and determine actions for each request
IF NOT request_in_progress THEN
    // Check incoming requests
    IF NOT X31 THEN
        request_in_progress := TRUE;
        cancel_request := FALSE;
    ELSIF NOT X35 THEN
        request_in_progress := TRUE;
        cancel_request := FALSE;
    END_IF;
END_IF;

// Process cancellation requests
IF request_in_progress AND (cancel_request OR X31 OR X35) THEN
    // Return to original lift
    request_in_progress := FALSE;
    complete_request := FALSE;
    Y2 := FALSE;
    IF X31 THEN
        D301 := D100; // Return ID for cancellation
    ELSEIF X35 THEN
        D303 := D120; // Return ID for cancellation
    END_IF;
    D81 := 1; // or other logic-defined station
    D80 := 2; // Extraction command
END_IF;

// Process active requests
IF request_in_progress AND NOT cancel_request THEN
    // Ensure safety constraints are met
    IF D1000 > -4500 AND D1000 < 4500 AND // Within shuttle travel
       D1004 >= 0 AND D1004 <= 180 THEN // Fork position
        safety_check_passed := TRUE;
    ELSE
        safety_check_passed := FALSE;
    END_IF;
    
    IF safety_check_passed THEN
        // Simulate axis movement commands
        allowable_move := TRUE;
        D2000 := D403; // Set target for shared shuttle X
        D2001 := 1000; // Full speed
        Y40 := TRUE; // Enable drive
    END_IF;
END_IF;

// Check completion
IF X51 THEN
    IF safety_check_passed AND NOT move_complete THEN
        complete_request := TRUE;
        request_in_progress := FALSE;
        retract_to_initial := TRUE;
        
        // Reset all motions
        D2000 := 0; D2004 := 0; D2008 := 0;
        D2012 := 0; D2016 := 0; D2020 := 0;
        D2024 := 0; D2028 := 0; D2032 := 0;
        Y40 := FALSE; Y41 := FALSE; Y42 := FALSE;
        Y43 := FALSE; Y44 := FALSE; Y45 := FALSE;
        Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        
        D300 := D100; // Completion ID
        D301 := 1;    // Completion
        D302 := D120; // Completion ID
        D303 := 1;    // Completion
        
    ELSE
        complete_request := FALSE;
    END_IF;
END_IF;

// Manage Post-Claim Maintenance
IF complete_request THEN
    timer_safety(IN := TRUE, PT := T#100ms);
    IF timer_safety.Q THEN
        Y2 := TRUE; // Maintain completion signal for 100 ms
    END_IF;
END_IF;

END_PROGRAM
```