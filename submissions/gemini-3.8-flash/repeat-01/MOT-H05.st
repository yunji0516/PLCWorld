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
    wait_cnt : INT := 0;
    curr_req : INT := 0;
    curr_id : DINT := 0;
    curr_loc : DINT := 0;
    curr_status : DINT := 1;
    active_axis : INT := 0;
    target_pos : DINT := 0;
    done_mask : INT := 0;
    seq_counter : DINT := 10;
    captured_reg : DINT := 0;
    c3_settle : INT := 0;
    c4_settle : INT := 0;
    all_finished : BOOL := FALSE;
    hold_cnt : INT := 0;
    init_done : BOOL := FALSE;
END_VAR

IF NOT init_done THEN
    init_done := TRUE;
    D2000 := 0;
    D2001 := 1000;
    D2002 := 0;
    Y40 := TRUE;

    D2004 := 0;
    D2005 := 1000;
    D2006 := 0;
    Y41 := TRUE;

    D2008 := 15000;
    D2009 := 1000;
    D2010 := 0;
    Y42 := TRUE;

    D2012 := 15000;
    D2013 := 1000;
    D2014 := 0;
    Y43 := TRUE;

    D2016 := -60000;
    D2017 := 1000;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := -60000;
    D2021 := 1000;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := 0;
    D2025 := 1000;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := 0;
    D2029 := 1000;
    D2030 := 0;
    Y47 := TRUE;

    D2032 := 0;
    D2033 := 1000;
    D2034 := 0;
    Y48 := TRUE;

    Y30 := FALSE;
    D80 := 0;
    D81 := 0;
    D82 := 0;
    Y2 := FALSE;
END_IF;

