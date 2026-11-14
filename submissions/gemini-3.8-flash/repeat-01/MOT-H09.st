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
    curr_ch : INT := -1;
    active_id : DINT := 0;
    active_station : DINT := 1;
    active_pocket : INT := 1;
    seq_cnt : DINT := 0;

    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;

    settle_cnt : INT := 0;
    res_cnt : INT := 0;

    target_dock : DINT := 73250;
    target_st_x : DINT := 0;
END_VAR

// Initial target clamps and defaults
IF step = 0 THEN
    D2000 := 0;
    D2001 := 1000;
    D2002 := 0;
    Y40 := TRUE;

    D2004 := 0;
    D2005 := 1000;
    D2006 := 0;
    Y41 := TRUE;

    D2008 := 15000;
    D2009 := 1000;
    D2010 := 0;
    Y42 := TRUE;

    D2012 := 15000;
    D2013 := 1000;
    D2014 := 0;
    Y43 := TRUE;

    D2016 := 0;
    D2017 := 1000;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := 0;
    D2021 := 1000;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := 0;
    D2025 := 1000;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := 0;
    D2029 := 1000;
    D2030 := 0;
    Y47 := TRUE;

    D2032 := 5000;
    D2033 := 1000;
    D2034 := 0;
    Y48 := TRUE;

    Y30 := FALSE;
    D80 := 0;
    D81 := 0;
    D82 := 0;
    step := 1;
END_IF;

