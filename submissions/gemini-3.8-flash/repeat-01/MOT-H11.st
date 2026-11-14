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

    init_done : BOOL;
    state : INT;
    cur_req : INT; (* 0 for r0, 1 for r1 *)
    cur_req_id : DINT;
    cur_loc : DINT; (* 1 for lift A, 2 for lift B *)
    next_seq : DINT;
    timer_ms : DINT;
    wait_cnt : DINT;

    c3_timer : DINT;
    c4_timer : DINT;

    c_done : BOOL;
    d_done : BOOL;
    done_hold_cnt : DINT;
END_VAR

IF NOT init_done THEN
    init_done := TRUE;
    state := 0;
    next_seq := 1;
    D2000 := 0;
    D2001 := 1000;
    Y40 := TRUE;
    D2004 := 0;
    D2005 := 1000;
    Y41 := TRUE;
    D2008 := 40000;
    D2009 := 1000;
    Y42 := TRUE;
    D2012 := 40000;
    D2013 := 1000;
    Y43 := TRUE;
    D2016 := 0;
    D2017 := 1000;
    Y44 := TRUE;
    D2020 := 5000;
    D2021 := 1000;
    Y45 := TRUE;
    D2024 := 0;
    D2025 := 1000;
    Y46 := TRUE;
    D2028 := 0;
    D2029 := 1000;
    Y47 := TRUE;
    D2032 := 0;
    D2033 := 1000;
    Y48 := TRUE;
    Y30 := TRUE;
    Y2 := FALSE;
END_IF;

