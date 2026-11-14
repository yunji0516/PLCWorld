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
    state : DINT;
    req_index : DINT;
    active_id : DINT;
    active_origin : DINT;
    active_cancel : BOOL;
    done0 : BOOL;
    done1 : BOOL;
    seq_no : DINT;
    couple_count : DINT;
    m3_phase : DINT;
    m4_phase : DINT;
    port_x : DINT;
    port_ready : BOOL;
    target_station : DINT;
    lift_dock : DINT;
    s4_safe : DINT := 35000;
    s4_final2 : DINT;
    final_valid : BOOL;
END_VAR

lift_dock := LIMIT(0, D92, 120000);

D2001 := 1000;
D2002 := 0;
D2005 := 1000;
D2006 := 0;
D2009 := 1000;
D2010 := 0;
D2013 := 1000;
D2014 := 0;
D2017 := 1000;
D2018 := 0;
D2021 := 1000;
D2022 := 0;
D2025 := 1000;
D2026 := 0;
D2029 := 1000;
D2030 := 0;
D2033 := 1000;
D2034 := 0;
D2037 := 1000;
D2038 := 0;
D2041 := 1000;
D2042 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;
Y49 := TRUE;
Y50 := TRUE;

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

D80 := 0;
D81 := 0;
Y30 := FALSE;
Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 1000;
Y2 := FALSE;

IF seq_no < 0 THEN
    seq_no := 0;
END_IF;
D82 := seq_no;

CASE target_station OF
1:
    port_x := D403;
    port_ready := X61;
2:
    port_x := D406;
    port_ready := X62;
3:
    port_x := D409;
    port_ready := X63;
4:
    port_x := D412;
    port_ready := X64;
ELSE
    port_x := 0;
    port_ready := FALSE;
END_CASE;

CASE state OF
0:
    req_index := 0;
    state := 5;

5:
    IF (NOT done0) AND (D100 <> 0) THEN
        active_id := D100;
        active_cancel := X31;
        IF D101 = 0 THEN
            active_origin := 1;
        ELSIF D101 = 1 THEN
            active_origin := 2;
        ELSIF D101 = 2 THEN
            active_origin := 2;
        ELSE
            active_origin := 1;
        END_IF;
        req_index := 0;
        IF active_cancel THEN
            state := 800;
        ELSE
            state := 100;
        END_IF;
    ELSIF (NOT done1) AND (D120 <> 0) THEN
        active_id := D120;
        active_cancel := X35;
        IF D121 = 0 THEN
            active_origin := 1;
        ELSIF D121 = 1 THEN
            active_origin := 2;
        ELSIF D121 = 2 THEN
            active_origin := 2;
        ELSE
            active_origin := 1;
        END_IF;
        req_index := 1;
        IF active_cancel THEN
            state := 800;
        ELSE
            state := 100;
        END_IF;
    ELSIF X51 THEN
        state := 900;
    END_IF;

100:
    target_station := active_origin;
    state := 101;

101:
    IF active_origin = 1 THEN
        D2000 := D403;
        port_ready := X61;
    ELSE
        D2000 := D406;
        port_ready := X62;
    END_IF;
    D2004 := 0;
    D2008 := lift_dock;
    D2012 := lift_dock;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - lift_dock) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - lift_dock) <= 20) AND (ABS(D1013) <= 100) AND port_ready THEN
        state := 102;
    END_IF;

102:
    IF active_origin = 1 THEN
        D2000 := D403;
    ELSE
        D2000 := D406;
    END_IF;
    D2004 := 18000;
    D2008 := lift_dock;
    D2012 := lift_dock;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        seq_no := seq_no + 1;
        D82 := seq_no;
        couple_count := 0;
        state := 103;
    END_IF;

103:
    IF active_origin = 1 THEN
        D2000 := D403;
    ELSE
        D2000 := D406;
    END_IF;
    D2004 := 18000;
    D2008 := lift_dock;
    D2012 := lift_dock;
    D80 := 1;
    D81 := active_origin;
    D82 := seq_no;
    couple_count := couple_count + 1;
    IF (D90 = active_id) AND (couple_count >= 2) THEN
        state := 104;
    END_IF;

104:
    IF active_origin = 1 THEN
        D2000 := D403;
    ELSE
        D2000 := D406;
    END_IF;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 200;
    END_IF;

200:
    D2000 := D409;
    D2004 := 0;
    D2016 := -6500;
    D2020 := 0;
    D2024 := 6500;
    D2028 := 0;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1016 + 6500) <= 20) AND (ABS(D1017) <= 100) AND (D1020 <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024 - 6500) <= 20) AND (ABS(D1025) <= 100) AND (D1028 <= 20) AND (ABS(D1029) <= 100) AND X63 THEN
        state := 201;
    END_IF;

201:
    D2000 := D409;
    D2004 := 18000;
    D2016 := -6500;
    D2020 := 0;
    D2024 := 6500;
    D2028 := 0;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        seq_no := seq_no + 1;
        D82 := seq_no;
        couple_count := 0;
        state := 202;
    END_IF;

202:
    D2000 := D409;
    D2004 := 18000;
    D80 := 2;
    D81 := 3;
    D82 := seq_no;
    couple_count := couple_count + 1;
    IF (D90 <> active_id) AND (couple_count >= 2) THEN
        m3_phase := 0;
        state := 203;
    END_IF;

203:
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 300;
    END_IF;

300:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := active_id;
    D701 := D526;
    D702 := 1000;
    CASE m3_phase OF
    0:
        D2016 := -6500;
        D2020 := 0;
        D2024 := 6500;
        D2028 := 0;
        IF (D1020 <= 8000) AND (ABS(D1021) <= 100) AND (D1028 <= 8000) AND (ABS(D1029) <= 100) THEN
            m3_phase := 1;
        END_IF;
    1:
        D2016 := LIMIT(-9000, D500, 9000);
        D2020 := 0;
        D2024 := LIMIT(-9000, D502, 9000);
        D2028 := 0;
        IF (ABS(D1016 - D2016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1024 - D2024) <= 20) AND (ABS(D1025) <= 100) THEN
            m3_phase := 2;
        END_IF;
    2:
        D2016 := LIMIT(-9000, D500, 9000);
        D2020 := LIMIT(0, D501, 65000);
        D2024 := LIMIT(-9000, D502, 9000);
        D2028 := LIMIT(0, D503, 65000);
        IF X70 AND (ABS(D1016 - D2016) <= 20) AND (ABS(D1020 - D2020) <= 20) AND (ABS(D1024 - D2024) <= 20) AND (ABS(D1028 - D2028) <= 20) THEN
            m3_phase := 3;
        END_IF;
    3:
        D2016 := LIMIT(-9000, D500, 9000);
        D2020 := 0;
        D2024 := LIMIT(-9000, D502, 9000);
        D2028 := 0;
        IF (D1020 <= 8000) AND (ABS(D1021) <= 100) AND (D1028 <= 8000) AND (ABS(D1029) <= 100) THEN
            m3_phase := 4;
        END_IF;
    4:
        D2016 := -6500;
        D2020 := 0;
        D2024 := 6500;
        D2028 := 0;
        IF (ABS(D1016 + 6500) <= 20) AND (ABS(D1017) <= 100) AND (D1020 <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024 - 6500) <= 20) AND (ABS(D1025) <= 100) AND (D1028 <= 20) AND (ABS(D1029) <= 100) THEN
            state := 400;
        END_IF;
    ELSE
        m3_phase := 0;
    END_CASE;

400:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := active_id;
    D701 := D526;
    D702 := 1000;
    D2000 := D409;
    D2004 := 0;
    D2016 := -6500;
    D2020 := 0;
    D2024 := 6500;
    D2028 := 0;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X63 THEN
        state := 401;
    END_IF;

401:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := active_id;
    D701 := D526;
    D702 := 1000;
    D2000 := D409;
    D2004 := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        seq_no := seq_no + 1;
        D82 := seq_no;
        couple_count := 0;
        state := 402;
    END_IF;

402:
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := active_id;
    D701 := D526;
    D702 := 1000;
    D2000 := D409;
    D2004 := 18000;
    D80 := 1;
    D81 := 3;
    D82 := seq_no;
    couple_count := couple_count + 1;
    IF (D90 = active_id) AND (couple_count >= 2) THEN
        state := 403;
    END_IF;

403:
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 500;
    END_IF;

500:
    D2000 := D412;
    D2004 := 0;
    D2032 := -65000;
    D2036 := 65000;
    D2040 := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1032 + 65000) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036 - 65000) <= 20) AND (ABS(D1037) <= 100) AND
       (D1040 <= 20) AND (ABS(D1041) <= 100) AND X64 THEN
        state := 501;
    END_IF;

501:
    D2000 := D412;
    D2004 := 18000;
    D2032 := -65000;
    D2036 := 65000;
    D2040 := 0;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        seq_no := seq_no + 1;
        D82 := seq_no;
        couple_count := 0;
        state := 502;
    END_IF;

502:
    D2000 := D412;
    D2004 := 18000;
    D80 := 2;
    D81 := 4;
    D82 := seq_no;
    couple_count := couple_count + 1;
    IF (D90 <> active_id) AND (couple_count >= 2) THEN
        m4_phase := 0;
        state := 503;
    END_IF;

503:
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 600;
    END_IF;

600:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := active_id;
    D711 := D626;
    D712 := 1000;
    s4_final2 := LIMIT(0, D602, 35000);
    IF (ABS(LIMIT(-90000, D600, 90000) - LIMIT(-90000, D601, 90000)) < 23000) AND (s4_final2 < 22000) THEN
        s4_final2 := 22000;
    END_IF;
    CASE m4_phase OF
    0:
        D2032 := -65000;
        D2036 := 65000;
        D2040 := s4_safe;
        IF (D1040 >= (s4_safe - 20)) AND (ABS(D1041) <= 100) THEN
            m4_phase := 1;
        END_IF;
    1:
        D2032 := LIMIT(-90000, D600, 90000);
        D2036 := LIMIT(-90000, D601, 90000);
        D2040 := s4_safe;
        IF (ABS(D1032 - D2032) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036 - D2036) <= 20) AND (ABS(D1037) <= 100) THEN
            m4_phase := 2;
        END_IF;
    2:
        D2032 := LIMIT(-90000, D600, 90000);
        D2036 := LIMIT(-90000, D601, 90000);
        D2040 := s4_final2;
        IF X75 AND (ABS(D1032 - D2032) <= 20) AND (ABS(D1036 - D2036) <= 20) AND (ABS(D1040 - D2040) <= 20) THEN
            m4_phase := 3;
        END_IF;
    3:
        D2032 := LIMIT(-90000, D600, 90000);
        D2036 := LIMIT(-90000, D601, 90000);
        D2040 := s4_safe;
        IF (D1040 >= (s4_safe - 20)) AND (ABS(D1041) <= 100) THEN
            m4_phase := 4;
        END_IF;
    4:
        D2032 := -65000;
        D2036 := 65000;
        D2040 := s4_safe;
        IF (ABS(D1032 + 65000) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036 - 65000) <= 20) AND (ABS(D1037) <= 100) THEN
            m4_phase := 5;
        END_IF;
    5:
        D2032 := -65000;
        D2036 := 65000;
        D2040 := 0;
        IF (ABS(D1032 + 65000) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036 - 65000) <= 20) AND (ABS(D1037) <= 100) AND
           (D1040 <= 20) AND (ABS(D1041) <= 100) THEN
            state := 700;
        END_IF;
    ELSE
        m4_phase := 0;
    END_CASE;

700:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := active_id;
    D711 := D626;
    D712 := 1000;
    D2000 := D412;
    D2004 := 0;
    D2032 := -65000;
    D2036 := 65000;
    D2040 := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND X64 THEN
        state := 701;
    END_IF;

701:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := active_id;
    D711 := D626;
    D712 := 1000;
    D2000 := D412;
    D2004 := 18000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        seq_no := seq_no + 1;
        D82 := seq_no;
        couple_count := 0;
        state := 702;
    END_IF;

702:
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := active_id;
    D711 := D626;
    D712 := 1000;
    D2000 := D412;
    D2004 := 18000;
    D80 := 1;
    D81 := 4;
    D82 := seq_no;
    couple_count := couple_count + 1;
    IF (D90 = active_id) AND (couple_count >= 2) THEN
        state := 703;
    END_IF;

703:
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 800;
    END_IF;

800:
    IF active_origin = 1 THEN
        D2000 := D403;
        port_ready := X61;
    ELSE
        D2000 := D406;
        port_ready := X62;
    END_IF;
    D2004 := 0;
    D2008 := lift_dock;
    D2012 := lift_dock;
    IF active_cancel AND (D90 <> active_id) THEN
        state := 850;
    ELSIF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - lift_dock) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - lift_dock) <= 20) AND (ABS(D1013) <= 100) AND port_ready THEN
        state := 801;
    END_IF;

801:
    IF active_origin = 1 THEN
        D2000 := D403;
    ELSE
        D2000 := D406;
    END_IF;
    D2004 := 18000;
    D2008 := lift_dock;
    D2012 := lift_dock;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
        seq_no := seq_no + 1;
        D82 := seq_no;
        couple_count := 0;
        state := 802;
    END_IF;

802:
    IF active_origin = 1 THEN
        D2000 := D403;
    ELSE
        D2000 := D406;
    END_IF;
    D2004 := 18000;
    D2008 := lift_dock;
    D2012 := lift_dock;
    D80 := 2;
    D81 := active_origin;
    D82 := seq_no;
    couple_count := couple_count + 1;
    IF (D90 <> active_id) AND (couple_count >= 2) THEN
        state := 850;
    END_IF;

850:
    D2000 := 0;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) THEN
        IF req_index = 0 THEN
            D300 := active_id;
            IF active_cancel THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            done0 := TRUE;
        ELSE
            D302 := active_id;
            IF active_cancel THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            done1 := TRUE;
        END_IF;
        state := 5;
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
    Y30 := TRUE;
    final_valid := X51 AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
                   (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100) AND
                   (ABS(D1016 + 6500) <= 20) AND (ABS(D1017) <= 100) AND (D1020 <= 20) AND (ABS(D1021) <= 100) AND
                   (ABS(D1024 - 6500) <= 20) AND (ABS(D1025) <= 100) AND (D1028 <= 20) AND (ABS(D1029) <= 100) AND
                   (ABS(D1032 + 65000) <= 20) AND (ABS(D1033) <= 100) AND (ABS(D1036 - 65000) <= 20) AND (ABS(D1037) <= 100) AND
                   (D1040 <= 20) AND (ABS(D1041) <= 100);
    IF final_valid THEN
        Y2 := TRUE;
    END_IF;

ELSE
    state := 5;
END_CASE;

D2000 := LIMIT(-450000, D2000, 730000);
D2004 := LIMIT(0, D2004, 18000);
D2008 := LIMIT(0, D2008, 120000);
D2012 := LIMIT(0, D2012, 120000);
D2016 := LIMIT(-9000, D2016, 9000);
D2020 := LIMIT(0, D2020, 65000);
D2024 := LIMIT(-9000, D2024, 9000);
D2028 := LIMIT(0, D2028, 65000);
D2032 := LIMIT(-90000, D2032, 90000);
D2036 := LIMIT(-90000, D2036, 90000);
D2040 := LIMIT(0, D2040, 35000);

D82 := seq_no;

END_PROGRAM