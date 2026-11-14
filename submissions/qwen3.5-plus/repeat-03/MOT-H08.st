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
    req0_active : BOOL := FALSE; req0_cancelled : BOOL := FALSE; req0_done : BOOL := FALSE;
    req1_active : BOOL := FALSE; req1_cancelled : BOOL := FALSE; req1_done : BOOL := FALSE;
    current_req : INT := 0;
    step : INT := 0;
    station_x : DINT := 0;
    target_a : DINT := 0; target_b : DINT := 0; target_c : DINT := 40000; target_d : DINT := 40000;
    target_s3_0 : DINT := -60000; target_s3_1 : DINT := -60000;
    target_s4_0 : DINT := 0; target_s4_1 : DINT := 0; target_s4_2 : DINT := 0;
    move_a : BOOL := FALSE; move_b : BOOL := FALSE; move_c : BOOL := FALSE; move_d : BOOL := FALSE;
    move_s3_0 : BOOL := FALSE; move_s3_1 : BOOL := FALSE;
    move_s4_0 : BOOL := FALSE; move_s4_1 : BOOL := FALSE; move_s4_2 : BOOL := FALSE;
    settled : BOOL := FALSE;
    settle_timer : TON;
    complete_timer : TON;
    seq_cnt : DINT := 1;
    is_cancel : BOOL := FALSE;
    prev_r0_id : DINT := 0; prev_r1_id : DINT := 0;
    angleA : REAL; angleB : REAL; sinA : REAL; sinB : REAL; x_calc : DINT;
    current_loc : INT := 0;
    all_at_home : BOOL := FALSE;
    req_id : DINT := 0;
END_VAR

IF (D100 <> 0) AND (D100 <> prev_r0_id) AND NOT req0_done THEN
    req0_active := TRUE;
    req0_cancelled := FALSE;
END_IF;
prev_r0_id := D100;

IF (D120 <> 0) AND (D120 <> prev_r1_id) AND NOT req1_done THEN
    req1_active := TRUE;
    req1_cancelled := FALSE;
END_IF;
prev_r1_id := D120;

IF X31 THEN req0_cancelled := TRUE; END_IF;
IF X35 THEN req1_cancelled := TRUE; END_IF;

IF step = 0 THEN
    IF req0_active AND NOT req0_done THEN
        current_req := 0;
        is_cancel := req0_cancelled;
        req_id := D100;
        current_loc := D101;
        step := 1;
    ELSIF req1_active AND NOT req1_done THEN
        current_req := 1;
        is_cancel := req1_cancelled;
        req_id := D120;
        current_loc := D121;
        step := 1;
    END_IF;
END_IF;

settle_timer(IN := (move_a OR move_b OR move_c OR move_d OR move_s3_0 OR move_s3_1 OR move_s4_0 OR move_s4_1 OR move_s4_2) AND 
    (ABS(D1000 - target_a) <= 20) AND (ABS(D1001) <= 100) AND
    (ABS(D1004 - target_b) <= 20) AND (ABS(D1005) <= 100) AND
    (ABS(D1008 - target_c) <= 20) AND (ABS(D1009) <= 100) AND
    (ABS(D1012 - target_d) <= 20) AND (ABS(D1013) <= 100) AND
    (ABS(D1016 - target_s3_0) <= 20) AND (ABS(D1017) <= 100) AND
    (ABS(D1020 - target_s3_1) <= 20) AND (ABS(D1021) <= 100) AND
    (ABS(D1024 - target_s4_0) <= 20) AND (ABS(D1025) <= 100) AND
    (ABS(D1028 - target_s4_1) <= 20) AND (ABS(D1029) <= 100) AND
    (ABS(D1032 - target_s4_2) <= 20) AND (ABS(D1033) <= 100), PT := T#30ms);
settled := settle_timer.Q;

all_at_home := (D1000 = 0) AND (D1004 = 0) AND (D1008 = 40000) AND (D1012 = 40000) AND
    (D1016 = -60000) AND (D1020 = -60000) AND (D1024 = 0) AND (D1028 = 0) AND (D1032 = 0);
complete_timer(IN := (req0_done AND req1_done) AND all_at_home, PT := T#100ms);
Y2 := complete_timer.Q;

CASE step OF
    0: NULL;
    1: 
        target_c := 95000; target_d := 95000;
        move_c := TRUE; move_d := TRUE;
        IF settled THEN move_c := FALSE; move_d := FALSE; step := 2; END_IF;
    2: 
        CASE current_loc OF
            1: station_x := -405000;
            2: station_x := -185000;
            3: station_x := 490000;
            4: station_x := 1140000;
            ELSE station_x := -405000;
        END_CASE;
        target_a := station_x;
        move_a := TRUE;
        IF settled THEN move_a := FALSE; step := 3; END_IF;
    3: 
        target_b := 18000;
        move_b := TRUE;
        D80 := 2; D81 := current_loc; D82 := seq_cnt; seq_cnt := seq_cnt + 1;
        IF settled THEN
            move_b := FALSE;
            IF is_cancel THEN step := 7; ELSE step := 4; END_IF;
        END_IF;
    4: 
        target_s3_0 := LIMIT(-60000, D500, 95000);
        target_s3_1 := LIMIT(-60000, D501, 95000);
        move_s3_0 := TRUE; move_s3_1 := TRUE;
        Y70 := TRUE; Y71 := TRUE; D700 := D520; D701 := D526; D702 := 500;
        IF settled THEN
            move_s3_0 := FALSE; move_s3_1 := FALSE;
            Y70 := FALSE; Y71 := FALSE;
            step := 5;
        END_IF;
    5: 
        target_s4_0 := LIMIT(-4500, D600, 4500);
        target_s4_1 := LIMIT(-4500, D601, 4500);
        angleA := REAL(target_s4_0) / 100.0;
        angleB := REAL(target_s4_1) / 100.0;
        sinA := SIN(angleA * 0.0174532925);
        sinB := SIN(angleB * 0.0174532925);
        x_calc := DINT((-225.0 * (sinA + sinB) + 100.0) * 100.0);
        target_s4_2 := LIMIT(-45000, x_calc, 45000);
        move_s4_0 := TRUE; move_s4_1 := TRUE; move_s4_2 := TRUE;
        Y75 := TRUE; Y76 := TRUE; D710 := D620; D711 := D626; D712 := 500;
        IF settled THEN
            move_s4_0 := FALSE; move_s4_1 := FALSE; move_s4_2 := FALSE;
            Y75 := FALSE; Y76 := FALSE;
            step := 6;
        END_IF;
    6: 
        target_s3_0 := -60000; target_s3_1 := -60000;
        target_s4_0 := 0; target_s4_1 := 0; target_s4_2 := 0;
        move_s3_0 := TRUE; move_s3_1 := TRUE;
        move_s4_0 := TRUE; move_s4_1 := TRUE; move_s4_2 := TRUE;
        IF settled THEN
            move_s3_0 := FALSE; move_s3_1 := FALSE;
            move_s4_0 := FALSE; move_s4_1 := FALSE; move_s4_2 := FALSE;
            step := 7;
        END_IF;
    7: 
        target_b := 0;
        move_b := TRUE;
        D80 := 1;
        IF settled THEN move_b := FALSE; step := 8; END_IF;
    8: 
        target_a := 0;
        move_a := TRUE;
        IF settled THEN move_a := FALSE; step := 9; END_IF;
    9: 
        target_c := 40000; target_d := 40000;
        move_c := TRUE; move_d := TRUE;
        IF settled THEN move_c := FALSE; move_d := FALSE; step := 10; END_IF;
    10: 
        IF current_req = 0 THEN
            D300 := req_id; D301 := 2; IF NOT is_cancel THEN D301 := 1; END_IF;
            req0_done := TRUE; req0_active := FALSE;
        ELSE
            D302 := req_id; D303 := 2; IF NOT is_cancel THEN D303 := 1; END_IF;
            req1_done := TRUE; req1_active := FALSE;
        END_IF;
        step := 0; is_cancel := FALSE;
END_CASE;

D2000 := target_a; D2001 := 500; D2002 := 0; Y40 := move_a;
D2004 := target_b; D2005 := 500; D2006 := 0; Y41 := move_b;
D2008 := target_c; D2009 := 500; D2010 := 0; Y42 := move_c;
D2012 := target_d; D2013 := 500; D2014 := 0; Y43 := move_d;
D2016 := target_s3_0; D2017 := 500; D2018 := 0; Y44 := move_s3_0;
D2020 := target_s3_1; D2021 := 500; D2022 := 0; Y45 := move_s3_1;
D2024 := target_s4_0; D2025 := 500; D2026 := 0; Y46 := move_s4_0;
D2028 := target_s4_1; D2029 := 500; D2030 := 0; Y47 := move_s4_1;
D2032 := target_s4_2; D2033 := 500; D2034 := 0; Y48 := move_s4_2;
Y30 := FALSE;

END_PROGRAM