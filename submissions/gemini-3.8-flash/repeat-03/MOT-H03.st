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
    active_req : INT := 0;
    req_id : DINT := 0;
    req_station : DINT := 0;
    req_is_cancel : BOOL := FALSE;
    next_seq : DINT := 1;

    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;

    s3_0_home : DINT := -50000;
    s3_1_home : DINT := -50000;
    s3_2_home : DINT := 0;
    s4_0_home : DINT := 0;
    s4_1_home : DINT := 0;

    lift_home_pos : DINT := 15000;
    lift_dock_pos : DINT := 73250;

    pos_tol : DINT := 20;
    vel_tol : DINT := 100;

    c3_timer : DINT := 0;
    c4_timer : DINT := 0;
    c4_speed_timer : DINT := 0;
    hold_timer : DINT := 0;

    s3_0_p_sync : DINT := 0;
    s3_0_start_x : DINT := 0;
    gear_ratio : DINT := 1000;
    s4_0_base : DINT := 0;
    s4_1_base : DINT := 0;
    s4_sweep_dir : DINT := 1;

    step_timer : DINT := 0;
    cancel_latched : BOOL := FALSE;
END_VAR

// Track request cancellations dynamically
IF active_req = 0 AND req_id <> 0 THEN
    IF X31 THEN
        cancel_latched := TRUE;
    END_IF;
ELSIF active_req = 1 AND req_id <> 0 THEN
    IF X35 THEN
        cancel_latched := TRUE;
    END_IF;
END_VAR;

IF D92 <> 0 THEN
    lift_dock_pos := D92;
END_IF;

