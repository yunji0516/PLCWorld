PROGRAM Main
VAR
    D1000, D1001, D1004, D1005, D1008, D1009, D1012, D1013: DINT;
    D1016, D1017, D1020, D1021, D1024, D1025, D1028, D1029: DINT;
    D1032, D1033, D100, D101, D102, D103, D104: DINT;
    D120, D121, D122, D123, D124: DINT;
    D90, D91, D92, D403, D404: DINT;
    D406, D407, D409, D410, D412, D413: DINT;
    D500, D501, D502, D520, D521, D522, D523: DINT;
    D524, D525, D526, D527, D600, D601, D620: DINT;
    D621, D622, D623, D624, D625, D626, D627: DINT;

    D2000, D2001, D2002, D2004, D2005, D2006, D2008: DINT;
    D2009, D2010, D2012, D2013, D2014, D2016, D2017: DINT;
    D2018, D2020, D2021, D2022, D2024, D2025, D2026: DINT;
    D2028, D2029, D2030, D2032, D2033, D2034, D300: DINT;
    D301, D302, D303, D700, D701, D702, D710, D711, D712: DINT;

    D80, D81, D82: DINT;

    X30, X31, X34, X35, X51, X61, X62, X63, X64: BOOL;
    X52, X53, X70, X71, X72, X75, X76, X77: BOOL;

    Y40, Y41, Y42, Y43, Y44, Y45, Y46, Y47, Y48: BOOL;
    Y70, Y71, Y75, Y76, Y30, Y2: BOOL;

    request_counter: INT := 0;
    request_id: ARRAY[0..1] OF DINT;
    current_target: DINT;
    target_reached: BOOL := FALSE;
    command_taken: BOOL := FALSE;

    edge_r0_returned : R_TRIG;
    edge_r1_returned : R_TRIG;

    completion_timer: TON;
    hold_complete: BOOL := FALSE;
END_VAR

// Initialize the edge detection
edge_r0_returned(CLK := X30);
edge_r1_returned(CLK := X34);

// Timer for maintaining Y2 completion signal
completion_timer(IN := hold_complete, PT := T#100ms);

// Handle request processing
IF edge_r0_returned.Q THEN
    request_counter := request_counter + 1;
    request_id[0] := D100;
ELSIF edge_r1_returned.Q THEN
    request_counter := request_counter + 1;
    request_id[1] := D120;
END_IF

// Control Logic for Axis Movement and Synchronization
// Set targets and enable outputs for movements
IF NOT command_taken THEN
    D2000 := 1000 * (1500 + request_counter * 1000);
    Y40 := TRUE;
    command_taken := TRUE;
END_IF

// Read the position and check if it reached target
IF D1000 = D2000 THEN
    target_reached := TRUE;
END_IF

// When target reached, proceed with other operations
IF target_reached THEN
    Y40 := FALSE;
    command_taken := FALSE;
    hold_complete := TRUE; // Completed task condition
END_IF

// Check for overall completion
IF completion_timer.Q THEN
    hold_complete := FALSE;
    completion_timer(IN := FALSE);
    Y2 := TRUE; // Assert completion signal for 100ms as required
ELSE
    Y2 := FALSE;
END_IF

END_PROGRAM