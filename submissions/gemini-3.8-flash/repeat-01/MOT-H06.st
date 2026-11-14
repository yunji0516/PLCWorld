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
    D1036 : DINT;
    D1037 : DINT;
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
    D603 : DINT;
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
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
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

    (* Internal state variables *)
    step : DINT := 0;
    active_req : DINT := -1; (* 0 for ch0, 1 for ch1 *)
    req_id : DINT := 0;
    req_loc : DINT := 0;     (* 1 for Lift A, 2 for Lift B *)
    req_is_cancel : BOOL := FALSE;
    target_stn : DINT := 0;
    target_pos_x : DINT := 0;
    seq_counter : DINT := 1;
    timer_ms : DINT := 0;
    c3_timer_ms : DINT := 0;
    c4_timer_ms : DINT := 0;
    comp_timer_ms : DINT := 0;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;

    (* Initial home positions in 0.01 scale *)
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_C : DINT := 15000;
    HOME_D : DINT := 15000;
    HOME_S3_0 : DINT := 0;
    HOME_S3_1 : DINT := 5000;
    HOME_S4_0 : DINT := -6500;
    HOME_S4_1 : DINT := 0;
    HOME_S4_2 : DINT := 6500;
    HOME_S4_3 : DINT := 0;

    DOCK_HEIGHT : DINT := 73250;
    FORK_EXTEND : DINT := 18000;
    FORK_RETRACT : DINT := 0;
    RATE_STD : DINT := 800;
    TOL_POS : DINT := 20;  (* 0.20 mm in 0.01 scale *)
    TOL_VEL : DINT := 100; (* 1.00 mm/s in 0.01 scale *)
END_VAR

(* 1. Default drive outputs *)
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;
Y49 := TRUE;

D2001 := RATE_STD;
D2005 := RATE_STD;
D2009 := RATE_STD;
D2013 := RATE_STD;
D2017 := RATE_STD;
D2021 := RATE_STD;
D2025 := RATE_STD;
D2029 := RATE_STD;
D2033 := RATE_STD;
D2037 := RATE_STD;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;
D2038 := 0;

(* Cell auxiliary control defaults *)
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

