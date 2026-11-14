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

    step : INT := 0;
    c3_step : INT := 0;
    c4_step : INT := 0;
    cur_req : INT := -1;
    cur_id : DINT := 0;
    cur_stn : DINT := 1;
    seq_cnt : DINT := 0;
    wait_time : TIME := T#0ms;
    step_timer : TON;
    c3_timer : TON;
    c4_timer : TON;
    all_done_timer : TON;
    
    r0_completed : BOOL := FALSE;
    r1_completed : BOOL := FALSE;
    is_cancelled : BOOL := FALSE;
END_VAR

(* Timer invocations *)
step_timer(IN := (wait_time > T#0ms), PT := wait_time);
c3_timer(IN := (c3_step = 2), PT := T#120ms);
c4_timer(IN := (c4_step = 2), PT := T#120ms);

(* Default drives enable and rates *)
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

(* Cell 3 state machine *)
CASE c3_step OF
    0:
        D2016 := 0;
        D2020 := 5000;
        Y70 := FALSE;
        Y71 := FALSE;
    1:
        (* Rotate to target angle while precision slide is retracted (<= 500mm) *)
        D2020 := 5000;
        D2016 := D527;
        IF ABS(D1016 - D527) <= 20 AND ABS(D1017) <= 100 AND ABS(D1020 - 5000) <= 20 THEN
            (* Angle reached, approach to 700mm *)
            D2020 := 70000;
            c3_step := 2;
        END_IF;
    2:
        D2016 := D527;
        D2020 := 70000;
        IF ABS(D1020 - 70000) <= 20 AND ABS(D1021) <= 100 THEN
            Y71 := TRUE;
            IF c3_timer.Q OR X70 THEN
                (* Retreat precision slide back to 50mm before resetting angle *)
                D2020 := 5000;
                c3_step := 3;
            END_IF;
        END_IF;
    3:
        D2020 := 5000;
        IF ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 THEN
            D2016 := 0;
            c3_step := 4;
        END_IF;
    4:
        D2016 := 0;
        D2020 := 5000;
        IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
            c3_step := 0;
        END_IF;
END_CASE;

(* Cell 4 state machine *)
CASE c4_step OF
    0:
        D2024 := -6500;
        D2028 := 0;
        D2032 := 6500;
        D2036 := 0;
        Y75 := FALSE;
        Y76 := FALSE;
    1:
        (* Ensure extension <= 80mm before swiveling *)
        D2028 := 0;
        D2036 := 0;
        IF ABS(D1028) <= 2000 AND ABS(D1036) <= 2000 THEN
            D2024 := D627;
            D2032 := -D627;
            IF ABS(D1024 - D627) <= 20 AND ABS(D1032 - (-D627)) <= 20 AND ABS(D1025) <= 100 AND ABS(D1033) <= 100 THEN
                D2028 := D601;
                D2036 := D603;
                c4_step := 2;
            END_IF;
        END_IF;
    2:
        D2024 := D627;
        D2032 := -D627;
        D2028 := D601;
        D2036 := D603;
        IF ABS(D1028 - D601) <= 20 AND ABS(D1036 - D603) <= 20 THEN
            Y76 := TRUE;
            IF c4_timer.Q OR X75 THEN
                (* Retract boom to <= 80mm before returning swivel *)
                D2028 := 0;
                D2036 := 0;
                c4_step := 3;
            END_IF;
        END_IF;
    3:
        D2028 := 0;
        D2036 := 0;
        IF ABS(D1028) <= 2000 AND ABS(D1036) <= 2000 AND ABS(D1029) <= 100 AND ABS(D1037) <= 100 THEN
            D2024 := -6500;
            D2032 := 6500;
            c4_step := 4;
        END_IF;
    4:
        D2024 := -6500;
        D2032 := 6500;
        D2028 := 0;
        D2036 := 0;
        IF ABS(D1024 - (-6500)) <= 20 AND ABS(D1032 - 6500) <= 20 AND ABS(D1025) <= 100 AND ABS(D1033) <= 100 THEN
            c4_step := 0;
        END_IF;
END_CASE;

(* Main sequence *)
CASE step OF
    0:
        (* Idle / Wait for request *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        Y30 := FALSE;
        D80 := 0;
        D81 := 0;

        IF D100 > 0 AND NOT r0_completed THEN
            cur_req := 0;
            cur_id := D100;
            cur_stn := D101;
            is_cancelled := X31;
            step := 1;
        ELSIF D120 > 0 AND NOT r1_completed THEN
            cur_req := 1;
            cur_id := D120;
            cur_stn := D121;
            is_cancelled := X35;
            step := 1;
        END_IF;

    1:
        (* Raise corresponding elevator to dock height *)
        IF cur_stn = 1 THEN
            D2008 := D92;
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 2;
            END_IF;
        ELSE
            D2012 := D92;
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 2;
            END_IF;
        END_IF;

    2:
        (* Move shuttle to elevator dock position *)
        IF cur_stn = 1 THEN
            D2000 := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                step := 3;
            END_IF;
        ELSE
            D2000 := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                step := 3;
            END_IF;
        END_IF;

    3:
        (* Extract jig from elevator: fork extends to 180mm *)
        seq_cnt := seq_cnt + 1;
        D82 := seq_cnt;
        D80 := 1; (* Extraction *)
        D81 := cur_stn;
        D2004 := 18000;
        step := 4;

    4:
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_time := T#60ms;
            step := 5;
        END_IF;

    5:
        IF step_timer.Q THEN
            wait_time := T#0ms;
            (* Retract fork back to 0mm *)
            D2004 := 0;
            step := 6;
        END_IF;

    6:
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            (* Jig is now on shuttle *)
            IF (cur_req = 0 AND X31) OR (cur_req = 1 AND X35) OR is_cancelled THEN
                (* Cancelled: return immediately to elevator *)
                step := 20;
            ELSE
                (* Normal: proceed to Cell 3 *)
                step := 7;
            END_IF;
        END_IF;

    7:
        (* Move shuttle to Cell 3 *)
        D2000 := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            step := 8;
        END_IF;

    8:
        (* Place jig into Cell 3 *)
        seq_cnt := seq_cnt + 1;
        D82 := seq_cnt;
        D80 := 2; (* Placement *)
        D81 := 3;
        D2004 := 18000;
        step := 9;

    9:
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_time := T#60ms;
            step := 10;
        END_IF;

    10:
        IF step_timer.Q THEN
            wait_time := T#0ms;
            D2004 := 0;
            step := 11;
        END_IF;

    11:
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            (* Check cancellation before triggering cell 3 *)
            IF (cur_req = 0 AND X31) OR (cur_req = 1 AND X35) THEN
                is_cancelled := TRUE;
                step := 12; (* Retrieve from cell 3 *)
            ELSE
                c3_step := 1;
                step := 12;
            END_IF;
        END_IF;

    12:
        (* Wait for cell 3 completion or retrieve if cancelled *)
        IF (cur_req = 0 AND X31) OR (cur_req = 1 AND X35) THEN
            is_cancelled := TRUE;
        END_IF;

        IF c3_step = 0 THEN
            (* Cell 3 done or idle, retrieve jig *)
            seq_cnt := seq_cnt + 1;
            D82 := seq_cnt;
            D80 := 1; (* Extraction *)
            D81 := 3;
            D2004 := 18000;
            step := 13;
        END_IF;

    13:
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_time := T#60ms;
            step := 14;
        END_IF;

    14:
        IF step_timer.Q THEN
            wait_time := T#0ms;
            D2004 := 0;
            step := 15;
        END_IF;

    15:
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF is_cancelled THEN
                step := 20; (* Return to elevator *)
            ELSE
                step := 16; (* Move to Cell 4 *)
            END_IF;
        END_IF;

    16:
        (* Move shuttle to Cell 4 *)
        D2000 := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            step := 17;
        END_IF;

    17:
        (* Place jig into Cell 4 *)
        seq_cnt := seq_cnt + 1;
        D82 := seq_cnt;
        D80 := 2; (* Placement *)
        D81 := 4;
        D2004 := 18000;
        step := 18;

    18:
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_time := T#60ms;
            step := 19;
        END_IF;

    19:
        IF step_timer.Q THEN
            wait_time := T#0ms;
            D2004 := 0;
            step := 23;
        END_IF;

    23:
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF (cur_req = 0 AND X31) OR (cur_req = 1 AND X35) THEN
                is_cancelled := TRUE;
                step := 24;
            ELSE
                c4_step := 1;
                step := 24;
            END_IF;
        END_IF;

    24:
        (* Wait for cell 4 completion *)
        IF (cur_req = 0 AND X31) OR (cur_req = 1 AND X35) THEN
            is_cancelled := TRUE;
        END_IF;

        IF c4_step = 0 THEN
            seq_cnt := seq_cnt + 1;
            D82 := seq_cnt;
            D80 := 1; (* Extraction *)
            D81 := 4;
            D2004 := 18000;
            step := 25;
        END_IF;

    25:
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_time := T#60ms;
            step := 26;
        END_IF;

    26:
        IF step_timer.Q THEN
            wait_time := T#0ms;
            D2004 := 0;
            step := 27;
        END_IF;

    27:
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 20; (* Return to elevator *)
        END_IF;

    20:
        (* Move shuttle back to elevator *)
        IF cur_stn = 1 THEN
            D2000 := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                step := 21;
            END_IF;
        ELSE
            D2000 := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                step := 21;
            END_IF;
        END_IF;

    21:
        (* Place jig back into elevator *)
        seq_cnt := seq_cnt + 1;
        D82 := seq_cnt;
        D80 := 2; (* Placement *)
        D81 := cur_stn;
        D2004 := 18000;
        step := 22;

    22:
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            wait_time := T#60ms;
            step := 28;
        END_IF;

    28:
        IF step_timer.Q THEN
            wait_time := T#0ms;
            D2004 := 0;
            step := 29;
        END_IF;

    29:
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            (* Lower elevator to home height (150 mm) *)
            IF cur_stn = 1 THEN
                D2008 := 15000;
                IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                    step := 30;
                END_IF;
            ELSE
                D2012 := 15000;
                IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                    step := 30;
                END_IF;
            END_IF;
        END_IF;

    30:
        (* Respond with ack and status *)
        IF cur_req = 0 THEN
            D300 := cur_id;
            IF is_cancelled OR X31 THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            r0_completed := TRUE;
        ELSE
            D302 := cur_id;
            IF is_cancelled OR X35 THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            r1_completed := TRUE;
        END_IF;
        step := 0;
END_CASE;

(* Shuttle return to 0 when idle and ready for final completion *)
IF step = 0 THEN
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
END_IF;

(* Final completion check *)
all_done_timer(IN := (X51 AND (step = 0)
                      AND ABS(D1000) <= 20 AND ABS(D1001) <= 100
                      AND ABS(D1004) <= 20 AND ABS(D1005) <= 100
                      AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100
                      AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100
                      AND ABS(D1016) <= 20 AND ABS(D1017) <= 100
                      AND ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100
                      AND ABS(D1024 - (-6500)) <= 20 AND ABS(D1025) <= 100
                      AND ABS(D1028) <= 20 AND ABS(D1029) <= 100
                      AND ABS(D1032 - 6500) <= 20 AND ABS(D1033) <= 100
                      AND ABS(D1036) <= 20 AND ABS(D1037) <= 100),
               PT := T#100ms);

IF all_done_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM