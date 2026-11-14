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
    seq_cnt : DINT := 1;
    curr_req : INT := 0;
    curr_id : DINT := 0;
    curr_orig_stn : DINT := 1;
    curr_is_cancel : BOOL := FALSE;
    c4_angle_rad : REAL := 0.0;
    settle_cnt : INT := 0;
    t_wait : INT := 0;
    done_cnt : INT := 0;
    initialized : BOOL := FALSE;
END_VAR

IF NOT initialized THEN
    initialized := TRUE;
    D2000 := 0;
    D2001 := 800;
    D2002 := 0;
    Y40 := TRUE;

    D2004 := 0;
    D2005 := 800;
    D2006 := 0;
    Y41 := TRUE;

    D2008 := 40000;
    D2009 := 800;
    D2010 := 0;
    Y42 := TRUE;

    D2012 := 40000;
    D2013 := 800;
    D2014 := 0;
    Y43 := TRUE;

    D2016 := 100000;
    D2017 := 800;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := 0;
    D2021 := 800;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := 0;
    D2025 := 800;
    D2026 := 0;
    Y46 := FALSE;

    D2028 := 0;
    D2029 := 500;
    D2030 := 0;
    Y47 := TRUE;

    D2032 := 0;
    D2033 := 800;
    D2034 := 0;
    Y48 := TRUE;

    Y30 := FALSE;
    Y2 := FALSE;
    D80 := 0;
    D81 := 0;
    D82 := 0;
END_IF;

c4_angle_rad := REAL(D1028) * 0.00017453292519943295;
D2032 := -DINT(ROUND(45000.0 * SIN(c4_angle_rad)));
IF D2032 > 45000 THEN
    D2032 := 45000;
ELSIF D2032 < -45000 THEN
    D2032 := -45000;
END_IF;

IF t_wait > 0 THEN
    t_wait := t_wait - 1;
END_IF;

CASE step OF
    0:
        IF X51 THEN
            step := 900;
        ELSIF (D100 > 0) AND (D300 = 0) THEN
            curr_req := 0;
            curr_id := D100;
            curr_orig_stn := D101 + 1;
            curr_is_cancel := X31;
            step := 10;
        ELSIF (D120 > 0) AND (D302 = 0) THEN
            curr_req := 1;
            curr_id := D120;
            curr_orig_stn := D121 + 1;
            curr_is_cancel := X35;
            step := 10;
        END_IF;

    10:
        D2008 := D92;
        D2012 := D92;
        IF (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100) THEN
            step := 20;
        END_IF;

    20:
        IF curr_orig_stn = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
            IF ((curr_orig_stn = 1) AND X61) OR ((curr_orig_stn = 2) AND X62) THEN
                step := 30;
            END_IF;
        END_IF;

    30:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 1;
            D81 := curr_orig_stn;
            D82 := seq_cnt;
            step := 40;
        END_IF;

    40:
        IF D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 50;
        END_IF;

    50:
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            IF curr_is_cancel THEN
                step := 700;
            ELSE
                step := 100;
            END_IF;
        END_IF;

    100:
        D2000 := D409;
        IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND X63 THEN
            step := 110;
        END_IF;

    110:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 2;
            D81 := 3;
            D82 := seq_cnt;
            step := 120;
        END_IF;

    120:
        IF D410 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 130;
        END_IF;

    130:
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D700 := curr_id;
            Y70 := TRUE;
            step := 140;
        END_IF;

    140:
        D2016 := D500;
        D2020 := D501;
        IF (ABS(D1016 - D500) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020 - D501) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 5 THEN
                settle_cnt := 0;
                step := 150;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    150:
        IF X70 THEN
            Y70 := FALSE;
            D2016 := 100000;
            D2020 := 0;
            step := 160;
        END_IF;

    160:
        IF (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) AND X63 THEN
            step := 170;
        END_IF;

    170:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 1;
            D81 := 3;
            D82 := seq_cnt;
            step := 180;
        END_IF;

    180:
        IF D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 190;
        END_IF;

    190:
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            step := 200;
        END_IF;

    200:
        D2000 := D412;
        IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND X64 THEN
            step := 210;
        END_IF;

    210:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 2;
            D81 := 4;
            D82 := seq_cnt;
            step := 220;
        END_IF;

    220:
        IF D413 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 230;
        END_IF;

    230:
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D710 := curr_id;
            Y75 := TRUE;
            step := 240;
        END_IF;

    240:
        D2028 := D600;
        IF (ABS(D1028 - D600) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032 - D2032) <= 20) AND (ABS(D1033) <= 100) THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 5 THEN
                settle_cnt := 0;
                step := 250;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    250:
        IF X75 THEN
            Y75 := FALSE;
            D2028 := 0;
            step := 260;
        END_IF;

    260:
        IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND X64 THEN
            step := 270;
        END_IF;

    270:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 1;
            D81 := 4;
            D82 := seq_cnt;
            step := 280;
        END_IF;

    280:
        IF D90 = curr_id THEN
            D80 := 0;
            D81 := 0;
            step := 290;
        END_IF;

    290:
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            step := 300;
        END_IF;

    300:
        IF curr_orig_stn = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
            IF ((curr_orig_stn = 1) AND X61) OR ((curr_orig_stn = 2) AND X62) THEN
                step := 310;
            END_IF;
        END_IF;

    310:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 2;
            D81 := curr_orig_stn;
            D82 := seq_cnt;
            step := 320;
        END_IF;

    320:
        IF ((curr_orig_stn = 1) AND (D404 = curr_id)) OR
           ((curr_orig_stn = 2) AND (D407 = curr_id)) THEN
            D80 := 0;
            D81 := 0;
            step := 330;
        END_IF;

    330:
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D2008 := 40000;
            D2012 := 40000;
            step := 340;
        END_IF;

    340:
        IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) THEN
            IF curr_req = 0 THEN
                D300 := curr_id;
                D301 := 1;
            ELSE
                D302 := curr_id;
                D303 := 1;
            END_IF;
            step := 0;
        END_IF;

    700:
        IF curr_orig_stn = 1 THEN
            D2000 := D403;
        ELSE
            D2000 := D406;
        END_IF;
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
            IF ((curr_orig_stn = 1) AND X61) OR ((curr_orig_stn = 2) AND X62) THEN
                step := 710;
            END_IF;
        END_IF;

    710:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            seq_cnt := seq_cnt + 1;
            D80 := 2;
            D81 := curr_orig_stn;
            D82 := seq_cnt;
            step := 720;
        END_IF;

    720:
        IF ((curr_orig_stn = 1) AND (D404 = curr_id)) OR
           ((curr_orig_stn = 2) AND (D407 = curr_id)) THEN
            D80 := 0;
            D81 := 0;
            step := 730;
        END_IF;

    730:
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D2008 := 40000;
            D2012 := 40000;
            step := 740;
        END_IF;

    740:
        IF (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) THEN
            IF curr_req = 0 THEN
                D300 := curr_id;
                D301 := 2;
            ELSE
                D302 := curr_id;
                D303 := 2;
            END_IF;
            step := 0;
        END_IF;

    900:
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := 100000;
        D2020 := 0;
        D2028 := 0;
        IF (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
           (ABS(D1016 - 100000) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024) <= 3) AND (ABS(D1025) <= 15) AND
           (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
            done_cnt := done_cnt + 1;
            IF done_cnt >= 5 THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            done_cnt := 0;
            Y2 := FALSE;
        END_IF;
END_CASE;

END_PROGRAM