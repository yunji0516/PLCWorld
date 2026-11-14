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
    D1040 : DINT;
    D1041 : DINT;
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
    D503 : DINT;
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
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
    D2040 : DINT;
    D2041 : DINT;
    D2042 : DINT;
    Y50 : BOOL;
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

    (* Internal variables *)
    step : INT := 0;
    active_req : INT := 0; (* 0: req0, 1: req1 *)
    current_req_id : DINT := 0;
    current_loc : DINT := 0;
    is_cancelled : BOOL := 0;

    seq_counter : DINT := 0;
    timer_ms : DINT := 0;

    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;

    all_completed : BOOL := FALSE;
    completion_timer : DINT := 0;

    dock_x : DINT := 0;
    dock_y : DINT := 0;

    settle_timer : DINT := 0;
END_VAR

(* Default continuous outputs for targets and rates *)
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
Y50 := TRUE;

D2001 := 700;
D2005 := 700;
D2009 := 700;
D2013 := 700;
D2017 := 700;
D2021 := 700;
D2025 := 700;
D2029 := 700;
D2033 := 700;
D2037 := 700;
D2041 := 700;

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
D2042 := 0;

Y30 := FALSE;

(* Lift safety: Common lift frame height difference must stay <= 80mm *)
(* We coordinate lift targets together *)

