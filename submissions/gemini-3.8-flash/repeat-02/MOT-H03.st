To control the system according to the task specification, the complete IEC 61131-3 Structured Text program is provided below.

```iec-st
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

    step : INT;
    req_index : INT;
    active_req_id : DINT;
    active_station : DINT;
    seq_counter : DINT;
    init_done : BOOL;
    start_pos_a : DINT;
    timer_ms : DINT;
    completion_ms : DINT;
    ratio_m4 : DINT;
    gear_target : DINT;
END_VAR

IF NOT init_done THEN
    seq_counter := 1;
    step := 0;
    req_index := 0;
    active_req_id := 0;
    active_station := 0;
    timer_ms := 0;
    completion_ms := 0;
    init_done := TRUE;
END_IF;

// Drive enables
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

// Default feedforward
D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;

// Default rates
D2001 := 600;
D2005 := 600;
D2009 := 600;
D2013 := 600;
D2017 := 600;
D2021 := 600;
D2025 := 600;
D2029 := 600;
D2033 := 600;

CASE step OF
    0: // Idle / Check next request
        Y30 := FALSE;
        D80 := 0;
        D81 := 0;
        Y70 := FALSE;
        Y71 := FALSE;
        Y75 := FALSE;
        Y76 := FALSE;
        
        // Reset non-servicing cell axes to home
        D2004 := 0;      // b at 0
        D2016 := -50000; // s3_0
        D2020 := -50000; // s3_1
        D2024 := 0;      // s3_2
        D2028 := 0;      // s4_0
        D2032 := 0;      // s4_1

        IF req_index = 0 THEN
            IF D100 > 0 THEN
                active_req_id := D100;
                active_station := D101;
                IF X31 THEN
                    step := 900; // Cancelled
                ELSE
                    step := 10;
                END_IF;
            ELSIF X51 THEN
                step := 950;
            END_IF;
        ELSIF req_index = 1 THEN
            IF D120 > 0 THEN
                active_req_id := D120;
                active_station := D121;
                IF X35 THEN
                    step := 900; // Cancelled
                ELSE
                    step := 10;
                END_IF;
            ELSIF X51 THEN
                step := 950;
            END_IF;
        ELSE
            step := 950;
        END_IF;

    10: // Move Lift to dock height and Shuttle A to source dock
        IF active_station = 1 THEN
            D2008 := D92;
            D2012 := 15000;
            D2000 := D403; // port1_x
        ELSE
            D2008 := 15000;
            D2012 := D92;
            D2000 := D406; // port2_x
        END_IF;
        D2004 := 0;

        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            IF ((active_station = 1 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND X61) OR
                (active_station = 2 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 AND X62)) THEN
                step := 11;
            END_IF;
        END_IF;

    11: // Extend fork B to pick jig from Lift
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; // Extract
            D81 := active_station;
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            step := 12;
            timer_ms := 0;
        END_IF;

    12: // Confirm ownership transfer to shuttle
        timer_ms := timer_ms + 20;
        IF D90 = active_req_id AND timer_ms >= 60 THEN
            D80 := 0;
            D81 := 0;
            step := 13;
        END_IF;

    13: // Retract fork B
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            // Reset lift to safe/initial height
            IF active_station = 1 THEN
                D2008 := 15000;
            ELSE
                D2012 := 15000;
            END_IF;
            step := 20;
        END_IF;

    20: // Move Shuttle A towards Cell 3 entrance and prepare Cell 3 axes
        // Move s3_1 to track shuttle, s3_0 matching origin
        D2000 := D409 - 30000; // approach position 300 mm before sync
        D2016 := 0;            // s3_0 aligns with frame
        D2020 := 0;            // s3_1 tracking
        D2024 := 0;            // s3_2 retracted
        
        IF ABS(D1000 - D2000) <= 100 AND ABS(D1016) <= 50 AND ABS(D1020) <= 50 THEN
            step := 21;
        END_IF;

    21: // Fly synchronization in Cell 3: Shuttle A moves at constant speed, Cell 3 syncs
        D2000 := D409 + 40000;
        D2001 := 200; // Moderate synchronized speed
        D2021 := 200;
        D2020 := D2000 - D409; // follow shuttle X
        
        // When relative position and velocity align, extend fork
        IF ABS((D1000 - D409) - D1020) <= 20 AND ABS(D1001 - D1021) <= 100 AND ABS(D1001) > 100 THEN
            D2024 := 18000; // extend s3_2 fork
            step := 22;
            timer_ms := 0;
            start_pos_a := D1000;
        END_IF;

    22: // Accompaniment for 200 mm with fork fully extended
        D2020 := D2000 - D409;
        IF ABS(D1024 - 18000) <= 20 THEN
            IF ABS((D1000 - D409) - D1020) <= 20 AND ABS(D1001 - D1021) <= 100 THEN
                timer_ms := timer_ms + 20;
            ELSE
                timer_ms := 0;
            END_IF;
            IF timer_ms >= 60 AND (D1000 - start_pos_a) >= 20000 THEN
                step := 23;
                timer_ms := 0;
            END_IF;
        END_IF;

    23: // Retract s3_2 fork and wait for cell 3 served signal
        D2024 := 0;
        IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
            timer_ms := timer_ms + 20;
            IF X70 OR timer_ms >= 100 THEN
                // Reset Cell 3
                D2016 := -50000;
                D2020 := -50000;
                step := 30;
            END_IF;
        END_IF;

    30: // Move Shuttle A to Cell 4 (station 4)
        D2000 := D412; // port4_x
        D2001 := 600;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            step := 31;
            timer_ms := 0;
        END_IF;

    31: // Engage Cell 4 electronic gear synchronization
        // Ratio configuration
        Y75 := TRUE; // m4_configure
        ratio_m4 := 1000;
        IF D625 > 0 THEN
            ratio_m4 := D625;
        END_IF;
        D710 := ratio_m4; // m4_select
        
        // Move master s4_0 to target goal
        gear_target := D600;
        IF gear_target = 0 THEN
            gear_target := 18000; // 180.00 deg
        END_IF;
        
        D2028 := gear_target;
        D2029 := 300; // master speed
        D2032 := (gear_target * ratio_m4) / 1000;
        D2033 := 300;

        // Check synchronization establishment
        IF ABS(D1029) > 100 THEN // master is moving
            IF ABS(D1032 - (D1028 * ratio_m4) / 1000) <= 20 AND ABS(D1033 - (D1029 * ratio_m4) / 1000) <= 100 THEN
                timer_ms := timer_ms + 20;
            ELSE
                timer_ms := 0;
            END_IF;
        END_IF;

        IF ABS(D1028 - gear_target) <= 20 AND ABS(D1029) <= 100 THEN
            IF timer_ms >= 60 OR X75 THEN
                step := 32;
                timer_ms := 0;
            END_IF;
        END_IF;

    32: // Maintain cell 4 result for 80 ms, then withdraw to initial posture
        timer_ms := timer_ms + 20;
        IF timer_ms >= 100 OR X75 THEN
            D2028 := 0;
            D2032 := 0;
            Y75 := FALSE;
            IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
                step := 40;
            END_IF;
        END_IF;

    40: // Return Shuttle A to original Lift section
        IF active_station = 1 THEN
            D2000 := D403;
            D2008 := D92;
        ELSE
            D2000 := D406;
            D2012 := D92;
        END_IF;
        D2001 := 600;

        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            IF ((active_station = 1 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100) OR
                (active_station = 2 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100)) THEN
                step := 41;
            END_IF;
        END_IF;

    41: // Extend fork B to place jig back onto lift
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; // Placement
            D81 := active_station;
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            step := 42;
            timer_ms := 0;
        END_IF;

    42: // Confirm ownership transfer back to lift
        timer_ms := timer_ms + 20;
        IF D90 = 0 AND timer_ms >= 60 THEN
            D80 := 0;
            D81 := 0;
            step := 43;
        END_IF;

    43: // Retract fork B
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 44;
        END_IF;

    44: // Descend lift to initial height (150 mm)
        IF active_station = 1 THEN
            D2008 := 15000;
        ELSE
            D2012 := 15000;
        END_IF;

        IF ((active_station = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
            (active_station = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100)) THEN
            // Respond completion for this request
            IF req_index = 0 THEN
                D300 := active_req_id;
                D301 := 1; // Completed
            ELSE
                D302 := active_req_id;
                D303 := 1; // Completed
            END_IF;
            req_index := req_index + 1;
            step := 0; // Next request or all done
        END_IF;

    900: // Cancellation retrieval sequence
        // Return jig if holding, or reset axes to home
        D2004 := 0;
        IF active_station = 1 THEN
            D2008 := 15000;
        ELSE
            D2012 := 15000;
        END_IF;
        IF req_index = 0 THEN
            D300 := active_req_id;
            D301 := 2; // Cancellation retrieval
        ELSE
            D302 := active_req_id;
            D303 := 2; // Cancellation retrieval
        END_IF;
        req_index := req_index + 1;
        step := 0;

    950: // All requests finished: Return all axes to initial connection posture
        D2000 := 0;      // shuttle X at 0
        D2004 := 0;      // fork b at 0
        D2008 := 15000;  // lift A at initial height 150 mm
        D2012 := 15000;  // lift B at initial height 150 mm
        D2016 := -50000; // s3_0 home
        D2020 := -50000; // s3_1 home
        D2024 := 0;      // s3_2 home
        D2028 := 0;      // s4_0 home
        D2032 := 0;      // s4_1 home

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-50000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-50000)) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            completion_ms := completion_ms + 20;
            IF completion_ms >= 100 THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            completion_ms := 0;
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM
```