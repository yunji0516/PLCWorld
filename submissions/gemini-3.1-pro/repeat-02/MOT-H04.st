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

    state : INT := 0;
    active_req : INT := 0;
    req_id : DINT := 0;
    req_loc : DINT := 0;
    req_cancel : BOOL := FALSE;
    req_progress : DINT := 0;
    port_x : DINT := 0;
    seq_counter : DINT := 0;

    lift_target : DINT := 40000;
    a_target_cmd : DINT := 0;
    b_target_cmd : DINT := 0;
    
    s3_0_target_var : DINT := 100000;
    s3_1_target_var : DINT := 0;
    s4_0_target_var : DINT := 0;
    
    ex_real : REAL;
    ev_real : REAL;
    eth_real : REAL;
    ew_real : REAL;
    pos_term : REAL;
    a_cmd_real : REAL;
    a_cmd : DINT;
    
    angle_rad : REAL;
    w_rad_s : REAL;
    s4_1_ideal : REAL;
END_VAR

// Enable all globally
Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
Y30 := FALSE;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000;

// Request Status Update
IF active_req = 1 THEN
    req_cancel := X31;
    req_progress := D102;
ELSIF active_req = 2 THEN
    req_cancel := X35;
    req_progress := D122;
ELSE
    req_cancel := FALSE;
    req_progress := 0;
END_IF;

// Main Sequence
CASE state OF
    0:
        IF D100 > 0 AND NOT X30 THEN
            active_req := 1;
            req_id := D100;
            req_loc := D101;
            state := 10;
        ELSIF D120 > 0 AND NOT X34 THEN
            active_req := 2;
            req_id := D120;
            req_loc := D121;
            state := 10;
        ELSIF X51 THEN
            state := 999;
        END_IF;

    10:
        lift_target := 95000;
        IF ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
            state := 15;
        END_IF;

    15:
        IF req_loc = 1 THEN port_x := D403; ELSE port_x := D406; END_IF;
        a_target_cmd := port_x;
        IF ABS(D1000 - port_x) <= 20 AND ABS(D1001) <= 100 THEN
            state := 20;
        END_IF;

    20:
        b_target_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; 
            D81 := req_loc;
            seq_counter := seq_counter + 1; 
            D82 := seq_counter;
            state := 30;
        END_IF;

    30:
        IF D90 = req_id THEN
            state := 40;
        END_IF;

    40:
        b_target_cmd := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF req_cancel THEN 
                state := 100; 
            ELSE 
                state := 50; 
            END_IF;
        END_IF;

    50:
        a_target_cmd := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
            state := 60;
        END_IF;

    60:
        b_target_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; 
            D81 := 3;
            seq_counter := seq_counter + 1; 
            D82 := seq_counter;
            state := 70;
        END_IF;

    70:
        IF D90 = 0 AND D410 = req_id THEN
            state := 80;
        END_IF;

    80:
        b_target_cmd := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF req_cancel THEN 
                state := 92; 
            ELSE 
                state := 90; 
            END_IF;
        END_IF;

    90:
        Y70 := TRUE; 
        D700 := req_id; 
        D701 := req_progress;
        IF X70 OR X71 THEN
            Y70 := FALSE; 
            D700 := 0;
            state := 91;
        END_IF;

    91:
        IF ABS(D1016 - 100000) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 3 
           AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND ABS(D1025) <= 15 THEN
            state := 92;
        END_IF;

    92:
        b_target_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; 
            D81 := 3;
            seq_counter := seq_counter + 1; 
            D82 := seq_counter;
            state := 93;
        END_IF;

    93:
        IF D90 = req_id THEN
            state := 94;
        END_IF;

    94:
        b_target_cmd := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF req_cancel THEN 
                state := 100; 
            ELSE 
                state := 95; 
            END_IF;
        END_IF;

    95:
        a_target_cmd := D412;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
            state := 96;
        END_IF;

    96:
        b_target_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; 
            D81 := 4;
            seq_counter := seq_counter + 1; 
            D82 := seq_counter;
            state := 97;
        END_IF;

    97:
        IF D90 = 0 AND D413 = req_id THEN
            state := 98;
        END_IF;

    98:
        b_target_cmd := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF req_cancel THEN 
                state := 992; 
            ELSE 
                state := 99; 
            END_IF;
        END_IF;

    99:
        Y75 := TRUE; 
        D710 := req_id; 
        D711 := req_progress;
        IF X75 OR X76 THEN
            Y75 := FALSE; 
            D710 := 0;
            state := 991;
        END_IF;

    991:
        IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
            state := 992;
        END_IF;

    992:
        b_target_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1; 
            D81 := 4;
            seq_counter := seq_counter + 1; 
            D82 := seq_counter;
            state := 993;
        END_IF;

    993:
        IF D90 = req_id THEN
            state := 994;
        END_IF;

    994:
        b_target_cmd := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 100;
        END_IF;

    100:
        IF req_loc = 1 THEN port_x := D403; ELSE port_x := D406; END_IF;
        a_target_cmd := port_x;
        IF ABS(D1000 - port_x) <= 20 AND ABS(D1001) <= 100 THEN
            state := 101;
        END_IF;

    101:
        b_target_cmd := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2; 
            D81 := req_loc;
            seq_counter := seq_counter + 1; 
            D82 := seq_counter;
            state := 102;
        END_IF;

    102:
        IF D90 = 0 THEN
            state := 103;
        END_IF;

    103:
        b_target_cmd := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 104;
        END_IF;

    104:
        lift_target := 40000;
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
            state := 105;
        END_IF;

    105:
        IF active_req = 1 THEN
            D300 := req_id;
            IF req_cancel THEN D301 := 2; ELSE D301 := 1; END_IF;
            IF D100 <> req_id THEN
                D300 := 0; D301 := 0; active_req := 0; state := 0;
            END_IF;
        ELSE
            D302 := req_id;
            IF req_cancel THEN D303 := 2; ELSE D303 := 1; END_IF;
            IF D120 <> req_id THEN
                D302 := 0; D303 := 0; active_req := 0; state := 0;
            END_IF;
        END_IF;

    999:
        lift_target := 40000;
        a_target_cmd := 0; 
        b_target_cmd := 0;
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND ABS(D1000) <= 20 AND ABS(D1004) <= 20 
           AND ABS(D1016 - 100000) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 3 
           AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

