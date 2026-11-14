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
    (* Internal state *)
    sm : INT := 0;
    cur_req : INT := -1;
    r0_proc : BOOL := FALSE;
    r1_proc : BOOL := FALSE;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    r0_cancelled : BOOL := FALSE;
    r1_cancelled : BOOL := FALSE;
    tgt_a : DINT := 0;
    tgt_b : DINT := 0;
    tgt_c : DINT := 40000;
    tgt_d : DINT := 40000;
    tgt_s3_0 : DINT := 0;
    tgt_s3_1 : DINT := 5000;
    tgt_s4_0 : DINT := 0;
    tgt_s4_1 : DINT := 0;
    tgt_s4_2 : DINT := 0;
    ra : DINT := 1000;
    rb : DINT := 1000;
    rc : DINT := 1000;
    rd : DINT := 1000;
    rs3_0 : DINT := 1000;
    rs3_1 : DINT := 1000;
    rs4_0 : DINT := 1000;
    rs4_1 : DINT := 1000;
    rs4_2 : DINT := 1000;
    tmr_settle : TON;
    tmr_comp : TON;
    tmr_y2 : TON;
    seq : DINT := 0;
    scan_cnt : DINT := 0;
    ack0_done : BOOL := FALSE;
    ack1_done : BOOL := FALSE;
    prev_r0_id : DINT := -1;
    prev_r1_id : DINT := -1;
    prev_r0_loc : DINT := -1;
    prev_r1_loc : DINT := -1;
    lift_x : DINT := -405000;
    cell3_x : DINT := 0;
    cell4_x : DINT := 360000;
    lift_home_h : DINT := 40000;
    dock_h : DINT := 95000;
    fork_conn : DINT := 18000;
    fork_ret : DINT := 0;
    cell3_home_a : DINT := 0;
    cell3_home_s : DINT := 5000;
    cell4_home_a : DINT := 0;
    cell4_home_p1 : DINT := 0;
    cell4_home_p2 : DINT := 0;
    y2_start_scan : DINT := 0;
    completion_observed : BOOL := FALSE;
    edge_r0 : R_TRIG;
    edge_r1 : R_TRIG;
    r0_active_new : BOOL := FALSE;
    r1_active_new : BOOL := FALSE;
END_VAR

scan_cnt := scan_cnt + 1;
edge_r0(CLK := D100 > 0 AND prev_r0_id <= 0);
edge_r1(CLK := D120 > 0 AND prev_r1_id <= 0);

IF D100 > 0 AND prev_r0_id <= 0 THEN
    r0_active_new := TRUE;
END_IF;
IF D120 > 0 AND prev_r1_id <= 0 THEN
    r1_active_new := TRUE;
END_IF;
prev_r0_id := D100;
prev_r1_id := D120;
prev_r0_loc := D101;
prev_r1_loc := D121;

IF X31 THEN r0_cancelled := TRUE; END_IF;
IF X35 THEN r1_cancelled := TRUE; END_IF;

Y30 := FALSE;
Y40 := tgt_a <> 0 OR tgt_b <> 0 OR tgt_c <> 40000 OR tgt_d <> 40000 OR tgt_s3_0 <> 0 OR tgt_s3_1 <> 5000 OR tgt_s4_0 <> 0 OR tgt_s4_1 <> 0 OR tgt_s4_2 <> 0 OR sm > 0;
IF sm = 0 AND tgt_a = 0 AND tgt_b = 0 AND tgt_c = 40000 AND tgt_d = 40000 THEN
    Y40 := FALSE;
END_IF;

