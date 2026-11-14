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
    state : INT;
    active_req : INT;
    req_id : DINT;
    origin_station : INT;
    req_status : DINT;
    cancel_mode : BOOL;
    seq_no : DINT;
    conn_issued : BOOL;
    dock_target : DINT;
    desired_lift : DINT;
    lift_cmd : DINT;
    lift_step : DINT := 1000;
    station_x : DINT;
    port_ready : BOOL;
    a_ready : BOOL;
    b_ready : BOOL;
    lift_dock_ready : BOOL;
    lift_home_ready : BOOL;
    s3_home : BOOL;
    s4_home : BOOL;
    g30 : DINT;
    g31 : DINT;
    g32 : DINT;
    g33 : DINT;
    g40 : DINT;
    g41 : DINT;
    g42 : DINT;
    s4_high : DINT;
    s4_final_v : DINT;
    final_ready : BOOL;
END_VAR

dock_target := D92;
IF dock_target < 0 THEN
    dock_target := 0;
END_IF;
IF dock_target > 120000 THEN
    dock_target := 120000;
END_IF;

g30 := D500;
IF g30 < -9000 THEN g30 := -9000; END_IF;
IF g30 > 9000 THEN g30 := 9000; END_IF;
g31 := D501;
IF g31 < 0 THEN g31 := 0; END_IF;
IF g31 > 65000 THEN g31 := 65000; END_IF;
g32 := D502;
IF g32 < -9000 THEN g32 := -9000; END_IF;
IF g32 > 9000 THEN g32 := 9000; END_IF;
g33 := D503;
IF g33 < 0 THEN g33 := 0; END_IF;
IF g33 > 65000 THEN g33 := 65000; END_IF;

g40 := D600;
IF g40 < -90000 THEN g40 := -90000; END_IF;
IF g40 > 90000 THEN g40 := 90000; END_IF;
g41 := D601;
IF g41 < -90000 THEN g41 := -90000; END_IF;
IF g41 > 90000 THEN g41 := 90000; END_IF;
g42 := D602;
IF g42 < 0 THEN g42 := 0; END_IF;
IF g42 > 35000 THEN g42 := 35000; END_IF;

s4_final_v := g42;
IF (ABS(g40 - g41) < 23000) AND (s4_final_v < 22000) THEN
    s4_final_v := 22000;
END_IF;
s4_high := s4_final_v;
IF s4_high < 22000 THEN
    s4_high := 22000;
END_IF;
IF s4_high > 35000 THEN
    s4_high := 35000;
END_IF;

D80 := 0;
D81 := 0;
D82 := seq_no;

D2000 := 0;
D2001 := 700;
D2002 := 0;
Y40 := TRUE;

D2004 := 0;
D2005 := 500;
D2006 := 0;
Y41 := TRUE;

D2008 := 40000;
D2009 := 300;
D2010 := 0;
Y42 := TRUE;

D2012 := 40000;
D2013 := 300;
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
Y30 := FALSE;

IF active_req = 0 THEN
    IF X31 THEN
        cancel_mode := TRUE;
        req_status := 2;
    END_IF;
ELSIF active_req = 1 THEN
    IF X35 THEN
        cancel_mode := TRUE;
        req_status := 2;
    END_IF;
END_IF;

s3_home := (ABS(D1016 + 6500) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024 - 6500) <= 20) AND (ABS(D1025) <= 100) AND
           (ABS(D1028) <= 20) AND (ABS(D1029) <= 100);

s4_home := (ABS(D1032 + 65000) <= 20) AND (ABS(D1033) <= 100) AND
           (ABS(D1036 - 65000) <= 20) AND (ABS(D1037) <= 100) AND
           (ABS(D1040) <= 20) AND (ABS(D1041) <= 100);

lift_dock_ready := (ABS(D1008 - dock_target) <= 20) AND (ABS(D1009) <= 100) AND
                   (ABS(D1012 - dock_target) <= 20) AND (ABS(D1013) <= 100);

lift_home_ready := (ABS(D1008 - 40000) <= 20) AND (ABS(D1009) <= 100) AND
                   (ABS(D1012 - 40000) <= 20) AND (ABS(D1013) <= 100);

desired_lift := 40000;