D2000 := a_target_cmd;
D2004 := b_target_cmd;
D2008 := lift_target;
D2012 := lift_target;

// Cell 3 Target Determination
IF state = 90 THEN
    s3_0_target_var := D500;
    s3_1_target_var := D501;
ELSIF state = 91 THEN
    s3_0_target_var := 100000;
    s3_1_target_var := 0;
ELSE
    s3_0_target_var := 100000;
    s3_1_target_var := 0;
END_IF;

// Cell 3 Drive
D2016 := s3_0_target_var;

ex_real := DINT_TO_REAL(D1020 - s3_1_target_var);
ev_real := DINT_TO_REAL(D1021);
eth_real := DINT_TO_REAL(D1024);
ew_real := DINT_TO_REAL(D1025);

pos_term := -0.5 * ex_real - 1.2 * ev_real;
IF pos_term > 5000.0 THEN pos_term := 5000.0; END_IF;
IF pos_term < -5000.0 THEN pos_term := -5000.0; END_IF;

a_cmd_real := pos_term + 50.0 * eth_real + 100.0 * ew_real;
IF a_cmd_real > 10000.0 THEN a_cmd_real := 10000.0; END_IF;
IF a_cmd_real < -10000.0 THEN a_cmd_real := -10000.0; END_IF;

a_cmd := REAL_TO_DINT(a_cmd_real);
D2020 := a_cmd;
D702 := a_cmd;
D2024 := 0;

// Cell 4 Target Determination
IF state = 99 THEN
    s4_0_target_var := D600;
ELSIF state = 991 THEN
    s4_0_target_var := 0;
ELSE
    s4_0_target_var := 0;
END_IF;

// Cell 4 Drive
D2028 := s4_0_target_var;

angle_rad := DINT_TO_REAL(D1028) * 3.1415926535 / 18000.0;
s4_1_ideal := -45000.0 * SIN(angle_rad);
D2032 := REAL_TO_DINT(s4_1_ideal);

w_rad_s := DINT_TO_REAL(D1029) * 3.1415926535 / 18000.0;
D2034 := REAL_TO_DINT(-45000.0 * COS(angle_rad) * w_rad_s);

END_PROGRAM