CASE step OF
    0: // Initial setup: home all axes
        Y40 := TRUE; D2000 := 0; D2001 := 500; D2002 := 0;
        Y41 := TRUE; D2004 := 0; D2005 := 500; D2006 := 0;
        Y42 := TRUE; D2008 := lift_home_pos; D2009 := 500; D2010 := 0;
        Y43 := TRUE; D2012 := lift_home_pos; D2013 := 500; D2014 := 0;
        Y44 := TRUE; D2016 := s3_0_home; D2017 := 500; D2018 := 0;
        Y45 := TRUE; D2020 := s3_1_home; D2021 := 500; D2022 := 0;
        Y46 := TRUE; D2024 := s3_2_home; D2025 := 500; D2026 := 0;
        Y47 := TRUE; D2028 := s4_0_home; D2029 := 500; D2030 := 0;
        Y48 := TRUE; D2032 := s4_1_home; D2033 := 500; D2034 := 0;
        Y30 := FALSE;
        D80 := 0; D81 := 0;
        Y70 := FALSE; Y71 := FALSE;
        Y75 := FALSE; Y76 := FALSE;

        IF ABS(D1000) <= pos_tol AND ABS(D1001) <= vel_tol AND
           ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol AND
           ABS(D1008 - lift_home_pos) <= pos_tol AND ABS(D1009) <= vel_tol AND
           ABS(D1012 - lift_home_pos) <= pos_tol AND ABS(D1013) <= vel_tol AND
           ABS(D1016 - s3_0_home) <= pos_tol AND ABS(D1017) <= vel_tol AND
           ABS(D1020 - s3_1_home) <= pos_tol AND ABS(D1021) <= vel_tol AND
           ABS(D1024 - s3_2_home) <= pos_tol AND ABS(D1025) <= vel_tol AND
           ABS(D1028 - s4_0_home) <= pos_tol AND ABS(D1029) <= vel_tol AND
           ABS(D1032 - s4_1_home) <= pos_tol AND ABS(D1033) <= vel_tol THEN
            step := 1;
        END_IF;

    1: // Arbitrate and select next pending request
        cancel_latched := FALSE;
        IF NOT r0_done AND D100 <> 0 THEN
            active_req := 0;
            req_id := D100;
            req_station := D101;
            req_is_cancel := X31;
            step := 10;
        ELSIF NOT r1_done AND D120 <> 0 THEN
            active_req := 1;
            req_id := D120;
            req_station := D121;
            req_is_cancel := X35;
            step := 10;
        ELSIF r0_done AND r1_done THEN
            step := 200; // All requests processed
        END_IF;

    10: // Raise lift at source station and align shuttle X
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        IF req_station = 1 THEN
            D2008 := lift_dock_pos; D2009 := 800;
            IF D403 <> 0 THEN D2000 := D403; ELSE D2000 := -360000; END_IF;
        ELSE
            D2012 := lift_dock_pos; D2013 := 800;
            IF D406 <> 0 THEN D2000 := D406; ELSE D2000 := -230000; END_IF;
        END_IF;
        D2001 := 800;
        D2004 := 0; D2005 := 500; // Fork retracted
        step := 11;

    11: // Wait for lift and shuttle alignment
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        IF req_station = 1 THEN
            IF ABS(D1000 - D2000) <= pos_tol AND ABS(D1001) <= vel_tol AND
               ABS(D1008 - lift_dock_pos) <= pos_tol AND ABS(D1009) <= vel_tol AND
               (X61 OR ABS(D1000 - D2000) <= pos_tol) THEN
                step := 12;
            END_IF;
        ELSE
            IF ABS(D1000 - D2000) <= pos_tol AND ABS(D1001) <= vel_tol AND
               ABS(D1012 - lift_dock_pos) <= pos_tol AND ABS(D1013) <= vel_tol AND
               (X62 OR ABS(D1000 - D2000) <= pos_tol) THEN
                step := 12;
            END_IF;
        END_IF;

    12: // Extract fixture from lift: extend connection fork
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        D80 := 1; // Extraction
        D81 := req_station;
        D82 := next_seq;
        next_seq := next_seq + 1;
        D2004 := 18000; // 180 mm insertion
        D2005 := 500;
        step := 13;

    13: // Wait for fork insertion and ownership transfer
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        IF ABS(D1004 - 18000) <= pos_tol AND ABS(D1005) <= vel_tol THEN
            D80 := 0; D81 := 0;
            IF req_is_cancel THEN
                step := 120; // Skip cell operations on cancellation
            ELSE
                step := 20;  // Proceed to Cell 3
            END_IF;
        END_IF;

    20: // Prepare Cell 3: Move s3 axes to synchronize with shuttle
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        IF req_is_cancel THEN
            step := 120;
        ELSE
            // Setup Cell 3 configuration
            Y70 := TRUE;
            D700 := 1000;
            // Move shuttle toward Cell 3 docking position (Nominal 2300 mm)
            IF D409 <> 0 THEN D2000 := D409; ELSE D2000 := 230000; END_IF;
            D2001 := 600;
            // Align Cell 3 axes
            D2016 := 0; D2017 := 500; // s3_0 aligns with fixture
            D2020 := 0; D2021 := 500; // s3_1 docks
            D2024 := 18000; D2025 := 500; // s3_2 fork connection
            step := 21;
            c3_timer := 0;
        END_IF;

    21: // Cell 3 Moving Synchronization
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        // Check relative posture and speed for 50 ms
        IF ABS(D1000 - D2000) <= pos_tol AND ABS(D1001) <= vel_tol AND
           ABS(D1016 - D2016) <= pos_tol AND ABS(D1017) <= vel_tol AND
           ABS(D1020 - D2020) <= pos_tol AND ABS(D1021) <= vel_tol AND
           ABS(D1024 - D2024) <= pos_tol AND ABS(D1025) <= vel_tol THEN
            c3_timer := c3_timer + 20;
        ELSE
            c3_timer := 0;
        END_IF;

        IF X70 OR c3_timer >= 120 THEN
            // Cell 3 served or synchronized, withdraw Cell 3 and proceed to Cell 4
            Y70 := FALSE;
            D2016 := s3_0_home; D2017 := 500;
            D2020 := s3_1_home; D2021 := 500;
            D2024 := s3_2_home; D2025 := 500;
            step := 30;
        END_IF;

    30: // Travel shuttle to Cell 4 (Nominal 9900 mm)
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        IF D412 <> 0 THEN D2000 := D412; ELSE D2000 := 990000; END_IF;
        D2001 := 700;
        step := 31;

    31: // Wait for shuttle arrival at Cell 4
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        IF ABS(D1000 - D2000) <= pos_tol AND ABS(D1001) <= vel_tol THEN
            step := 40;
        END_IF;

    40: // Prepare Cell 4 Electronic Gearing
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        IF req_is_cancel THEN
            step := 120;
        ELSE
            Y75 := TRUE; // m4_configure
            D710 := 1000; // ratio 1.000
            gear_ratio := 1000;
            s4_0_base := D1028;
            s4_1_base := D1032;
            c4_timer := 0;
            c4_speed_timer := 0;
            // Sweep s4_0 at controlled speed, s4_1 follows or driven symmetrically
            D2028 := s4_0_base + 9000; // 90.0 deg
            D2029 := 300; // 300/1000 speed ratio (~270 deg/s)
            D2032 := s4_1_base + 9000;
            D2033 := 300;
            step := 41;
        END_IF;

    41: // Synchronous rotation execution
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        // Verify master speed > 1 deg/s (100 in 0.01 scale) and angle error <= 0.2 deg (20 scale)
        IF ABS(D1029) >= 100 AND ABS(D1028 - D1032) <= 20 AND ABS(D1029 - D1033) <= 100 THEN
            c4_speed_timer := c4_speed_timer + 20;
        ELSE
            c4_speed_timer := 0;
        END_IF;

        IF X75 OR (c4_speed_timer >= 60 AND ABS(D1028 - (s4_0_base + 9000)) <= pos_tol) THEN
            // Rotation accomplished, return Cell 4 axes to home
            Y75 := FALSE;
            D2028 := s4_0_home; D2029 := 400;
            D2032 := s4_1_home; D2033 := 400;
            step := 42;
        END_IF;

    42: // Wait for Cell 4 home
        IF cancel_latched THEN req_is_cancel := TRUE; END_IF;
        IF ABS(D1028 - s4_0_home) <= pos_tol AND ABS(D1029) <= vel_tol AND
           ABS(D1032 - s4_1_home) <= pos_tol AND ABS(D1033) <= vel_tol THEN
            step := 120; // Return shuttle to original lift
        END_IF;

    120: // Return shuttle to original lift station
        IF req_station = 1 THEN
            IF D403 <> 0 THEN D2000 := D403; ELSE D2000 := -360000; END_IF;
        ELSE
            IF D406 <> 0 THEN D2000 := D406; ELSE D2000 := -230000; END_IF;
        END_IF;
        D2001 := 800;
        step := 121;

    121: // Wait for shuttle alignment at lift
        IF ABS(D1000 - D2000) <= pos_tol AND ABS(D1001) <= vel_tol THEN
            step := 122;
        END_IF;

    122: // Retract fork to deposit jig back onto lift
        D80 := 2; // Placement
        D81 := req_station;
        D82 := next_seq;
        next_seq := next_seq + 1;
        D2004 := 0; // Fork return to 0
        D2005 := 500;
        step := 123;

    123: // Wait for fork full retraction
        IF ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol THEN
            D80 := 0; D81 := 0;
            // Lower lift back to home height
            IF req_station = 1 THEN
                D2008 := lift_home_pos; D2009 := 600;
            ELSE
                D2012 := lift_home_pos; D2013 := 600;
            END_IF;
            step := 124;
        END_IF;

    124: // Wait for lift to reach home height and acknowledge request
        IF req_station = 1 THEN
            IF ABS(D1008 - lift_home_pos) <= pos_tol AND ABS(D1009) <= vel_tol THEN
                IF active_req = 0 THEN
                    D300 := req_id;
                    IF req_is_cancel OR cancel_latched THEN D301 := 2; ELSE D301 := 1; END_IF;
                    r0_done := TRUE;
                ELSE
                    D302 := req_id;
                    IF req_is_cancel OR cancel_latched THEN D303 := 2; ELSE D303 := 1; END_IF;
                    r1_done := TRUE;
                END_IF;
                step := 1; // Process next request
            END_IF;
        ELSE
            IF ABS(D1012 - lift_home_pos) <= pos_tol AND ABS(D1013) <= vel_tol THEN
                IF active_req = 0 THEN
                    D300 := req_id;
                    IF req_is_cancel OR cancel_latched THEN D301 := 2; ELSE D301 := 1; END_IF;
                    r0_done := TRUE;
                ELSE
                    D302 := req_id;
                    IF req_is_cancel OR cancel_latched THEN D303 := 2; ELSE D303 := 1; END_IF;
                    r1_done := TRUE;
                END_IF;
                step := 1; // Process next request
            END_IF;
        END_IF;

    200: // Return all axes to absolute home and verify stability
        D2000 := 0; D2001 := 600;
        D2004 := 0; D2005 := 500;
        D2008 := lift_home_pos; D2009 := 500;
        D2012 := lift_home_pos; D2013 := 500;
        D2016 := s3_0_home; D2017 := 500;
        D2020 := s3_1_home; D2021 := 500;
        D2024 := s3_2_home; D2025 := 500;
        D2028 := s4_0_home; D2029 := 500;
        D2032 := s4_1_home; D2033 := 500;

        IF ABS(D1000) <= pos_tol AND ABS(D1001) <= vel_tol AND
           ABS(D1004) <= pos_tol AND ABS(D1005) <= vel_tol AND
           ABS(D1008 - lift_home_pos) <= pos_tol AND ABS(D1009) <= vel_tol AND
           ABS(D1012 - lift_home_pos) <= pos_tol AND ABS(D1013) <= vel_tol AND
           ABS(D1016 - s3_0_home) <= pos_tol AND ABS(D1017) <= vel_tol AND
           ABS(D1020 - s3_1_home) <= pos_tol AND ABS(D1021) <= vel_tol AND
           ABS(D1024 - s3_2_home) <= pos_tol AND ABS(D1025) <= vel_tol AND
           ABS(D1028 - s4_0_home) <= pos_tol AND ABS(D1029) <= vel_tol AND
           ABS(D1032 - s4_1_home) <= pos_tol AND ABS(D1033) <= vel_tol THEN
            step := 201;
            hold_timer := 0;
        END_IF;

    201: // Assert completion Y2 and maintain required holding condition
        Y2 := TRUE;
        hold_timer := hold_timer + 20;
END_CASE;

END_PROGRAM