CASE sm OF
    0: (* IDLE - select request by deadline *)
        tgt_a := 0;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        tgt_s3_0 := cell3_home_a;
        tgt_s3_1 := cell3_home_s;
        tgt_s4_0 := cell4_home_a;
        tgt_s4_1 := cell4_home_p1;
        tgt_s4_2 := cell4_home_p2;
        D80 := 0;
        D81 := 0;
        D82 := 0;
        ack0_done := FALSE;
        ack1_done := FALSE;
        
        IF NOT r0_done AND NOT r0_cancelled AND r0_active_new OR (D100 > 0 AND NOT r0_done) THEN
            cur_req := 0;
            r0_proc := TRUE;
            r0_cancelled := X31;
            IF D101 = 1 THEN
                lift_x := -405000;
            ELSIF D101 = 2 THEN
                lift_x := -185000;
            END_IF;
            sm := 1;
        ELSIF NOT r1_done AND NOT r1_cancelled AND r1_active_new OR (D120 > 0 AND NOT r1_done) THEN
            cur_req := 1;
            r1_proc := TRUE;
            r1_cancelled := X35;
            IF D121 = 1 THEN
                lift_x := -405000;
            ELSIF D121 = 2 THEN
                lift_x := -185000;
            END_IF;
            sm := 1;
        END_IF;
        
    1: (* MOVE shuttle to lift *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        IF ABS(D1000 - lift_x) < 200 AND ABS(D1001) < 100 THEN
            sm := 2;
        END_IF;
        
    2: (* LOWER lift to dock height *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        IF cur_req = 0 AND (D101 = 1 OR prev_r0_loc = 1) THEN
            tgt_c := dock_h;
            tgt_d := lift_home_h;
        ELSIF cur_req = 1 AND (D121 = 2 OR prev_r1_loc = 2) THEN
            tgt_d := dock_h;
            tgt_c := lift_home_h;
        ELSE
            tgt_c := dock_h;
            tgt_d := lift_home_h;
        END_IF;
        
        tmr_settle(IN := (cur_req = 0 AND tgt_c = dock_h AND ABS(D1008 - dock_h) < 200) OR (cur_req = 1 AND tgt_d = dock_h AND ABS(D1012 - dock_h) < 200), PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 3;
        END_IF;
        
    3: (* CONNECT - extraction *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        IF cur_req = 0 AND (D101 = 1 OR prev_r0_loc = 1) THEN
            tgt_c := dock_h;
            tgt_d := lift_home_h;
        ELSIF cur_req = 1 AND (D121 = 2 OR prev_r1_loc = 2) THEN
            tgt_d := dock_h;
            tgt_c := lift_home_h;
        ELSE
            tgt_c := dock_h;
            tgt_d := lift_home_h;
        END_IF;
        
        seq := seq + 1;
        IF cur_req = 0 AND (D101 = 1 OR prev_r0_loc = 1) THEN
            D81 := 1;
        ELSIF cur_req = 1 AND (D121 = 2 OR prev_r1_loc = 2) THEN
            D81 := 2;
        ELSE
            D81 := 1;
        END_IF;
        D80 := 1;
        D82 := seq;
        
        IF (cur_req = 0 AND (D101 = 1 OR prev_r0_loc = 1) AND X61) OR (cur_req = 1 AND (D121 = 2 OR prev_r1_loc = 2) AND X62) THEN
            tmr_settle(IN := TRUE, PT := T#80ms);
            IF tmr_settle.Q THEN
                sm := 4;
            END_IF;
        END_IF;
        
    4: (* RAISE lift back to home *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        tmr_settle(IN := ABS(D1008 - lift_home_h) < 200 AND ABS(D1012 - lift_home_h) < 200, PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 5;
        END_IF;
        
    5: (* MOVE shuttle to cell 3 *)
        tgt_a := cell3_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        IF ABS(D1000 - cell3_x) < 200 AND ABS(D1001) < 100 THEN
            sm := 6;
        END_IF;
        
    6: (* CELL 3 - configure and rotate *)
        tgt_a := cell3_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        Y70 := TRUE;
        Y71 := TRUE;
        IF cur_req = 0 THEN
            D700 := 0;
            tgt_s3_0 := D500;
            tgt_s3_1 := 500;
        ELSE
            D700 := 1;
            tgt_s3_0 := D600;
            tgt_s3_1 := 500;
        END_IF;
        
        tmr_settle(IN := tgt_s3_0 <> 0 AND ABS(D1016 - tgt_s3_0) < 200 AND ABS(D1017) < 100, PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 7;
        END_IF;
        
    7: (* CELL 3 - approach *)
        tgt_a := cell3_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        Y70 := TRUE;
        Y71 := TRUE;
        tgt_s3_0 := D500;
        tgt_s3_1 := 70000;
        
        tmr_settle(IN := ABS(D1020 - 70000) < 200 AND ABS(D1021) < 100, PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 8;
        END_IF;
        
    8: (* CELL 3 - process and hold *)
        tgt_a := cell3_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        Y70 := TRUE;
        Y71 := TRUE;
        tgt_s3_0 := D500;
        tgt_s3_1 := 70000;
        
        tmr_settle(IN := X72, PT := T#80ms);
        IF tmr_settle.Q THEN
            sm := 9;
        END_IF;
        
    9: (* CELL 3 - retract *)
        tgt_a := cell3_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        Y70 := TRUE;
        Y71 := TRUE;
        tgt_s3_0 := cell3_home_a;
        tgt_s3_1 := cell3_home_s;
        
        tmr_settle(IN := ABS(D1016 - cell3_home_a) < 200 AND ABS(D1020 - cell3_home_s) < 200, PT := T#30ms);
        IF tmr_settle.Q THEN
            Y70 := FALSE;
            Y71 := FALSE;
            sm := 10;
        END_IF;
        
    10: (* MOVE shuttle to cell 4 *)
        tgt_a := cell4_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        IF ABS(D1000 - cell4_x) < 200 AND ABS(D1001) < 100 THEN
            sm := 11;
        END_IF;
        
    11: (* CELL 4 - retrieve pins and rotate *)
        tgt_a := cell4_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        Y75 := TRUE;
        Y76 := TRUE;
        IF cur_req = 0 THEN
            D710 := 0;
        ELSE
            D710 := 1;
        END_IF;
        tgt_s4_1 := 0;
        tgt_s4_2 := 0;
        tgt_s4_0 := D600;
        
        tmr_settle(IN := tgt_s4_0 <> 0 AND ABS(D1024 - tgt_s4_0) < 200 AND ABS(D1025) < 100, PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 12;
        END_IF;
        
    12: (* CELL 4 - insert pin *)
        tgt_a := cell4_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        Y75 := TRUE;
        Y76 := TRUE;
        tgt_s4_0 := D600;
        tgt_s4_1 := 4000;
        tgt_s4_2 := 0;
        
        tmr_settle(IN := ABS(D1028 - 4000) < 200, PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 13;
        END_IF;
        
    13: (* CELL 4 - process and hold *)
        tgt_a := cell4_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        Y75 := TRUE;
        Y76 := TRUE;
        tgt_s4_0 := D600;
        tgt_s4_1 := 4000;
        tgt_s4_2 := 0;
        
        tmr_settle(IN := X77, PT := T#80ms);
        IF tmr_settle.Q THEN
            sm := 14;
        END_IF;
        
    14: (* CELL 4 - retract *)
        tgt_a := cell4_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        Y75 := TRUE;
        Y76 := TRUE;
        tgt_s4_0 := cell4_home_a;
        tgt_s4_1 := cell4_home_p1;
        tgt_s4_2 := cell4_home_p2;
        
        tmr_settle(IN := ABS(D1024 - cell4_home_a) < 200 AND ABS(D1028 - cell4_home_p1) < 200 AND ABS(D1032 - cell4_home_p2) < 200, PT := T#30ms);
        IF tmr_settle.Q THEN
            Y75 := FALSE;
            Y76 := FALSE;
            sm := 15;
        END_IF;
        
    15: (* MOVE shuttle back to lift *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        IF ABS(D1000 - lift_x) < 200 AND ABS(D1001) < 100 THEN
            sm := 16;
        END_IF;
        
    16: (* LOWER lift for dropoff *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        IF cur_req = 0 AND (D101 = 1 OR prev_r0_loc = 1) THEN
            tgt_c := dock_h;
            tgt_d := lift_home_h;
        ELSIF cur_req = 1 AND (D121 = 2 OR prev_r1_loc = 2) THEN
            tgt_d := dock_h;
            tgt_c := lift_home_h;
        ELSE
            tgt_c := dock_h;
            tgt_d := lift_home_h;
        END_IF;
        
        tmr_settle(IN := (cur_req = 0 AND tgt_c = dock_h AND ABS(D1008 - dock_h) < 200) OR (cur_req = 1 AND tgt_d = dock_h AND ABS(D1012 - dock_h) < 200), PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 17;
        END_IF;
        
    17: (* DISCONNECT - placement *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        IF cur_req = 0 AND (D101 = 1 OR prev_r0_loc = 1) THEN
            tgt_c := dock_h;
            tgt_d := lift_home_h;
        ELSIF cur_req = 1 AND (D121 = 2 OR prev_r1_loc = 2) THEN
            tgt_d := dock_h;
            tgt_c := lift_home_h;
        ELSE
            tgt_c := dock_h;
            tgt_d := lift_home_h;
        END_IF;
        
        seq := seq + 1;
        IF cur_req = 0 AND (D101 = 1 OR prev_r0_loc = 1) THEN
            D81 := 1;
        ELSIF cur_req = 1 AND (D121 = 2 OR prev_r1_loc = 2) THEN
            D81 := 2;
        ELSE
            D81 := 1;
        END_IF;
        D80 := 2;
        D82 := seq;
        
        IF (cur_req = 0 AND (D101 = 1 OR prev_r0_loc = 1) AND X61) OR (cur_req = 1 AND (D121 = 2 OR prev_r1_loc = 2) AND X62) THEN
            tmr_settle(IN := TRUE, PT := T#80ms);
            IF tmr_settle.Q THEN
                sm := 18;
            END_IF;
        END_IF;
        
    18: (* RAISE lift back *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        tmr_settle(IN := ABS(D1008 - lift_home_h) < 200 AND ABS(D1012 - lift_home_h) < 200, PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 19;
        END_IF;
        
    19: (* ACKNOWLEDGE *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        IF cur_req = 0 THEN
            D300 := D100;
            IF r0_cancelled THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            ack0_done := TRUE;
        ELSIF cur_req = 1 THEN
            D302 := D120;
            IF r1_cancelled THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            ack1_done := TRUE;
        END_IF;
        
        tmr_settle(IN := TRUE, PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 20;
        END_IF;
        
    20: (* CHECK request completion *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        IF cur_req = 0 THEN
            r0_proc := FALSE;
            r0_done := TRUE;
        ELSE
            r1_proc := FALSE;
            r1_done := TRUE;
        END_IF;
        
        tmr_settle(IN := TRUE, PT := T#20ms);
        IF tmr_settle.Q THEN
            sm := 21;
        END_IF;
        
    21: (* HANDLE OTHER REQUEST OR RETURN HOME *)
        tgt_a := lift_x;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        IF NOT r0_done AND NOT r0_cancelled AND D100 > 0 THEN
            cur_req := 0;
            r0_proc := TRUE;
            r0_cancelled := X31;
            IF D101 = 1 THEN
                lift_x := -405000;
            ELSIF D101 = 2 THEN
                lift_x := -185000;
            END_IF;
            sm := 1;
        ELSIF NOT r1_done AND NOT r1_cancelled AND D120 > 0 THEN
            cur_req := 1;
            r1_proc := TRUE;
            r1_cancelled := X35;
            IF D121 = 1 THEN
                lift_x := -405000;
            ELSIF D121 = 2 THEN
                lift_x := -185000;
            END_IF;
            sm := 1;
        ELSE
            sm := 22;
        END_IF;
        
    22: (* RETURN shuttle home *)
        tgt_a := 0;
        tgt_b := fork_conn;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        IF ABS(D1000) < 200 AND ABS(D1001) < 100 THEN
            sm := 23;
        END_IF;
        
    23: (* RETURN fork home *)
        tgt_a := 0;
        tgt_b := fork_ret;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        
        tmr_settle(IN := ABS(D1004) < 200, PT := T#30ms);
        IF tmr_settle.Q THEN
            sm := 24;
        END_IF;
        
    24: (* CHECK COMPLETION *)
        tgt_a := 0;
        tgt_b := fork_ret;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        tgt_s3_0 := cell3_home_a;
        tgt_s3_1 := cell3_home_s;
        tgt_s4_0 := cell4_home_a;
        tgt_s4_1 := cell4_home_p1;
        tgt_s4_2 := cell4_home_p2;
        
        all_req_done := r0_done AND r1_done;
        IF all_req_done AND NOT completion_observed THEN
            y2_start_scan := scan_cnt;
            completion_observed := TRUE;
        END_IF;
        
        IF completion_observed THEN
            tmr_y2(IN := TRUE, PT := T#100ms);
            IF tmr_y2.Q THEN
                Y2 := TRUE;
                sm := 25;
            END_IF;
        ELSE
            tmr_y2(IN := FALSE, PT := T#100ms);
        END_IF;
        
    25: (* MAINTAIN COMPLETION *)
        tgt_a := 0;
        tgt_b := fork_ret;
        tgt_c := lift_home_h;
        tgt_d := lift_home_h;
        tgt_s3_0 := cell3_home_a;
        tgt_s3_1 := cell3_home_s;
        tgt_s4_0 := cell4_home_a;
        tgt_s4_1 := cell4_home_p1;
        tgt_s4_2 := cell4_home_p2;
        Y2 := TRUE;
        
    ELSE
        sm := 0;
END_CASE;

D2000 := tgt_a;
D2001 := ra;
D2002 := 0;

D2004 := tgt_b;
D2005 := rb;
D2006 := 0;

D2008 := tgt_c;
D2009 := rc;
D2010 := 0;

D2012 := tgt_d;
D2013 := rd;
D2014 := 0;

D2016 := tgt_s3_0;
D2017 := rs3_0;
D2018 := 0;

D2020 := tgt_s3_1;
D2021 := rs3_1;
D2022 := 0;

D2024 := tgt_s4_0;
D2025 := rs4_0;
D2026 := 0;

D2028 := tgt_s4_1;
D2029 := rs4_1;
D2030 := 0;

D2032 := tgt_s4_2;
D2033 := rs4_2;
D2034 := 0;

END_PROGRAM