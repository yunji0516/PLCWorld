PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT;
    D1012 : DINT; D1013 : DINT; D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT;
    D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT; D1032 : DINT; D1033 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT;
    X30 : BOOL; X31 : BOOL; D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT;
    X34 : BOOL; X35 : BOOL; X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT;
    X52 : BOOL; X53 : BOOL; D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT;
    X62 : BOOL; D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D502 : DINT; D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT;
    D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D620 : DINT; D621 : DINT; D622 : DINT; D623 : DINT; D624 : DINT;
    D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL; D2004 : DINT; D2005 : DINT; D2006 : DINT;
    Y41 : BOOL; D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL; D2012 : DINT; D2013 : DINT;
    D2014 : DINT; Y43 : BOOL; D2016 : DINT; D2017 : DINT; D2018 : DINT; Y44 : BOOL; D2020 : DINT;
    D2021 : DINT; D2022 : DINT; Y45 : BOOL; D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL;
    D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL; D2032 : DINT; D2033 : DINT; D2034 : DINT;
    Y48 : BOOL; D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT; Y70 : BOOL; Y71 : BOOL;
    D700 : DINT; D701 : DINT; D702 : DINT; Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT;
    D712 : DINT; D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;

    sys_step : INT := 0;
    req_sel : INT := -1;
    lift_id : INT := 1;
    seq_num : DINT := 1;
    
    t_wait : TON;
    t_obs : TON;
    
    tgt_a : DINT := 0;
    tgt_b : DINT := 0;
    tgt_c : DINT := 15000;
    tgt_d : DINT := 15000;
    tgt_s3_0 : DINT := 0;
    tgt_s3_1 : DINT := 0;
    tgt_s3_2 : DINT := 0;
    tgt_s4_0 : DINT := 0;
    tgt_s4_1 : DINT := 5000;
    
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    
    r0_ack_id : DINT := 0;
    r1_ack_id : DINT := 0;
    r0_status : DINT := 0;
    r1_status : DINT := 0;
    
    a_ok : BOOL;
    b_ok : BOOL;
    c_ok : BOOL;
    d_ok : BOOL;
    s3_0_ok : BOOL;
    s3_1_ok : BOOL;
    s3_2_ok : BOOL;
    s4_0_ok : BOOL;
    s4_1_ok : BOOL;
END_VAR

a_ok := ABS(D1000 - tgt_a) <= 20 AND ABS(D1001) <= 100;
b_ok := ABS(D1004 - tgt_b) <= 20 AND ABS(D1005) <= 100;
c_ok := ABS(D1008 - tgt_c) <= 20 AND ABS(D1009) <= 100;
d_ok := ABS(D1012 - tgt_d) <= 20 AND ABS(D1013) <= 100;
s3_0_ok := ABS(D1016 - tgt_s3_0) <= 20 AND ABS(D1017) <= 100;
s3_1_ok := ABS(D1020 - tgt_s3_1) <= 20 AND ABS(D1021) <= 100;
s3_2_ok := ABS(D1024 - tgt_s3_2) <= 20 AND ABS(D1025) <= 100;
s4_0_ok := ABS(D1028 - tgt_s4_0) <= 20 AND ABS(D1029) <= 100;
s4_1_ok := ABS(D1032 - tgt_s4_1) <= 20 AND ABS(D1033) <= 100;

CASE sys_step OF
    0:
        Y2 := FALSE;
        Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
        D700 := 0; D701 := 0; D702 := 0;
        D710 := 0; D711 := 0; D712 := 0;
        D80 := 0; D81 := 0; D82 := 0;
        D300 := 0; D301 := 0; D302 := 0; D303 := 0;
        IF NOT r0_done AND D100 <> 0 THEN
            req_sel := 0;
            sys_step := 10;
        ELSIF NOT r1_done AND D120 <> 0 THEN
            req_sel := 1;
            sys_step := 10;
        END_IF;
        
    10:
        IF req_sel = 0 THEN
            lift_id := D101;
            r0_ack_id := D100;
            r0_status := 1;
            IF X31 THEN r0_status := 2; END_IF;
        ELSE
            lift_id := D121;
            r1_ack_id := D120;
            r1_status := 1;
            IF X35 THEN r1_status := 2; END_IF;
        END_IF;
        
        tgt_s3_0 := 0; tgt_s3_1 := 0; tgt_s3_2 := 0;
        tgt_s4_0 := 0; tgt_s4_1 := 5000;
        tgt_b := 0;
        t_wait(IN := FALSE, PT := T#80ms);
        t_obs(IN := FALSE, PT := T#100ms);
        sys_step := 20;
        
    20:
        IF lift_id = 1 THEN tgt_a := -360000; ELSE tgt_a := -230000; END_IF;
        IF a_ok THEN sys_step := 30; END_IF;
        
    30:
        tgt_c := 73250; tgt_d := 73250; tgt_b := 18000;
        IF c_ok AND d_ok AND b_ok THEN sys_step := 40; END_IF;
        
    40:
        tgt_a := 490000;
        IF a_ok THEN sys_step := 50; END_IF;
        
    50:
        Y70 := TRUE; Y71 := TRUE;
        D700 := D520; D701 := D526;
        tgt_s3_0 := D500; tgt_s3_1 := D501; tgt_s3_2 := D502;
        D702 := 600;
        
        t_wait(IN := s3_0_ok AND s3_1_ok AND s3_2_ok, PT := T#80ms);
        IF t_wait.Q THEN
            Y70 := FALSE; Y71 := FALSE;
            t_wait(IN := FALSE, PT := T#80ms);
            sys_step := 60;
        END_IF;
        
    60:
        tgt_s3_0 := 0; tgt_s3_1 := 0; tgt_s3_2 := 0;
        tgt_a := 114000;
        IF a_ok AND s3_0_ok AND s3_1_ok AND s3_2_ok THEN sys_step := 70; END_IF;
        
    70:
        Y75 := TRUE; Y76 := TRUE;
        tgt_s4_0 := D600; tgt_s4_1 := 50000;
        D710 := D620; D711 := D626;
        D712 := 600;
        
        t_wait(IN := s4_0_ok AND s4_1_ok, PT := T#80ms);
        IF t_wait.Q THEN
            t_wait(IN := FALSE, PT := T#80ms);
            sys_step := 80;
        END_IF;
        
    80:
        tgt_s4_1 := 70000;
        IF s4_1_ok THEN
            t_wait(IN := TRUE, PT := T#80ms);
            IF t_wait.Q THEN
                t_wait(IN := FALSE, PT := T#80ms);
                sys_step := 90;
            END_IF;
        END_IF;
        
    90:
        Y75 := FALSE; Y76 := FALSE;
        tgt_s4_0 := 0; tgt_s4_1 := 5000;
        IF lift_id = 1 THEN tgt_a := -360000; ELSE tgt_a := -230000; END_IF;
        IF a_ok AND s4_0_ok AND s4_1_ok THEN sys_step := 100; END_IF;
        
    100:
        tgt_b := 0; tgt_c := 15000; tgt_d := 15000;
        IF b_ok AND c_ok AND d_ok THEN sys_step := 110; END_IF;
        
    110:
        D80 := 2; D81 := lift_id; D82 := seq_num; seq_num := seq_num + 1;
        IF req_sel = 0 THEN
            D300 := r0_ack_id; D301 := r0_status; r0_done := TRUE;
        ELSE
            D302 := r1_ack_id; D303 := r1_status; r1_done := TRUE;
        END_IF;
        sys_step := 120;
        
    120:
        D80 := 0; D81 := 0;
        IF (NOT r0_done AND D100 <> 0) OR (NOT r1_done AND D120 <> 0) THEN
            sys_step := 0;
        ELSE
            sys_step := 200;
        END_IF;
        
    200:
        tgt_a := 0; tgt_b := 0;
        tgt_c := 15000; tgt_d := 15000;
        tgt_s3_0 := 0; tgt_s3_1 := 0; tgt_s3_2 := 0;
        tgt_s4_0 := 0; tgt_s4_1 := 5000;
        
        IF a_ok AND b_ok AND c_ok AND d_ok AND s3_0_ok AND s3_1_ok AND s3_2_ok AND s4_0_ok AND s4_1_ok THEN
            t_obs(IN := TRUE, PT := T#100ms);
            IF t_obs.Q THEN Y2 := TRUE; END_IF;
        ELSE
            t_obs(IN := FALSE, PT := T#100ms);
        END_IF;
        
ELSE
    sys_step := 0;
END_CASE;

D2000 := tgt_a; D2001 := 850; Y40 := sys_step >= 10 AND sys_step <= 200;
D2004 := tgt_b; D2005 := 700; Y41 := sys_step >= 30 AND sys_step <= 100;
D2008 := tgt_c; D2009 := 850; Y42 := sys_step >= 30 AND sys_step <= 100;
D2012 := tgt_d; D2013 := 700; Y43 := sys_step >= 30 AND sys_step <= 100;
D2016 := tgt_s3_0; D2017 := 850; Y44 := sys_step >= 50 AND sys_step <= 60;
D2020 := tgt_s3_1; D2021 := 700; Y45 := sys_step >= 50 AND sys_step <= 60;
D2024 := tgt_s3_2; D2025 := 850; Y46 := sys_step >= 50 AND sys_step <= 60;
D2028 := tgt_s4_0; D2029 := 700; Y47 := sys_step >= 70 AND sys_step <= 90;
D2032 := tgt_s4_1; D2033 := 850; Y48 := sys_step >= 70 AND sys_step <= 90;

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;

Y30 := NOT (Y40 OR Y41 OR Y42 OR Y43 OR Y44 OR Y45 OR Y46 OR Y47 OR Y48);

END_PROGRAM