CASE step OF
    0: (* Wait for request *)
        IF (done_mask AND 1) = 0 AND D100 <> 0 THEN
            curr_req := 0;
            curr_id := D100;
            curr_loc := D101;
            curr_status := 1;
            IF X31 THEN
                curr_status := 2;
            END_IF;
            step := 10;
        ELSIF (done_mask AND 2) = 0 AND D120 <> 0 THEN
            curr_req := 1;
            curr_id := D120;
            curr_loc := D121;
            curr_status := 1;
            IF X35 THEN
                curr_status := 2;
            END_IF;
            step := 10;
        ELSIF (done_mask = 3) OR X51 THEN
            step := 900;
        END_IF;

    10: (* Lift station to dock height *)
        IF curr_loc = 1 THEN
            D2008 := D92;
        ELSE
            D2012 := D92;
        END_IF;
        step := 11;

    11: (* Wait lift dock height *)
        IF curr_loc = 1 THEN
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 12;
            END_IF;
        ELSE
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 12;
            END_IF;
        END_IF;

    12: (* Move shuttle A to lift docking X *)
        IF curr_loc = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        step := 13;

    13: (* Wait shuttle A arrival *)
        IF (curr_loc = 1 AND ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100) OR
           (curr_loc = 2 AND ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100) THEN
            wait_cnt := 0;
            step := 14;
        END_IF;

    14: (* Settle and verify port ready *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 2 THEN
            IF (curr_loc = 1 AND X61) OR (curr_loc = 2 AND X62) THEN
                D2004 := 18000;
                step := 15;
            END_IF;
        END_IF;

    15: (* Wait fork connect (180 mm) *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1;
            D81 := curr_loc;
            wait_cnt := 0;
            step := 16;
        END_IF;

    16: (* Wait extraction ownership handover *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 5 AND D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0;
            step := 17;
        END_IF;

    17: (* Wait fork retract to 0 mm *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF curr_status = 2 THEN
                step := 500;
            ELSE
                step := 100;
            END_IF;
        END_IF;

    100: (* Move shuttle A to Cell 3 (station 3) *)
        D2000 := D409;
        step := 101;

    101: (* Wait shuttle A at Cell 3 *)
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
            wait_cnt := 0;
            step := 102;
        END_IF;

    102: (* Check port 3 ready *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 2 AND X63 THEN
            D2004 := 18000;
            step := 103;
        END_IF;

    103: (* Wait fork connect to Cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2;
            D81 := 3;
            wait_cnt := 0;
            step := 104;
        END_IF;

    104: (* Wait placement in Cell 3 *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 5 AND D410 = curr_id THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0;
            step := 105;
        END_IF;

    105: (* Wait fork retract *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 110;
        END_IF;

    110: (* Configure Cell 3 capture *)
        D700 := curr_id;
        D701 := 0;
        D702 := 1000;
        Y70 := TRUE;
        Y71 := TRUE;
        active_axis := INT(m3_lane);
        IF active_axis = 0 THEN
            target_pos := D500 + 25000;
            D2016 := target_pos;
        ELSE
            target_pos := D501 + 25000;
            D2020 := target_pos;
        END_IF;
        c3_settle := 0;
        step := 111;

    111: (* Wait Cell 3 axis arrival *)
        IF (active_axis = 0 AND ABS(D1016 - target_pos) <= 20 AND ABS(D1017) <= 100) OR
           (active_axis = 1 AND ABS(D1020 - target_pos) <= 20 AND ABS(D1021) <= 100) THEN
            IF D522 = curr_id AND D524 = D91 THEN
                captured_reg := D523;
                c3_settle := c3_settle + 1;
                IF c3_settle >= 4 AND X70 THEN
                    IF active_axis = 0 THEN
                        D2016 := -60000;
                    ELSE
                        D2020 := -60000;
                    END_IF;
                    step := 112;
                END_IF;
            END_IF;
        END_IF;

    112: (* Wait Cell 3 axis return to home -600 mm *)
        IF (active_axis = 0 AND ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100) OR
           (active_axis = 1 AND ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100) THEN
            wait_cnt := 0;
            step := 113;
        END_IF;

    113: (* Wait port 3 ready for extraction *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 2 AND X63 THEN
            D2004 := 18000;
            step := 114;
        END_IF;

    114: (* Connect fork to retrieve jig from Cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1;
            D81 := 3;
            wait_cnt := 0;
            step := 115;
        END_IF;

    115: (* Wait extraction from Cell 3 *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 5 AND D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0;
            step := 116;
        END_IF;

    116: (* Wait fork retract *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 200;
        END_IF;

    200: (* Move shuttle A to Cell 4 (station 4) *)
        D2000 := D412;
        step := 201;

    201: (* Wait shuttle A at Cell 4 *)
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
            wait_cnt := 0;
            step := 202;
        END_IF;

    202: (* Check port 4 ready *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 2 AND X64 THEN
            D2004 := 18000;
            step := 203;
        END_IF;

    203: (* Connect fork to Cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2;
            D81 := 4;
            wait_cnt := 0;
            step := 204;
        END_IF;

    204: (* Wait placement into Cell 4 *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 5 AND D413 = curr_id THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0;
            step := 205;
        END_IF;

    205: (* Wait fork retract *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 210;
        END_IF;

    210: (* Ensure pins retracted before rotating index *)
        D2028 := 0;
        D2032 := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            step := 211;
        END_IF;

    211: (* Rotate index s4_0 to requested angle *)
        D710 := curr_id;
        D711 := 0;
        D712 := 1000;
        Y75 := TRUE;
        Y76 := TRUE;
        D2024 := D600;
        step := 212;

    212: (* Wait rotation arrival *)
        IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 THEN
            IF D620 = 0 THEN
                D2028 := 4000;
            ELSE
                D2032 := 4000;
            END_IF;
            c4_settle := 0;
            step := 213;
        END_IF;

    213: (* Wait pin insertion (40 mm) *)
        IF (D620 = 0 AND ABS(D1028 - 4000) <= 20 AND ABS(D1029) <= 100) OR
           (D620 <> 0 AND ABS(D1032 - 4000) <= 20 AND ABS(D1033) <= 100) THEN
            c4_settle := c4_settle + 1;
            IF c4_settle >= 4 AND X75 THEN
                D2028 := 0;
                D2032 := 0;
                step := 214;
            END_IF;
        END_IF;

    214: (* Wait pin retraction to 0 mm *)
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            D2024 := 0;
            step := 215;
        END_IF;

    215: (* Wait index rotation return to 0 deg *)
        IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
            wait_cnt := 0;
            step := 216;
        END_IF;

    216: (* Wait port 4 ready for extraction *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 2 AND X64 THEN
            D2004 := 18000;
            step := 217;
        END_IF;

    217: (* Connect fork to retrieve jig from Cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1;
            D81 := 4;
            wait_cnt := 0;
            step := 218;
        END_IF;

    218: (* Wait extraction from Cell 4 *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 5 AND D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            D2004 := 0;
            step := 219;
        END_IF;

    219: (* Wait fork retract *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            step := 500;
        END_IF;

    500: (* Move shuttle A back to lift docking position *)
        IF curr_loc = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        step := 501;

    501: (* Wait shuttle A at lift dock position *)
        IF (curr_loc = 1 AND ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100) OR
           (curr_loc = 2 AND ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100) THEN
            wait_cnt := 0;
            step := 502;
        END_IF;

    502: (* Wait port ready for placement back to lift *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 2 THEN
            IF (curr_loc = 1 AND X61) OR (curr_loc = 2 AND X62) THEN
                D2004 := 18000;
                step := 503;
            END_IF;
        END_IF;

    503: (* Connect fork *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2;
            D81 := curr_loc;
            wait_cnt := 0;
            step := 504;
        END_IF;

    504: (* Wait jig placed into lift *)
        wait_cnt := wait_cnt + 1;
        IF wait_cnt >= 5 THEN
            IF (curr_loc = 1 AND D404 = curr_id) OR (curr_loc = 2 AND D407 = curr_id) THEN
                D80 := 0;
                D81 := 0;
                D2004 := 0;
                step := 505;
            END_IF;
        END_IF;

    505: (* Wait fork retract *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF curr_loc = 1 THEN
                D2008 := 15000;
            ELSE
                D2012 := 15000;
            END_IF;
            step := 506;
        END_IF;

    506: (* Wait lift descend to initial height 150 mm *)
        IF (curr_loc = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
           (curr_loc = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
            IF curr_req = 0 THEN
                D300 := curr_id;
                D301 := curr_status;
                done_mask := done_mask OR 1;
            ELSE
                D302 := curr_id;
                D303 := curr_status;
                done_mask := done_mask OR 2;
            END_IF;
            step := 0;
        END_IF;

    900: (* Bring all axes to home coordinates *)
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        D2016 := -60000;
        D2020 := -60000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        Y70 := FALSE;
        Y71 := FALSE;
        Y75 := FALSE;
        Y76 := FALSE;
        D80 := 0;
        D81 := 0;
        step := 901;

    901: (* Verify all axes at home and stopped *)
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            all_finished := TRUE;
            step := 902;
        END_IF;

    902: (* Maintain Y2 for observation *)
        Y2 := TRUE;
END_CASE;

IF all_finished THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM