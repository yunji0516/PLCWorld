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
    seq_cnt : DINT := 1;
    curr_req : INT := 0;
    curr_id : DINT := 0;
    curr_lift : DINT := 0;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    timer_cnt : INT := 0;
    is_cancelled : BOOL := FALSE;
    req_status : DINT := 1;

    shuttle_tgt : DINT := 0;
    fork_tgt : DINT := 0;
    lift_a_tgt : DINT := 40000;
    lift_b_tgt : DINT := 40000;
    s3_0_t : DINT := -60000;
    s3_1_t : DINT := -60000;
    s4_0_t : DINT := 0;
    s4_1_t : DINT := 0;
    s4_2_t : DINT := 0;

    c4_cw_f : REAL := 0.0;
    deg_to_rad : REAL := 0.017453292519943295;
    m4_0_rad : REAL := 0.0;
    m4_1_rad : REAL := 0.0;
    final_done : BOOL := FALSE;
END_VAR

// Set static drive rates and feeds
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

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 0;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 0;
Y30 := FALSE;

// Main state machine for handling requests sequentially
CASE step OF
    0: // Idle / Arbitrate request
        D80 := 0;
        D81 := 0;
        timer_cnt := 0;
        IF (D100 > 0) AND NOT req0_done THEN
            curr_req := 0;
            curr_id := D100;
            curr_lift := D101; // 1: Lift A, 2: Lift B
            IF curr_lift = 0 THEN
                curr_lift := 1;
            END_IF;
            is_cancelled := X31;
            IF is_cancelled THEN
                req_status := 2;
            ELSE
                req_status := 1;
            END_IF;
            step := 10;
        ELSIF (D120 > 0) AND NOT req1_done THEN
            curr_req := 1;
            curr_id := D120;
            curr_lift := D121; // 1: Lift A, 2: Lift B
            IF curr_lift = 0 THEN
                curr_lift := 2;
            END_IF;
            is_cancelled := X35;
            IF is_cancelled THEN
                req_status := 2;
            ELSE
                req_status := 1;
            END_IF;
            step := 10;
        ELSIF X51 AND ((D100 = 0) OR req0_done) AND ((D120 = 0) OR req1_done) THEN
            step := 900; // All done
        END_IF;

    10: // Align lift and move shuttle to lift docking position
        IF curr_lift = 1 THEN
            lift_a_tgt := D92;
            lift_b_tgt := D92; // Keep lifts level to avoid frame skew
            shuttle_tgt := D403;
        ELSE
            lift_a_tgt := D92;
            lift_b_tgt := D92;
            shuttle_tgt := D406;
        END_IF;
        fork_tgt := 0;
        IF (ABS(D1008 - lift_a_tgt) <= 20) AND (ABS(D1012 - lift_b_tgt) <= 20)
           AND (ABS(D1000 - shuttle_tgt) <= 20) AND (ABS(D1001) <= 100)
           AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 20;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    20: // Extend fork to retrieve jig from lift
        fork_tgt := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                // Couple action: 1: extraction
                D80 := 1;
                D81 := curr_lift;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                step := 30;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    30: // Wait for holding ownership transfer
        IF D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 40;
        END_IF;

    40: // Retract fork to 0 mm
        fork_tgt := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                IF is_cancelled THEN
                    step := 200; // Return directly if cancelled
                ELSE
                    step := 50; // Move to Cell 3
                END_IF;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    50: // Move shuttle to Cell 3 docking position, prep Cell 3 axes
        shuttle_tgt := D409;
        s3_0_t := -60000;
        s3_1_t := -60000;
        IF (ABS(D1000 - shuttle_tgt) <= 20) AND (ABS(D1001) <= 100)
           AND (ABS(D1016 - s3_0_t) <= 20) AND (ABS(D1020 - s3_1_t) <= 20) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 60;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    60: // Extend fork into Cell 3
        fork_tgt := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                D80 := 2; // Placement into Cell 3
                D81 := 3;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                step := 70;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    70: // Wait for Cell 3 capture
        IF D522 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 80;
        END_IF;

    80: // Retract fork
        fork_tgt := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 90;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    90: // Cell 3 operation: drive gantry to goal targets
        s3_0_t := D500;
        s3_1_t := D501;
        IF (ABS(D1016 - s3_0_t) <= 20) AND (ABS(D1020 - s3_1_t) <= 20)
           AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF (timer_cnt >= 5) OR X70 THEN // 80 ms hold
                timer_cnt := 0;
                step := 100;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    100: // Cell 3 return to home coordinates
        s3_0_t := -60000;
        s3_1_t := -60000;
        IF (ABS(D1016 - s3_0_t) <= 20) AND (ABS(D1020 - s3_1_t) <= 20)
           AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 110;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    110: // Extend fork to retrieve jig from Cell 3
        fork_tgt := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                D80 := 1; // Extraction from Cell 3
                D81 := 3;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                step := 120;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    120: // Wait for holding ownership transfer back to shuttle
        IF D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 130;
        END_IF;

    130: // Retract fork
        fork_tgt := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 140;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    140: // Move shuttle to Cell 4 docking position
        shuttle_tgt := D412;
        s4_0_t := 0;
        s4_1_t := 0;
        s4_2_t := 0;
        IF (ABS(D1000 - shuttle_tgt) <= 20) AND (ABS(D1001) <= 100)
           AND (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 150;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    150: // Extend fork into Cell 4
        fork_tgt := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                D80 := 2; // Placement into Cell 4
                D81 := 4;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                step := 160;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    160: // Wait for Cell 4 capture
        IF D622 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 170;
        END_IF;

    170: // Retract fork
        fork_tgt := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 180;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    180: // Cell 4 operation: drive incline heads and calculate counterweight
        s4_0_t := D600;
        s4_1_t := D601;
        // Interlocking counterweight x = -225*(sin(thetaA) + sin(thetaB))
        m4_0_rad := REAL(s4_0_t) * 0.01 * deg_to_rad;
        m4_1_rad := REAL(s4_1_t) * 0.01 * deg_to_rad;
        c4_cw_f := -225.0 * (SIN(m4_0_rad) + SIN(m4_1_rad));
        s4_2_t := DINT(c4_cw_f * 100.0);

        IF (ABS(D1024 - s4_0_t) <= 20) AND (ABS(D1028 - s4_1_t) <= 20) AND (ABS(D1032 - s4_2_t) <= 20)
           AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF (timer_cnt >= 5) OR X75 THEN // 80 ms hold
                timer_cnt := 0;
                step := 190;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    190: // Cell 4 return to home posture
        s4_0_t := 0;
        s4_1_t := 0;
        s4_2_t := 0;
        IF (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 20)
           AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 192;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    192: // Extend fork into Cell 4 to retrieve jig
        fork_tgt := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                D80 := 1; // Extraction from Cell 4
                D81 := 4;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                step := 194;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    194: // Wait for holding ownership transfer to shuttle
        IF D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 196;
        END_IF;

    196: // Retract fork
        fork_tgt := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 200; // Return to lift
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    200: // Return shuttle to original lift section docking position
        IF curr_lift = 1 THEN
            shuttle_tgt := D403;
            lift_a_tgt := D92;
            lift_b_tgt := D92;
        ELSE
            shuttle_tgt := D406;
            lift_a_tgt := D92;
            lift_b_tgt := D92;
        END_IF;
        IF (ABS(D1000 - shuttle_tgt) <= 20) AND (ABS(D1001) <= 100)
           AND (ABS(D1008 - lift_a_tgt) <= 20) AND (ABS(D1012 - lift_b_tgt) <= 20) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 210;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    210: // Extend fork to return jig to lift
        fork_tgt := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                D80 := 2; // Placement to lift
                D81 := curr_lift;
                D82 := seq_cnt;
                seq_cnt := seq_cnt + 1;
                step := 220;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    220: // Wait for holding release
        IF D90 = 0 THEN
            D80 := 0;
            D81 := 0;
            step := 230;
        END_IF;

    230: // Retract fork
        fork_tgt := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                step := 240;
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    240: // Lower lift to initial height (400 mm)
        lift_a_tgt := 40000;
        lift_b_tgt := 40000;
        IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20)
           AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
            timer_cnt := timer_cnt + 1;
            IF timer_cnt >= 3 THEN
                timer_cnt := 0;
                // Acknowledge request
                IF curr_req = 0 THEN
                    D300 := curr_id;
                    D301 := req_status;
                    req0_done := TRUE;
                ELSE
                    D302 := curr_id;
                    D303 := req_status;
                    req1_done := TRUE;
                END_IF;
                step := 0; // Return to check next request or completion
            END_IF;
        ELSE
            timer_cnt := 0;
        END_IF;

    900: // All requests finished, move all axes to initial home positions
        shuttle_tgt := 0;
        fork_tgt := 0;
        lift_a_tgt := 40000;
        lift_b_tgt := 40000;
        s3_0_t := -60000;
        s3_1_t := -60000;
        s4_0_t := 0;
        s4_1_t := 0;
        s4_2_t := 0;

        IF (ABS(D1000) <= 20) AND (ABS(D1004) <= 20)
           AND (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20)
           AND (ABS(D1016 - (-60000)) <= 20) AND (ABS(D1020 - (-60000)) <= 20)
           AND (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 20)
           AND (ABS(D1001) <= 100) AND (ABS(D1005) <= 100)
           AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
            final_done := TRUE;
        END_IF;
END_CASE;

// Drive outputs update
D2000 := shuttle_tgt;
D2004 := fork_tgt;
D2008 := lift_a_tgt;
D2012 := lift_b_tgt;
D2016 := s3_0_t;
D2020 := s3_1_t;
D2024 := s4_0_t;
D2028 := s4_1_t;
D2032 := s4_2_t;

Y2 := final_done;

END_PROGRAM
