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

    // Internal Variables
    reference_changed : BOOL := FALSE;
    current_reference : DINT := 0;
    last_reference_epoch : DINT := 0;
    capture_position : DINT;
    capture_epoch : DINT;

    timer : TON;
    has_timer_started : BOOL := FALSE;
    post_maintenance : BOOL := FALSE;

END_VAR

// Control logic implementation

// Monitor for changes in the common reference
IF D91 <> last_reference_epoch THEN
    reference_changed := TRUE;
    last_reference_epoch := D91;
ELSE
    reference_changed := FALSE;
END_IF;

// Process the position setting requests based on the current reference
IF reference_changed THEN
    // Stop and capture the new position
    capture_position := D1024 + 250; // New value + 250 mm

    // Set targets for the return to initial posture
    D2000 := D403; 
    D2008 := D92;  // Return lift A to original height
    D2012 := D92;  // Return lift B to original height

    // Update outputs to reflect stopping
    Y40 := FALSE;
    Y41 := FALSE;
    Y42 := FALSE;
    Y43 := FALSE;

    // Configure the appropriate cell
    IF (D520 = 0) THEN
        D2016 := capture_position;  // Update cell 3 axis 0 target
        D2020 := capture_position;  // Update cell 3 axis 1 target
        // Activate cell 3 axes
        Y44 := TRUE;
        Y45 := TRUE;
        // Update cell 3 configure
        Y70 := TRUE;
    ELSE
        D2024 := capture_position;  // Update cell 4 axis 0 target
        D2028 := capture_position;  // Update cell 4 axis 1 target
        // Activate cell 4 axes
        Y46 := TRUE;
        Y47 := TRUE;
        // Update cell 4 configure
        Y75 := TRUE;
    END_IF;

    // Reset reference changed flag
    reference_changed := FALSE;
    
    // Store the capture epoch
    capture_epoch := D91;
END_IF;

// Timer logic to ensure 100ms maintenance after completion
IF X51 AND NOT has_timer_started THEN
    timer(IN := TRUE, PT := T#100ms);
    has_timer_started := TRUE;
ELSE
    timer(IN := FALSE);
END_IF;

IF timer.Q THEN
    post_maintenance := TRUE;
END_IF;

// Completion condition logic
IF post_maintenance THEN
    Y2 := TRUE;
    // Reset for next sequence
    has_timer_started := FALSE;
    post_maintenance := FALSE;
END_IF;

END_PROGRAM