// Main request selection and state machine
CASE step OF
    1: // Idle: check for pending requests
        IF D92 <> 0 THEN
            target_dock := D92;
        END_IF;

        IF (D100 <> 0) AND (NOT r0_done) AND (D300 = 0) THEN
            curr_ch := 0;
            active_id := D100;
            active_station := 1; // Lift A
            active_pocket := 1;
            step := 10;
        ELSIF (D120 <> 0) AND (NOT r1_done) AND (D302 = 0) THEN
            curr_ch := 1;
            active_id := D120;
            active_station := 2; // Lift B
            active_pocket := 2;
            step := 10;
        ELSIF X51 OR (r0_done AND r1_done) THEN
            step := 100; // All done, final home check
        END_IF;

    // --- STEP 1: PREPARE LIFT ---
    10: // Move Lift to Docking Height
        IF active_station = 1 THEN
            D2008 := target_dock;
            IF (ABS(D1008 - target_dock) <= 20) AND (ABS(D1009) <= 100) THEN
                step := 12;
            END_IF;
        ELSE
            D2012 := target_dock;
            IF (ABS(D1012 - target_dock) <= 20) AND (ABS(D1013) <= 100) THEN
                step := 12;
            END_IF;
        END_IF;

    12: // Move Shuttle A to Lift Station
        IF active_station = 1 THEN
            target_st_x := D403;
            IF target_st_x = 0 THEN target_st_x := -360000; END_IF;
        ELSE
            target_st_x := D406;
            IF target_st_x = 0 THEN target_st_x := -230000; END_IF;
        END_IF;
        D2000 := target_st_x;

        IF (ABS(D1000 - target_st_x) <= 20) AND (ABS(D1001) <= 100) THEN
            step := 14;
        END_IF;

    14: // Extend Connection Fork (180 mm = 18000) to extract jig
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 1; // Extract
            D81 := active_station;
            D82 := seq_cnt;
            settle_cnt := 0;
            step := 16;
        END_IF;

    16: // Settle and retract fork
        settle_cnt := settle_cnt + 1;
        IF settle_cnt >= 4 THEN
            D2004 := 0;
            IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                D80 := 0;
                D81 := 0;
                step := 20;
            END_IF;
        END_IF;

    // --- STEP 2: MOVE TO CELL 3 ---
    20: // Move Shuttle to Station 3
        target_st_x := D409;
        IF target_st_x = 0 THEN target_st_x := 490000; END_IF;
        D2000 := target_st_x;

        IF (ABS(D1000 - target_st_x) <= 20) AND (ABS(D1001) <= 100) THEN
            step := 22;
        END_IF;

    22: // Select Pocket and Extend Fork to Station 3
        D700 := INT_TO_DINT(active_pocket);
        Y70 := TRUE;
        D2004 := 18000;

        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 2; // Placement
            D81 := 3;
            D82 := seq_cnt;
            settle_cnt := 0;
            step := 24;
        END_IF;

    24: // Retract fork, activate pocket axis
        settle_cnt := settle_cnt + 1;
        IF settle_cnt >= 4 THEN
            D2004 := 0;
            IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                D80 := 0;
                D81 := 0;
                step := 26;
            END_IF;
        END_IF;

    26: // Move pocket axis to target
        IF active_pocket = 1 THEN
            IF D501 <> 0 THEN D2020 := D501; ELSE D2020 := 30000; END_IF;
            IF (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100) THEN
                res_cnt := 0;
                step := 28;
            END_IF;
        ELSE
            IF D502 <> 0 THEN D2024 := D502; ELSE D2024 := 30000; END_IF;
            IF (ABS(D1024 - D2024) <= 20) AND (ABS(D1025) <= 100) THEN
                res_cnt := 0;
                step := 28;
            END_IF;
        END_IF;

    28: // Maintain actual result for 80 ms (4 scans) or wait for X70
        res_cnt := res_cnt + 1;
        IF (res_cnt >= 5) OR X70 THEN
            // Retract pocket axis to 0
            IF active_pocket = 1 THEN D2020 := 0; ELSE D2024 := 0; END_IF;
            step := 30;
        END_IF;

    30: // Wait pocket axis return to 0
        IF (active_pocket = 1 AND ABS(D1020) <= 20 AND ABS(D1021) <= 100) OR
           (active_pocket = 2 AND ABS(D1024) <= 20 AND ABS(D1025) <= 100) THEN
            Y70 := FALSE;
            step := 32;
        END_IF;

    32: // Re-extract jig from Cell 3 to Shuttle
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 1; // Extract
            D81 := 3;
            D82 := seq_cnt;
            settle_cnt := 0;
            step := 34;
        END_IF;

    34: // Retract fork
        settle_cnt := settle_cnt + 1;
        IF settle_cnt >= 4 THEN
            D2004 := 0;
            IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                D80 := 0;
                D81 := 0;
                step := 40;
            END_IF;
        END_IF;

    // --- STEP 3: MOVE TO CELL 4 ---
    40: // Move Shuttle to Station 4
        target_st_x := D412;
        IF target_st_x = 0 THEN target_st_x := 1140000; END_IF;
        D2000 := target_st_x;

        IF (ABS(D1000 - target_st_x) <= 20) AND (ABS(D1001) <= 100) THEN
            step := 42;
        END_IF;

    42: // Extend Fork to place into Cell 4
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 2; // Placement
            D81 := 4;
            D82 := seq_cnt;
            settle_cnt := 0;
            step := 44;
        END_IF;

    44: // Retract fork
        settle_cnt := settle_cnt + 1;
        IF settle_cnt >= 4 THEN
            D2004 := 0;
            IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                D80 := 0;
                D81 := 0;
                step := 46;
            END_IF;
        END_IF;

    46: // Ensure Cell 4 slide is at or below 500 mm (50000) before rotate
        D2032 := 5000; // Initial slide is 50 mm (5000)
        IF (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100) THEN
            // Rotate s4_0 to requested angle
            IF D600 <> 0 THEN D2028 := D600; ELSE D2028 := 9000; END_IF;
            step := 48;
        END_IF;

    48: // Wait for rotation complete
        IF (ABS(D1028 - D2028) <= 20) AND (ABS(D1029) <= 100) THEN
            // Approach slide to 700 mm (70000)
            IF D601 <> 0 THEN D2032 := D601; ELSE D2032 := 70000; END_IF;
            step := 50;
        END_IF;

    50: // Wait for slide approach to arrive
        IF (ABS(D1032 - D2032) <= 20) AND (ABS(D1033) <= 100) THEN
            res_cnt := 0;
            step := 52;
        END_IF;

    52: // Maintain actual result for 80 ms (4 scans) or wait for X75
        res_cnt := res_cnt + 1;
        IF (res_cnt >= 5) OR X75 THEN
            // Return slide to 50 mm (5000)
            D2032 := 5000;
            step := 54;
        END_IF;

    54: // Wait slide back to 50 mm, then rotate back to 0 deg
        IF (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100) THEN
            D2028 := 0;
            step := 56;
        END_IF;

    56: // Wait rotation back to 0 deg
        IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) THEN
            step := 58;
        END_IF;

    58: // Re-extract jig from Cell 4
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 1; // Extract
            D81 := 4;
            D82 := seq_cnt;
            settle_cnt := 0;
            step := 60;
        END_IF;

    60: // Retract fork
        settle_cnt := settle_cnt + 1;
        IF settle_cnt >= 4 THEN
            D2004 := 0;
            IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                D80 := 0;
                D81 := 0;
                step := 70;
            END_IF;
        END_IF;

    // --- STEP 4: RETURN TO ORIGINAL LIFT ---
    70: // Move Shuttle back to Lift Station
        IF active_station = 1 THEN
            target_st_x := D403;
            IF target_st_x = 0 THEN target_st_x := -360000; END_IF;
        ELSE
            target_st_x := D406;
            IF target_st_x = 0 THEN target_st_x := -230000; END_IF;
        END_IF;
        D2000 := target_st_x;

        IF (ABS(D1000 - target_st_x) <= 20) AND (ABS(D1001) <= 100) THEN
            step := 72;
        END_IF;

    72: // Extend Fork to place into Lift
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 2; // Placement
            D81 := active_station;
            D82 := seq_cnt;
            settle_cnt := 0;
            step := 74;
        END_IF;

    74: // Retract fork
        settle_cnt := settle_cnt + 1;
        IF settle_cnt >= 4 THEN
            D2004 := 0;
            IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
                D80 := 0;
                D81 := 0;
                step := 76;
            END_IF;
        END_IF;

    76: // Descend Lift to initial height 150 mm (15000)
        IF active_station = 1 THEN
            D2008 := 15000;
            IF (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) THEN
                step := 78;
            END_IF;
        ELSE
            D2012 := 15000;
            IF (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
                step := 78;
            END_IF;
        END_IF;

    78: // Acknowledge completion of request
        IF curr_ch = 0 THEN
            D300 := active_id;
            IF X31 THEN D301 := 2; ELSE D301 := 1; END_IF;
            r0_done := TRUE;
        ELSE
            D302 := active_id;
            IF X35 THEN D303 := 2; ELSE D303 := 1; END_IF;
            r1_done := TRUE;
        END_IF;
        step := 1; // Check next request

    // --- STEP 5: FINAL HOMING AND COMPLETION ---
    100: // Ensure all axes are at home coordinates
        D2000 := 0;     // Shuttle X -> 0
        D2004 := 0;     // Fork -> 0
        D2008 := 15000; // Lift A -> 150 mm
        D2012 := 15000; // Lift B -> 150 mm
        D2016 := 0;     // s3_0 -> 0
        D2020 := 0;     // s3_1 -> 0
        D2024 := 0;     // s3_2 -> 0
        D2028 := 0;     // s4_0 -> 0 deg
        D2032 := 5000;  // s4_1 -> 50 mm

        IF (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
           (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
           (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032 - 5000) <= 20) AND (ABS(D1033) <= 100) THEN
            settle_cnt := 0;
            step := 110;
        END_IF;

    110: // Assert completion
        Y2 := TRUE;
END_CASE;

END_PROGRAM