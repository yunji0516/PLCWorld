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

    init_done : BOOL;
    seq_counter : DINT;

    step : INT;
    cur_ch : INT;
    cur_req_id : DINT;
    cur_orig_station : DINT;
    cur_cancelled : BOOL;

    settle_cnt : INT;
    m3_hold_cnt : INT;
    m4_hold_cnt : INT;
    all_done_cnt : INT;

    t_rad : REAL;
    x_cw : REAL;
    s4_err : REAL;
    s4_v : REAL;
    sway_rad : REAL;
    sway_vel : REAL;
    L_m : REAL;
    dL_m : REAL;
    accel_cmd : REAL;

    t_shuttle : DINT;
    t_fork : DINT;
    t_lift_a : DINT;
    t_lift_b : DINT;
    t_s3_0 : DINT;
    t_s3_1 : DINT;
    t_s4_0 : DINT;
    t_s4_1 : DINT;
    t_s4_2 : DINT;

    en_shuttle : BOOL;
    en_fork : BOOL;
    en_lift_a : BOOL;
    en_lift_b : BOOL;
    en_s3_0 : BOOL;
    en_s3_1 : BOOL;
    en_s4_0 : BOOL;
    en_s4_1 : BOOL;
    en_s4_2 : BOOL;
    brake_cmd : BOOL;

    r0_served : BOOL;
    r1_served : BOOL;
END_VAR

IF NOT init_done THEN
    init_done := TRUE;
    seq_counter := 1;
    step := 0;
    cur_ch := -1;
    cur_req_id := 0;
    cur_orig_station := 1;
    cur_cancelled := FALSE;

    settle_cnt := 0;
    m3_hold_cnt := 0;
    m4_hold_cnt := 0;
    all_done_cnt := 0;

    r0_served := FALSE;
    r1_served := FALSE;

    t_shuttle := 0;
    t_fork := 0;
    t_lift_a := 15000;
    t_lift_b := 15000;
    t_s3_0 := 0;
    t_s3_1 := 0;
    t_s4_0 := 100000;
    t_s4_1 := 0;
    t_s4_2 := 0;

    en_shuttle := TRUE;
    en_fork := TRUE;
    en_lift_a := TRUE;
    en_lift_b := TRUE;
    en_s3_0 := TRUE;
    en_s3_1 := TRUE;
    en_s4_0 := TRUE;
    en_s4_1 := TRUE;
    en_s4_2 := FALSE;
    brake_cmd := FALSE;

    D300 := 0;
    D301 := 0;
    D302 := 0;
    D303 := 0;
    D80 := 0;
    D81 := 0;
    D82 := 0;
    Y2 := FALSE;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    D700 := 0;
    D701 := 0;
    D702 := 0;
    D710 := 0;
    D711 := 0;
    D712 := 0;
END_IF;

