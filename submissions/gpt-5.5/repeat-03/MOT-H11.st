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
    step : INT;
    scan_count : DINT;
    selected_channel : INT;
    current_id : DINT;
    original_station : INT;
    current_status : DINT;
    seq_no : DINT;
    issued : BOOL;
    prev_id0 : DINT;
    prev_id1 : DINT;
    acked0 : BOOL;
    acked1 : BOOL;
    ack_id0 : DINT;
    ack_id1 : DINT;
    ack_status0 : DINT;
    ack_status1 : DINT;
    request0_waiting : BOOL;
    request1_waiting : BOOL;
    station_x : DINT;
    station_ready : BOOL;
    lift_target : DINT;
    lift_dock_ready : BOOL;
    lift_home_ready : BOOL;
    at_station : BOOL;
    at_b0 : BOOL;
    at_b180 : BOOL;
    s3_ang_goal : DINT;
    s3_slide_goal : DINT;
    s3_slide_safe : DINT;
    s4_ang_goal : DINT;
    s4_pin1_goal : DINT;
    s4_pin2_goal : DINT;
    axis_ok : BOOL;
    cell3_home : BOOL;
    cell4_home : BOOL;
    all_home : BOOL;
    final_declared : BOOL;
    source_cancelled : BOOL;
END_VAR

scan_count := scan_count + 1;

IF D100 <> prev_id0 THEN
    prev_id0 := D100;
    acked0 := FALSE;
    ack_id0 := 0;
    ack_status0 := 0;
END_IF;

IF D120 <> prev_id1 THEN
    prev_id1 := D120;
    acked1 := FALSE;
    ack_id1 := 0;
    ack_status1 := 0;
END_IF;

request0_waiting := (D100 <> 0) AND NOT acked0 AND NOT X30;
request1_waiting := (D120 <> 0) AND NOT acked1 AND NOT X34;

D300 := ack_id0;
D301 := ack_status0;
D302 := ack_id1;
D303 := ack_status1;

D2001 := 1000;
D2002 := 0;
Y40 := TRUE;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

D2000 := 0;
D2004 := 0;
D2016 := 0;
D2020 := 5000;
D2024 := 0;
D2028 := 0;
D2032 := 0;

Y70 := FALSE;
Y71 := FALSE;
D700 := current_id;
D701 := D526;
D702 := 1000;
Y75 := FALSE;
Y76 := FALSE;
D710 := current_id;
D711 := D626;
D712 := 1000;
D80 := 0;
D81 := 0;
D82 := seq_no;

s3_ang_goal := D500;
IF s3_ang_goal < 0 THEN s3_ang_goal := 0; END_IF;
IF s3_ang_goal > 27000 THEN s3_ang_goal := 27000; END_IF;

s3_slide_goal := D501;
IF s3_slide_goal < 0 THEN s3_slide_goal := 0; END_IF;
IF s3_slide_goal > 70000 THEN s3_slide_goal := 70000; END_IF;
s3_slide_safe := s3_slide_goal;
IF s3_slide_safe > 50000 THEN s3_slide_safe := 50000; END_IF;

s4_ang_goal := D600;
IF s4_ang_goal < 0 THEN s4_ang_goal := 0; END_IF;
IF s4_ang_goal > 27000 THEN s4_ang_goal := 27000; END_IF;

s4_pin1_goal := D601;
s4_pin2_goal := D602;
IF (s4_pin1_goal = 0) AND (s4_pin2_goal = 0) THEN
    IF D620 = 0 THEN
        s4_pin1_goal := 4000;
        s4_pin2_goal := 0;
    ELSE
        s4_pin1_goal := 0;
        s4_pin2_goal := 4000;
    END_IF;
END_IF;
IF s4_pin1_goal < 0 THEN s4_pin1_goal := 0; END_IF;
IF s4_pin1_goal > 4000 THEN s4_pin1_goal := 4000; END_IF;
IF s4_pin2_goal < 0 THEN s4_pin2_goal := 0; END_IF;
IF s4_pin2_goal > 4000 THEN s4_pin2_goal := 4000; END_IF;

IF original_station = 2 THEN
    station_x := D406;
    station_ready := X62;
ELSIF original_station = 3 THEN
    station_x := D409;
    station_ready := X63;
ELSIF original_station = 4 THEN
    station_x := D412;
    station_ready := X64;
ELSE
    station_x := D403;
    station_ready := X61;
END_IF;

at_station := (ABS(D1000 - station_x) <= 20) AND (ABS(D1001) <= 100);
at_b0 := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
at_b180 := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);

lift_dock_ready := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
lift_home_ready := (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100);

cell3_home := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - 5000) <= 20) AND (ABS(D1021) <= 100);
cell4_home := (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

IF (step >= 10) AND (step <= 120) THEN
    lift_target := MIN(D1008, D1012) + 6000;
    IF lift_target > D92 THEN
        lift_target := D92;
    END_IF;
ELSIF step = 130 THEN
    lift_target := MAX(D1008, D1012) - 6000;
    IF lift_target < 40000 THEN
        lift_target := 40000;
    END_IF;
ELSE
    lift_target := 40000;
END_IF;

IF lift_target < 0 THEN lift_target := 0; END_IF;
IF lift_target > 120000 THEN lift_target := 120000; END_IF;
D2008 := lift_target;
D2012 := lift_target;

Y30 := FALSE;

CASE step OF
0:
    issued := FALSE;
    current_id := 0;
    selected_channel := -1;
    original_station := 1;
    current_status := 1;
    IF request0_waiting OR request1_waiting THEN
        IF request0_waiting AND request1_waiting THEN
            IF D103 <= D123 THEN
                selected_channel := 0;
            ELSE
                selected_channel := 1;
            END_IF;
        ELSIF request0_waiting THEN
            selected_channel := 0;
        ELSE
            selected_channel := 1;
        END_IF;

        IF selected_channel = 0 THEN
            current_id := D100;
            IF D101 = 2 THEN
                original_station := 2;
            ELSE
                original_station := 1;
            END_IF;
            source_cancelled := X31;
        ELSE
            current_id := D120;
            IF D121 = 2 THEN
                original_station := 2;
            ELSE
                original_station := 1;
            END_IF;
            source_cancelled := X35;
        END_IF;

        IF source_cancelled THEN
            current_status := 2;
        ELSE
            current_status := 1;
        END_IF;
        step := 10;
    END_IF;

10:
    IF original_station = 2 THEN
        station_x := D406;
        station_ready := X62;
    ELSE
        station_x := D403;
        station_ready := X61;
    END_IF;
    D2000 := station_x;
    D2004 := 0;
    IF at_station AND at_b0 AND station_ready AND lift_dock_ready THEN
        step := 20;
        issued := FALSE;
    END_IF;

20:
    IF original_station = 2 THEN
        station_x := D406;
        station_ready := X62;
    ELSE
        station_x := D403;
        station_ready := X61;
    END_IF;
    D2000 := station_x;
    D2004 := 0;
    IF at_station AND at_b0 AND station_ready THEN
        IF NOT issued THEN
            seq_no := seq_no + 1;
            issued := TRUE;
        END_IF;
        D80 := 1;
        D81 := original_station;
        D82 := seq_no;
        IF D90 = current_id THEN
            issued := FALSE;
            IF current_status = 2 THEN
                step := 110;
            ELSE
                step := 30;
            END_IF;
        END_IF;
    END_IF;

30:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 5000;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND at_b0 AND X63 AND cell3_home THEN
        step := 35;
    END_IF;

35:
    D2000 := D409;
    D2004 := 18000;
    D2016 := 0;
    D2020 := 5000;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND at_b180 AND X63 AND cell3_home THEN
        step := 40;
        issued := FALSE;
    END_IF;

40:
    D2000 := D409;
    D2004 := 18000;
    D2016 := 0;
    D2020 := 5000;
    IF NOT issued THEN
        seq_no := seq_no + 1;
        issued := TRUE;
    END_IF;
    D80 := 2;
    D81 := 3;
    D82 := seq_no;
    IF D90 <> current_id THEN
        issued := FALSE;
        step := 41;
    END_IF;

41:
    D2000 := D409;
    D2004 := 0;
    Y71 := TRUE;
    IF at_b0 THEN
        step := 50;
    END_IF;

50:
    Y70 := TRUE;
    Y71 := TRUE;
    D2016 := 0;
    D2020 := s3_slide_safe;
    IF (ABS(D1020 - s3_slide_safe) <= 20) AND (ABS(D1021) <= 100) THEN
        step := 52;
    END_IF;

52:
    Y70 := TRUE;
    Y71 := TRUE;
    D2016 := s3_ang_goal;
    D2020 := s3_slide_safe;
    IF (ABS(D1016 - s3_ang_goal) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - s3_slide_safe) <= 20) AND (ABS(D1021) <= 100) THEN
        step := 54;
    END_IF;

54:
    Y70 := TRUE;
    Y71 := TRUE;
    D2016 := s3_ang_goal;
    D2020 := s3_slide_goal;
    IF X70 AND (ABS(D1016 - s3_ang_goal) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - s3_slide_goal) <= 20) AND (ABS(D1021) <= 100) THEN
        step := 56;
    END_IF;

56:
    Y71 := TRUE;
    D2016 := 0;
    D2020 := 5000;
    IF cell3_home AND X63 THEN
        step := 60;
    END_IF;

60:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 5000;
    Y71 := TRUE;
    IF (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND at_b0 AND X63 AND cell3_home THEN
        IF NOT issued THEN
            seq_no := seq_no + 1;
            issued := TRUE;
        END_IF;
        D80 := 1;
        D81 := 3;
        D82 := seq_no;
        IF D90 = current_id THEN
            issued := FALSE;
            step := 70;
        END_IF;
    END_IF;

70:
    D2000 := D412;
    D2004 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND at_b0 AND X64 AND cell4_home THEN
        step := 75;
    END_IF;

75:
    D2000 := D412;
    D2004 := 18000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND at_b180 AND X64 AND cell4_home THEN
        step := 80;
        issued := FALSE;
    END_IF;

80:
    D2000 := D412;
    D2004 := 18000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF NOT issued THEN
        seq_no := seq_no + 1;
        issued := TRUE;
    END_IF;
    D80 := 2;
    D81 := 4;
    D82 := seq_no;
    IF D90 <> current_id THEN
        issued := FALSE;
        step := 81;
    END_IF;

81:
    D2000 := D412;
    D2004 := 0;
    Y76 := TRUE;
    IF at_b0 THEN
        step := 90;
    END_IF;

90:
    Y75 := TRUE;
    Y76 := TRUE;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        step := 92;
    END_IF;

92:
    Y75 := TRUE;
    Y76 := TRUE;
    D2024 := s4_ang_goal;
    D2028 := 0;
    D2032 := 0;
    IF (ABS(D1024 - s4_ang_goal) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
        step := 94;
    END_IF;

94:
    Y75 := TRUE;
    Y76 := TRUE;
    D2024 := s4_ang_goal;
    D2028 := s4_pin1_goal;
    D2032 := s4_pin2_goal;
    IF X75 AND (ABS(D1024 - s4_ang_goal) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - s4_pin1_goal) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - s4_pin2_goal) <= 20) AND (ABS(D1033) <= 100) THEN
        step := 96;
    END_IF;

96:
    Y76 := TRUE;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    IF cell4_home AND X64 THEN
        step := 100;
    END_IF;

100:
    D2000 := D412;
    D2004 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    Y76 := TRUE;
    IF (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND at_b0 AND X64 AND cell4_home THEN
        IF NOT issued THEN
            seq_no := seq_no + 1;
            issued := TRUE;
        END_IF;
        D80 := 1;
        D81 := 4;
        D82 := seq_no;
        IF D90 = current_id THEN
            issued := FALSE;
            step := 110;
        END_IF;
    END_IF;

110:
    IF original_station = 2 THEN
        station_x := D406;
        station_ready := X62;
    ELSE
        station_x := D403;
        station_ready := X61;
    END_IF;
    D2000 := station_x;
    D2004 := 0;
    IF at_station AND at_b0 AND station_ready AND lift_dock_ready THEN
        step := 115;
    END_IF;

115:
    IF original_station = 2 THEN
        station_x := D406;
        station_ready := X62;
    ELSE
        station_x := D403;
        station_ready := X61;
    END_IF;
    D2000 := station_x;
    D2004 := 18000;
    IF at_station AND at_b180 AND station_ready AND lift_dock_ready THEN
        step := 120;
        issued := FALSE;
    END_IF;

120:
    IF original_station = 2 THEN
        station_x := D406;
        station_ready := X62;
    ELSE
        station_x := D403;
        station_ready := X61;
    END_IF;
    D2000 := station_x;
    D2004 := 18000;
    IF NOT issued THEN
        seq_no := seq_no + 1;
        issued := TRUE;
    END_IF;
    D80 := 2;
    D81 := original_station;
    D82 := seq_no;
    IF D90 <> current_id THEN
        issued := FALSE;
        step := 130;
    END_IF;

130:
    IF original_station = 2 THEN
        station_x := D406;
    ELSE
        station_x := D403;
    END_IF;
    D2000 := station_x;
    D2004 := 0;
    IF at_b0 AND lift_home_ready THEN
        step := 140;
    END_IF;

140:
    IF selected_channel = 0 THEN
        acked0 := TRUE;
        ack_id0 := current_id;
        ack_status0 := current_status;
    ELSE
        acked1 := TRUE;
        ack_id1 := current_id;
        ack_status1 := current_status;
    END_IF;
    step := 0;
ELSE
    step := 0;
END_CASE;

IF step = 0 THEN
    Y30 := TRUE;
END_IF;

IF D2000 < -450000 THEN D2000 := -450000; END_IF;
IF D2000 > 450000 THEN D2000 := 450000; END_IF;
IF D2004 < 0 THEN D2004 := 0; END_IF;
IF D2004 > 18000 THEN D2004 := 18000; END_IF;
IF D2008 < 0 THEN D2008 := 0; END_IF;
IF D2008 > 120000 THEN D2008 := 120000; END_IF;
IF D2012 < 0 THEN D2012 := 0; END_IF;
IF D2012 > 120000 THEN D2012 := 120000; END_IF;
IF D2016 < 0 THEN D2016 := 0; END_IF;
IF D2016 > 27000 THEN D2016 := 27000; END_IF;
IF D2020 < 0 THEN D2020 := 0; END_IF;
IF D2020 > 74000 THEN D2020 := 74000; END_IF;
IF D2024 < 0 THEN D2024 := 0; END_IF;
IF D2024 > 27000 THEN D2024 := 27000; END_IF;
IF D2028 < 0 THEN D2028 := 0; END_IF;
IF D2028 > 4000 THEN D2028 := 4000; END_IF;
IF D2032 < 0 THEN D2032 := 0; END_IF;
IF D2032 > 4000 THEN D2032 := 4000; END_IF;

all_home := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
            (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
            lift_home_ready AND cell3_home AND cell4_home;

IF X51 AND all_home AND (step = 0) AND (scan_count <= 16000) THEN
    final_declared := TRUE;
END_IF;

Y2 := final_declared AND X51 AND all_home;
IF Y2 THEN
    Y30 := TRUE;
END_IF;

D300 := ack_id0;
D301 := ack_status0;
D302 := ack_id1;
D303 := ack_status1;
D82 := seq_no;

END_PROGRAM