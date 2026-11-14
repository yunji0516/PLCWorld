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
    
    req_active : INT := 0;
    step : INT := 0;
    act_id : DINT := 0;
    act_origin : DINT := 0;
    act_cancelled : BOOL := FALSE;
    
    tgt_a : DINT := 0;
    tgt_b : DINT := 0;
    tgt_c : DINT := 400;
    tgt_s3_0 : DINT := -60000;
    tgt_s3_1 : DINT := -60000;
    tgt_s4_0 : DINT := 0;
    tgt_s4_1 : DINT := 0;

    cmd_c : DINT := 400;
    cmd_s3_0 : DINT := -60000;
    cmd_s3_1 : DINT := -60000;
    cmd_s4_0 : DINT := 0;
    cmd_s4_1 : DINT := 0;

    couple_seq_out : DINT := 0;
    ack0_out : DINT := 0;
    status0_out : DINT := 0;
    ack1_out : DINT := 0;
    status1_out : DINT := 0;
    
    home_reached : BOOL := FALSE;
END_VAR

act_cancelled := (req_active = 1 AND X31) OR (req_active = 2 AND X35);

IF req_active = 0 THEN
    IF D100 > 0 AND NOT X30 AND ack0_out <> D100 THEN
        req_active := 1; 
        act_id := D100; 
        act_origin := D101; 
        step := 1; 
        tgt_c := 95000;
    ELSIF D120 > 0 AND NOT X34 AND ack1_out <> D120 THEN
        req_active := 2; 
        act_id := D120; 
        act_origin := D121; 
        step := 1; 
        tgt_c := 95000;
    ELSIF X51 THEN
        tgt_a := 0;
        tgt_b := 0;
        tgt_c := 400;
        tgt_s3_0 := -60000; 
        tgt_s3_1 := -60000;
        tgt_s4_0 := 0; 
        tgt_s4_1 := 0;
    ELSE
        tgt_c := 95000; 
    END_IF;
ELSE
    CASE step OF
        1: 
            tgt_c := 95000;
            IF ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 THEN
                step := 2;
            END_IF;
            
        2: 
            IF act_origin = 1 THEN tgt_a := D403; ELSE tgt_a := D406; END_IF;
            IF ABS(D1000 - tgt_a) <= 20 AND ABS(D1001) <= 100 THEN
                step := 3;
            END_IF;
            
        3: 
            tgt_b := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                couple_seq_out := couple_seq_out + 1;
                step := 4;
            END_IF;
            
        4: 
            D80 := 1; 
            D81 := act_origin; 
            D82 := couple_seq_out;
            IF D90 = act_id THEN
                step := 5;
            END_IF;
            
        5: 
            tgt_b := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                IF act_cancelled THEN step := 24; ELSE step := 6; END_IF;
            END_IF;
            
        6: 
            tgt_a := D409;
            IF ABS(D1000 - tgt_a) <= 20 AND ABS(D1001) <= 100 THEN
                step := 7;
            END_IF;
            
        7: 
            tgt_b := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                couple_seq_out := couple_seq_out + 1;
                step := 8;
            END_IF;
            
        8: 
            D80 := 2; 
            D81 := 3; 
            D82 := couple_seq_out;
            IF D90 = 0 THEN
                step := 9;
            END_IF;
            
        9: 
            tgt_b := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                step := 10;
            END_IF;
            
        10: 
            D700 := act_id; 
            Y70 := TRUE;
            tgt_s3_0 := D500; 
            tgt_s3_1 := D501;
            IF act_cancelled OR X70 THEN
                step := 11;
            END_IF;
            
        11: 
            Y70 := FALSE;
            tgt_s3_0 := -60000; 
            tgt_s3_1 := -60000;
            IF ABS(D1016 + 60000) <= 20 AND ABS(D1020 + 60000) <= 20 THEN
                step := 12;
            END_IF;

        12: 
            tgt_b := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                couple_seq_out := couple_seq_out + 1;
                step := 13;
            END_IF;
            
        13: 
            D80 := 1; 
            D81 := 3; 
            D82 := couple_seq_out;
            IF D90 = act_id THEN
                step := 14;
            END_IF;
            
        14: 
            tgt_b := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                IF act_cancelled THEN step := 24; ELSE step := 15; END_IF;
            END_IF;
            
        15: 
            tgt_a := D412;
            IF ABS(D1000 - tgt_a) <= 20 AND ABS(D1001) <= 100 THEN
                step := 16;
            END_IF;
            
        16: 
            tgt_b := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                couple_seq_out := couple_seq_out + 1;
                step := 17;
            END_IF;
            
        17: 
            D80 := 2; 
            D81 := 4; 
            D82 := couple_seq_out;
            IF D90 = 0 THEN
                step := 18;
            END_IF;
            
        18: 
            D710 := act_id; 
            Y75 := TRUE;
            tgt_s4_0 := D600; 
            tgt_s4_1 := D601;
            IF act_cancelled OR X75 THEN
                step := 20;
            END_IF;
            
        20: 
            Y75 := FALSE;
            tgt_s4_0 := 0; 
            tgt_s4_1 := 0;
            IF ABS(D1024) <= 20 AND ABS(D1028) <= 20 THEN
                step := 21;
            END_IF;
            
        21: 
            tgt_b := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                couple_seq_out := couple_seq_out + 1;
                step := 22;
            END_IF;
            
        22: 
            D80 := 1; 
            D81 := 4; 
            D82 := couple_seq_out;
            IF D90 = act_id THEN
                step := 23;
            END_IF;
            
        23: 
            tgt_b := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                step := 24;
            END_IF;
            
        24: 
            IF act_origin = 1 THEN tgt_a := D403; ELSE tgt_a := D406; END_IF;
            IF ABS(D1000 - tgt_a) <= 20 AND ABS(D1001) <= 100 THEN
                step := 25;
            END_IF;
            
        25: 
            tgt_b := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                couple_seq_out := couple_seq_out + 1;
                step := 26;
            END_IF;
            
        26: 
            D80 := 2; 
            D81 := act_origin; 
            D82 := couple_seq_out;
            IF D90 = 0 THEN
                step := 27;
            END_IF;
            
        27: 
            tgt_b := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                step := 28;
            END_IF;
            
        28: 
            IF req_active = 1 THEN
                ack0_out := act_id;
                IF act_cancelled THEN status0_out := 2; ELSE status0_out := 1; END_IF;
            ELSE
                ack1_out := act_id;
                IF act_cancelled THEN status1_out := 2; ELSE status1_out := 1; END_IF;
            END_IF;
            req_active := 0;
            step := 0;
    END_CASE;
