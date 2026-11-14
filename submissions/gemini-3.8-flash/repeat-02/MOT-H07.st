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
    D1040 : DINT;
    D1041 : DINT;
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
    D503 : DINT;
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
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
    D2040 : DINT;
    D2041 : DINT;
    D2042 : DINT;
    Y50 : BOOL;
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

    step : DINT := 0;
    active_req : DINT := 0;
    active_id : DINT := 0;
    active_stn : DINT := 0;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    all_finished : BOOL := FALSE;

    seq_cnt : DINT := 1;
    dwell_cnt : DINT := 0;

    init_done : BOOL := FALSE;
    c3_phase : DINT := 0;
    c4_phase : DINT := 0;
END_VAR

IF NOT init_done THEN
    init_done := TRUE;
    D2000 := 0;
    D2001 := 700;
    D2002 := 0;
    Y40 := TRUE;

    D2004 := 0;
    D2005 := 700;
    D2006 := 0;
    Y41 := TRUE;

    D2008 := 40000;
    D2009 := 700;
    D2010 := 0;
    Y42 := TRUE;

    D2012 := 40000;
    D2013 := 700;
    D2014 := 0;
    Y43 := TRUE;

    D2016 := -6500;
    D2017 := 700;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := 0;
    D2021 := 700;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := 6500;
    D2025 := 700;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := 0;
    D2029 := 700;
    D2030 := 0;
    Y47 := TRUE;

    D2032 := -65000;
    D2033 := 700;
    D2034 := 0;
    Y48 := TRUE;

    D2036 := 65000;
    D2037 := 700;
    D2038 := 0;
    Y49 := TRUE;

    D2040 := 0;
    D2041 := 700;
    D2042 := 0;
    Y50 := TRUE;

    Y30 := TRUE;
    D80 := 0;
    D81 := 0;
    D82 := 0;
    seq_cnt := 1;
END_IF;

CASE step OF
    0:
        IF (NOT r0_done) AND (D100 > 0) THEN
            active_req := 0;
            active_id := D100;
            active_stn := D101;
            step := 10;
        ELSIF (NOT r1_done) AND (D120 > 0) THEN
            active_req := 1;
            active_id := D120;
            active_stn := D121;
            step := 10;
        ELSIF (r0_done OR (D100 = 0)) AND (r1_done OR (D120 = 0)) AND X51 THEN
            all_finished := TRUE;
            step := 900;
        END_IF;

    10:
        IF active_stn = 1 THEN
            D2008 := D92;
            D2000 := D403;
        ELSE
            D2012 := D92;
            D2000 := D406;
        END_IF;
        step := 11;

    11:
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
            IF (active_stn = 1) AND (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100) THEN
                step := 12;
            ELSIF (active_stn = 2) AND (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100) THEN
                step := 12;
            END_IF;
        END_IF;

    12:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 1;
            D81 := active_stn;
            D82 := seq_cnt;
            seq_cnt := seq_cnt + 1;
            step := 13;
        END_IF;

    13:
        IF D90 = active_id THEN
            D2004 := 0;
            step := 14;
        END_IF;

    14:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            IF (active_req = 0 AND X31) OR (active_req = 1 AND X35) THEN
                step := 50;
            ELSE
                step := 20;
            END_IF;
        END_IF;

    20:
        D2000 := D409;
        IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) THEN
            dwell_cnt := 0;
            c3_phase := 1;
            step := 21;
        END_IF;

    21:
        CASE c3_phase OF
            1:
                D2020 := 0;
                D2028 := 0;
                IF (ABS(D1020) <= 20) AND (ABS(D1028) <= 20) THEN
                    c3_phase := 2;
                END_IF;
            2:
                D2016 := D500;
                D2024 := D502;
                IF (ABS(D1016 - D500) <= 20) AND (ABS(D1024 - D502) <= 20) THEN
                    c3_phase := 3;
                END_IF;
            3:
                D2020 := D501;
                D2028 := D503;
                IF (ABS(D1020 - D501) <= 20) AND (ABS(D1028 - D503) <= 20) THEN
                    dwell_cnt := dwell_cnt + 1;
                    IF dwell_cnt >= 5 THEN
                        c3_phase := 4;
                    END_IF;
                END_IF;
            4:
                D2020 := 0;
                D2028 := 0;
                IF (ABS(D1020) <= 20) AND (ABS(D1028) <= 20) THEN
                    c3_phase := 5;
                END_IF;
            5:
                D2016 := -6500;
                D2024 := 6500;
                IF (ABS(D1016 - (-6500)) <= 20) AND (ABS(D1024 - 6500) <= 20) THEN
                    step := 30;
                END_IF;
        END_CASE;

    30:
        D2000 := D412;
        IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) THEN
            dwell_cnt := 0;
            c4_phase := 1;
            step := 31;
        END_IF;

    31:
        CASE c4_phase OF
            1:
                D2040 := 25000;
                IF ABS(D1040 - 25000) <= 20 THEN
                    c4_phase := 2;
                END_IF;
            2:
                D2032 := D600;
                D2036 := D601;
                IF (ABS(D1032 - D600) <= 20) AND (ABS(D1036 - D601) <= 20) THEN
                    c4_phase := 3;
                END_IF;
            3:
                D2040 := D602;
                IF ABS(D1040 - D602) <= 20 THEN
                    dwell_cnt := dwell_cnt + 1;
                    IF dwell_cnt >= 5 THEN
                        c4_phase := 4;
                    END_IF;
                END_IF;
            4:
                D2040 := 25000;
                IF ABS(D1040 - 25000) <= 20 THEN
                    c4_phase := 5;
                END_IF;
            5:
                D2032 := -65000;
                D2036 := 65000;
                IF (ABS(D1032 - (-65000)) <= 20) AND (ABS(D1036 - 65000) <= 20) THEN
                    c4_phase := 6;
                END_IF;
            6:
                D2040 := 0;
                IF ABS(D1040) <= 20 THEN
                    step := 40;
                END_IF;
        END_CASE;

    40:
        IF active_stn = 1 THEN
            D2000 := D403;
            D2008 := D92;
        ELSE
            D2000 := D406;
            D2012 := D92;
        END_IF;
        step := 41;

    41:
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
            IF (active_stn = 1) AND (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100) THEN
                step := 42;
            ELSIF (active_stn = 2) AND (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100) THEN
                step := 42;
            END_IF;
        END_IF;

    42:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 2;
            D81 := active_stn;
            D82 := seq_cnt;
            seq_cnt := seq_cnt + 1;
            step := 43;
        END_IF;

    43:
        IF D90 = 0 THEN
            D2004 := 0;
            step := 44;
        END_IF;

    44:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            IF active_stn = 1 THEN
                D2008 := 40000;
            ELSE
                D2012 := 40000;
            END_IF;
            step := 45;
        END_IF;

    45:
        IF (active_stn = 1 AND ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100) OR
           (active_stn = 2 AND ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100) THEN
            IF active_req = 0 THEN
                D300 := active_id;
                D301 := 1;
                r0_done := TRUE;
            ELSE
                D302 := active_id;
                D303 := 1;
                r1_done := TRUE;
            END_IF;
            step := 0;
        END_IF;

    50:
        IF active_stn = 1 THEN
            D2000 := D403;
            D2008 := D92;
        ELSE
            D2000 := D406;
            D2012 := D92;
        END_IF;
        step := 51;

    51:
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) THEN
            IF (active_stn = 1) AND (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100) THEN
                step := 52;
            ELSIF (active_stn = 2) AND (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100) THEN
                step := 52;
            END_IF;
        END_IF;

    52:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 2;
            D81 := active_stn;
            D82 := seq_cnt;
            seq_cnt := seq_cnt + 1;
            step := 53;
        END_IF;

    53:
        IF D90 = 0 THEN
            D2004 := 0;
            step := 54;
        END_IF;

    54:
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            D80 := 0;
            D81 := 0;
            IF active_stn = 1 THEN
                D2008 := 40000;
            ELSE
                D2012 := 40000;
            END_IF;
            step := 55;
        END_IF;

    55:
        IF (active_stn = 1 AND ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100) OR
           (active_stn = 2 AND ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100) THEN
            IF active_req = 0 THEN
                D300 := active_id;
                D301 := 2;
                r0_done := TRUE;
            ELSE
                D302 := active_id;
                D303 := 2;
                r1_done := TRUE;
            END_IF;
            step := 0;
        END_IF;

    900:
        D2000 := 0;
        D2004 := 0;
        D2008 := 40000;
        D2012 := 40000;
        D2016 := -6500;
        D2020 := 0;
        D2024 := 6500;
        D2028 := 0;
        D2032 := -65000;
        D2036 := 65000;
        D2040 := 0;
        IF (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
           (ABS(D1016 - (-6500)) <= 20) AND (ABS(D1020) <= 20) AND
           (ABS(D1024 - 6500) <= 20) AND (ABS(D1028) <= 20) AND
           (ABS(D1032 - (-65000)) <= 20) AND (ABS(D1036 - 65000) <= 20) AND
           (ABS(D1040) <= 20) THEN
            step := 910;
        END_IF;

    910:
        Y2 := TRUE;
END_CASE;

END_PROGRAM