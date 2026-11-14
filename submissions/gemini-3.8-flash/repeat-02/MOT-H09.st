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
    active_ch : INT := 0;
    active_id : DINT := 0;
    active_st : DINT := 0;
    active_pkt : DINT := 1;
    active_cancel : BOOL := FALSE;
    seq_cnt : DINT := 0;
    wait_timer : TON;
    wait_in : BOOL := FALSE;
    wait_pt : TIME := T#0ms;
    final_timer : TON;
    final_in : BOOL := FALSE;
    last_r0_id : DINT := 0;
    last_r1_id : DINT := 0;
END_VAR

(* Target initialization on first scan *)
IF step = 0 THEN
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := 0;
    D2020 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 5000;
    step := 1;
END_IF;

(* Default Drive Ratios and Enables *)
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

wait_in := FALSE;

CASE step OF
    1: (* Wait for request *)
        IF D100 > 0 AND D100 <> last_r0_id AND NOT X30 THEN
            active_ch := 0;
            active_id := D100;
            active_st := 1;
            active_pkt := 1;
            active_cancel := X31;
            step := 10;
        ELSIF D120 > 0 AND D120 <> last_r1_id AND NOT X34 THEN
            active_ch := 1;
            active_id := D120;
            active_st := 2;
            active_pkt := 2;
            active_cancel := X35;
            step := 10;
        ELSIF X51 THEN
            step := 100;
        END_IF;

    10: (* Move lift to docking height and shuttle to station port *)
        IF active_st = 1 THEN
            D2008 := D92;
            D2000 := D403;
        ELSE
            D2012 := D92;
            D2000 := D406;
        END_IF;
        D2004 := 0;
        Y30 := FALSE;
        step := 11;

    11: (* Check arrival at docking position *)
        IF active_st = 1 THEN
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND X61 THEN
                Y30 := TRUE;
                seq_cnt := seq_cnt + 1;
                D82 := seq_cnt;
                D81 := active_st;
                D80 := 1; (* Extraction *)
                D2004 := 18000; (* Extend fork *)
                step := 12;
            END_IF;
        ELSE
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 AND X62 THEN
                Y30 := TRUE;
                seq_cnt := seq_cnt + 1;
                D82 := seq_cnt;
                D81 := active_st;
                D80 := 1; (* Extraction *)
                D2004 := 18000; (* Extend fork *)
                step := 12;
            END_IF;
        END_IF;

    12: (* Fork engaged, hold coupling *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_in := TRUE;
            wait_pt := T#100ms;
            IF wait_timer.Q THEN
                D2004 := 0; (* Retract fork *)
                step := 13;
            END_IF;
        END_IF;

    13: (* Fork fully retracted onto shuttle *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y30 := FALSE;
            (* Return lift to home coordinate *)
            IF active_st = 1 THEN
                D2008 := 15000;
            ELSE
                D2012 := 15000;
            END_IF;
            IF active_cancel THEN
                step := 60; (* Return to original lift directly *)
            ELSE
                step := 20; (* Proceed to Cell 3 *)
            END_IF;
        END_IF;

    20: (* Move shuttle to Cell 3 *)
        D2000 := D409;
        D700 := active_pkt;
        Y70 := TRUE;
        step := 21;

    21: (* Arrived at Cell 3 *)
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            Y30 := TRUE;
            seq_cnt := seq_cnt + 1;
            D82 := seq_cnt;
            D81 := 3;
            D80 := 2; (* Placement into cell 3 *)
            D2004 := 18000;
            step := 22;
        END_IF;

    22: (* Fork connected to Cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_in := TRUE;
            wait_pt := T#100ms;
            IF wait_timer.Q THEN
                D2004 := 0;
                step := 23;
            END_IF;
        END_IF;

    23: (* Fork retracted, shuttle disengaged, start Cell 3 processing *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y71 := TRUE;
            IF active_pkt = 1 THEN
                D2020 := D501;
            ELSIF active_pkt = 2 THEN
                D2024 := D502;
            ELSE
                D2016 := D500;
            END_IF;
            step := 24;
        END_IF;

    24: (* Cell 3 reached target, hold for served feedback *)
        IF (active_pkt = 1 AND ABS(D1020 - D501) <= 20 AND ABS(D1021) <= 100) OR
           (active_pkt = 2 AND ABS(D1024 - D502) <= 20 AND ABS(D1025) <= 100) OR
           (active_pkt = 0 AND ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100) THEN
            IF X70 THEN
                (* Retract cell 3 axis to home *)
                D2016 := 0;
                D2020 := 0;
                D2024 := 0;
                step := 25;
            END_IF;
        END_IF;

    25: (* Cell 3 axes back to home, retrieve jig *)
        IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 THEN
            Y71 := FALSE;
            Y70 := FALSE;
            seq_cnt := seq_cnt + 1;
            D82 := seq_cnt;
            D81 := 3;
            D80 := 1; (* Extraction from cell 3 *)
            D2004 := 18000;
            step := 26;
        END_IF;

    26: (* Fork engaged to Cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_in := TRUE;
            wait_pt := T#100ms;
            IF wait_timer.Q THEN
                D2004 := 0;
                step := 27;
            END_IF;
        END_IF;

    27: (* Jig back on shuttle, release brake and move to Cell 4 *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y30 := FALSE;
            D2000 := D412;
            step := 30;
        END_IF;

    30: (* Arrived at Cell 4 *)
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            Y30 := TRUE;
            seq_cnt := seq_cnt + 1;
            D82 := seq_cnt;
            D81 := 4;
            D80 := 2; (* Placement into cell 4 *)
            D2004 := 18000;
            step := 31;
        END_IF;

    31: (* Fork extended to Cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_in := TRUE;
            wait_pt := T#100ms;
            IF wait_timer.Q THEN
                D2004 := 0;
                step := 32;
            END_IF;
        END_IF;

    32: (* Fork retracted, start Cell 4 operation *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y75 := TRUE;
            Y76 := TRUE;
            (* Rotate s4_0 first while s4_1 is at home 50 mm <= 500 mm *)
            D2028 := D600;
            step := 33;
        END_IF;

    33: (* s4_0 reached target angle, approach slide to target *)
        IF ABS(D1028 - D600) <= 20 AND ABS(D1029) <= 100 THEN
            D2032 := D601;
            step := 34;
        END_IF;

    34: (* s4_1 reached target, wait for served *)
        IF ABS(D1032 - D601) <= 20 AND ABS(D1033) <= 100 THEN
            IF X75 THEN
                (* Retract slide back to home 50 mm *)
                D2032 := 5000;
                step := 35;
            END_IF;
        END_IF;

    35: (* Slide retracted, rotate table back to home 0 deg *)
        IF ABS(D1032 - 5000) <= 20 AND ABS(D1033) <= 100 THEN
            D2028 := 0;
            step := 36;
        END_IF;

    36: (* Cell 4 axes back home, retrieve jig *)
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 THEN
            Y76 := FALSE;
            Y75 := FALSE;
            seq_cnt := seq_cnt + 1;
            D82 := seq_cnt;
            D81 := 4;
            D80 := 1; (* Extraction from cell 4 *)
            D2004 := 18000;
            step := 37;
        END_IF;

    37: (* Fork extended to Cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_in := TRUE;
            wait_pt := T#100ms;
            IF wait_timer.Q THEN
                D2004 := 0;
                step := 38;
            END_IF;
        END_IF;

    38: (* Jig back on shuttle, prepare return to lift *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y30 := FALSE;
            step := 60;
        END_IF;

    60: (* Move shuttle to original lift station and raise lift to docking height *)
        IF active_st = 1 THEN
            D2000 := D403;
            D2008 := D92;
        ELSE
            D2000 := D406;
            D2012 := D92;
        END_IF;
        step := 61;

    61: (* Arrived at original lift *)
        IF active_st = 1 THEN
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND X61 THEN
                Y30 := TRUE;
                seq_cnt := seq_cnt + 1;
                D82 := seq_cnt;
                D81 := active_st;
                D80 := 2; (* Placement back to lift *)
                D2004 := 18000;
                step := 62;
            END_IF;
        ELSE
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 AND X62 THEN
                Y30 := TRUE;
                seq_cnt := seq_cnt + 1;
                D82 := seq_cnt;
                D81 := active_st;
                D80 := 2; (* Placement back to lift *)
                D2004 := 18000;
                step := 62;
            END_IF;
        END_IF;

    62: (* Fork extended to lift *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_in := TRUE;
            wait_pt := T#100ms;
            IF wait_timer.Q THEN
                D2004 := 0;
                step := 63;
            END_IF;
        END_IF;

    63: (* Fork retracted, release brake, lower lift to home *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y30 := FALSE;
            IF active_st = 1 THEN
                D2008 := 15000;
            ELSE
                D2012 := 15000;
            END_IF;
            step := 64;
        END_IF;

    64: (* Lift back at home coordinate *)
        IF (active_st = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
           (active_st = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
            IF active_ch = 0 THEN
                D300 := active_id;
                IF active_cancel THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                last_r0_id := active_id;
            ELSE
                D302 := active_id;
                IF active_cancel THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                last_r1_id := active_id;
            END_IF;
            step := 1;
        END_IF;

    100: (* All done: bring all axes to home posture *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        D2016 := 0;
        D2020 := 0;
        D2024 := 0;
        D2028 := 0;
        D2032 := 5000;
        Y30 := FALSE;
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032 - 5000) <= 20 AND ABS(D1033) <= 100 THEN
            final_in := TRUE;
            IF final_timer.Q THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            final_in := FALSE;
        END_IF;
END_CASE;

wait_timer(IN := wait_in, PT := wait_pt);
final_timer(IN := final_in, PT := T#100ms);

END_PROGRAM