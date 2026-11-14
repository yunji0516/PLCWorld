```iecst
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
    active_ch : INT := -1;
    curr_req_id : DINT := 0;
    curr_loc : DINT := 0;
    curr_cancelled : BOOL := FALSE;
    seq_counter : DINT := 1;
    wait_timer : TON;
    wait_in : BOOL := FALSE;
    wait_pt : TIME := T#0ms;
    settle_cnt : INT := 0;

    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    completion_stable : INT := 0;
END_VAR

(* Default enables and feedforwards *)
Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;

D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;

Y30 := FALSE;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;

wait_timer(IN := wait_in, PT := wait_pt);

(* Main sequencer *)
CASE step OF
    0: (* Idle / Select request *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := -60000;
        D2020 := -60000;
        D2024 := -60000;
        D2028 := -60000;
        D80 := 0;
        D81 := 0;

        IF D100 > 0 AND NOT r0_done AND (D300 = 0) THEN
            active_ch := 0;
            curr_req_id := D100;
            curr_loc := D101;
            curr_cancelled := X31;
            step := 10;
        ELSIF D120 > 0 AND NOT r1_done AND (D302 = 0) THEN
            active_ch := 1;
            curr_req_id := D120;
            curr_loc := D121;
            curr_cancelled := X35;
            step := 10;
        ELSIF X51 THEN
            step := 900;
        END_IF;

    (* STEP 10..40: Pick up from Lift *)
    10: (* Move corresponding lift to dock height *)
        IF curr_loc = 1 THEN
            D2008 := D92; (* c to source_dock *)
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 12;
            END_IF;
        ELSE
            D2012 := D92; (* d to source_dock *)
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 12;
            END_IF;
        END_IF;

    12: (* Move shuttle A to Lift dock coordinate *)
        IF curr_loc = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 15;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    15: (* Extend fork B to 180 mm *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 20;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    20: (* Couple with lift jig (extraction) *)
        D80 := 1; (* extraction *)
        D81 := curr_loc;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        wait_in := TRUE;
        wait_pt := T#60ms;
        step := 21;

    21: (* Wait coupling confirmation *)
        IF wait_timer.Q THEN
            wait_in := FALSE;
            step := 25;
        END_IF;

    25: (* Retract fork B to 0 mm *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                IF curr_cancelled THEN
                    step := 70; (* Return immediately *)
                ELSE
                    step := 100; (* Move to Cell 3 *)
                END_IF;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    (* STEP 100..290: Cell 3 Processing *)
    100: (* Move shuttle A to Cell 3 *)
        D2000 := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 105;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    105: (* Extend fork B to 180 mm into Cell 3 *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 110;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    110: (* Placement coupling to Cell 3 *)
        D80 := 2; (* placement *)
        D81 := 3;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        wait_in := TRUE;
        wait_pt := T#60ms;
        step := 111;

    111:
        IF wait_timer.Q THEN
            wait_in := FALSE;
            step := 115;
        END_IF;

    115: (* Retract fork B before Cell 3 work *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 120;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    120: (* Move Cell 3 gantry axes to goal *)
        D2016 := D500;
        D2020 := D501;
        IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - D501) <= 20 AND ABS(D1021) <= 100 THEN
            wait_in := TRUE;
            wait_pt := T#80ms;
            step := 125;
        END_IF;

    125: (* Wait 80 ms maintenance *)
        IF wait_timer.Q OR X70 THEN
            wait_in := FALSE;
            step := 130;
        END_IF;

    130: (* Return Cell 3 gantry axes to initial posture *)
        D2016 := -60000;
        D2020 := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 135;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    135: (* Extend fork B to pick up from Cell 3 *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 140;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    140: (* Extraction coupling from Cell 3 *)
        D80 := 1; (* extraction *)
        D81 := 3;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        wait_in := TRUE;
        wait_pt := T#60ms;
        step := 141;

    141:
        IF wait_timer.Q THEN
            wait_in := FALSE;
            step := 145;
        END_IF;

    145: (* Retract fork B *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 200; (* Move to Cell 4 *)
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    (* STEP 200..390: Cell 4 Processing *)
    200: (* Move shuttle A to Cell 4 *)
        D2000 := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 205;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    205: (* Extend fork B to 180 mm into Cell 4 *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 210;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    210: (* Placement coupling to Cell 4 *)
        D80 := 2; (* placement *)
        D81 := 4;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        wait_in := TRUE;
        wait_pt := T#60ms;
        step := 211;

    211:
        IF wait_timer.Q THEN
            wait_in := FALSE;
            step := 215;
        END_IF;

    215: (* Retract fork B *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 220;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    220: (* Move Cell 4 axes to goal *)
        D2024 := D600;
        D2028 := D601;
        IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - D601) <= 20 AND ABS(D1029) <= 100 THEN
            wait_in := TRUE;
            wait_pt := T#80ms;
            step := 225;
        END_IF;

    225: (* Wait 80 ms maintenance *)
        IF wait_timer.Q OR X75 THEN
            wait_in := FALSE;
            step := 230;
        END_IF;

    230: (* Return Cell 4 axes to initial posture *)
        D2024 := -60000;
        D2028 := -60000;
        IF ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - (-60000)) <= 20 AND ABS(D1029) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 235;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    235: (* Extend fork B to retrieve from Cell 4 *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 240;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    240: (* Extraction coupling from Cell 4 *)
        D80 := 1; (* extraction *)
        D81 := 4;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        wait_in := TRUE;
        wait_pt := T#60ms;
        step := 241;

    241:
        IF wait_timer.Q THEN
            wait_in := FALSE;
            step := 245;
        END_IF;

    245: (* Retract fork B *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 70; (* Return to original lift *)
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    (* STEP 70..99: Return to original lift *)
    70: (* Move lift to dock height if not already *)
        IF curr_loc = 1 THEN
            D2008 := D92;
        ELSE
            D2012 := D92;
        END_IF;
        step := 72;

    72: (* Move shuttle A to original Lift *)
        IF curr_loc = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
            IF curr_loc = 1 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 75;
                END_IF;
            ELSIF curr_loc = 2 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 75;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    75: (* Extend fork B to 180 mm *)
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 80;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    80: (* Placement coupling back to lift *)
        D80 := 2; (* placement *)
        D81 := curr_loc;
        D82 := seq_counter;
        seq_counter := seq_counter + 1;
        wait_in := TRUE;
        wait_pt := T#60ms;
        step := 81;

    81:
        IF wait_timer.Q THEN
            wait_in := FALSE;
            step := 85;
        END_IF;

    85: (* Retract fork B to 0 *)
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 90;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    90: (* Descend lift to initial height 400 mm *)
        IF curr_loc = 1 THEN
            D2008 := 40000;
            IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 95;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            D2012 := 40000;
            IF ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 95;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        END_IF;

    95: (* Acknowledge request *)
        IF active_ch = 0 THEN
            D300 := curr_req_id;
            IF curr_cancelled THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            r0_done := TRUE;
        ELSE
            D302 := curr_req_id;
            IF curr_cancelled THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            r1_done := TRUE;
        END_IF;
        active_ch := -1;
        step := 0;

    (* STEP 900: Final return to initial state and hold for completion *)
    900:
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := -60000;
        D2020 := -60000;
        D2024 := -60000;
        D2028 := -60000;

        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - (-60000)) <= 20 AND ABS(D1029) <= 100 THEN
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM
```