CASE step OF
    0:
        IF D100 > 0 AND NOT r0_served THEN
            cur_ch := 0;
            cur_req_id := D100;
            IF D101 = 2 THEN cur_orig_station := 2; ELSE cur_orig_station := 1; END_IF;
            cur_cancelled := X31;
            step := 10;
        ELSIF D120 > 0 AND NOT r1_served THEN
            cur_ch := 1;
            cur_req_id := D120;
            IF D121 = 2 THEN cur_orig_station := 2; ELSE cur_orig_station := 1; END_IF;
            cur_cancelled := X35;
            step := 10;
        ELSIF X51 THEN
            step := 900;
        END_IF;

    10:
        IF cur_orig_station = 1 THEN
            t_lift_a := D92;
        ELSE
            t_lift_b := D92;
        END_IF;
        step := 11;

    11:
        IF cur_orig_station = 1 THEN
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                step := 20;
            END_IF;
        ELSE
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                step := 20;
            END_IF;
        END_IF;

    20:
        IF cur_orig_station = 1 THEN
            t_shuttle := D403;
        ELSE
            t_shuttle := D406;
        END_IF;
        step := 21;

    21:
        IF ABS(D1000 - t_shuttle) <= 20 AND ABS(D1001) <= 100 THEN
            IF (cur_orig_station = 1 AND X61) OR (cur_orig_station = 2 AND X62) THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 30;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    30:
        t_fork := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D80 := 1;
            D81 := cur_orig_station;
            D82 := seq_counter;
            step := 31;
        END_IF;

    31:
        IF D90 = cur_req_id THEN
            step := 40;
        END_IF;

    40:
        t_fork := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            IF cur_orig_station = 1 THEN
                t_lift_a := 15000;
            ELSE
                t_lift_b := 15000;
            END_IF;
            IF cur_cancelled THEN
                step := 200;
            ELSE
                step := 50;
            END_IF;
        END_IF;

    50:
        t_shuttle := D409;
        t_s3_0 := 0;
        t_s3_1 := 0;
        step := 51;

    51:
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 60;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    60:
        t_fork := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D80 := 2;
            D81 := 3;
            D82 := seq_counter;
            step := 61;
        END_IF;

    61:
        IF D410 = cur_req_id AND D90 = 0 THEN
            step := 62;
        END_IF;

    62:
        t_fork := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 70;
        END_IF;

    70:
        t_s3_0 := D500;
        t_rad := REAL(D500) * 0.000174532925;
        x_cw := -450.0 * SIN(t_rad);
        t_s3_1 := REAL_TO_DINT(x_cw * 100.0);
        step := 71;

    71:
        IF ABS(D1016 - t_s3_0) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - t_s3_1) <= 20 AND ABS(D1021) <= 100 THEN
            IF X70 THEN
                m3_hold_cnt := m3_hold_cnt + 1;
                IF m3_hold_cnt >= 5 THEN
                    m3_hold_cnt := 0;
                    step := 72;
                END_IF;
            ELSE
                m3_hold_cnt := 0;
            END_IF;
        ELSE
            m3_hold_cnt := 0;
        END_IF;

    72:
        t_s3_0 := 0;
        t_s3_1 := 0;
        IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 THEN
            step := 73;
        END_IF;

    73:
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND X63 THEN
            step := 80;
        ELSE
            t_shuttle := D409;
        END_IF;

    80:
        t_fork := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D80 := 1;
            D81 := 3;
            D82 := seq_counter;
            step := 81;
        END_IF;

    81:
        IF D90 = cur_req_id THEN
            step := 82;
        END_IF;

    82:
        t_fork := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 90;
        END_IF;

    90:
        t_shuttle := D412;
        t_s4_0 := 100000;
        t_s4_1 := 0;
        step := 91;

    91:
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                step := 100;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    100:
        t_fork := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D80 := 2;
            D81 := 4;
            D82 := seq_counter;
            step := 101;
        END_IF;

    101:
        IF D413 = cur_req_id AND D90 = 0 THEN
            step := 102;
        END_IF;

    102:
        t_fork := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 110;
        END_IF;

    110:
        t_s4_0 := D600;
        t_s4_1 := D601;
        step := 111;

    111:
        IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028 - D601) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 3 AND ABS(D1033) <= 15 THEN
            IF X75 THEN
                m4_hold_cnt := m4_hold_cnt + 1;
                IF m4_hold_cnt >= 5 THEN
                    m4_hold_cnt := 0;
                    step := 112;
                END_IF;
            ELSE
                m4_hold_cnt := 0;
            END_IF;
        ELSE
            m4_hold_cnt := 0;
        END_IF;

    112:
        t_s4_0 := 100000;
        t_s4_1 := 0;
        IF ABS(D1024 - 100000) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 3 AND ABS(D1033) <= 15 THEN
            step := 113;
        END_IF;

    113:
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND X64 THEN
            step := 120;
        ELSE
            t_shuttle := D412;
        END_IF;

    120:
        t_fork := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D80 := 1;
            D81 := 4;
            D82 := seq_counter;
            step := 121;
        END_IF;

    121:
        IF D90 = cur_req_id THEN
            step := 122;
        END_IF;

    122:
        t_fork := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            step := 200;
        END_IF;

    200:
        IF cur_orig_station = 1 THEN
            t_lift_a := D92;
            t_shuttle := D403;
        ELSE
            t_lift_b := D92;
            t_shuttle := D406;
        END_IF;
        step := 201;

    201:
        IF cur_orig_station = 1 THEN
            IF ABS(D1000 - D403) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND X61 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 210;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            IF ABS(D1000 - D406) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 AND X62 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    step := 210;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        END_IF;

    210:
        t_fork := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D80 := 2;
            D81 := cur_orig_station;
            D82 := seq_counter;
            step := 211;
        END_IF;

    211:
        IF cur_orig_station = 1 THEN
            IF D404 = cur_req_id AND D90 = 0 THEN
                step := 212;
            END_IF;
        ELSE
            IF D407 = cur_req_id AND D90 = 0 THEN
                step := 212;
            END_IF;
        END_IF;

    212:
        t_fork := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            D81 := 0;
            IF cur_orig_station = 1 THEN
                t_lift_a := 15000;
            ELSE
                t_lift_b := 15000;
            END_IF;
            step := 220;
        END_IF;

    220:
        IF cur_orig_station = 1 THEN
            IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                IF cur_ch = 0 THEN
                    D300 := cur_req_id;
                    IF cur_cancelled THEN D301 := 2; ELSE D301 := 1; END_IF;
                    r0_served := TRUE;
                ELSE
                    D302 := cur_req_id;
                    IF cur_cancelled THEN D303 := 2; ELSE D303 := 1; END_IF;
                    r1_served := TRUE;
                END_IF;
                step := 0;
            END_IF;
        ELSE
            IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                IF cur_ch = 0 THEN
                    D300 := cur_req_id;
                    IF cur_cancelled THEN D301 := 2; ELSE D301 := 1; END_IF;
                    r0_served := TRUE;
                ELSE
                    D302 := cur_req_id;
                    IF cur_cancelled THEN D303 := 2; ELSE D303 := 1; END_IF;
                    r1_served := TRUE;
                END_IF;
                step := 0;
            END_IF;
        END_IF;

    900:
        t_shuttle := 0;
        t_fork := 0;
        t_lift_a := 15000;
        t_lift_b := 15000;
        t_s3_0 := 0;
        t_s3_1 := 0;
        t_s4_0 := 100000;
        t_s4_1 := 0;
        t_s4_2 := 0;
        step := 901;

    901:
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024 - 100000) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 3 AND ABS(D1033) <= 15 THEN
            all_done_cnt := all_done_cnt + 1;
            IF all_done_cnt >= 5 THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            all_done_cnt := 0;
            Y2 := FALSE;
        END_IF;
