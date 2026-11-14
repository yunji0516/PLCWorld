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

    (* Internal state variables *)
    step : INT := 0;
    active_req : INT := 0; (* 0: none, 1: req0, 2: req1 *)
    current_req_id : DINT := 0;
    origin_station : DINT := 0;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    seq_counter : DINT := 1;
    step_timer : DINT := 0;
    all_finished : BOOL := FALSE;

    (* Cell 4 counterweight calculation temporary *)
    theta_A_rad : REAL;
    theta_B_rad : REAL;
    s4_cw_x : REAL;
    s4_cw_target : DINT;
END_VAR

(* Default continuous axis enables and rates *)
Y40 := TRUE; (* shuttle A *)
D2001 := 1000;
D2002 := 0;

Y41 := TRUE; (* fork B *)
D2005 := 1000;
D2006 := 0;

Y42 := TRUE; (* lift A (C) *)
D2009 := 1000;
D2010 := 0;

Y43 := TRUE; (* lift B (D) *)
D2013 := 1000;
D2014 := 0;

Y44 := TRUE; (* cell 3 axis 0 *)
D2017 := 1000;
D2018 := 0;

Y45 := TRUE; (* cell 3 axis 1 *)
D2021 := 1000;
D2022 := 0;

Y46 := TRUE; (* cell 4 axis 0 *)
D2025 := 1000;
D2026 := 0;

Y47 := TRUE; (* cell 4 axis 1 *)
D2029 := 1000;
D2030 := 0;

Y48 := TRUE; (* cell 4 axis 2 (counterweight) *)
D2033 := 1000;
D2034 := 0;

(* Cell 4 continuous balance counterweight calculation *)
(* Formula: moment = 0 => x = -225 * (sin(thetaA) + sin(thetaB)) in mm *)
(* Angles are in degrees: deg * PI / 180.0 *)
theta_A_rad := (REAL(D2024) / 100.0) * 0.0174532925;
theta_B_rad := (REAL(D2028) / 100.0) * 0.0174532925;
s4_cw_x := -225.0 * (SIN(theta_A_rad) + SIN(theta_B_rad));
s4_cw_target := DINT(s4_cw_x * 100.0);
D2032 := LIMIT(-45000, s4_cw_target, 45000);

(* State machine timer *)
step_timer := step_timer + 1;

