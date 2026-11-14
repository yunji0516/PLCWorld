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

    step : DINT := 0;
    seq_counter : DINT := 1;
    active_req : DINT := -1;
    active_req_id : DINT := 0;
    active_station : DINT := 1;
    is_cancelled : BOOL := FALSE;

    settle_count : DINT := 0;
    c3_settle_count : DINT := 0;
    c4_settle_count : DINT := 0;
    all_done_count : DINT := 0;

    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;

    target_dock_x : DINT := 0;
    theta_rad : REAL := 0.0;
    sin_theta : REAL := 0.0;
    bal_cw : REAL := 0.0;
END_VAR

// Enable all axis drives
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

// Default rates to maximum (1000 = 100%)
D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

// Speed feedforwards default to 0
D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;

// Common brake disengaged during normal operations
Y30 := FALSE;

// Main state machine
CASE step OF
    0: // IDLE - Check for incoming requests or completion
        D80 := 0;
        D81 := 0;
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := 100000;
        D2020 := 0;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        Y70 := FALSE;
        Y71 := FALSE;
        Y75 := FALSE;
        Y76 := FALSE;

        IF NOT r0_done AND D100 <> 0 THEN
            active_req := 0;
            active_req_id := D100;
            IF D101 = 2 THEN
                active_station := 2;
            ELSE
                active_station := 1;
            END_IF;
            is_cancelled := X31;
            step := 10;
        ELSIF NOT r1_done AND D120 <> 0 THEN
            active_req := 1;
            active_req_id := D120;
            IF D121 = 2 THEN
                active_station := 2;
            ELSE
                active_station := 1;
            END_IF;
            is_cancelled := X35;
            step := 10;
        ELSIF X51 OR (r0_done AND r1_done) THEN
            step := 900; // Go to completion check
        END_IF;

    // -------------------------------------------------------------
    // STEP 10: Lift docking - move source lift to docking height
    // -------------------------------------------------------------
    10:
        IF active_station = 1 THEN
            D2008 := 95000; // Lift A dock height (950 mm)
            D2012 := 40000;
            target_dock_x := D403;
            IF target_dock_x = 0 THEN target_dock_x := -405000; END_IF;
            IF ABS(D1008 - 95000) <= 20 AND ABS(D1009) <= 100 THEN
                step := 20;
            END_IF;
        ELSE
            D2008 := 40000;
            D2012 := 95000; // Lift B dock height (950 mm)
            target_dock_x := D406;
            IF target_dock_x = 0 THEN target_dock_x := -185000; END_IF;
            IF ABS(D1012 - 95000) <= 20 AND ABS(D1013) <= 100 THEN
                step := 20;
            END_IF;
        END_IF;

    // -------------------------------------------------------------
    // STEP 20: Shuttle move to Lift port
    // -------------------------------------------------------------
    20:
        D2000 := target_dock_x;
        D2004 := 0; // Fork retracted
        IF ABS(D1000 - target_dock_x) <= 20 AND ABS(D1001) <= 100 THEN
            settle_count := settle_count + 1;
            IF settle_count >= 2 THEN
                settle_count := 0;
                step := 30;
            END_IF;
        ELSE
            settle_count := 0;
        END_IF;

    // -------------------------------------------------------------
    // STEP 30: Connect & Extract jig from Lift
    // -------------------------------------------------------------
    30:
        D80 := 1; // Extraction
        D81 := active_station;
        D82 := seq_counter;
        D2004 := 18000; // Fork extended to 180 mm
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 40;
        END_IF;

    // -------------------------------------------------------------
    // STEP 40: Retract fork with jig onto shuttle
    // -------------------------------------------------------------
    40:
        D80 := 0;
        D81 := 0;
        D2004 := 0; // Fork retract
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            // Reset lifts to home
            D2008 := 40000;
            D2012 := 40000;
            IF is_cancelled THEN
                step := 300; // Return directly to lift if cancelled
            ELSE
                step := 100; // Move to Cell 3
            END_IF;
        END_IF;

    // -------------------------------------------------------------
    // CELL 3 (HOIST): Shuttle move to Port 3
    // -------------------------------------------------------------
    100:
        target_dock_x := D409;
        IF target_dock_x = 0 THEN target_dock_x := 90000; END_IF;
        D2000 := target_dock_x;
        D2004 := 0;
        // Pre-position hoist to connection posture
        D2016 := 100000;
        D2020 := 0;
        D2024 := 0;
        IF ABS(D1000 - target_dock_x) <= 20 AND ABS(D1001) <= 100 THEN
            settle_count := settle_count + 1;
            IF settle_count >= 2 THEN
                settle_count := 0;
                step := 110;
            END_IF;
        ELSE
            settle_count := 0;
        END_IF;

    // -------------------------------------------------------------
    // STEP 110: Connect to Cell 3 (Placement)
    // -------------------------------------------------------------
    110:
        D80 := 2; // Placement
        D81 := 3; // Station 3
        D82 := seq_counter;
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 120;
        END_IF;

    // -------------------------------------------------------------
    // STEP 120: Retract fork, release jig to Cell 3
    // -------------------------------------------------------------
    120:
        D80 := 0;
        D81 := 0;
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 130;
        END_IF;

    // -------------------------------------------------------------
    // STEP 130: Process Cell 3 (Configure, execute hoist motion)
    // -------------------------------------------------------------
    130:
        Y70 := TRUE; // Hoist configure
        D700 := active_req_id;
        IF D500 <> 0 THEN
            D2016 := D500; // Rope length target
        ELSE
            D2016 := 100000;
        END_IF;
        IF D501 <> 0 THEN
            D2020 := D501; // Trolley pos target
        ELSE
            D2020 := 0;
        END_IF;
        D2024 := 0;

        // Check if Cell 3 reached targets and settled
        IF ABS(D1016 - D2016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - D2020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 3 AND ABS(D1025) <= 15 THEN
            c3_settle_count := c3_settle_count + 1;
            IF c3_settle_count >= 4 OR X70 THEN // 80 ms maintained
                c3_settle_count := 0;
                step := 140;
            END_IF;
        ELSE
            c3_settle_count := 0;
        END_IF;

    // -------------------------------------------------------------
    // STEP 140: Hoist return to initial connection posture
    // -------------------------------------------------------------
    140:
        D2016 := 100000;
        D2020 := 0;
        D2024 := 0;
        IF ABS(D1016 - 100000) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 3 AND ABS(D1025) <= 15 THEN
            c3_settle_count := c3_settle_count + 1;
            IF c3_settle_count >= 4 THEN
                c3_settle_count := 0;
                Y70 := FALSE;
                step := 150;
            END_IF;
        ELSE
            c3_settle_count := 0;
        END_IF;

    // -------------------------------------------------------------
    // STEP 150: Reconnect & Extract jig from Cell 3
    // -------------------------------------------------------------
    150:
        D80 := 1; // Extraction
        D81 := 3;
        D82 := seq_counter;
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 160;
        END_IF;

    // -------------------------------------------------------------
    // STEP 160: Retract fork with jig
    // -------------------------------------------------------------
    160:
        D80 := 0;
        D81 := 0;
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 200; // Proceed to Cell 4
        END_IF;

    // -------------------------------------------------------------
    // CELL 4 (COUNTERBALANCE): Shuttle move to Port 4
    // -------------------------------------------------------------
    200:
        target_dock_x := D412;
        IF target_dock_x = 0 THEN target_dock_x := 410000; END_IF;
        D2000 := target_dock_x;
        D2004 := 0;
        D2028 := 0;
        D2032 := 0;
        IF ABS(D1000 - target_dock_x) <= 20 AND ABS(D1001) <= 100 THEN
            settle_count := settle_count + 1;
            IF settle_count >= 2 THEN
                settle_count := 0;
                step := 210;
            END_IF;
        ELSE
            settle_count := 0;
        END_IF;

    // -------------------------------------------------------------
    // STEP 210: Connect to Cell 4 (Placement)
    // -------------------------------------------------------------
    210:
        D80 := 2; // Placement
        D81 := 4; // Station 4
        D82 := seq_counter;
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 220;
        END_IF;

    // -------------------------------------------------------------
    // STEP 220: Retract fork, release jig to Cell 4
    // -------------------------------------------------------------
    220:
        D80 := 0;
        D81 := 0;
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 230;
        END_IF;

    // -------------------------------------------------------------
    // STEP 230: Process Cell 4 (Inclined head and counterweight)
    // -------------------------------------------------------------
    230:
        Y75 := TRUE; // Head configure
        D710 := active_req_id;
        IF D600 <> 0 THEN
            D2028 := D600; // Angle target (0.01 deg)
        ELSE
            D2028 := 0;
        END_IF;

        // Balance moment = 0 -> x = -450 * sin(theta)
        // Convert theta to radians: (D2028 * 0.01) * pi / 180
        theta_rad := REAL(D2028) * 0.000174532925;
        sin_theta := SIN(theta_rad);
        bal_cw := -450.0 * sin_theta; // in mm
        D2032 := DINT(bal_cw * 100.0); // 0.01 mm target

        IF ABS(D1028 - D2028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032 - D2032) <= 20 AND ABS(D1033) <= 100 THEN
            c4_settle_count := c4_settle_count + 1;
            IF c4_settle_count >= 4 OR X75 THEN // 80 ms maintained
                c4_settle_count := 0;
                step := 240;
            END_IF;
        ELSE
            c4_settle_count := 0;
        END_IF;

    // -------------------------------------------------------------
    // STEP 240: Return Cell 4 to initial connection posture
    // -------------------------------------------------------------
    240:
        D2028 := 0;
        D2032 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            c4_settle_count := c4_settle_count + 1;
            IF c4_settle_count >= 4 THEN
                c4_settle_count := 0;
                Y75 := FALSE;
                step := 250;
            END_IF;
        ELSE
            c4_settle_count := 0;
        END_IF;

    // -------------------------------------------------------------
    // STEP 250: Reconnect & Extract jig from Cell 4
    // -------------------------------------------------------------
    250:
        D80 := 1; // Extraction
        D81 := 4;
        D82 := seq_counter;
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 260;
        END_IF;

    // -------------------------------------------------------------
    // STEP 260: Retract fork with jig
    // -------------------------------------------------------------
    260:
        D80 := 0;
        D81 := 0;
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 300; // Proceed to return to original lift
        END_IF;

    // -------------------------------------------------------------
    // STEP 300: Shuttle return to original Lift
    // -------------------------------------------------------------
    300:
        IF active_station = 1 THEN
            D2008 := 95000;
            D2012 := 40000;
            target_dock_x := D403;
            IF target_dock_x = 0 THEN target_dock_x := -405000; END_IF;
        ELSE
            D2008 := 40000;
            D2012 := 95000;
            target_dock_x := D406;
            IF target_dock_x = 0 THEN target_dock_x := -185000; END_IF;
        END_IF;

        D2000 := target_dock_x;
        D2004 := 0;
        IF ABS(D1000 - target_dock_x) <= 20 AND ABS(D1001) <= 100 THEN
            settle_count := settle_count + 1;
            IF settle_count >= 2 THEN
                settle_count := 0;
                step := 310;
            END_IF;
        ELSE
            settle_count := 0;
        END_IF;

    // -------------------------------------------------------------
    // STEP 310: Connect & Place jig back into Lift
    // -------------------------------------------------------------
    310:
        D80 := 2; // Placement
        D81 := active_station;
        D82 := seq_counter;
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 320;
        END_IF;

    // -------------------------------------------------------------
    // STEP 320: Retract fork onto shuttle
    // -------------------------------------------------------------
    320:
        D80 := 0;
        D81 := 0;
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 330;
        END_IF;

    // -------------------------------------------------------------
    // STEP 330: Descend lift to initial height (400 mm = 40000)
    // -------------------------------------------------------------
    330:
        D2008 := 40000;
        D2012 := 40000;
        IF (active_station = 1 AND ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100) OR
           (active_station = 2 AND ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100) THEN
            // Acknowledge request completion
            IF active_req = 0 THEN
                D300 := active_req_id;
                IF is_cancelled THEN
                    D301 := 2; // Cancellation retrieval
                ELSE
                    D301 := 1; // Completion
                END_IF;
                r0_done := TRUE;
            ELSE
                D302 := active_req_id;
                IF is_cancelled THEN
                    D303 := 2; // Cancellation retrieval
                ELSE
                    D303 := 1; // Completion
                END_IF;
                r1_done := TRUE;
            END_IF;
            step := 0; // Return to check other requests or complete
        END_IF;

    // -------------------------------------------------------------
    // STEP 900: Completion check and holding
    // -------------------------------------------------------------
    900:
        D80 := 0;
        D81 := 0;
        D2000 := 0; // Shuttle home (0 mm)
        D2004 := 0; // Fork home (0 mm)
        D2008 := 40000; // Lift A home (400 mm)
        D2012 := 40000; // Lift B home (400 mm)
        D2016 := 100000; // Hoist rope (1000 mm)
        D2020 := 0; // Hoist trolley (0 mm)
        D2024 := 0; // Hoist sway target (0 deg)
        D2028 := 0; // Head angle (0 deg)
        D2032 := 0; // Counterweight (0 mm)

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - 100000) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 3 AND ABS(D1025) <= 15 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            all_done_count := all_done_count + 1;
            IF all_done_count >= 5 THEN // 100 ms maintained
                Y2 := TRUE;
            END_IF;
        ELSE
            all_done_count := 0;
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM