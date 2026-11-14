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

    step : DINT := 0;
    curr_req : DINT := 0;
    curr_station : DINT := 0;
    is_cancelled : BOOL := FALSE;
    next_seq : DINT := 1;
    timer_cnt : DINT := 0;
    sync_cnt : DINT := 0;
    all_done_latch : BOOL := FALSE;
    obs_cnt : DINT := 0;

    c_lift_target : DINT := 40000;
    d_lift_target : DINT := 40000;
    a_shuttle_target : DINT := 0;
    b_fork_target : DINT := 0;

    s3_1_tgt : DINT := 0;
    s3_2_tgt : DINT := 0;
    s4_0_tgt : DINT := 0;
    s4_1_tgt : DINT := 0;

    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    req_ratio : DINT := 700;
END_VAR

// Scan 0 initialization
IF step = 0 THEN
    D2001 := 1000; // a_rate
    D2005 := 1000; // b_rate
    D2009 := 1000; // c_rate
    D2013 := 1000; // d_rate
    D2017 := 1000; // s3_0_rate
    D2021 := 1000; // s3_1_rate
    D2025 := 1000; // s3_2_rate
    D2029 := 1000; // s4_0_rate
    D2033 := 1000; // s4_1_rate

    D2000 := 0;     // a_target
    D2004 := 0;     // b_target
    D2008 := 40000; // c_target
    D2012 := 40000; // d_target
    D2016 := 0;
    D2020 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;

    Y40 := TRUE;
    Y41 := TRUE;
    Y42 := TRUE;
    Y43 := TRUE;
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    Y47 := TRUE;
    Y48 := TRUE;

    c_lift_target := 40000;
    d_lift_target := 40000;
    step := 1;
END_IF;

IF X51 THEN
    all_done_latch := TRUE;
END_IF;