END_CASE;

s4_err := REAL(t_s4_1 - D1028) * 0.01;
s4_v := REAL(D1029) * 0.01;
sway_rad := REAL(D1032) * 0.000174532925;
sway_vel := REAL(D1033) * 0.000174532925;
L_m := REAL(D1024) * 0.00001;
IF L_m < 0.2 THEN L_m := 0.2; END_IF;
dL_m := REAL(D1025) * 0.00001;

accel_cmd := (4.0 * s4_err - 3.5 * s4_v + 15.0 * L_m * sway_rad + 4.0 * L_m * sway_vel) * 100.0;
accel_cmd := LIMIT(-1000000.0, accel_cmd, 1000000.0);
D712 := REAL_TO_DINT(accel_cmd);

D2000 := LIMIT(-450000, t_shuttle, 1130000);
D2001 := 1000;
D2002 := 0;
Y40 := en_shuttle;

D2004 := LIMIT(0, t_fork, 18000);
D2005 := 1000;
D2006 := 0;
Y41 := en_fork;

D2008 := LIMIT(0, t_lift_a, 120000);
D2009 := 1000;
D2010 := 0;
Y42 := en_lift_a;

D2012 := LIMIT(0, t_lift_b, 120000);
D2013 := 1000;
D2014 := 0;
Y43 := en_lift_b;

D2016 := LIMIT(-5000, t_s3_0, 5000);
D2017 := 1000;
D2018 := 0;
Y44 := en_s3_0;

D2020 := LIMIT(-45000, t_s3_1, 45000);
D2021 := 1000;
D2022 := 0;
Y45 := en_s3_1;

D2024 := LIMIT(50000, t_s4_0, 150000);
D2025 := 1000;
D2026 := 0;
Y46 := en_s4_0;

D2028 := LIMIT(-100000, t_s4_1, 100000);
D2029 := 1000;
D2030 := 0;
Y47 := en_s4_1;

D2032 := 0;
D2033 := 0;
D2034 := 0;
Y48 := en_s4_2;

IF ABS(D1009) <= 100 AND ABS(D1013) <= 100 AND (step = 0 OR step = 901) THEN
    brake_cmd := TRUE;
ELSE
    brake_cmd := FALSE;
END_IF;
Y30 := brake_cmd;

END_PROGRAM