CASE state OF
0:
    desired_lift := 40000;
    D2000 := 0;
    D2004 := 0;
    IF (D100 <> 0) AND (D300 <> D100) THEN
        active_req := 0;
        req_id := D100;
        origin_station := D101;
        IF (origin_station <> 1) AND (origin_station <> 2) THEN
            origin_station := 1;
        END_IF;
        req_status := 1;
        cancel_mode := X31;
        IF cancel_mode THEN req_status := 2; END_IF;
        conn_issued := FALSE;
        state := 10;
    ELSIF (D120 <> 0) AND (D302 <> D120) THEN
        active_req := 1;
        req_id := D120;
        origin_station := D121;
        IF (origin_station <> 1) AND (origin_station <> 2) THEN
            origin_station := 2;
        END_IF;
        req_status := 1;
        cancel_mode := X35;
        IF cancel_mode THEN req_status := 2; END_IF;
        conn_issued := FALSE;
        state := 10;
    END_IF;

10:
    desired_lift := dock_target;
    D2004 := 0;
    IF lift_dock_ready THEN
        state := 20;
    END_IF;

20:
    desired_lift := dock_target;
    D2004 := 0;
    IF origin_station = 1 THEN
        station_x := D403;
        port_ready := X61;
    ELSE
        station_x := D406;
        port_ready := X62;
    END_IF;
    D2000 := station_x;
    a_ready := (ABS(D1000 - station_x) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF a_ready AND b_ready AND lift_dock_ready AND port_ready THEN
        conn_issued := FALSE;
        state := 30;
    END_IF;

30:
    desired_lift := dock_target;
    IF origin_station = 1 THEN
        station_x := D403;
        port_ready := X61;
    ELSE
        station_x := D406;
        port_ready := X62;
    END_IF;
    D2000 := station_x;
    D2004 := 18000;
    a_ready := (ABS(D1000 - station_x) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF NOT conn_issued THEN
        IF a_ready AND b_ready AND lift_dock_ready AND port_ready THEN
            seq_no := seq_no + 1;
            conn_issued := TRUE;
        END_IF;
    END_IF;
    IF conn_issued THEN
        D80 := 1;
        D81 := origin_station;
        D82 := seq_no;
    END_IF;
    IF D90 = req_id THEN
        conn_issued := FALSE;
        state := 32;
    END_IF;

32:
    desired_lift := dock_target;
    IF origin_station = 1 THEN
        station_x := D403;
    ELSE
        station_x := D406;
    END_IF;
    D2000 := station_x;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF cancel_mode THEN
            state := 120;
        ELSE
            state := 40;
        END_IF;
    END_IF;

40:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 0;
    a_ready := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF a_ready AND b_ready AND X63 AND s3_home THEN
        conn_issued := FALSE;
        state := 41;
    END_IF;

41:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 18000;
    a_ready := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF NOT conn_issued THEN
        IF a_ready AND b_ready AND X63 AND s3_home THEN
            seq_no := seq_no + 1;
            conn_issued := TRUE;
        END_IF;
    END_IF;
    IF conn_issued THEN
        D80 := 2;
        D81 := 3;
        D82 := seq_no;
    END_IF;
    IF D90 <> req_id THEN
        conn_issued := FALSE;
        state := 42;
    END_IF;

42:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 0;
    Y71 := TRUE;
    D700 := req_id;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF cancel_mode THEN
            state := 53;
        ELSE
            state := 50;
        END_IF;
    END_IF;

50:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := req_id;
    D2016 := -6500;
    D2020 := 0;
    D2024 := 6500;
    D2028 := 0;
    IF (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) THEN
        state := 51;
    END_IF;

51:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := req_id;
    D2016 := g30;
    D2020 := 0;
    D2024 := g32;
    D2028 := 0;
    IF (ABS(D1016 - g30) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1024 - g32) <= 20) AND (ABS(D1025) <= 100) THEN
        state := 52;
    END_IF;

52:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := req_id;
    D2016 := g30;
    D2020 := g31;
    D2024 := g32;
    D2028 := g33;
    IF (ABS(D1016 - g30) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 - g31) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024 - g32) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028 - g33) <= 20) AND (ABS(D1029) <= 100) AND X70 THEN
        state := 53;
    END_IF;

53:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 0;
    Y71 := TRUE;
    D700 := req_id;
    D2016 := g30;
    D2020 := 0;
    D2024 := g32;
    D2028 := 0;
    IF (D1020 <= 8000) AND (ABS(D1021) <= 100) AND
       (D1028 <= 8000) AND (ABS(D1029) <= 100) THEN
        state := 54;
    END_IF;

54:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 0;
    Y71 := TRUE;
    D700 := req_id;
    D2016 := -6500;
    D2020 := 0;
    D2024 := 6500;
    D2028 := 0;
    IF s3_home THEN
        conn_issued := FALSE;
        state := 55;
    END_IF;

55:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 18000;
    a_ready := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF NOT conn_issued THEN
        IF a_ready AND b_ready AND X63 AND s3_home THEN
            seq_no := seq_no + 1;
            conn_issued := TRUE;
        END_IF;
    END_IF;
    IF conn_issued THEN
        D80 := 1;
        D81 := 3;
        D82 := seq_no;
    END_IF;
    IF D90 = req_id THEN
        conn_issued := FALSE;
        state := 56;
    END_IF;

56:
    desired_lift := dock_target;
    D2000 := D409;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF cancel_mode THEN
            state := 120;
        ELSE
            state := 60;
        END_IF;
    END_IF;

60:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    a_ready := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF a_ready AND b_ready AND X64 AND s4_home THEN
        conn_issued := FALSE;
        state := 61;
    END_IF;

61:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 18000;
    a_ready := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF NOT conn_issued THEN
        IF a_ready AND b_ready AND X64 AND s4_home THEN
            seq_no := seq_no + 1;
            conn_issued := TRUE;
        END_IF;
    END_IF;
    IF conn_issued THEN
        D80 := 2;
        D81 := 4;
        D82 := seq_no;
    END_IF;
    IF D90 <> req_id THEN
        conn_issued := FALSE;
        state := 62;
    END_IF;

62:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    Y76 := TRUE;
    D710 := req_id;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF cancel_mode THEN
            state := 73;
        ELSE
            state := 70;
        END_IF;
    END_IF;

70:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := req_id;
    D2032 := -65000;
    D2036 := 65000;
    D2040 := s4_high;
    IF (ABS(D1040 - s4_high) <= 20) AND (ABS(D1041) <= 100) THEN
        state := 71;
    END_IF;

71:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := req_id;
    D2032 := g40;
    D2036 := g41;
    D2040 := s4_high;
    IF (ABS(D1032 - g40) <= 20) AND (ABS(D1033) <= 100) AND
       (ABS(D1036 - g41) <= 20) AND (ABS(D1037) <= 100) THEN
        state := 72;
    END_IF;

72:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := req_id;
    D2032 := g40;
    D2036 := g41;
    D2040 := s4_final_v;
    IF (ABS(D1032 - g40) <= 20) AND (ABS(D1033) <= 100) AND
       (ABS(D1036 - g41) <= 20) AND (ABS(D1037) <= 100) AND
       (ABS(D1040 - s4_final_v) <= 20) AND (ABS(D1041) <= 100) AND X75 THEN
        state := 73;
    END_IF;

73:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    Y76 := TRUE;
    D710 := req_id;
    D2032 := g40;
    D2036 := g41;
    D2040 := s4_high;
    IF (ABS(D1040 - s4_high) <= 20) AND (ABS(D1041) <= 100) THEN
        state := 74;
    END_IF;

74:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    Y76 := TRUE;
    D710 := req_id;
    D2032 := -65000;
    D2036 := 65000;
    D2040 := s4_high;
    IF (ABS(D1032 + 65000) <= 20) AND (ABS(D1033) <= 100) AND
       (ABS(D1036 - 65000) <= 20) AND (ABS(D1037) <= 100) THEN
        state := 75;
    END_IF;

75:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    Y76 := TRUE;
    D710 := req_id;
    D2032 := -65000;
    D2036 := 65000;
    D2040 := 0;
    IF s4_home THEN
        conn_issued := FALSE;
        state := 76;
    END_IF;

76:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 18000;
    a_ready := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF NOT conn_issued THEN
        IF a_ready AND b_ready AND X64 AND s4_home THEN
            seq_no := seq_no + 1;
            conn_issued := TRUE;
        END_IF;
    END_IF;
    IF conn_issued THEN
        D80 := 1;
        D81 := 4;
        D82 := seq_no;
    END_IF;
    IF D90 = req_id THEN
        conn_issued := FALSE;
        state := 77;
    END_IF;

77:
    desired_lift := dock_target;
    D2000 := D412;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 120;
    END_IF;

120:
    desired_lift := dock_target;
    IF origin_station = 1 THEN
        station_x := D403;
        port_ready := X61;
    ELSE
        station_x := D406;
        port_ready := X62;
    END_IF;
    D2000 := station_x;
    D2004 := 0;
    a_ready := (ABS(D1000 - station_x) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF a_ready AND b_ready AND lift_dock_ready AND port_ready THEN
        conn_issued := FALSE;
        state := 121;
    END_IF;

121:
    desired_lift := dock_target;
    IF origin_station = 1 THEN
        station_x := D403;
        port_ready := X61;
    ELSE
        station_x := D406;
        port_ready := X62;
    END_IF;
    D2000 := station_x;
    D2004 := 18000;
    a_ready := (ABS(D1000 - station_x) <= 20) AND (ABS(D1001) <= 100);
    b_ready := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF NOT conn_issued THEN
        IF a_ready AND b_ready AND lift_dock_ready AND port_ready THEN
            seq_no := seq_no + 1;
            conn_issued := TRUE;
        END_IF;
    END_IF;
    IF conn_issued THEN
        D80 := 2;
        D81 := origin_station;
        D82 := seq_no;
    END_IF;
    IF D90 <> req_id THEN
        conn_issued := FALSE;
        state := 122;
    END_IF;

122:
    desired_lift := dock_target;
    IF origin_station = 1 THEN
        station_x := D403;
    ELSE
        station_x := D406;
    END_IF;
    D2000 := station_x;
    D2004 := 0;
    IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        state := 123;
    END_IF;

123:
    desired_lift := 40000;
    IF origin_station = 1 THEN
        station_x := D403;
    ELSE
        station_x := D406;
    END_IF;
    D2000 := station_x;
    D2004 := 0;
    IF lift_home_ready AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF active_req = 0 THEN
            D300 := req_id;
            D301 := req_status;
        ELSE
            D302 := req_id;
            D303 := req_status;
        END_IF;
        active_req := -1;
        req_id := 0;
        cancel_mode := FALSE;
        state := 0;
    END_IF;

ELSE
    state := 0;
END_CASE;

IF desired_lift > 120000 THEN desired_lift := 120000; END_IF;
IF desired_lift < 0 THEN desired_lift := 0; END_IF;

IF (D1008 < (desired_lift - 20)) OR (D1012 < (desired_lift - 20)) THEN
    IF D1008 < D1012 THEN
        lift_cmd := D1008 + lift_step;
    ELSE
        lift_cmd := D1012 + lift_step;
    END_IF;
    IF lift_cmd > desired_lift THEN lift_cmd := desired_lift; END_IF;
ELSIF (D1008 > (desired_lift + 20)) OR (D1012 > (desired_lift + 20)) THEN
    IF D1008 > D1012 THEN
        lift_cmd := D1008 - lift_step;
    ELSE
        lift_cmd := D1012 - lift_step;
    END_IF;
    IF lift_cmd < desired_lift THEN lift_cmd := desired_lift; END_IF;
ELSE
    lift_cmd := desired_lift;
END_IF;

IF lift_cmd < 0 THEN lift_cmd := 0; END_IF;
IF lift_cmd > 120000 THEN lift_cmd := 120000; END_IF;
D2008 := lift_cmd;
D2012 := lift_cmd;

IF D2000 < -450000 THEN D2000 := -450000; END_IF;
IF D2000 > 730000 THEN D2000 := 730000; END_IF;
IF D2004 < 0 THEN D2004 := 0; END_IF;
IF D2004 > 18000 THEN D2004 := 18000; END_IF;

final_ready := (state = 0) AND X51 AND
               (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
               (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
               lift_home_ready AND s3_home AND s4_home;

IF final_ready OR Y2 THEN
    Y2 := TRUE;
    Y30 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM