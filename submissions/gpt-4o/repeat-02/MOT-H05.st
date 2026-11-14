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
    request_sequence : DINT := 0;
    is_completion_achieved : BOOL := FALSE;
    request_in_progress : BOOL := FALSE;
    request1_completed : BOOL := FALSE;
    request2_completed : BOOL := FALSE;
    move_to_initial_position : BOOL := FALSE;
    timer : TON;
    motion_state : DINT := 0;
END_VAR

// Control logic
IF NOT request_in_progress THEN
    // Initialize requests
    IF (NOT X31 AND NOT request1_completed) THEN
        request_in_progress := TRUE;
        request_sequence := D100;
        Y40 := TRUE;
        motion_state := 1;
    ELSIF (NOT X35 AND NOT request2_completed) THEN
        request_in_progress := TRUE;
        request_sequence := D120;
        Y41 := TRUE;
        motion_state := 1;
    END_IF;
ELSE
    // Execute movement logic
    CASE motion_state OF
        1: // Move to Cell 3
            D2000 := D500 + 2500; // Target position adjusted
            D2001 := 900;// Drive ratio
            D80 := 2; // Placement
            D81 := 1; // Targeting Cell 3
            IF D1000 >= D2000 - 2 AND D1000 <= D2000 + 2 THEN
                motion_state := 2; // Proceed to next state
            END_IF;
        
        2: // Process in Cell 3
            Y70 := TRUE; // Configure
            MOVE(D500, D700); // Set select from goal
            IF X70 THEN
                motion_state := 3; // Finished Cell 3
            END_IF;
        
        3: // Move to Cell 4
            D2000 := D600 + 4000; // Move to next cell
            IF D1000 >= D2000 - 2 AND D1000 <= D2000 + 2 THEN
                motion_state := 4; // Proceed to index operation
            END_IF;

        4: // Process in Cell 4
            Y75 := TRUE; // Configure
            MOVE(D600, D710); // Set select from goal
            IF X75 THEN
                motion_state := 5; // Finished Cell 4
            END_IF;
        
        5: // Align and return to lift
            IF NOT move_to_initial_position THEN
                D2000 := 0;
                move_to_initial_position := TRUE;
            ELSE
                IF D1000 <= 2 THEN
                    Y40 := FALSE;
                    Y41 := FALSE;
                    request1_completed := request_sequence = D100;
                    request2_completed := request_sequence = D120;
                    request_in_progress := FALSE;
                    move_to_initial_position := FALSE; 
                    Y2 := TRUE; // Completion
                    IF timer.Q THEN // Hold completion for 100ms
                        Y2 := FALSE;
                        is_completion_achieved := TRUE;
                    END_IF;
                END_IF;
            END_IF;
        
        ELSE
            // Unexpected state
            motion_state := 0;
    END_CASE;
END_IF;

IF X51 THEN
    // Mark all-done condition
    Y2 := FALSE;
    D300 := 0;
    D301 := 1;
    D302 := 0;
    D303 := 1;
END_IF;

timer(IN := Y2, PT := T#100ms);

END_PROGRAM