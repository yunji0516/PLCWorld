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
    active_req : INT := 0;
    active_id : DINT := 0;
    active_station : DINT := 0;
    seq_cnt : DINT := 1;
    wait_cnt : DINT := 0;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    target_captured : DINT := 0;
    last_epoch : DINT := -1;
    cell3_timer : DINT := 0;
    cell4_timer : DINT := 0;
    all_finished : BOOL := FALSE;
    hold_cnt : DINT := 0;
END_VAR

(* Set common rates and enables *)
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

D702 := 1000;
D712 := 1000;

(* Select active request if idle *)
IF step = 0 THEN
    IF NOT req0_done AND D100 <> 0 THEN
        active_req := 0;
        active_id := D100;
        active_station := D101;
        step := 10;
    ELSIF NOT req1_done AND D120 <> 0 THEN
        active_req := 1;
        active_id := D120;
        active_station := D121;
        step := 10;
    ELSIF req0_done AND req1_done THEN
        all_finished := TRUE;
    END_IF;
END_IF;

(* Sequence control *)
CASE step OF
    0:
        (* Idle - keep initial positions *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        D2016 := -60000;
        D2020 := -60000;
        D2024 := -60000;
        D2028 := -60000;
        Y70 := FALSE;
        Y75 := FALSE;
        D80 := 0;
        D81 := 0;

    10:
        (* Move lift of active request to docking height *)
        IF active_station = 1 THEN
            D2008 := D92;
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 11;
            END_IF;
        ELSE
            D2012 := D92;
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 11;
            END_IF;
        END_IF;

    11:
        (* Move shuttle X to lift port *)
        IF active_station = 1 THEN
            D2000 := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                step := 12;
            END_IF;
        ELSE
            D2000 := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                step := 12;
            END_IF;
        END_IF;

    12:
        (* Extend fork to 180mm to couple jig (action 1: extraction) *)
        D2004 := 18000;
        D80 := 1;
        D81 := active_station;
        D82 := seq_cnt;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_cnt := seq_cnt + 1;
            step := 13;
        END_IF;

    13:
        (* Retract fork to 0mm with jig on shuttle *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D90 = active_id THEN
            step := 20;
        END_IF;

    20:
        (* Move shuttle to Cell 3 *)
        D2000 := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            step := 21;
        END_IF;

    21:
        (* Place jig into Cell 3: extend fork (action 2: placement) *)
        D2004 := 18000;
        D80 := 2;
        D81 := 3;
        D82 := seq_cnt;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_cnt := seq_cnt + 1;
            step := 22;
        END_IF;

    22:
        (* Retract fork, leave jig in Cell 3 *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 23;
            wait_cnt := 0;
        END_IF;

    23:
        (* Cell 3 processing: configure reference frame while stopped *)
        D700 := active_id;
        D701 := D526;
        IF ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
            Y70 := TRUE;
            wait_cnt := wait_cnt + 1;
            IF wait_cnt >= 3 THEN
                step := 24;
            END_IF;
        END_IF;

    24:
        (* Deassert configure before motion *)
        Y70 := FALSE;
        (* Move Cell 3 work axes to goal *)
        D2016 := D500;
        D2020 := D501;
        IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - D501) <= 20 AND ABS(D1021) <= 100 THEN
            cell3_timer := cell3_timer + 1;
            IF cell3_timer >= 5 THEN
                step := 25;
            END_IF;
        ELSE
            cell3_timer := 0;
        END_IF;

    25:
        (* Return Cell 3 axes to initial posture *)
        D2016 := -60000;
        D2020 := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND X63 THEN
            step := 26;
        END_IF;

    26:
        (* Extract jig from Cell 3 *)
        D2004 := 18000;
        D80 := 1;
        D81 := 3;
        D82 := seq_cnt;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_cnt := seq_cnt + 1;
            step := 27;
        END_IF;

    27:
        (* Retract fork with jig *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D90 = active_id THEN
            step := 30;
        END_IF;

    30:
        (* Move shuttle to Cell 4 *)
        D2000 := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            step := 31;
        END_IF;

    31:
        (* Place jig into Cell 4 *)
        D2004 := 18000;
        D80 := 2;
        D81 := 4;
        D82 := seq_cnt;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_cnt := seq_cnt + 1;
            step := 32;
        END_IF;

    32:
        (* Retract fork *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 33;
            last_epoch := D91;
        END_IF;

    33:
        (* Cell 4 processing: set capture selection to active jig ID *)
        D710 := active_id;
        D711 := D626;
        (* Move Cell 4 axis across registration mark towards goal *)
        D2024 := D600;
        D2028 := D601;
        (* If common reference generation changed, discard and update *)
        IF D91 <> last_epoch THEN
            last_epoch := D91;
        END_IF;
        (* Check captured position matching ID and current epoch *)
        IF D622 = active_id AND D624 = D91 THEN
            target_captured := D623 + 25000;
            step := 34;
        END_IF;

    34:
        (* Stop at detected captured value + 250 mm *)
        D2024 := target_captured;
        IF ABS(D1024 - target_captured) <= 20 AND ABS(D1025) <= 100 THEN
            cell4_timer := cell4_timer + 1;
            IF cell4_timer >= 5 THEN
                step := 35;
            END_IF;
        ELSE
            cell4_timer := 0;
        END_IF;

    35:
        (* Return Cell 4 axes to initial posture *)
        D2024 := -60000;
        D2028 := -60000;
        IF ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - (-60000)) <= 20 AND ABS(D1029) <= 100 AND X64 THEN
            step := 36;
        END_IF;

    36:
        (* Extract jig from Cell 4 *)
        D2004 := 18000;
        D80 := 1;
        D81 := 4;
        D82 := seq_cnt;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_cnt := seq_cnt + 1;
            step := 37;
        END_IF;

    37:
        (* Retract fork *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND D90 = active_id THEN
            step := 40;
        END_IF;

    40:
        (* Move shuttle back to original lift port *)
        IF active_station = 1 THEN
            D2000 := D403;
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND X61 THEN
                step := 41;
            END_IF;
        ELSE
            D2000 := D406;
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND X62 THEN
                step := 41;
            END_IF;
        END_IF;

    41:
        (* Place jig back onto lift *)
        D2004 := 18000;
        D80 := 2;
        D81 := active_station;
        D82 := seq_cnt;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_cnt := seq_cnt + 1;
            step := 42;
        END_IF;

    42:
        (* Retract fork to 0 *)
        D2004 := 0;
        D80 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 43;
        END_IF;

    43:
        (* Return lift to initial height (150 mm = 15000) *)
        IF active_station = 1 THEN
            D2008 := 15000;
            IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                step := 44;
            END_IF;
        ELSE
            D2012 := 15000;
            IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                step := 44;
            END_IF;
        END_IF;

    44:
        (* Acknowledge completion of request *)
        IF active_req = 0 THEN
            D300 := active_id;
            D301 := 1;
            req0_done := TRUE;
        ELSE
            D302 := active_id;
            D303 := 1;
            req1_done := TRUE;
        END_IF;
        step := 0;
END_CASE;

(* Final completion check *)
IF all_finished OR X51 THEN
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := -60000;
    D2028 := -60000;

    IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
       ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
       ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
       ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
       ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
       ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND
       ABS(D1024 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND
       ABS(D1028 - (-60000)) <= 20 AND ABS(D1029) <= 100 THEN
        IF hold_cnt < 6 THEN
            hold_cnt := hold_cnt + 1;
        END_IF;
        IF hold_cnt >= 5 THEN
            Y2 := TRUE;
        END_IF;
    ELSE
        hold_cnt := 0;
        Y2 := FALSE;
    END_IF;
ELSE
    Y2 := FALSE;
    hold_cnt := 0;
END_IF;

END_PROGRAM