(* 2. Main State Machine *)
CASE step OF
    0: (* Idle: Look for active requests *)
        D2000 := HOME_A;
        D2004 := HOME_B;
        D2008 := HOME_C;
        D2012 := HOME_D;
        D2016 := HOME_S3_0;
        D2020 := HOME_S3_1;
        D2024 := HOME_S4_0;
        D2028 := HOME_S4_1;
        D2032 := HOME_S4_2;
        D2036 := HOME_S4_3;
        D80 := 0;
        D81 := 0;

        IF (D100 > 0) AND (NOT req0_done) THEN
            active_req := 0;
            req_id := D100;
            req_loc := D101;
            req_is_cancel := X31;
            step := 10;
        ELSIF (D120 > 0) AND (NOT req1_done) THEN
            active_req := 1;
            req_id := D120;
            req_loc := D121;
            req_is_cancel := X35;
            step := 10;
        ELSIF X51 THEN
            step := 900; (* All requests finished *)
        END_IF;

    10: (* Preparation: Move lift to docking height and shuttle to station *)
        target_stn := req_loc;
        IF target_stn = 1 THEN
            target_pos_x := D403;
            D2008 := DOCK_HEIGHT;
            D2012 := HOME_D;
        ELSE
            target_pos_x := D406;
            D2008 := HOME_C;
            D2012 := DOCK_HEIGHT;
        END_IF;
        D2000 := target_pos_x;
        D2004 := FORK_RETRACT;

        (* Check if lift and shuttle have arrived *)
        IF ABS(D1000 - target_pos_x) <= TOL_POS AND ABS(D1001) <= TOL_VEL THEN
            IF (target_stn = 1 AND ABS(D1008 - DOCK_HEIGHT) <= TOL_POS AND ABS(D1009) <= TOL_VEL AND X61) OR
               (target_stn = 2 AND ABS(D1012 - DOCK_HEIGHT) <= TOL_POS AND ABS(D1013) <= TOL_VEL AND X62) THEN
                D80 := 1; (* 1: extraction *)
                D81 := target_stn;
                D82 := seq_counter;
                seq_counter := seq_counter + 1;
                step := 20;
            END_IF;
        END_IF;

    20: (* Extend connection fork to extract fixture *)
        D2004 := FORK_EXTEND;
        IF ABS(D1004 - FORK_EXTEND) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 25;
        END_IF;

    25: (* Retract connection fork back onto shuttle *)
        D2004 := FORK_RETRACT;
        IF ABS(D1004 - FORK_RETRACT) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            IF req_is_cancel THEN
                step := 200; (* Return fixture to original lift *)
            ELSE
                step := 30;  (* Proceed to Cell 3 *)
            END_IF;
        END_IF;

    30: (* Move shuttle to Cell 3 *)
        target_stn := 3;
        target_pos_x := D409;
        D2000 := target_pos_x;
        D2004 := FORK_RETRACT;
        D2008 := HOME_C;
        D2012 := HOME_D;

        IF ABS(D1000 - target_pos_x) <= TOL_POS AND ABS(D1001) <= TOL_VEL AND X63 THEN
            D80 := 2; (* 2: placement into cell 3 *)
            D81 := 3;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            step := 40;
        END_IF;

    40: (* Extend fork to place fixture in Cell 3 *)
        D2004 := FORK_EXTEND;
        IF ABS(D1004 - FORK_EXTEND) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 45;
        END_IF;

    45: (* Retract fork from Cell 3 *)
        D2004 := FORK_RETRACT;
        IF ABS(D1004 - FORK_RETRACT) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 50;
            c3_timer_ms := 0;
        END_IF;

    50: (* Cell 3 Operation: Rotate table to m3_goal0 while slide <= 500 mm *)
        D2016 := D500;
        D2020 := HOME_S3_1; (* Slide at 50 mm *)
        IF ABS(D1016 - D500) <= TOL_POS AND ABS(D1017) <= TOL_VEL THEN
            step := 55;
        END_IF;

    55: (* Cell 3 Operation: Approach to 700 mm (70000) *)
        D2020 := 70000;
        IF ABS(D1020 - 70000) <= TOL_POS AND ABS(D1021) <= TOL_VEL THEN
            c3_timer_ms := c3_timer_ms + 20;
            IF c3_timer_ms >= 100 OR X70 THEN
                step := 60;
            END_IF;
        ELSE
            c3_timer_ms := 0;
        END_IF;

    60: (* Cell 3 Operation: Retract slide to initial 50 mm *)
        D2020 := HOME_S3_1;
        IF ABS(D1020 - HOME_S3_1) <= TOL_POS AND ABS(D1021) <= TOL_VEL THEN
            step := 65;
        END_IF;

    65: (* Cell 3 Operation: Return rotation to 0 deg *)
        D2016 := HOME_S3_0;
        IF ABS(D1016 - HOME_S3_0) <= TOL_POS AND ABS(D1017) <= TOL_VEL THEN
            step := 70;
        END_IF;

    70: (* Retract fixture from Cell 3 back to shuttle *)
        D80 := 1; (* Extraction *)
        D81 := 3;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        step := 75;

    75: (* Extend fork to grasp fixture *)
        D2004 := FORK_EXTEND;
        IF ABS(D1004 - FORK_EXTEND) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 80;
        END_IF;

    80: (* Retract fork onto shuttle *)
        D2004 := FORK_RETRACT;
        IF ABS(D1004 - FORK_RETRACT) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 90; (* Proceed to Cell 4 *)
        END_IF;

    90: (* Move shuttle to Cell 4 *)
        target_stn := 4;
        target_pos_x := D412;
        D2000 := target_pos_x;
        D2004 := FORK_RETRACT;

        IF ABS(D1000 - target_pos_x) <= TOL_POS AND ABS(D1001) <= TOL_VEL AND X64 THEN
            D80 := 2; (* Placement into cell 4 *)
            D81 := 4;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            step := 100;
        END_IF;

    100: (* Extend fork into Cell 4 *)
        D2004 := FORK_EXTEND;
        IF ABS(D1004 - FORK_EXTEND) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 105;
        END_IF;

    105: (* Retract fork from Cell 4 *)
        D2004 := FORK_RETRACT;
        IF ABS(D1004 - FORK_RETRACT) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 110;
            c4_timer_ms := 0;
        END_IF;

    110: (* Cell 4: Swivel twin booms to m4_goal0/m4_goal2 while booms <= 80 mm *)
        D2028 := HOME_S4_1; (* 0 mm *)
        D2036 := HOME_S4_3; (* 0 mm *)
        D2024 := D600;
        D2032 := D602;

        IF ABS(D1024 - D600) <= TOL_POS AND ABS(D1025) <= TOL_VEL AND
           ABS(D1032 - D602) <= TOL_POS AND ABS(D1033) <= TOL_VEL THEN
            step := 115;
        END_IF;

    115: (* Cell 4: Extend booms to m4_goal1/m4_goal3 *)
        D2028 := D601;
        D2036 := D603;

        IF ABS(D1028 - D601) <= TOL_POS AND ABS(D1029) <= TOL_VEL AND
           ABS(D1036 - D603) <= TOL_POS AND ABS(D1037) <= TOL_VEL THEN
            c4_timer_ms := c4_timer_ms + 20;
            IF c4_timer_ms >= 100 OR X75 THEN
                step := 120;
            END_IF;
        ELSE
            c4_timer_ms := 0;
        END_IF;

    120: (* Cell 4: Retract booms to 0 mm *)
        D2028 := HOME_S4_1;
        D2036 := HOME_S4_3;

        IF ABS(D1028 - HOME_S4_1) <= TOL_POS AND ABS(D1029) <= TOL_VEL AND
           ABS(D1036 - HOME_S4_3) <= TOL_POS AND ABS(D1037) <= TOL_VEL THEN
            step := 125;
        END_IF;

    125: (* Cell 4: Return angles to initial posture *)
        D2024 := HOME_S4_0;
        D2032 := HOME_S4_2;

        IF ABS(D1024 - HOME_S4_0) <= TOL_POS AND ABS(D1025) <= TOL_VEL AND
           ABS(D1032 - HOME_S4_2) <= TOL_POS AND ABS(D1033) <= TOL_VEL THEN
            step := 130;
        END_IF;

    130: (* Retract fixture from Cell 4 *)
        D80 := 1; (* Extraction *)
        D81 := 4;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        step := 135;

    135: (* Extend fork into Cell 4 *)
        D2004 := FORK_EXTEND;
        IF ABS(D1004 - FORK_EXTEND) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 140;
        END_IF;

    140: (* Retract fork onto shuttle *)
        D2004 := FORK_RETRACT;
        IF ABS(D1004 - FORK_RETRACT) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 200; (* Return to original elevator *)
        END_IF;

    200: (* Move shuttle back to original elevator position *)
        target_stn := req_loc;
        IF target_stn = 1 THEN
            target_pos_x := D403;
            D2008 := DOCK_HEIGHT;
            D2012 := HOME_D;
        ELSE
            target_pos_x := D406;
            D2008 := HOME_C;
            D2012 := DOCK_HEIGHT;
        END_IF;
        D2000 := target_pos_x;
        D2004 := FORK_RETRACT;

        IF ABS(D1000 - target_pos_x) <= TOL_POS AND ABS(D1001) <= TOL_VEL THEN
            IF (target_stn = 1 AND ABS(D1008 - DOCK_HEIGHT) <= TOL_POS AND ABS(D1009) <= TOL_VEL AND X61) OR
               (target_stn = 2 AND ABS(D1012 - DOCK_HEIGHT) <= TOL_POS AND ABS(D1013) <= TOL_VEL AND X62) THEN
                D80 := 2; (* Placement back to elevator *)
                D81 := target_stn;
                D82 := seq_counter;
                seq_counter := seq_counter + 1;
                step := 210;
            END_IF;
        END_IF;

    210: (* Extend fork to deliver fixture back to elevator *)
        D2004 := FORK_EXTEND;
        IF ABS(D1004 - FORK_EXTEND) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 215;
        END_IF;

    215: (* Retract fork onto shuttle *)
        D2004 := FORK_RETRACT;
        IF ABS(D1004 - FORK_RETRACT) <= TOL_POS AND ABS(D1005) <= TOL_VEL THEN
            step := 220;
        END_IF;

    220: (* Descend elevator to initial height *)
        IF target_stn = 1 THEN
            D2008 := HOME_C;
        ELSE
            D2012 := HOME_D;
        END_IF;

        IF (target_stn = 1 AND ABS(D1008 - HOME_C) <= TOL_POS AND ABS(D1009) <= TOL_VEL) OR
           (target_stn = 2 AND ABS(D1012 - HOME_D) <= TOL_POS AND ABS(D1013) <= TOL_VEL) THEN
            (* Acknowledge completion or cancel retrieval *)
            IF active_req = 0 THEN
                D300 := req_id;
                IF req_is_cancel THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                req0_done := TRUE;
            ELSIF active_req = 1 THEN
                D302 := req_id;
                IF req_is_cancel THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                req1_done := TRUE;
            END_IF;
            step := 0; (* Return to idle *)
        END_IF;

    900: (* Final completion check *)
        D2000 := HOME_A;
        D2004 := HOME_B;
        D2008 := HOME_C;
        D2012 := HOME_D;
        D2016 := HOME_S3_0;
        D2020 := HOME_S3_1;
        D2024 := HOME_S4_0;
        D2028 := HOME_S4_1;
        D2032 := HOME_S4_2;
        D2036 := HOME_S4_3;

        IF ABS(D1000 - HOME_A) <= TOL_POS AND ABS(D1001) <= TOL_VEL AND
           ABS(D1004 - HOME_B) <= TOL_POS AND ABS(D1005) <= TOL_VEL AND
           ABS(D1008 - HOME_C) <= TOL_POS AND ABS(D1009) <= TOL_VEL AND
           ABS(D1012 - HOME_D) <= TOL_POS AND ABS(D1013) <= TOL_VEL AND
           ABS(D1016 - HOME_S3_0) <= TOL_POS AND ABS(D1017) <= TOL_VEL AND
           ABS(D1020 - HOME_S3_1) <= TOL_POS AND ABS(D1021) <= TOL_VEL AND
           ABS(D1024 - HOME_S4_0) <= TOL_POS AND ABS(D1025) <= TOL_VEL AND
           ABS(D1028 - HOME_S4_1) <= TOL_POS AND ABS(D1029) <= TOL_VEL AND
           ABS(D1032 - HOME_S4_2) <= TOL_POS AND ABS(D1033) <= TOL_VEL AND
           ABS(D1036 - HOME_S4_3) <= TOL_POS AND ABS(D1037) <= TOL_VEL THEN
            comp_timer_ms := comp_timer_ms + 20;
            IF comp_timer_ms >= 100 THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            comp_timer_ms := 0;
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM