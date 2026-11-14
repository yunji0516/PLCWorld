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

    step : DINT := 0;
    active_req : DINT := 0; (* 0 for req0, 1 for req1 *)
    current_id : DINT := 0;
    current_station : DINT := 0;
    current_lane : DINT := 0;
    target_x : DINT := 0;
    wait_timer : DINT := 0;
    seq_counter : DINT := 1;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    all_finished : BOOL := FALSE;
    final_hold_timer : DINT := 0;
END_VAR

(* Default continuous axis parameters *)
D2001 := 1000;
D2002 := 0;
D2005 := 1000;
D2006 := 0;
D2009 := 1000;
D2010 := 0;
D2013 := 1000;
D2014 := 0;
D2017 := 1000;
D2018 := 0;
D2021 := 1000;
D2022 := 0;
D2025 := 1000;
D2026 := 0;
D2029 := 1000;
D2030 := 0;
D2033 := 1000;
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

(* Cell 3 configuration defaults *)
D700 := current_id;
D701 := 0;
D702 := 0;
Y70 := TRUE;
Y71 := TRUE;

(* Cell 4 configuration defaults *)
D710 := current_id;
D711 := 0;
D712 := 0;
Y75 := TRUE;
Y76 := TRUE;

CASE step OF
    0: (* Initial / idle: wait for requests *)
        Y30 := TRUE;
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        D2016 := -60000;
        D2020 := -60000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;

        IF NOT req0_done AND D100 > 0 THEN
            active_req := 0;
            current_id := D100;
            current_station := 1;
            step := 10;
        ELSIF NOT req1_done AND D120 > 0 THEN
            active_req := 1;
            current_id := D120;
            current_station := 2;
            step := 10;
        ELSIF (req0_done OR D100 = 0) AND (req1_done OR D120 = 0) AND (req0_done OR req1_done OR X51) THEN
            step := 900;
        END_IF;

    10: (* Lift target section: raise lift to dock height *)
        Y30 := TRUE;
        IF current_station = 1 THEN
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

    20: (* Move shuttle X to lift station *)
        Y30 := FALSE;
        IF current_station = 1 THEN
            target_x := D403;
        ELSE
            target_x := D406;
        END_IF;
        D2000 := target_x;

        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 THEN
            Y30 := TRUE;
            step := 30;
        END_IF;

    30: (* Check port ready and extract from lift *)
        Y30 := TRUE;
        IF (current_station = 1 AND X61) OR (current_station = 2 AND X62) THEN
            D80 := 1; (* extraction *)
            D81 := current_station;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            D2004 := 18000;
            step := 40;
        END_IF;

    40: (* Fork reached lift fixture *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                D2004 := 0; (* retract fork with fixture *)
                step := 50;
            END_IF;
        END_IF;

    50: (* Fork retracted onto shuttle *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 60;
        END_IF;

    60: (* Check for cancellation *)
        IF (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
            step := 500; (* abort and return *)
        ELSE
            step := 100; (* proceed to cell 3 *)
        END_IF;

    100: (* Move shuttle to Cell 3 *)
        Y30 := FALSE;
        target_x := D409;
        D2000 := target_x;
        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 THEN
            Y30 := TRUE;
            step := 110;
        END_IF;

    110: (* Check port3 ready and place fixture into cell 3 *)
        Y30 := TRUE;
        IF X63 THEN
            D80 := 2; (* placement *)
            D81 := 3;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            D2004 := 18000;
            step := 120;
        END_IF;

    120: (* Fork reached cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                D2004 := 0; (* retract empty fork *)
                step := 130;
            END_IF;
        END_IF;

    130: (* Empty fork retracted, setup Cell 3 capture *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            current_lane := D520;
            IF current_lane = 0 THEN
                D2016 := D500 + 25000; (* value + 250 mm *)
            ELSE
                D2020 := D501 + 25000;
            END_IF;
            step := 140;
        END_IF;

    140: (* Wait for Cell 3 result maintained *)
        IF X70 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                (* Return cell 3 axis to initial home *)
                D2016 := -60000;
                D2020 := -60000;
                step := 150;
            END_IF;
        END_IF;

    150: (* Wait for Cell 3 axes to return home *)
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 THEN
            step := 160;
        END_IF;

    160: (* Retrieve fixture from Cell 3 *)
        IF X63 THEN
            D80 := 1; (* extraction *)
            D81 := 3;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            D2004 := 18000;
            step := 170;
        END_IF;

    170: (* Fork extended to retrieve *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                D2004 := 0;
                step := 180;
            END_IF;
        END_IF;

    180: (* Fork retracted with fixture *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 200; (* Move to Cell 4 *)
        END_IF;

    200: (* Move shuttle to Cell 4 *)
        Y30 := FALSE;
        target_x := D412;
        D2000 := target_x;
        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 THEN
            Y30 := TRUE;
            step := 210;
        END_IF;

    210: (* Check port4 ready and place fixture into cell 4 *)
        Y30 := TRUE;
        IF X64 THEN
            D80 := 2; (* placement *)
            D81 := 4;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            D2004 := 18000;
            step := 220;
        END_IF;

    220: (* Fork reached cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                D2004 := 0; (* retract empty fork *)
                step := 230;
            END_IF;
        END_IF;

    230: (* Empty fork retracted, Cell 4 rotation posture *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            (* Pins s4_1 and s4_2 are retrieved (0 mm) *)
            D2028 := 0;
            D2032 := 0;
            (* Rotate to requested angle *)
            D2024 := D600;
            step := 240;
        END_IF;

    240: (* Wait for rotation to stop at requested angle *)
        IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
            (* Insert selected pin 40 mm *)
            IF D620 = 0 THEN
                D2028 := 4000;
                D2032 := 0;
            ELSE
                D2028 := 0;
                D2032 := 4000;
            END_IF;
            step := 250;
        END_IF;

    250: (* Wait for pin insertion and Cell 4 served *)
        IF X75 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                (* Return all cell 4 axes to home *)
                D2028 := 0;
                D2032 := 0;
                D2024 := 0;
                step := 260;
            END_IF;
        END_IF;

    260: (* Wait for Cell 4 axes home *)
        IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            step := 270;
        END_IF;

    270: (* Retrieve fixture from Cell 4 *)
        IF X64 THEN
            D80 := 1; (* extraction *)
            D81 := 4;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            D2004 := 18000;
            step := 280;
        END_IF;

    280: (* Fork extended to retrieve *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                D2004 := 0;
                step := 290;
            END_IF;
        END_IF;

    290: (* Fork retracted with fixture *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 400; (* return to lift *)
        END_IF;

    400: (* Move shuttle back to original lift station *)
        Y30 := FALSE;
        IF current_station = 1 THEN
            target_x := D403;
        ELSE
            target_x := D406;
        END_IF;
        D2000 := target_x;

        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 THEN
            Y30 := TRUE;
            step := 410;
        END_IF;

    410: (* Check lift port ready and place fixture back *)
        Y30 := TRUE;
        IF (current_station = 1 AND X61) OR (current_station = 2 AND X62) THEN
            D80 := 2; (* placement *)
            D81 := current_station;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            D2004 := 18000;
            step := 420;
        END_IF;

    420: (* Fork extended to lift *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                D2004 := 0;
                step := 430;
            END_IF;
        END_IF;

    430: (* Empty fork retracted *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            (* Lower lift to initial height 150 mm *)
            IF current_station = 1 THEN
                D2008 := 15000;
            ELSE
                D2012 := 15000;
            END_IF;
            step := 440;
        END_IF;

    440: (* Wait for lift to reach initial height *)
        IF (current_station = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
           (current_station = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
            IF active_req = 0 THEN
                D300 := current_id;
                D301 := 1; (* completion *)
                req0_done := TRUE;
            ELSE
                D302 := current_id;
                D303 := 1; (* completion *)
                req1_done := TRUE;
            END_IF;
            step := 0; (* return to idle *)
        END_IF;

    500: (* Cancelled path: return fixture to original lift *)
        Y30 := FALSE;
        IF current_station = 1 THEN
            target_x := D403;
        ELSE
            target_x := D406;
        END_IF;
        D2000 := target_x;

        IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 THEN
            Y30 := TRUE;
            step := 510;
        END_IF;

    510: (* Check lift port ready and place fixture *)
        Y30 := TRUE;
        IF (current_station = 1 AND X61) OR (current_station = 2 AND X62) THEN
            D80 := 2;
            D81 := current_station;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            D2004 := 18000;
            step := 520;
        END_IF;

    520: (* Fork extended to lift *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_timer := wait_timer + 1;
            IF wait_timer >= 5 THEN
                wait_timer := 0;
                D2004 := 0;
                step := 530;
            END_IF;
        END_IF;

    530: (* Empty fork retracted *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF current_station = 1 THEN
                D2008 := 15000;
            ELSE
                D2012 := 15000;
            END_IF;
            step := 540;
        END_IF;

    540: (* Wait for lift initial height *)
        IF (current_station = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
           (current_station = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
            IF active_req = 0 THEN
                D300 := current_id;
                D301 := 2; (* cancellation retrieval *)
                req0_done := TRUE;
            ELSE
                D302 := current_id;
                D303 := 2; (* cancellation retrieval *)
                req1_done := TRUE;
            END_IF;
            step := 0;
        END_IF;

    900: (* Return all axes to initial connection posture *)
        Y30 := FALSE;
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
            Y30 := TRUE;
            step := 910;
        END_IF;

    910: (* Maintain Y2 for 100 ms (5 scans of 20 ms) *)
        Y30 := TRUE;
        Y2 := TRUE;
        final_hold_timer := final_hold_timer + 1;
        IF final_hold_timer >= 5 THEN
            all_finished := TRUE;
        END_IF;
END_CASE;

END_PROGRAM