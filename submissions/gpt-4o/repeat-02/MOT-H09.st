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

    current_request: INT := 0;
    occupied_pockets: ARRAY [0..1] OF BOOL := [FALSE, FALSE];
    timer: TON;
END_VAR

// Initialize
IF current_request = 0 THEN
    IF NOT X31 AND (r0_location = 1 OR r0_location = 2) AND NOT occupied_pockets[0] THEN
        current_request := 1;
        occupied_pockets[0] := TRUE;
    ELSIF NOT X35 AND (r1_location = 1 OR r1_location = 2) AND NOT occupied_pockets[1] THEN
        current_request := 2;
        occupied_pockets[1] := TRUE;
    END_IF
END_IF

// Control Logic
CASE current_request OF
    0:
        // No active request, do nothing
    1:
        // Handle request 1
        IF X30 THEN
            occupied_pockets[0] := FALSE;
            D300 := r0_id;
            D301 := 1;
            current_request := 0;
        ELSEIF X31 THEN
            occupied_pockets[0] := FALSE;
            D300 := r0_id;
            D301 := 2;
            current_request := 0;
        ELSE
            // Position shared shuttle based on r0_location
            D2000 := r0_location * 100;
            D2001 := 1000;
            Y40 := TRUE;
            // Handle other axes
            D2008 := 7325; // lift A to docking height
            D2009 := 1000;
            Y42 := TRUE;
            D2012 := 7325; // lift B to docking height
            D2013 := 1000;
            Y43 := TRUE;
            // Set completion signal if all actions finished
            IF X51 THEN
                timer(IN := TRUE, PT := T#100ms);
                IF timer.Q THEN
                    Y2 := TRUE;
                END_IF
            ELSE
                timer(IN := FALSE);
                Y2 := FALSE;
            END_IF
        END_IF
    2:
        // Handle request 2
        IF X34 THEN
            occupied_pockets[1] := FALSE;
            D302 := r1_id;
            D303 := 1;
            current_request := 0;
        ELSEIF X35 THEN
            occupied_pockets[1] := FALSE;
            D302 := r1_id;
            D303 := 2;
            current_request := 0;
        ELSE
            // Position shared shuttle based on r1_location
            D2000 := r1_location * 100;
            D2001 := 1000;
            Y40 := TRUE;
            // Handle other axes
            D2008 := 7325; // lift A to docking height
            D2009 := 1000;
            Y42 := TRUE;
            D2012 := 7325; // lift B to docking height
            D2013 := 1000;
            Y43 := TRUE;
            // Set completion signal if all actions finished
            IF X51 THEN
                timer(IN := TRUE, PT := T#100ms);
                IF timer.Q THEN
                    Y2 := TRUE;
                END_IF
            ELSE
                timer(IN := FALSE);
                Y2 := FALSE;
            END_IF
        END_IF
ELSE
    // Unknown request state
    current_request := 0;
END_CASE

END_PROGRAM