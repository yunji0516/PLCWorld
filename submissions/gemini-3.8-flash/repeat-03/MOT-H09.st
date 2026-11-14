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

    step : INT := 0;
    active_ch : INT := -1;
    curr_req_id : DINT := 0;
    curr_station : DINT := 1;
    curr_pocket : INT := 1;
    is_cancel : BOOL := FALSE;
    seq_counter : DINT := 10;
    settle_cnt : INT := 0;
    comp_cnt : INT := 0;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    saved_m3_goal : DINT := 0;
    saved_m4_deg : DINT := 0;
    saved_m4_slide : DINT := 70000;
END_VAR

// Set default continuous rate and enable outputs
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

// State Machine
CASE step OF
    0: // Idle / Arbitrate Request
        D80 := 0;
        D81 := 0;
        Y70 := FALSE;
        Y71 := FALSE;
        Y75 := FALSE;
        Y76 := FALSE;
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        D2016 := 0;
        D2020 := 0;
        D2024 := 0;
        D2028 := 0;
        D2032 := 5000;

        IF D100 > 0 AND NOT r0_done AND D300 = 0 THEN
            active_ch := 0;
            curr_req_id := D100;
            curr_station := 1;
            curr_pocket := 1;
            is_cancel := X31;
            settle_cnt := 0;
            step := 10;
        ELSIF D120 > 0 AND NOT r1_done AND D302 = 0 THEN
            active_ch := 1;
            curr_req_id := D120;
            curr_station := 2;
            curr_pocket := 2;
            is_cancel := X35;
            settle_cnt := 0;
            step := 10;
        END_IF;

    10: // Align Lift and Shuttle to Pick Up from Lift
        IF curr_station = 1 THEN
            D2008 := D92; // Lift A to docking height
            D2000 := D403; // Shuttle to station 1
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND
               ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    seq_counter := seq_counter + 1;
                    D82 := seq_counter;
                    D80 := 1; // Extract
                    D81 := 1; // Lift A
                    step := 20;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            D2012 := D92; // Lift B to docking height
            D2000 := D406; // Shuttle to station 2
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 AND
               ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    seq_counter := seq_counter + 1;
                    D82 := seq_counter;
                    D80 := 1; // Extract
                    D81 := 2; // Lift B
                    step := 20;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        END_IF;

    20: // Fork Engage (180 mm) at Lift
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 25;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    25: // Fork Retract (0 mm) with Fixture
        D2004 := 0;
        // Also command lift back to home (150 mm)
        IF curr_station = 1 THEN
            D2008 := 15000;
        ELSE
            D2012 := 15000;
        END_IF;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D90 = curr_req_id THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                D80 := 0;
                D81 := 0;
                IF is_cancel THEN
                    step := 80; // Skip cells and return
                ELSE
                    step := 30; // Proceed to Cell 3
                END_IF;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    30: // Shuttle to Cell 3
        D2000 := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                D80 := 2; // Placement
                D81 := 3; // Cell 3
                step := 35;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    35: // Fork Connect (180 mm) into Cell 3
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 40;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    40: // Pocket Approach Axis Extend in Cell 3
        D700 := INT_TO_DINT(curr_pocket);
        Y70 := TRUE;
        Y71 := TRUE;
        IF curr_pocket = 1 THEN
            saved_m3_goal := D501;
            IF saved_m3_goal <= 0 THEN
                saved_m3_goal := 50000;
            END_IF;
            D2020 := saved_m3_goal;
        ELSIF curr_pocket = 2 THEN
            saved_m3_goal := D502;
            IF saved_m3_goal <= 0 THEN
                saved_m3_goal := 50000;
            END_IF;
            D2024 := saved_m3_goal;
        ELSE
            saved_m3_goal := D500;
            IF saved_m3_goal <= 0 THEN
                saved_m3_goal := 50000;
            END_IF;
            D2016 := saved_m3_goal;
        END_IF;

        IF X70 THEN
            step := 45;
        ELSIF curr_pocket = 1 AND ABS(D1020 - saved_m3_goal) <= 20 AND ABS(D1021) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 5 THEN
                settle_cnt := 0;
                step := 45;
            END_IF;
        ELSIF curr_pocket = 2 AND ABS(D1024 - saved_m3_goal) <= 20 AND ABS(D1025) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 5 THEN
                settle_cnt := 0;
                step := 45;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    45: // Retract Pocket Axis in Cell 3 to Home
        D2016 := 0;
        D2020 := 0;
        D2024 := 0;
        IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND
           ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND ABS(D1025) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                Y70 := FALSE;
                Y71 := FALSE;
                step := 50;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    50: // Fork Retract (0 mm) from Cell 3
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                D80 := 0;
                D81 := 0;
                step := 55;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    55: // Shuttle to Cell 4
        D2000 := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                D80 := 2; // Placement
                D81 := 4; // Cell 4
                step := 60;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    60: // Fork Connect (180 mm) into Cell 4
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 65;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    65: // Rotate Cell 4 Table at Slide <= 50 mm (s4_1 = 50 mm)
        Y75 := TRUE;
        Y76 := TRUE;
        D710 := 1;
        saved_m4_deg := D600;
        IF saved_m4_deg <= 0 THEN
            saved_m4_deg := 9000; // Default 90 deg
        END_IF;
        D2028 := saved_m4_deg;
        D2032 := 5000; // slide <= 50 mm

        IF ABS(D1028 - saved_m4_deg) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032 - 5000) <= 20 AND ABS(D1033) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 70;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    70: // Precision Slide Approach to 700 mm
        D2032 := 70000;
        IF X75 THEN
            step := 73;
        ELSIF ABS(D1032 - 70000) <= 20 AND ABS(D1033) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 5 THEN
                settle_cnt := 0;
                step := 73;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    73: // Cell 4 Return to Initial Connection Posture (deg 0, slide 50 mm)
        D2032 := 5000;
        IF ABS(D1032 - 5000) <= 20 AND ABS(D1033) <= 100 THEN
            D2028 := 0;
            IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    Y75 := FALSE;
                    Y76 := FALSE;
                    step := 75;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    75: // Fork Retract (0 mm) from Cell 4
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                D80 := 0;
                D81 := 0;
                step := 80;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    80: // Shuttle Return to Original Lift Section
        IF curr_station = 1 THEN
            D2000 := D403;
            D2008 := D92;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND X61 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    seq_counter := seq_counter + 1;
                    D82 := seq_counter;
                    D80 := 2; // Placement
                    D81 := 1;
                    step := 85;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            D2000 := D406;
            D2012 := D92;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 AND X62 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    seq_counter := seq_counter + 1;
                    D82 := seq_counter;
                    D80 := 2; // Placement
                    D81 := 2;
                    step := 85;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        END_IF;

    85: // Fork Extend (180 mm) to Return Fixture to Lift
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 90;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    90: // Fork Retract (0 mm) Leaving Fixture on Lift
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                D80 := 0;
                D81 := 0;
                step := 95;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    95: // Lift Descend to Initial Height (150 mm)
        IF curr_station = 1 THEN
            D2008 := 15000;
            IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 100;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            D2012 := 15000;
            IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 100;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        END_IF;

    100: // Acknowledge Request Completion / Cancellation
        IF active_ch = 0 THEN
            D300 := curr_req_id;
            IF is_cancel THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            r0_done := TRUE;
        ELSE
            D302 := curr_req_id;
            IF is_cancel THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            r1_done := TRUE;
        END_IF;
        step := 0;
END_CASE;

// Check Overall Completion Condition
IF X51 AND (r0_done OR D100 = 0) AND (r1_done OR D120 = 0) AND step = 0 THEN
    IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
       ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
       ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
       ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
       ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
       ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
       ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
       ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
       ABS(D1032 - 5000) <= 20 AND ABS(D1033) <= 100 THEN
        comp_cnt := comp_cnt + 1;
        IF comp_cnt >= 5 THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        comp_cnt := 0;
    END_IF;
ELSE
    comp_cnt := 0;
END_IF;

END_PROGRAM