// Master state machine
CASE step OF
    1: // Idle: wait for request
        IF NOT r0_done AND (D100 <> 0 OR X31) THEN
            curr_req := 0;
            curr_station := 1;
            is_cancelled := X31;
            c_lift_target := D92;
            step := 10;
        ELSIF NOT r1_done AND (D120 <> 0 OR X35) THEN
            curr_req := 1;
            curr_station := 2;
            is_cancelled := X35;
            d_lift_target := D92;
            step := 10;
        ELSIF all_done_latch OR (r0_done AND r1_done) THEN
            step := 900;
        END_IF;

    10: // Raise lift to docking height
        IF curr_station = 1 THEN
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 12;
            END_IF;
        ELSE
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 12;
            END_IF;
        END_IF;

    12: // Move shuttle to lift station
        IF curr_station = 1 THEN
            a_shuttle_target := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                step := 20;
            END_IF;
        ELSE
            a_shuttle_target := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                step := 20;
            END_IF;
        END_IF;

    20: // Handshake: couple jig from lift (Action 1 = extraction)
        D80 := 1;
        D81 := curr_station;
        D82 := next_seq;
        next_seq := next_seq + 1;
        b_fork_target := 18000;
        step := 21;

    21: // Wait for fork extended
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            b_fork_target := 0;
            step := 22;
        END_IF;

    22: // Wait for fork retracted with jig
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            IF is_cancelled THEN
                step := 200; // Return immediately
            ELSE
                step := 30;  // Proceed to Cell 3
            END_IF;
        END_IF;

    30: // Move shuttle to Cell 3
        a_shuttle_target := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            step := 40;
        END_IF;

    40: // Handshake: place jig into Cell 3 (Action 2 = placement)
        D80 := 2;
        D81 := 3;
        D82 := next_seq;
        next_seq := next_seq + 1;
        b_fork_target := 18000;
        step := 41;

    41: // Fork extended
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            b_fork_target := 0;
            step := 42;
        END_IF;

    42: // Fork retracted, jig left in Cell 3
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            s3_1_tgt := D501;
            s3_2_tgt := D502;
            step := 50;
        END_IF;

    50: // Cell 3 working: wait for cell result (X70)
        IF X70 THEN
            // Cell 3 complete, return axes to home (0) before docking
            s3_1_tgt := 0;
            s3_2_tgt := 0;
            step := 52;
        END_IF;

    52: // Wait for Cell 3 axes at home and stopped
        IF ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND X63 THEN
            step := 60;
        END_IF;

    60: // Handshake: retrieve jig from Cell 3 (Action 1 = extraction)
        D80 := 1;
        D81 := 3;
        D82 := next_seq;
        next_seq := next_seq + 1;
        b_fork_target := 18000;
        step := 61;

    61: // Fork extended
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            b_fork_target := 0;
            step := 62;
        END_IF;

    62: // Fork retracted with jig
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 70; // Move to Cell 4
        END_IF;

    70: // Move shuttle to Cell 4
        a_shuttle_target := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            step := 80;
        END_IF;

    80: // Handshake: place jig into Cell 4 (Action 2 = placement)
        D80 := 2;
        D81 := 4;
        D82 := next_seq;
        next_seq := next_seq + 1;
        b_fork_target := 18000;
        step := 81;

    81: // Fork extended
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            b_fork_target := 0;
            step := 82;
        END_IF;

    82: // Fork retracted, jig left in Cell 4
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            // Configure electronic gear
            req_ratio := 700;
            IF D600 <> 0 AND D601 <> 0 THEN
                req_ratio := (D601 * 1000) / D600;
            END_IF;
            D710 := req_ratio;
            D711 := D626;
            D712 := 3000;
            Y75 := TRUE; // m4_configure
            Y76 := TRUE; // m4_retain
            s4_0_tgt := D600;
            s4_1_tgt := D601;
            sync_cnt := 0;
            step := 90;
        END_IF;

    90: // Cell 4 gear synchronization and rotation
        // Check sync conditions: master moving (|vel| > 1 deg/s = 100),
        // angle error <= 0.2 deg (20), speed error <= 1 deg/s (100)
        IF ABS(D1029) > 100 AND
           ABS(D1032 - (D1028 * req_ratio) / 1000) <= 20 AND
           ABS(D1033 - (D1029 * req_ratio) / 1000) <= 100 THEN
            sync_cnt := sync_cnt + 1;
        ELSE
            sync_cnt := 0;
        END_IF;
        IF X75 THEN // Cell 4 result achieved!
            Y75 := FALSE;
            s4_0_tgt := 0;
            s4_1_tgt := 0;
            step := 92;
        END_IF;

    92: // Wait for Cell 4 axes returned to home posture (0) and stopped
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 AND X64 THEN
            step := 100;
        END_IF;

    100: // Handshake: retrieve jig from Cell 4 (Action 1 = extraction)
        D80 := 1;
        D81 := 4;
        D82 := next_seq;
        next_seq := next_seq + 1;
        b_fork_target := 18000;
        step := 101;

    101: // Fork extended
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            b_fork_target := 0;
            step := 102;
        END_IF;

    102: // Fork retracted with jig
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 200; // Return to lift
        END_IF;

    200: // Move shuttle back to original lift station
        IF curr_station = 1 THEN
            a_shuttle_target := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                step := 210;
            END_IF;
        ELSE
            a_shuttle_target := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                step := 210;
            END_IF;
        END_IF;

    210: // Handshake: place jig back onto lift (Action 2 = placement)
        D80 := 2;
        D81 := curr_station;
        D82 := next_seq;
        next_seq := next_seq + 1;
        b_fork_target := 18000;
        step := 211;

    211: // Fork extended
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            b_fork_target := 0;
            step := 212;
        END_IF;

    212: // Fork retracted, jig back on lift
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            IF curr_station = 1 THEN
                c_lift_target := 40000; // Return lift A to initial height 400 mm
            ELSE
                d_lift_target := 40000; // Return lift B to initial height 400 mm
            END_IF;
            step := 220;
        END_IF;

    220: // Wait for lift back at initial height (400 mm = 40000)
        IF curr_station = 1 THEN
            IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 THEN
                D300 := D100;
                IF is_cancelled THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                r0_done := TRUE;
                step := 1; // Check next request
            END_IF;
        ELSE
            IF ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
                D302 := D120;
                IF is_cancelled THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                r1_done := TRUE;
                step := 1; // Check next request
            END_IF;
        END_IF;

    900: // Return all mechanisms to home/initial posture
        a_shuttle_target := 0;
        b_fork_target := 0;
        c_lift_target := 40000;
        d_lift_target := 40000;
        s3_1_tgt := 0;
        s3_2_tgt := 0;
        s4_0_tgt := 0;
        s4_1_tgt := 0;
        Y71 := FALSE; // Stop common motor for final completion
        Y76 := FALSE;
        Y75 := FALSE;
        step := 910;

    910: // Verify all axes at home and stopped
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 AND
           ABS(D1017) <= 100 THEN
            Y2 := TRUE; // Completion declared!
            obs_cnt := 0;
            step := 920;
        END_IF;

    920: // Observation hold: 100 ms (5 scans at 20 ms)
        Y2 := TRUE;
        obs_cnt := obs_cnt + 1;
        IF obs_cnt >= 6 THEN
            step := 930;
        END_IF;

    930: // Completed
        Y2 := TRUE;
END_CASE;

// Cell 3 common motor control:
// Must be kept at 200 deg/s when entering cell 4 until cell result,
// and kept running when needed for return motion. Stop at final completion.
IF step >= 70 AND step <= 102 THEN
    Y71 := TRUE; // m3_retain
ELSIF step >= 900 THEN
    Y71 := FALSE;
END_IF;

// Drive outputs update
D2000 := a_shuttle_target;
D2004 := b_fork_target;
D2008 := c_lift_target;
D2012 := d_lift_target;

D2020 := s3_1_tgt;
D2024 := s3_2_tgt;
D2028 := s4_0_tgt;
D2032 := s4_1_tgt;

END_PROGRAM
```