CASE step OF
    0: (* Wait for request *)
        D80 := 0;
        D81 := 0;
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := -6500;
        D2020 := 0;
        D2024 := 6500;
        D2028 := 0;
        D2032 := -65000;
        D2036 := 65000;
        D2040 := 0;

        IF (NOT req0_done) AND (D100 > 0) THEN
            active_req := 0;
            current_req_id := D100;
            current_loc := D101;
            is_cancelled := X31;
            step := 10;
        ELSIF req0_done AND (NOT req1_done) AND (D120 > 0) THEN
            active_req := 1;
            current_req_id := D120;
            current_loc := D121;
            is_cancelled := X35;
            step := 10;
        ELSIF req0_done AND req1_done THEN
            step := 900;
        END_IF;

    10: (* Check cancellation or start pickup at Lift *)
        IF (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
            is_cancelled := TRUE;
        END_IF;

        (* Lifts move together to docking height (default 950mm = 95000) *)
        IF D92 > 0 THEN
            dock_y := D92;
        ELSE
            dock_y := 95000;
        END_IF;

        D2008 := dock_y;
        D2012 := dock_y;

        (* Shuttle moves to lift docking coordinate *)
        IF current_loc = 1 THEN
            D81 := 1;
            IF D403 <> 0 THEN
                dock_x := D403;
            ELSE
                dock_x := -405000;
            END_IF;
        ELSE
            D81 := 2;
            IF D406 <> 0 THEN
                dock_x := D406;
            ELSE
                dock_x := -185000;
            END_IF;
        END_IF;

        D2000 := dock_x;
        D2004 := 0; (* Fork retracted *)

        (* Wait until lift and shuttle arrive *)
        IF ABS(D1000 - dock_x) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1008 - dock_y) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - dock_y) <= 20 AND ABS(D1013) <= 100 THEN
            step := 20;
        END_IF;

    20: (* Extend fork to pick up jig from lift *)
        D2004 := 18000; (* 180 mm connection *)
        D80 := 1; (* extraction *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            timer_ms := 0;
            step := 30;
        END_IF;

    30: (* Settle and confirm jig ownership on shuttle *)
        timer_ms := timer_ms + 20;
        IF (D90 = current_req_id OR timer_ms >= 100) AND timer_ms >= 80 THEN
            step := 40;
        END_IF;

    40: (* Retract fork with jig *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            (* Return lifts to home height 400mm *)
            D2008 := 40000;
            D2012 := 40000;
            IF is_cancelled THEN
                (* Cancelled request returns immediately *)
                step := 500;
            ELSE
                step := 100; (* Proceed to Cell 3 *)
            END_IF;
        END_IF;

    100: (* Move shuttle to Cell 3 *)
        IF D409 <> 0 THEN
            dock_x := D409;
        ELSE
            dock_x := 0;
        END_IF;
        D81 := 3;
        D2000 := dock_x;
        D2004 := 0;

        IF ABS(D1000 - dock_x) <= 20 AND ABS(D1001) <= 100 THEN
            step := 110;
        END_IF;

    110: (* Cell 3 operation: twin booms *)
        (* Boom retrieves to 80 mm or less before swiveling *)
        D2020 := 0;
        D2028 := 0;
        D2016 := D500;
        D2024 := D502;
        IF ABS(D1016 - D500) <= 20 AND ABS(D1024 - D502) <= 20 THEN
            D2020 := D501;
            D2028 := D503;
            IF ABS(D1020 - D501) <= 20 AND ABS(D1028 - D503) <= 20 THEN
                step := 120;
                timer_ms := 0;
            END_IF;
        END_IF;

    120: (* Maintain Cell 3 actual result for 80 ms *)
        timer_ms := timer_ms + 20;
        IF X70 OR timer_ms >= 120 THEN
            step := 130;
        END_IF;

    130: (* Retract booms to <= 80mm before swiveling back *)
        D2020 := 0;
        D2028 := 0;
        IF ABS(D1020) <= 20 AND ABS(D1028) <= 20 THEN
            (* Swivel back to home angles *)
            D2016 := -6500;
            D2024 := 6500;
            IF ABS(D1016 - (-6500)) <= 20 AND ABS(D1024 - 6500) <= 20 THEN
                step := 200; (* Proceed to Cell 4 *)
            END_IF;
        END_IF;

    200: (* Move shuttle to Cell 4 *)
        IF D412 <> 0 THEN
            dock_x := D412;
        ELSE
            dock_x := 670000;
        END_IF;
        D81 := 4;
        D2000 := dock_x;
        D2004 := 0;

        IF ABS(D1000 - dock_x) <= 20 AND ABS(D1001) <= 100 THEN
            step := 210;
        END_IF;

    210: (* Cell 4 operation: Lift Exchange Head *)
        (* Safety constraint: Exchange head maintains height difference >= 220mm at horizontal gap < 230mm *)
        (* Set s4_2 height first if moving close, or follow goals *)
        D2040 := D602;
        IF ABS(D1040 - D602) <= 20 OR D602 >= 22000 THEN
            D2032 := D600;
            D2036 := D601;
            IF ABS(D1032 - D600) <= 20 AND ABS(D1036 - D601) <= 20 AND
               ABS(D1040 - D602) <= 20 THEN
                step := 220;
                timer_ms := 0;
            END_IF;
        END_IF;

    220: (* Maintain Cell 4 actual result for 80 ms *)
        timer_ms := timer_ms + 20;
        IF X75 OR timer_ms >= 120 THEN
            step := 230;
        END_IF;

    230: (* Retract Cell 4 heads to home posture *)
        (* First retract horizontally while maintaining height, then lower height *)
        D2032 := -65000;
        D2036 := 65000;
        IF ABS(D1032 - (-65000)) <= 20 AND ABS(D1036 - 65000) <= 20 THEN
            D2040 := 0;
            IF ABS(D1040) <= 20 THEN
                step := 500; (* Return to lift *)
            END_IF;
        END_IF;

    500: (* Return shuttle to original lift section *)
        IF current_loc = 1 THEN
            D81 := 1;
            IF D403 <> 0 THEN
                dock_x := D403;
            ELSE
                dock_x := -405000;
            END_IF;
        ELSE
            D81 := 2;
            IF D406 <> 0 THEN
                dock_x := D406;
            ELSE
                dock_x := -185000;
            END_IF;
        END_IF;

        IF D92 > 0 THEN
            dock_y := D92;
        ELSE
            dock_y := 95000;
        END_IF;

        D2008 := dock_y;
        D2012 := dock_y;
        D2000 := dock_x;
        D2004 := 0;

        IF ABS(D1000 - dock_x) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1008 - dock_y) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - dock_y) <= 20 AND ABS(D1013) <= 100 THEN
            step := 510;
        END_IF;

    510: (* Extend fork to place jig back to lift *)
        D2004 := 18000;
        D80 := 2; (* placement *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            timer_ms := 0;
            step := 520;
        END_IF;

    520: (* Settle placement and handover ownership *)
        timer_ms := timer_ms + 20;
        IF (D90 = 0 OR timer_ms >= 100) AND timer_ms >= 80 THEN
            step := 530;
        END_IF;

    530: (* Retract fork *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 540;
        END_IF;

    540: (* Lower lift to initial height (400 mm = 40000) *)
        D2008 := 40000;
        D2012 := 40000;
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
            (* Acknowledge request *)
            IF active_req = 0 THEN
                D300 := current_req_id;
                IF is_cancelled THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                req0_done := TRUE;
            ELSE
                D302 := current_req_id;
                IF is_cancelled THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                req1_done := TRUE;
            END_IF;
            step := 0; (* Go back to check next request or complete *)
        END_IF;

    900: (* All requests done: return shuttle to 0, ensure everything at initial posture *)
        D80 := 0;
        D81 := 0;
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := -6500;
        D2020 := 0;
        D2024 := 6500;
        D2028 := 0;
        D2032 := -65000;
        D2036 := 65000;
        D2040 := 0;

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-6500)) <= 20 AND ABS(D1020) <= 20 AND
           ABS(D1024 - 6500) <= 20 AND ABS(D1028) <= 20 AND
           ABS(D1032 - (-65000)) <= 20 AND ABS(D1036 - 65000) <= 20 AND
           ABS(D1040) <= 20 THEN
            all_completed := TRUE;
            step := 910;
        END_IF;

    910: (* Maintain Y2 for 100 ms *)
        Y2 := TRUE;
        completion_timer := completion_timer + 20;
END_CASE;

IF all_completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM
