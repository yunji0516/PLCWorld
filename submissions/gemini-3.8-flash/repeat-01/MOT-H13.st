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
    active_req : DINT := 0;
    curr_id : DINT := 0;
    curr_station : DINT := 1;
    is_cancelled : BOOL := FALSE;
    sub_step : DINT := 0;
    wait_cnt : DINT := 0;
    all_finished : BOOL := FALSE;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    target_pos : DINT := 0;
    gear_synced_time : DINT := 0;
END_VAR

// Keep brake released and axes enabled
Y30 := FALSE;
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

a_rate := 1000;
b_rate := 1000;
c_rate := 1000;
d_rate := 1000;
s3_0_rate := 1000;
s3_1_rate := 1000;
s3_2_rate := 1000;
s4_0_rate := 1000;
s4_1_rate := 1000;

a_ff := 0;
b_ff := 0;
c_ff := 0;
d_ff := 0;
s3_0_ff := 0;
s3_1_ff := 0;
s3_2_ff := 0;
s4_0_ff := 0;
s4_1_ff := 0;

// Handle requests sequentially
CASE step OF
    0: // Idle, check for pending requests
        a_target := 0;
        b_target := 0;
        c_target := 40000;
        d_target := 40000;
        s3_1_target := 0;
        s3_2_target := 0;
        s4_0_target := 0;
        s4_1_target := 0;
        m3_retain := FALSE;
        m4_configure := FALSE;
        m4_retain := FALSE;
        action := 0;
        station := 0;

        IF (D100 <> 0) AND NOT req0_done THEN
            active_req := 0;
            curr_id := D100;
            curr_station := 1; // Lift A
            is_cancelled := X31;
            step := 10;
        ELSIF (D120 <> 0) AND NOT req1_done THEN
            active_req := 1;
            curr_id := D120;
            curr_station := 2; // Lift B
            is_cancelled := X35;
            step := 10;
        ELSIF X51 AND ((D100 = 0) OR req0_done) AND ((D120 = 0) OR req1_done) THEN
            step := 900; // Final completion
        END_IF;

    // --- STEP 10: Lift to docking height (950 mm = 95000) ---
    10:
        IF curr_station = 1 THEN
            c_target := D92;
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 20;
            END_IF;
        ELSE
            d_target := D92;
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 20;
            END_IF;
        END_IF;

    // --- STEP 20: Shuttle moves to Lift station ---
    20:
        IF curr_station = 1 THEN
            target_pos := D403;
        ELSE
            target_pos := D406;
        END_IF;
        a_target := target_pos;

        IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 THEN
            IF (curr_station = 1 AND X61) OR (curr_station = 2 AND X62) THEN
                step := 30;
                sub_step := 0;
            END_IF;
        END_IF;

    // --- STEP 30: Connect & Extract from Lift ---
    30:
        CASE sub_step OF
            0:
                station := curr_station;
                action := 1; // extraction
                seq_counter := seq_counter + 1;
                couple_seq := seq_counter;
                b_target := 18000;
                sub_step := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    wait_cnt := 0;
                    sub_step := 2;
                END_IF;
            2:
                // Wait for ownership handover
                wait_cnt := wait_cnt + 1;
                IF (D90 = curr_id) OR (wait_cnt >= 5) THEN
                    b_target := 0;
                    sub_step := 3;
                END_IF;
            3:
                IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
                    action := 0;
                    station := 0;
                    IF is_cancelled THEN
                        step := 300; // Directly return to lift
                    ELSE
                        step := 100; // Move to Cell 3
                    END_IF;
                END_IF;
        END_CASE;

    // --- STEP 100: Move shuttle to Cell 3 ---
    100:
        target_pos := D409;
        a_target := target_pos;
        IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            step := 110;
            sub_step := 0;
        END_IF;

    // --- STEP 110: Place jig into Cell 3 ---
    110:
        CASE sub_step OF
            0:
                station := 3;
                action := 2; // placement
                seq_counter := seq_counter + 1;
                couple_seq := seq_counter;
                b_target := 18000;
                sub_step := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    wait_cnt := 0;
                    sub_step := 2;
                END_IF;
            2:
                wait_cnt := wait_cnt + 1;
                IF (D410 = curr_id) OR (wait_cnt >= 5) THEN
                    b_target := 0;
                    sub_step := 3;
                END_IF;
            3:
                IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
                    action := 0;
                    station := 0;
                    step := 120;
                END_IF;
        END_CASE;

    // --- STEP 120: Cell 3 Processing ---
    120:
        // Common motor runs at 200 deg/s
        m3_retain := TRUE;
        s3_1_target := D501;
        s3_2_target := D502;
        IF X70 THEN // cell 3 result achieved
            step := 130;
        END_IF;

    // --- STEP 130: Return Cell 3 axes to 0 for extraction ---
    130:
        s3_1_target := 0;
        s3_2_target := 0;
        IF ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND X63 THEN
            step := 140;
            sub_step := 0;
        END_IF;

    // --- STEP 140: Extract jig from Cell 3 ---
    140:
        CASE sub_step OF
            0:
                station := 3;
                action := 1; // extraction
                seq_counter := seq_counter + 1;
                couple_seq := seq_counter;
                b_target := 18000;
                sub_step := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    wait_cnt := 0;
                    sub_step := 2;
                END_IF;
            2:
                wait_cnt := wait_cnt + 1;
                IF (D90 = curr_id) OR (wait_cnt >= 5) THEN
                    b_target := 0;
                    sub_step := 3;
                END_IF;
            3:
                IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
                    action := 0;
                    station := 0;
                    step := 200; // Move to Cell 4
                END_IF;
        END_CASE;

    // --- STEP 200: Move shuttle to Cell 4 ---
    200:
        // Maintain m3_retain for Cell 4 power source!
        m3_retain := TRUE;
        target_pos := D412;
        a_target := target_pos;
        IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            step := 210;
            sub_step := 0;
        END_IF;

    // --- STEP 210: Place jig into Cell 4 ---
    210:
        m3_retain := TRUE;
        CASE sub_step OF
            0:
                station := 4;
                action := 2; // placement
                seq_counter := seq_counter + 1;
                couple_seq := seq_counter;
                b_target := 18000;
                sub_step := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    wait_cnt := 0;
                    sub_step := 2;
                END_IF;
            2:
                wait_cnt := wait_cnt + 1;
                IF (D413 = curr_id) OR (wait_cnt >= 5) THEN
                    b_target := 0;
                    sub_step := 3;
                END_IF;
            3:
                IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
                    action := 0;
                    station := 0;
                    step := 220;
                    gear_synced_time := 0;
                END_IF;
        END_CASE;

    // --- STEP 220: Cell 4 Synchronization & Processing ---
    220:
        m3_retain := TRUE;
        // Gear configuration
        m4_select := 1000; // ratio 1:1
        m4_configure := TRUE;
        m4_retain := TRUE;
        s4_0_target := D600;
        s4_1_target := D601;

        IF X75 THEN // Cell 4 result achieved
            step := 230;
        END_IF;

    // --- STEP 230: Return Cell 4 axes to initial posture (0) ---
    230:
        m3_retain := TRUE;
        m4_configure := FALSE;
        s4_0_target := 0;
        s4_1_target := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1032) <= 20 AND ABS(D1033) <= 100 AND X64 THEN
            step := 240;
            sub_step := 0;
        END_IF;

    // --- STEP 240: Extract jig from Cell 4 ---
    240:
        m3_retain := TRUE;
        CASE sub_step OF
            0:
                station := 4;
                action := 1; // extraction
                seq_counter := seq_counter + 1;
                couple_seq := seq_counter;
                b_target := 18000;
                sub_step := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    wait_cnt := 0;
                    sub_step := 2;
                END_IF;
            2:
                wait_cnt := wait_cnt + 1;
                IF (D90 = curr_id) OR (wait_cnt >= 5) THEN
                    b_target := 0;
                    sub_step := 3;
                END_IF;
            3:
                IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
                    action := 0;
                    station := 0;
                    m4_retain := FALSE;
                    step := 300; // Return to lift
                END_IF;
        END_CASE;

    // --- STEP 300: Shuttle moves back to original Lift ---
    300:
        IF curr_station = 1 THEN
            target_pos := D403;
        ELSE
            target_pos := D406;
        END_IF;
        a_target := target_pos;

        IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 THEN
            IF (curr_station = 1 AND X61) OR (curr_station = 2 AND X62) THEN
                step := 310;
                sub_step := 0;
            END_IF;
        END_IF;

    // --- STEP 310: Place jig back onto Lift ---
    310:
        CASE sub_step OF
            0:
                station := curr_station;
                action := 2; // placement
                seq_counter := seq_counter + 1;
                couple_seq := seq_counter;
                b_target := 18000;
                sub_step := 1;
            1:
                IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                    wait_cnt := 0;
                    sub_step := 2;
                END_IF;
            2:
                wait_cnt := wait_cnt + 1;
                IF ((curr_station = 1 AND D404 = curr_id) OR (curr_station = 2 AND D407 = curr_id)) OR (wait_cnt >= 5) THEN
                    b_target := 0;
                    sub_step := 3;
                END_IF;
            3:
                IF ABS(D1004 - 0) <= 20 AND ABS(D1005) <= 100 THEN
                    action := 0;
                    station := 0;
                    step := 320;
                END_IF;
        END_CASE;

    // --- STEP 320: Descend Lift to initial height (400 mm = 40000) ---
    320:
        IF curr_station = 1 THEN
            c_target := 40000;
            IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 THEN
                step := 330;
            END_IF;
        ELSE
            d_target := 40000;
            IF ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
                step := 330;
            END_IF;
        END_IF;

    // --- STEP 330: Ack request completion / cancellation ---
    330:
        IF active_req = 0 THEN
            D300 := curr_id;
            IF is_cancelled THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            req0_done := TRUE;
        ELSE
            D302 := curr_id;
            IF is_cancelled THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            req1_done := TRUE;
        END_IF;
        step := 0; // Back to check next request

    // --- STEP 900: Return all axes home and finish ---
    900:
        a_target := 0;
        b_target := 0;
        c_target := 40000;
        d_target := 40000;
        s3_1_target := 0;
        s3_2_target := 0;
        s4_0_target := 0;
        s4_1_target := 0;
        m3_retain := FALSE;
        m4_configure := FALSE;
        m4_retain := FALSE;

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1017) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM