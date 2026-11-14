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

    step : INT := 0;
    curr_req : INT := 0;
    req_id : DINT := 0;
    req_station : DINT := 1;
    is_cancel : BOOL := FALSE;
    seq_counter : DINT := 0;
    timer_cnt : DINT := 0;
    r0_finished : BOOL := FALSE;
    r1_finished : BOOL := FALSE;
    target_pos : DINT := 0;
    reg_val : DINT := 0;
    pin_target : DINT := 0;
END_VAR

// Base drive parameters and enables
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;

CASE step OF
    0: // Idle / Arbitrate request
        Y30 := FALSE;
        Y70 := FALSE;
        Y71 := FALSE;
        Y75 := FALSE;
        Y76 := FALSE;
        D80 := 0;
        D81 := 0;
        
        // Default target coordinates
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000; // 150 mm
        D2012 := 15000; // 150 mm
        D2016 := -60000; // -600 mm
        D2020 := -60000; // -600 mm
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;

        IF (NOT r0_finished) AND (D100 > 0) THEN
            curr_req := 0;
            req_id := D100;
            req_station := 1;
            is_cancel := X31;
            step := 10;
        ELSIF (NOT r1_finished) AND (D120 > 0) THEN
            curr_req := 1;
            req_id := D120;
            req_station := 2;
            is_cancel := X35;
            step := 10;
        ELSIF r0_finished AND r1_finished AND X51 THEN
            step := 900;
            timer_cnt := 0;
        END_IF;

    10: // Prepare Lift: move lift to dock height (D92)
        IF req_station = 1 THEN
            D2008 := D92;
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 20;
            END_IF;
        ELSE
            D2012 := D92;
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 20;
            END_IF;
        END_IF;

    20: // Move Shuttle A to Lift station
        IF req_station = 1 THEN
            target_pos := D403;
        ELSE
            target_pos := D406;
        END_IF;
        D2000 := target_pos;
        IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D81 := req_station;
            D80 := 1; // Extraction from lift
            step := 30;
        END_IF;

    30: // Extend Fork B to connect/extract jig from lift (180 mm)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND (D90 = req_id) THEN
            // Handover complete, retract fork
            D80 := 0;
            D81 := 0;
            step := 40;
        END_IF;

    40: // Retract Fork B (0 mm)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF is_cancel THEN
                // Cancelled request returns directly to lift
                step := 600;
            ELSE
                step := 100; // Proceed to Cell 3
            END_IF;
        END_IF;

    100: // Move Shuttle A to Cell 3 (Port 3)
        target_pos := D409;
        D2000 := target_pos;
        IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D81 := 3;
            D80 := 2; // Placement to Cell 3
            step := 110;
        END_IF;

    110: // Extend Fork B to place jig into Cell 3 (180 mm)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 120;
        END_IF;

    120: // Retract Fork B (0 mm) leaving jig in Cell 3
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 130;
        END_IF;

    130: // Configure Cell 3 registration capture
        D700 := req_id; // Set capture selection to ID
        Y70 := TRUE;    // Configure
        Y71 := TRUE;    // Retain ownership
        step := 140;

    140: // Move s3_0 and s3_1 to capture registration mark
        // Target is request goal D500, D501
        D2016 := D500;
        D2020 := D501;
        IF X70 OR (D523 > 0 AND D524 = D91) THEN
            // Registration captured! Capture position + 250 mm stop
            reg_val := D523;
            D2016 := reg_val + 25000;
            D2020 := reg_val + 25000;
            step := 150;
        END_IF;

    150: // Stop at registration + 250 mm, wait for settling
        IF ABS(D1016 - (reg_val + 25000)) <= 20 AND ABS(D1017) <= 100 THEN
            timer_cnt := 0;
            step := 160;
        END_IF;

    160: // Maintain actual result for 80 ms
        timer_cnt := timer_cnt + 20;
        IF timer_cnt >= 80 THEN
            step := 170;
        END_IF;

    170: // Return Cell 3 axes to initial home coordinates (-600 mm)
        D2016 := -60000;
        D2020 := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D81 := 3;
            D80 := 1; // Extract jig from Cell 3
            step := 180;
        END_IF;

    180: // Extend Fork B to pick jig from Cell 3
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND (D90 = req_id) THEN
            D80 := 0;
            D81 := 0;
            step := 190;
        END_IF;

    190: // Retract Fork B (0 mm)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 200; // Proceed to Cell 4
        END_IF;

    200: // Move Shuttle A to Cell 4 (Port 4)
        target_pos := D412;
        D2000 := target_pos;
        IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D81 := 4;
            D80 := 2; // Placement to Cell 4
            step := 210;
        END_IF;

    210: // Extend Fork B to place jig into Cell 4
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 220;
        END_IF;

    220: // Retract Fork B (0 mm) leaving jig in Cell 4
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 230;
        END_IF;

    230: // Configure Cell 4
        D710 := req_id;
        Y75 := TRUE;
        Y76 := TRUE;
        // Rotate after retrieving two pins (pins at 0) to requested angle D600
        D2024 := D600; // Requested angle
        D2028 := 0;    // Pin 1 retrieved
        D2032 := 0;    // Pin 2 retrieved
        step := 240;

    240: // Wait until stopped at requested angle
        IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 THEN
            // Release ownership of Cell 3 now that rotation posture is reached
            Y71 := FALSE;
            // Select pin based on lane/configuration: insert selected pin 40 mm
            IF (curr_req = 0 AND D520 = 0) OR (curr_req = 1 AND D520 = 0) THEN
                pin_target := 1;
                D2028 := 4000; // 40 mm
            ELSE
                pin_target := 2;
                D2032 := 4000; // 40 mm
            END_IF;
            step := 250;
        END_IF;

    250: // Wait for pin insertion 40 mm
        IF (pin_target = 1 AND ABS(D1028 - 4000) <= 20 AND ABS(D1029) <= 100) OR
           (pin_target = 2 AND ABS(D1032 - 4000) <= 20 AND ABS(D1033) <= 100) THEN
            timer_cnt := 0;
            step := 260;
        END_IF;

    260: // Maintain actual result for 80 ms
        timer_cnt := timer_cnt + 20;
        IF timer_cnt >= 80 THEN
            step := 270;
        END_IF;

    270: // Retrieve pin (return to 0 mm) and reset index rotation (return to 0 deg)
        D2028 := 0;
        D2032 := 0;
        D2024 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
            Y76 := FALSE;
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D81 := 4;
            D80 := 1; // Extract jig from Cell 4
            step := 280;
        END_IF;

    280: // Extend Fork B to pick jig from Cell 4
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND (D90 = req_id) THEN
            D80 := 0;
            D81 := 0;
            step := 290;
        END_IF;

    290: // Retract Fork B (0 mm)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 600; // Return jig to lift
        END_IF;

    600: // Move Shuttle A back to original lift station
        IF req_station = 1 THEN
            target_pos := D403;
        ELSE
            target_pos := D406;
        END_IF;
        D2000 := target_pos;
        IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D81 := req_station;
            D80 := 2; // Placement to lift
            step := 610;
        END_IF;

    610: // Extend Fork B to return jig to lift
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 620;
        END_IF;

    620: // Retract Fork B (0 mm)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 630;
        END_IF;

    630: // Return lift to initial height (150 mm)
        IF req_station = 1 THEN
            D2008 := 15000;
            IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                step := 640;
            END_IF;
        ELSE
            D2012 := 15000;
            IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                step := 640;
            END_IF;
        END_IF;

    640: // Acknowledge completion or cancellation
        IF curr_req = 0 THEN
            D300 := req_id;
            IF is_cancel THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            r0_finished := TRUE;
        ELSE
            D302 := req_id;
            IF is_cancel THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            r1_finished := TRUE;
        END_IF;
        step := 0; // Return to arbitrate next request or complete

    900: // Final completion holding
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        D2016 := -60000;
        D2020 := -60000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM