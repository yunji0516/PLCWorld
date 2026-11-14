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
    stage : DINT := 0;
    current_channel : DINT := -1;
    current_id : DINT := 0;
    source_station : DINT := 1;
    response_status : DINT := 1;
    seq_no : DINT := 0;
    couple_active : BOOL := FALSE;
    couple_action : DINT := 0;
    couple_station : DINT := 0;
    lift_dock : DINT := 95000;
    source_x : DINT := 0;
    source_id_at_port : DINT := 0;
    source_ready : BOOL := FALSE;
    target_a : DINT := 0;
    target_b : DINT := 0;
    target_lift : DINT := 40000;
    target_s3_0 : DINT := 0;
    target_s3_1 : DINT := 0;
    target_s3_2 : DINT := 0;
    target_s4_0 : DINT := 0;
    target_s4_1 : DINT := 0;
    m3_work : BOOL := FALSE;
    m4_work : BOOL := FALSE;
    common_run : BOOL := FALSE;
    curr_cancel : BOOL := FALSE;
    final_ready : BOOL := FALSE;
    lift_at_dock : BOOL := FALSE;
    lift_at_home : BOOL := FALSE;
    a_at_source : BOOL := FALSE;
    a_at_p3 : BOOL := FALSE;
    a_at_p4 : BOOL := FALSE;
    a_at_home : BOOL := FALSE;
    fork_home : BOOL := FALSE;
    fork_ext : BOOL := FALSE;
    s3_dock_ready : BOOL := FALSE;
    s4_dock_ready : BOOL := FALSE;
    common_speed_ok : BOOL := FALSE;
    ratio_cmd : DINT := 700;
    temp_dint : DINT := 0;
END_VAR

lift_dock := LIMIT(0, D92, 120000);

IF source_station = 2 THEN
    source_x := LIMIT(-450000, D406, 450000);
    source_id_at_port := D407;
    source_ready := X62;
ELSE
    source_x := LIMIT(-450000, D403, 450000);
    source_id_at_port := D404;
    source_ready := X61;
END_IF;

curr_cancel := FALSE;
IF current_channel = 0 THEN
    curr_cancel := X31;
ELSIF current_channel = 1 THEN
    curr_cancel := X35;
END_IF;

IF curr_cancel THEN
    response_status := 2;
END_IF;

target_a := 0;
target_b := 0;
target_lift := 40000;
target_s3_0 := 0;
target_s3_1 := 0;
target_s3_2 := 0;
target_s4_0 := 0;
target_s4_1 := 0;
m3_work := FALSE;
m4_work := FALSE;
common_run := FALSE;

lift_at_dock := (ABS(D1008 - lift_dock) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - lift_dock) <= 20) AND (ABS(D1013) <= 100);
lift_at_home := (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100);
a_at_source := (ABS(D1000 - source_x) <= 20) AND (ABS(D1001) <= 100);
a_at_p3 := (ABS(D1000 - LIMIT(-450000, D409, 450000)) <= 20) AND (ABS(D1001) <= 100);
a_at_p4 := (ABS(D1000 - LIMIT(-450000, D412, 450000)) <= 20) AND (ABS(D1001) <= 100);
a_at_home := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100);
fork_home := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
fork_ext := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
s3_dock_ready := (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100);
s4_dock_ready := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
common_speed_ok := (ABS(D1017 - 20000) <= 200);

CASE stage OF
0:
    couple_active := FALSE;
    couple_action := 0;
    couple_station := 0;
    IF (D100 <> 0) AND (D300 <> D100) AND NOT X30 THEN
        current_channel := 0;
        current_id := D100;
        IF D101 = 2 THEN
            source_station := 2;
        ELSE
            source_station := 1;
        END_IF;
        IF X31 THEN
            response_status := 2;
        ELSE
            response_status := 1;
        END_IF;
        stage := 10;
    ELSIF (D120 <> 0) AND (D302 <> D120) AND NOT X34 THEN
        current_channel := 1;
        current_id := D120;
        IF D121 = 1 THEN
            source_station := 1;
        ELSE
            source_station := 2;
        END_IF;
        IF X35 THEN
            response_status := 2;
        ELSE
            response_status := 1;
        END_IF;
        stage := 10;
    ELSE
        stage := 200;
    END_IF;

10:
    target_lift := lift_dock;
    target_a := source_x;
    target_b := 0;
    IF lift_at_dock AND a_at_source AND fork_home AND source_ready THEN
        stage := 11;
        couple_active := FALSE;
    END_IF;

11:
    target_lift := lift_dock;
    target_a := source_x;
    target_b := 18000;
    IF fork_ext AND a_at_source AND lift_at_dock AND source_ready THEN
        IF NOT couple_active THEN
            seq_no := seq_no + 1;
            couple_active := TRUE;
            couple_action := 1;
            couple_station := source_station;
        END_IF;
        IF D90 = current_id THEN
            couple_active := FALSE;
            stage := 12;
        END_IF;
    END_IF;

12:
    target_lift := lift_dock;
    target_a := source_x;
    target_b := 0;
    IF fork_home THEN
        IF curr_cancel THEN
            stage := 90;
        ELSE
            stage := 20;
        END_IF;
    END_IF;

20:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D409, 450000);
    target_b := 0;
    target_s3_1 := 0;
    target_s3_2 := 0;
    common_run := TRUE;
    IF a_at_p3 AND fork_home AND X63 AND s3_dock_ready THEN
        stage := 21;
        couple_active := FALSE;
    END_IF;

21:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D409, 450000);
    target_b := 18000;
    target_s3_1 := 0;
    target_s3_2 := 0;
    common_run := TRUE;
    IF fork_ext AND a_at_p3 AND X63 AND s3_dock_ready THEN
        IF NOT couple_active THEN
            seq_no := seq_no + 1;
            couple_active := TRUE;
            couple_action := 2;
            couple_station := 3;
        END_IF;
        IF (D90 <> current_id) AND (D410 = current_id) THEN
            couple_active := FALSE;
            stage := 30;
        END_IF;
    END_IF;

30:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D409, 450000);
    target_b := 0;
    target_s3_1 := 0;
    target_s3_2 := 0;
    common_run := TRUE;
    m3_work := TRUE;
    IF curr_cancel OR X70 THEN
        stage := 40;
    END_IF;

40:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D409, 450000);
    target_b := 0;
    target_s3_1 := 0;
    target_s3_2 := 0;
    common_run := TRUE;
    IF a_at_p3 AND fork_home AND X63 AND s3_dock_ready THEN
        stage := 41;
        couple_active := FALSE;
    END_IF;

41:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D409, 450000);
    target_b := 18000;
    target_s3_1 := 0;
    target_s3_2 := 0;
    common_run := TRUE;
    IF fork_ext AND a_at_p3 AND X63 AND s3_dock_ready THEN
        IF NOT couple_active THEN
            seq_no := seq_no + 1;
            couple_active := TRUE;
            couple_action := 1;
            couple_station := 3;
        END_IF;
        IF D90 = current_id THEN
            couple_active := FALSE;
            stage := 42;
        END_IF;
    END_IF;

42:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D409, 450000);
    target_b := 0;
    common_run := TRUE;
    IF fork_home THEN
        IF curr_cancel THEN
            stage := 90;
        ELSE
            stage := 50;
        END_IF;
    END_IF;

50:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D412, 450000);
    target_b := 0;
    target_s4_0 := 0;
    target_s4_1 := 0;
    common_run := TRUE;
    IF a_at_p4 AND fork_home AND X64 AND s4_dock_ready AND common_speed_ok THEN
        stage := 51;
        couple_active := FALSE;
    END_IF;

51:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D412, 450000);
    target_b := 18000;
    target_s4_0 := 0;
    target_s4_1 := 0;
    common_run := TRUE;
    IF fork_ext AND a_at_p4 AND X64 AND s4_dock_ready AND common_speed_ok THEN
        IF NOT couple_active THEN
            seq_no := seq_no + 1;
            couple_active := TRUE;
            couple_action := 2;
            couple_station := 4;
        END_IF;
        IF (D90 <> current_id) AND (D413 = current_id) THEN
            couple_active := FALSE;
            stage := 60;
        END_IF;
    END_IF;

60:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D412, 450000);
    target_b := 0;
    common_run := TRUE;
    m4_work := TRUE;
    target_s4_0 := LIMIT(-360000, D600, 360000);
    IF (D601 >= 0) AND (D601 <= 1000) THEN
        ratio_cmd := D601;
    ELSE
        ratio_cmd := 700;
    END_IF;
    temp_dint := target_s4_0 * ratio_cmd;
    target_s4_1 := LIMIT(-360000, temp_dint / 1000, 360000);
    IF curr_cancel OR X75 THEN
        stage := 70;
    END_IF;

70:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D412, 450000);
    target_b := 0;
    target_s4_0 := 0;
    target_s4_1 := 0;
    common_run := TRUE;
    IF s4_dock_ready AND fork_home THEN
        stage := 80;
    END_IF;

80:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D412, 450000);
    target_b := 0;
    target_s4_0 := 0;
    target_s4_1 := 0;
    common_run := TRUE;
    IF a_at_p4 AND fork_home AND X64 AND s4_dock_ready THEN
        stage := 81;
        couple_active := FALSE;
    END_IF;

81:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D412, 450000);
    target_b := 18000;
    target_s4_0 := 0;
    target_s4_1 := 0;
    common_run := TRUE;
    IF fork_ext AND a_at_p4 AND X64 AND s4_dock_ready THEN
        IF NOT couple_active THEN
            seq_no := seq_no + 1;
            couple_active := TRUE;
            couple_action := 1;
            couple_station := 4;
        END_IF;
        IF D90 = current_id THEN
            couple_active := FALSE;
            stage := 82;
        END_IF;
    END_IF;

82:
    target_lift := lift_dock;
    target_a := LIMIT(-450000, D412, 450000);
    target_b := 0;
    target_s4_0 := 0;
    target_s4_1 := 0;
    common_run := TRUE;
    IF fork_home THEN
        stage := 90;
    END_IF;

90:
    target_lift := lift_dock;
    target_a := source_x;
    target_b := 0;
    IF lift_at_dock AND a_at_source AND fork_home AND source_ready THEN
        stage := 91;
        couple_active := FALSE;
    END_IF;

91:
    target_lift := lift_dock;
    target_a := source_x;
    target_b := 18000;
    IF fork_ext AND a_at_source AND lift_at_dock AND source_ready THEN
        IF NOT couple_active THEN
            seq_no := seq_no + 1;
            couple_active := TRUE;
            couple_action := 2;
            couple_station := source_station;
        END_IF;
        IF (D90 <> current_id) AND (source_id_at_port = current_id) THEN
            couple_active := FALSE;
            stage := 100;
        END_IF;
    END_IF;

100:
    target_lift := 40000;
    target_a := source_x;
    target_b := 0;
    IF fork_home AND lift_at_home THEN
        IF current_channel = 0 THEN
            D300 := current_id;
            D301 := response_status;
        ELSIF current_channel = 1 THEN
            D302 := current_id;
            D303 := response_status;
        END_IF;
        current_channel := -1;
        current_id := 0;
        response_status := 1;
        stage := 0;
    END_IF;

200:
    target_a := 0;
    target_b := 0;
    target_lift := 40000;
    target_s3_1 := 0;
    target_s3_2 := 0;
    target_s4_0 := 0;
    target_s4_1 := 0;
    common_run := FALSE;
    IF ((D100 <> 0) AND (D300 <> D100) AND NOT X30) OR ((D120 <> 0) AND (D302 <> D120) AND NOT X34) THEN
        stage := 0;
    END_IF;

ELSE
    stage := 0;
END_CASE;

D2000 := LIMIT(-450000, target_a, 450000);
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := LIMIT(0, target_b, 18000);
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := LIMIT(0, target_lift, 120000);
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := LIMIT(0, target_lift, 120000);
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := LIMIT(-3600000, target_s3_0, 3600000);
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := LIMIT(-3600000, target_s3_1, 3600000);
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := LIMIT(-3600000, target_s3_2, 3600000);
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := LIMIT(-360000, target_s4_0, 360000);
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := LIMIT(-360000, target_s4_1, 360000);
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

Y70 := m3_work;
Y71 := common_run;
D700 := 1000;
D701 := D526;
D702 := 1000;

Y75 := m4_work;
Y76 := m4_work;
IF (D601 >= 0) AND (D601 <= 1000) THEN
    D710 := D601;
ELSE
    D710 := 700;
END_IF;
D711 := D626;
D712 := 1000;

IF couple_active THEN
    D80 := couple_action;
    D81 := couple_station;
ELSE
    D80 := 0;
    D81 := 0;
END_IF;
D82 := seq_no;

final_ready := X51 AND a_at_home AND fork_home AND lift_at_home AND s3_dock_ready AND s4_dock_ready AND (ABS(D1017) <= 100) AND NOT common_run AND (stage = 200);
IF final_ready THEN
    Y2 := TRUE;
    Y30 := TRUE;
ELSE
    Y2 := FALSE;
    Y30 := FALSE;
END_IF;

END_PROGRAM