END_IF;

D2000 := tgt_a;
D2004 := tgt_b;

cmd_c := cmd_c + LIMIT(-500, tgt_c - cmd_c, 500);
D2008 := cmd_c;
D2012 := cmd_c;

cmd_s3_0 := cmd_s3_0 + LIMIT(-200, tgt_s3_0 - cmd_s3_0, 200);
cmd_s3_1 := cmd_s3_1 + LIMIT(-200, tgt_s3_1 - cmd_s3_1, 200);
D2016 := cmd_s3_0;
D2020 := cmd_s3_1;

cmd_s4_0 := cmd_s4_0 + LIMIT(-4, tgt_s4_0 - cmd_s4_0, 4);
cmd_s4_1 := cmd_s4_1 + LIMIT(-4, tgt_s4_1 - cmd_s4_1, 4);
D2024 := cmd_s4_0;
D2028 := cmd_s4_1;
D2032 := DINT( -22500.0 * (SIN( REAL(cmd_s4_0) * 0.0001745329 ) + SIN( REAL(cmd_s4_1) * 0.0001745329 )) );

D2001 := 1000; 
D2005 := 1000; 
D2009 := 1000; 
D2013 := 1000;
D2017 := 1000; 
D2021 := 1000; 
D2025 := 1000; 
D2029 := 1000; 
D2033 := 1000;

Y40 := TRUE; 
Y41 := TRUE; 
Y42 := TRUE; 
Y43 := TRUE;
Y44 := TRUE; 
Y45 := TRUE; 
Y46 := TRUE; 
Y47 := TRUE; 
Y48 := TRUE;
Y30 := FALSE;

D300 := ack0_out;
D301 := status0_out;
D302 := ack1_out;
D303 := status1_out;

home_reached := (ABS(D1000) <= 20 AND ABS(D1001) <= 100) AND
                (ABS(D1004) <= 20 AND ABS(D1005) <= 100) AND
                (ABS(D1008 - 400) <= 20 AND ABS(D1012 - 400) <= 20) AND
                (ABS(D1016 + 60000) <= 20 AND ABS(D1020 + 60000) <= 20) AND
                (ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20);

Y2 := X51 AND (req_active = 0) AND home_reached;

END_PROGRAM