(* Main State Machine *)
CASE state OF
    0: (* Idle / Select Request *)
        IF X51 THEN
            state := 900; (* All done, return home and complete *)
        ELSE
            (* Pick earliest deadline or available request *)
            IF (D100 > 0) AND (D300 = 0) AND ((D120 = 0) OR (D302 > 0) OR (D103 <= D123)) THEN
                cur_req := 0;
                cur_req_id := D100;
                cur_loc := D101;
                state := 10;
            ELSIF (D120 > 0) AND (D302 = 0) THEN
                cur_req := 1;
                cur_req_id := D120;
                cur_loc := D121;
                state := 10;
            END_IF;
        END_IF;

    10: (* Raise lift at cur_loc to source_dock (D92) *)
        IF cur_loc = 1 THEN
            D2008 := D92;
            (* Lift height diff check <= 80mm (8000) *)
            IF D2008 - D1012 > 7000 THEN
                D2012 := D2008 - 7000;
            END_IF;
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                state := 20;
            END_IF;
        ELSE
            D2012 := D92;
            IF D2012 - D1008 > 7000 THEN
                D2008 := D2012 - 7000;
            END_IF;
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                state := 20;
            END_IF;
        END_IF;

    20: (* Move Shuttle X to Lift Docking Position *)
        IF cur_loc = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            state := 30;
        END_IF;

    30: (* Extend Fork axis B to 180mm (18000) to extract jig *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            (* Trigger mechanical extraction coupling *)
            D80 := 1; (* extraction *)
            D81 := cur_loc; (* station 1 or 2 *)
            D82 := next_seq;
            next_seq := next_seq + 1;
            wait_cnt := 0;
            state := 40;
        END_IF;

    40: (* Wait for holding handover *)
        wait_cnt := wait_cnt + 1;
        IF (D90 = cur_req_id) OR (wait_cnt >= 10) THEN
            state := 50;
        END_IF;

    50: (* Retract Fork axis B to 0mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 100; (* Move to Cell 3 *)
        END_IF;

    100: (* Move Shuttle X to Cell 3 (Port 3) *)
        D2000 := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
            state := 110;
        END_IF;

    110: (* Extend Fork to 180mm into Cell 3 *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; (* placement *)
            D81 := 3; (* station 3 *)
            D82 := next_seq;
            next_seq := next_seq + 1;
            wait_cnt := 0;
            state := 120;
        END_IF;

    120: (* Wait for transfer to Cell 3 *)
        wait_cnt := wait_cnt + 1;
        IF (D410 = cur_req_id) OR (wait_cnt >= 10) THEN
            state := 130;
        END_IF;

    130: (* Retract Fork axis B to 0mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 200; (* Process Cell 3 *)
        END_IF;

    200: (* Cell 3: Ensure s3_1 is <= 500mm, then rotate to m3_goal0 *)
        D2020 := 5000; (* 50mm initial posture *)
        IF ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 THEN
            D2016 := D500; (* rotate table to requested angle *)
            IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 THEN
                state := 210;
            END_IF;
        END_IF;

    210: (* Cell 3: Precision approach to 700mm (70000) or m3_goal1 *)
        IF D501 > 0 THEN
            D2020 := D501;
        ELSE
            D2020 := 70000;
        END_IF;
        IF ABS(D1020 - D2020) <= 20 AND ABS(D1021) <= 100 THEN
            state := 220;
            c3_timer := 0;
        END_IF;

    220: (* Cell 3: Hold result for at least 80 ms *)
        c3_timer := c3_timer + 20;
        IF X70 OR (c3_timer >= 120) THEN
            state := 230;
        END_IF;

    230: (* Cell 3: Return to home posture (s3_1 -> 50mm, s3_0 -> 0 deg) *)
        D2020 := 5000;
        IF ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 THEN
            D2016 := 0;
            IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
                state := 240;
            END_IF;
        END_IF;

    240: (* Retrieve jig from Cell 3: Extend Fork *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; (* extraction *)
            D81 := 3; (* station 3 *)
            D82 := next_seq;
            next_seq := next_seq + 1;
            wait_cnt := 0;
            state := 250;
        END_IF;

    250: (* Wait for jig retrieval *)
        wait_cnt := wait_cnt + 1;
        IF (D90 = cur_req_id) OR (wait_cnt >= 10) THEN
            state := 260;
        END_IF;

    260: (* Retract Fork axis B to 0mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 300; (* Move to Cell 4 *)
        END_IF;

    300: (* Move Shuttle X to Cell 4 (Port 4) *)
        D2000 := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
            state := 310;
        END_IF;

    310: (* Extend Fork into Cell 4 *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; (* placement *)
            D81 := 4; (* station 4 *)
            D82 := next_seq;
            next_seq := next_seq + 1;
            wait_cnt := 0;
            state := 320;
        END_IF;

    320: (* Wait for placement into Cell 4 *)
        wait_cnt := wait_cnt + 1;
        IF (D413 = cur_req_id) OR (wait_cnt >= 10) THEN
            state := 330;
        END_IF;

    330: (* Retract Fork axis B to 0mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 400; (* Process Cell 4 *)
        END_IF;

    400: (* Cell 4: Retrieve pins (s4_1, s4_2 to 0), then rotate s4_0 to m4_goal0 *)
        D2028 := 0;
        D2032 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            D2024 := D600;
            IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 THEN
                state := 410;
            END_IF;
        END_IF;

    410: (* Cell 4: Insert selected pin to 40mm (4000) *)
        IF D602 > 0 THEN
            D2032 := 4000;
        ELSE
            D2028 := 4000;
        END_IF;
        IF (ABS(D1028 - D2028) <= 20 AND ABS(D1029) <= 100) AND (ABS(D1032 - D2032) <= 20 AND ABS(D1033) <= 100) THEN
            state := 420;
            c4_timer := 0;
        END_IF;

    420: (* Cell 4: Hold result for at least 80 ms *)
        c4_timer := c4_timer + 20;
        IF X75 OR (c4_timer >= 120) THEN
            state := 430;
        END_IF;

    430: (* Cell 4: Retract pins to 0, then rotate s4_0 to 0 *)
        D2028 := 0;
        D2032 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            D2024 := 0;
            IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
                state := 440;
            END_IF;
        END_IF;

    440: (* Retrieve jig from Cell 4: Extend Fork *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; (* extraction *)
            D81 := 4; (* station 4 *)
            D82 := next_seq;
            next_seq := next_seq + 1;
            wait_cnt := 0;
            state := 450;
        END_IF;

    450: (* Wait for jig retrieval *)
        wait_cnt := wait_cnt + 1;
        IF (D90 = cur_req_id) OR (wait_cnt >= 10) THEN
            state := 460;
        END_IF;

    460: (* Retract Fork axis B to 0mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 500; (* Return to original lift *)
        END_IF;

    500: (* Ensure lift is at source_dock, move Shuttle X to original lift *)
        IF cur_loc = 1 THEN
            D2008 := D92;
            IF D2008 - D1012 > 7000 THEN
                D2012 := D2008 - 7000;
            END_IF;
            D2000 := D403;
        ELSE
            D2012 := D92;
            IF D2012 - D1008 > 7000 THEN
                D2008 := D2012 - 7000;
            END_IF;
            D2000 := D406;
        END_IF;

        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            state := 510;
        END_IF;

    510: (* Extend Fork to place jig back onto lift *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; (* placement *)
            D81 := cur_loc;
            D82 := next_seq;
            next_seq := next_seq + 1;
            wait_cnt := 0;
            state := 520;
        END_IF;

    520: (* Wait for handoff to lift *)
        wait_cnt := wait_cnt + 1;
        IF (D90 = 0) OR (wait_cnt >= 10) THEN
            state := 530;
        END_IF;

    530: (* Retract Fork axis B to 0mm *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 540;
        END_IF;

    540: (* Descend lift to initial height (400mm = 40000) *)
        IF cur_loc = 1 THEN
            D2008 := 40000;
            IF D1012 - D2008 > 7000 THEN
                D2012 := D2008 + 7000;
            END_IF;
            IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 THEN
                state := 550;
            END_IF;
        ELSE
            D2012 := 40000;
            IF D1008 - D2012 > 7000 THEN
                D2008 := D2012 + 7000;
            END_IF;
            IF ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
                state := 550;
            END_IF;
        END_IF;

    550: (* Set ACK and Status for completed request *)
        IF cur_req = 0 THEN
            D300 := cur_req_id;
            IF X31 THEN
                D301 := 2; (* cancellation retrieval *)
            ELSE
                D301 := 1; (* completion *)
            END_IF;
        ELSE
            D302 := cur_req_id;
            IF X35 THEN
                D303 := 2; (* cancellation retrieval *)
            ELSE
                D303 := 1; (* completion *)
            END_IF;
        END_IF;
        state := 0; (* Process next request or finish *)

    900: (* Return all axes to initial positions *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := 0;
        D2020 := 5000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            done_hold_cnt := done_hold_cnt + 1;
            IF done_hold_cnt >= 5 THEN (* 100 ms hold *)
                Y2 := TRUE;
            END_IF;
        ELSE
            done_hold_cnt := 0;
        END_IF;
END_CASE;

END_PROGRAM