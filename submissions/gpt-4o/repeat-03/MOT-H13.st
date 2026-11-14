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
    current_request_id : DINT;
    axis_rate_floor : REAL := 0.02; // Minimum drive fraction
    est_time_since_sync_est : TIME;
    time_since_final_completion : TIME;
    synchronization_established : BOOL := FALSE;
    synchronization_timer : TON;
    completion_timer : TON;
    request_active : BOOL;
    request_cancellation_detected : BOOL;
    sync_within_error_tolerance : BOOL;
    synchronize_axes : BOOL;
    observe_completion : BOOL;

END_VAR

// Initialize function block instances
synchronization_timer(IN := FALSE, PT := T#50ms);
completion_timer(IN := FALSE, PT := T#100ms);

// Initialize logic for handling requests
// Identify whether there are active requests
request_active := (X30 AND NOT X31) OR (X34 AND NOT X35);

// Detect if request cancellation is detected
request_cancellation_detected := (X31 OR X35);

// Determine whether synchronization should be conducted
synchronize_axes := request_active AND NOT request_cancellation_detected;

// Check if electronic gear synchronization should be established
IF synchronize_axes THEN
    IF NOT synchronization_established THEN
        // Check angle and speed error conditions
        sync_within_error_tolerance := 
            (ABS(D1017 - D1029) <= 100) AND  // Speed error < 1 deg/s
            (ABS(D1016 - D1028) <= 20);      // Position error < 0.2 deg

        IF sync_within_error_tolerance THEN
            synchronization_timer(IN := TRUE);
        ELSE
            synchronization_timer(IN := FALSE);
        END_IF

        // Process synchronization establishment
        IF synchronization_timer.Q THEN
            synchronization_established := TRUE;
        END_IF

    ELSE
        // Maintain synchronization if already established
        sync_within_error_tolerance := 
            (ABS(D1016 - D1028) <= 60); // Position error < 0.6 degrees

        IF NOT sync_within_error_tolerance THEN
            // Reset if error tolerance is breached
            synchronization_established := FALSE;
            synchronization_timer(IN := FALSE);
        END_IF

    END_IF
ELSE
    synchronization_established := FALSE;
    synchronization_timer(IN := FALSE);
END_IF

// Control logic when synchronization is established
IF synchronization_established THEN
    // Control axes movement with maintained synchronization
    D700 := 0; // Use placeholder selector
    D701 := D625; // Set route to captured route
    D702 := 200; // Set acceleration consistent with request
    Y71 := TRUE; // Enable configuration
    Y70 := TRUE; // Retain configuration
ELSE
    Y71 := FALSE;
    Y70 := FALSE;
END_IF

// Handle completion detection
IF X51 THEN
    observe_completion := TRUE;
    completion_timer(IN := TRUE);
ELSE
    observe_completion := FALSE;
    completion_timer(IN := FALSE);
END_IF

// Completion output after observing required duration
IF completion_timer.Q THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF

END_PROGRAM