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
    phase : DINT;
    prev_phase : DINT;
    entry : BOOL;
    seq : DINT;
    cur_index : DINT;
    cur_id : DINT;
    cur_origin : DINT;
    cur_status : DINT;
    cur_cancel : BOOL;
    origin_x : DINT;
    origin_ready : BOOL;
    dock_raw : DINT;
    r0_done : BOOL;
    r1_done : BOOL;
    r0_ack_id : DINT;
    r1_ack_id : DINT;
    r0_stat : DINT;
    r1_stat : DINT;
    m3_lane_cur : DINT;
    m3_stop : DINT;
    m3_epoch : DINT;
    m4_lane_cur : DINT;
    m4_angle : DINT;
    m4_epoch : DINT;
    final_count : DINT;
    completion_latched : BOOL;
    ready_final : BOOL;
END_VAR

entry := phase <> prev_phase;
prev_phase := phase;

dock_raw := LIMIT(0, D92, 120000);

IF cur_origin = 2 THEN
    origin_x := LIMIT(-450000, D406, 1130000);
    origin_ready := X62;
ELSE
    origin_x := LIMIT(-450000, D403, 1130000);
    origin_ready := X61;
END_IF;

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

D80 := 0;
D81 := 0;
D82 := seq;

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

IF phase >= 10 THEN
    IF cur_origin = 2 THEN
        D2012 := dock_raw;
        D2008 := 15000;
    ELSE
        D2008 := dock_raw;
        D2012 := 15000;
    END_IF;
END_IF;

IF (phase >= 34) AND (phase <= 61) THEN
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := cur_id;
    D701 := D526;
    D702 := 1000;
END_IF;

IF (phase >= 60) AND (phase <= 63) THEN
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := cur_id;
    D711 := D626;
    D712 := 1000;
END_IF;

CASE phase OF
0:
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;

    IF NOT completion_latched THEN
        IF (NOT r0_done) AND (D100 <> 0) THEN
            cur_index := 0;
            cur_id := D100;
            IF D101 = 2 THEN
                cur_origin := 2;
            ELSE
                cur_origin := 1;
            END_IF;
            cur_status := 1;
            cur_cancel := X31;
            IF X31 THEN
                cur_status := 2;
            END_IF;
            phase := 10;
        ELSIF (NOT r1_done) AND (D120 <> 0) THEN
            cur_index := 1;
            cur_id := D120;
            IF D121 = 1 THEN
                cur_origin := 1;
            ELSE
                cur_origin := 2;
            END_IF;
            cur_status := 1;
            cur_cancel := X35;
            IF X35 THEN
                cur_status := 2;
            END_IF;
            phase := 10;
        END_IF;
    END_IF;

10:
    D2000 := origin_x;
    D2004 := 0;
    IF cur_origin = 2 THEN
        D2012 := dock_raw;
        D2008 := 15000;
    ELSE
        D2008 := dock_raw;
        D2012 := 15000;
    END_IF;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       origin_ready AND
       (((cur_origin = 1) AND (ABS(D1008 - dock_raw) <= 20) AND (ABS(D1009) <= 100)) OR
        ((cur_origin = 2) AND (ABS(D1012 - dock_raw) <= 20) AND (ABS(D1013) <= 100))) THEN
        phase := 20;
    END_IF;

20:
    D2000 := origin_x;
    D2004 := 18000;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND origin_ready THEN
        phase := 21;
    END_IF;

21:
    D2000 := origin_x;
    D2004 := 18000;
    D80 := 1;
    D81 := cur_origin;
    IF entry THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    IF D90 = cur_id THEN
        phase := 22;
    END_IF;

22:
    D2000 := origin_x;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF cur_cancel THEN
            phase := 80;
        ELSE
            phase := 30;
        END_IF;
    END_IF;

30:
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 0;
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) AND X63 THEN
        phase := 31;
    END_IF;

31:
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 18000;
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND X63 THEN
        phase := 32;
    END_IF;

32:
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 18000;
    D2016 := -60000;
    D2020 := -60000;
    D80 := 2;
    D81 := 3;
    IF entry THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    IF D90 <> cur_id THEN
        phase := 33;
    END_IF;

33:
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 0;
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        phase := 34;
    END_IF;

34:
    IF entry THEN
        m3_epoch := D91;
        IF D520 = 1 THEN
            m3_lane_cur := 1;
            m3_stop := LIMIT(-95000, D501 + 25000, 95000);
        ELSE
            m3_lane_cur := 0;
            m3_stop := LIMIT(-95000, D500 + 25000, 95000);
        END_IF;
    END_IF;
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 0;
    IF m3_lane_cur = 1 THEN
        D2016 := -60000;
        D2020 := m3_stop;
    ELSE
        D2016 := m3_stop;
        D2020 := -60000;
    END_IF;
    IF X70 AND (D522 = cur_id) AND (D524 >= m3_epoch) AND
       (((m3_lane_cur = 0) AND (ABS(D1016 - m3_stop) <= 20) AND (ABS(D1017) <= 100)) OR
        ((m3_lane_cur = 1) AND (ABS(D1020 - m3_stop) <= 20) AND (ABS(D1021) <= 100))) THEN
        phase := 35;
    END_IF;

35:
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 0;
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) AND X63 THEN
        phase := 40;
    END_IF;

40:
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 18000;
    D2016 := -60000;
    D2020 := -60000;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND X63 THEN
        phase := 41;
    END_IF;

41:
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 18000;
    D2016 := -60000;
    D2020 := -60000;
    D80 := 1;
    D81 := 3;
    IF entry THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    IF D90 = cur_id THEN
        phase := 42;
    END_IF;

42:
    D2000 := LIMIT(-450000, D409, 1130000);
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        phase := 50;
    END_IF;

50:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND X64 THEN
        phase := 51;
    END_IF;

51:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 18000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND X64 THEN
        phase := 52;
    END_IF;

52:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 18000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    D80 := 2;
    D81 := 4;
    IF entry THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    IF D90 <> cur_id THEN
        phase := 53;
    END_IF;

53:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        phase := 60;
    END_IF;

60:
    IF entry THEN
        m4_epoch := D91;
        IF D620 = 1 THEN
            m4_lane_cur := 1;
        ELSE
            m4_lane_cur := 0;
        END_IF;
        m4_angle := LIMIT(0, D600, 27000);
    END_IF;
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        phase := 61;
    END_IF;

61:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 0;
    D2024 := m4_angle;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1024 - m4_angle) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        phase := 62;
    END_IF;

62:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 0;
    D2024 := m4_angle;
    IF m4_lane_cur = 1 THEN
        D2028 := 0;
        D2032 := 4000;
    ELSE
        D2028 := 4000;
        D2032 := 0;
    END_IF;
    IF X75 AND (D622 = cur_id) AND (D624 >= m4_epoch) AND
       (ABS(D1024 - m4_angle) <= 20) AND (ABS(D1025) <= 100) AND
       (((m4_lane_cur = 0) AND (ABS(D1028 - 4000) <= 20) AND (ABS(D1029) <= 100)) OR
        ((m4_lane_cur = 1) AND (ABS(D1032 - 4000) <= 20) AND (ABS(D1033) <= 100))) THEN
        phase := 63;
    END_IF;

63:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
       (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) AND X64 THEN
        phase := 70;
    END_IF;

70:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 18000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND X64 THEN
        phase := 71;
    END_IF;

71:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 18000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    D80 := 1;
    D81 := 4;
    IF entry THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    IF D90 = cur_id THEN
        phase := 72;
    END_IF;

72:
    D2000 := LIMIT(-450000, D412, 1130000);
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        phase := 80;
    END_IF;

80:
    D2000 := origin_x;
    D2004 := 0;
    IF cur_origin = 2 THEN
        D2012 := dock_raw;
        D2008 := 15000;
    ELSE
        D2008 := dock_raw;
        D2012 := 15000;
    END_IF;
    IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND origin_ready AND
       (((cur_origin = 1) AND (ABS(D1008 - dock_raw) <= 20) AND (ABS(D1009) <= 100)) OR
        ((cur_origin = 2) AND (ABS(D1012 - dock_raw) <= 20) AND (ABS(D1013) <= 100))) THEN
        phase := 81;
    END_IF;

81:
    D2000 := origin_x;
    D2004 := 18000;
    IF cur_origin = 2 THEN
        D2012 := dock_raw;
        D2008 := 15000;
    ELSE
        D2008 := dock_raw;
        D2012 := 15000;
    END_IF;
    IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND origin_ready THEN
        phase := 82;
    END_IF;

82:
    D2000 := origin_x;
    D2004 := 18000;
    IF cur_origin = 2 THEN
        D2012 := dock_raw;
        D2008 := 15000;
    ELSE
        D2008 := dock_raw;
        D2012 := 15000;
    END_IF;
    D80 := 2;
    D81 := cur_origin;
    IF entry THEN
        seq := seq + 1;
    END_IF;
    D82 := seq;
    IF D90 <> cur_id THEN
        phase := 83;
    END_IF;

83:
    D2000 := origin_x;
    D2004 := 0;
    IF cur_origin = 2 THEN
        D2012 := dock_raw;
        D2008 := 15000;
    ELSE
        D2008 := dock_raw;
        D2012 := 15000;
    END_IF;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        phase := 84;
    END_IF;

84:
    D2000 := origin_x;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    IF (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
        IF cur_index = 0 THEN
            r0_ack_id := cur_id;
            r0_stat := cur_status;
            r0_done := TRUE;
        ELSE
            r1_ack_id := cur_id;
            r1_stat := cur_status;
            r1_done := TRUE;
        END_IF;
        cur_id := 0;
        phase := 0;
    END_IF;

ELSE
    phase := 0;
END_CASE;

D300 := r0_ack_id;
D301 := r0_stat;
D302 := r1_ack_id;
D303 := r1_stat;

Y30 := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);

ready_final := X51 AND (phase = 0) AND
               (r0_done OR (D100 = 0)) AND (r1_done OR (D120 = 0)) AND
               (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
               (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
               (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
               (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
               (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND
               (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) AND
               (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
               (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
               (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

IF ready_final THEN
    IF final_count < 5 THEN
        final_count := final_count + 1;
    END_IF;
ELSE
    IF NOT completion_latched THEN
        final_count := 0;
    END_IF;
END_IF;

IF final_count >= 5 THEN
    completion_latched := TRUE;
END_IF;

Y2 := completion_latched;

END_PROGRAM