CASE step OF
    0: (* Wait for request *)
        IF NOT r0_done AND D100 > 0 THEN
            active_req := 1;
            current_req_id := D100;
            origin_station := 1; (* Lift A *)
            step := 10;
            step_timer := 0;
        ELSIF NOT r1_done AND D120 > 0 THEN
            active_req := 2;
            current_req_id := D120;
            origin_station := 2; (* Lift B *)
            step := 10;
            step_timer := 0;
        ELSIF (r0_done OR D100 = 0) AND (r1_done OR D120 = 0) AND X51 THEN
            all_finished := TRUE;
            step := 900;
            step_timer := 0;
        END_IF;

    10: (* Lift origin station to dock height D92 (or 95000) *)
        IF origin_station = 1 THEN
            D2008 := D92; (* Lift A target *)
            D2012 := 40000;
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 20;
                step_timer := 0;
            END_IF;
        ELSE
            D2012 := D92; (* Lift B target *)
            D2008 := 40000;
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 20;
                step_timer := 0;
            END_IF;
        END_IF;

    20: (* Move shuttle A to origin station docking position *)
        IF origin_station = 1 THEN
            D2000 := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 THEN
                step := 30;
                step_timer := 0;
            END_IF;
        ELSE
            D2000 := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 THEN
                step := 30;
                step_timer := 0;
            END_IF;
        END_IF;

    30: (* Connect / Extract jig from lift: extend fork to 180 mm *)
        D2004 := 18000;
        D80 := 1; (* extraction *)
        D81 := origin_station;
        D82 := seq_counter;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 40;
            step_timer := 0;
        END_IF;

    40: (* Retract fork to 0 mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            (* Return lift to home 400 mm *)
            IF origin_station = 1 THEN
                D2008 := 40000;
            ELSE
                D2012 := 40000;
            END_IF;
            step := 100;
            step_timer := 0;
        END_IF;

    100: (* Move shuttle A to Cell 3 *)
        D2000 := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
            step := 110;
            step_timer := 0;
        END_IF;

    110: (* Connect / Place jig into Cell 3: extend fork to 180 mm *)
        D2004 := 18000;
        D80 := 2; (* placement *)
        D81 := 3; (* cell 3 *)
        D82 := seq_counter;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 120;
            step_timer := 0;
        END_IF;

    120: (* Retract fork to 0 mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 130;
            step_timer := 0;
        END_IF;

    130: (* Execute Cell 3 operation *)
        D2016 := D500;
        D2020 := D501;
        Y70 := TRUE; (* configure *)
        IF X70 OR (ABS(D1016 - D500) <= 20 AND ABS(D1020 - D501) <= 20 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100) THEN
            IF step_timer >= 5 THEN (* 100 ms hold *)
                step := 140;
                step_timer := 0;
            END_IF;
        ELSE
            step_timer := 0;
        END_IF;

    140: (* Return Cell 3 to connection posture [-600, -600] *)
        D2016 := -60000;
        D2020 := -60000;
        Y70 := FALSE;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
            step := 150;
            step_timer := 0;
        END_IF;

    150: (* Extract jig from Cell 3 *)
        D2004 := 18000;
        D80 := 1; (* extraction *)
        D81 := 3;
        D82 := seq_counter;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 160;
            step_timer := 0;
        END_IF;

    160: (* Retract fork to 0 mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 200;
            step_timer := 0;
        END_IF;

    200: (* Move shuttle A to Cell 4 *)
        D2000 := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
            step := 210;
            step_timer := 0;
        END_IF;

    210: (* Connect / Place jig into Cell 4: extend fork to 180 mm *)
        D2004 := 18000;
        D80 := 2; (* placement *)
        D81 := 4; (* cell 4 *)
        D82 := seq_counter;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 220;
            step_timer := 0;
        END_IF;

    220: (* Retract fork to 0 mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 230;
            step_timer := 0;
        END_IF;

    230: (* Execute Cell 4 operation *)
        D2024 := D600;
        D2028 := D601;
        Y75 := TRUE; (* configure *)
        IF X75 OR (ABS(D1024 - D600) <= 20 AND ABS(D1028 - D601) <= 20 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100) THEN
            IF step_timer >= 5 THEN (* 100 ms hold *)
                step := 240;
                step_timer := 0;
            END_IF;
        ELSE
            step_timer := 0;
        END_IF;

    240: (* Return Cell 4 to connection posture [0, 0] *)
        D2024 := 0;
        D2028 := 0;
        Y75 := FALSE;
        IF ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100 THEN
            step := 250;
            step_timer := 0;
        END_IF;

    250: (* Extract jig from Cell 4 *)
        D2004 := 18000;
        D80 := 1; (* extraction *)
        D81 := 4;
        D82 := seq_counter;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 260;
            step_timer := 0;
        END_IF;

    260: (* Retract fork to 0 mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            (* Prepare origin lift at dock height *)
            IF origin_station = 1 THEN
                D2008 := D92;
            ELSE
                D2012 := D92;
            END_IF;
            step := 300;
            step_timer := 0;
        END_IF;

    300: (* Move shuttle A back to origin station *)
        IF origin_station = 1 THEN
            D2000 := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND ABS(D1008 - D92) <= 20 THEN
                step := 310;
                step_timer := 0;
            END_IF;
        ELSE
            D2000 := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND ABS(D1012 - D92) <= 20 THEN
                step := 310;
                step_timer := 0;
            END_IF;
        END_IF;

    310: (* Place jig back to lift: extend fork to 180 mm *)
        D2004 := 18000;
        D80 := 2; (* placement *)
        D81 := origin_station;
        D82 := seq_counter;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            step := 320;
            step_timer := 0;
        END_IF;

    320: (* Retract fork to 0 mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 330;
            step_timer := 0;
        END_IF;

    330: (* Descend origin lift to home height 400 mm *)
        IF origin_station = 1 THEN
            D2008 := 40000;
            IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 THEN
                D300 := current_req_id;
                D301 := 1; (* completion *)
                r0_done := TRUE;
                active_req := 0;
                step := 0;
                step_timer := 0;
            END_IF;
        ELSE
            D2012 := 40000;
            IF ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
                D302 := current_req_id;
                D303 := 1; (* completion *)
                r1_done := TRUE;
                active_req := 0;
                step := 0;
                step_timer := 0;
            END_IF;
        END_IF;

    900: (* Final return to initial coordinates for completion *)
        D2000 := 0;     (* shuttle A to 0 *)
        D2004 := 0;     (* fork B to 0 *)
        D2008 := 40000; (* lift A to 400 *)
        D2012 := 40000; (* lift B to 400 *)
        D2016 := -60000;(* cell 3 to home *)
        D2020 := -60000;
        D2024 := 0;     (* cell 4 to home *)
        D2028 := 0;
        D2032 := 0;

        IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20
           AND ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20
           AND ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20
           AND ABS(D1001) <= 100 AND ABS(D1005) <= 100 THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM
