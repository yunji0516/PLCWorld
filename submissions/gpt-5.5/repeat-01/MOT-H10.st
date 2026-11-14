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
    req0_seen : DINT;
    req1_seen : DINT;
    req0_stage : INT;
    req1_stage : INT;
    req0_ack : BOOL;
    req1_ack : BOOL;
    req0_cancel : BOOL;
    req1_cancel : BOOL;
    req0_status : DINT;
    req1_status : DINT;
    req0_sent : BOOL;
    req1_sent : BOOL;
    active_req : INT;
    cur_id : DINT;
    cur_origin : INT;
    cur_stage : INT;
    cur_cancel : BOOL;
    cur_sent : BOOL;
    new_stage : INT;
    couple_seq_internal : DINT;
    port_target : DINT;
    port_id : DINT;
    port_ready : BOOL;
    origin_port_id : DINT;
    origin_ready : BOOL;
    origin_x : DINT;
    aligned : BOOL;
    fork_in : BOOL;
    fork_out : BOOL;
    send_couple : BOOL;
    couple_action : DINT;
    couple_station : DINT;
    final_ready : BOOL;
    final_declared : BOOL;
    lift_need_move : BOOL;
    s3_angle_cmd : DINT;
    s3_counter_cmd : DINT;
    s3_angle_real : REAL;
    s3_counter_real : REAL;
    pi_value : REAL := 3.14159265;
    s4_trolley_cmd : DINT;
    s4_rope_cmd : DINT;
    s4_sway_cmd : DINT;
    hoist_accel_cmd : DINT;
    hoist_accel_real : REAL;
END_VAR

IF D100 <> req0_seen THEN
    req0_seen := D100;
    req0_stage := 0;
    req0_ack := FALSE;
    req0_cancel := FALSE;
    req0_status := 0;
    req0_sent := FALSE;
    IF D100 <> 0 THEN
        req0_stage := 10;
    END_IF;
END_IF;

IF D120 <> req1_seen THEN
    req1_seen := D120;
    req1_stage := 0;
    req1_ack := FALSE;
    req1_cancel := FALSE;
    req1_status := 0;
    req1_sent := FALSE;
    IF D120 <> 0 THEN
        req1_stage := 10;
    END_IF;
END_IF;

IF X31 AND (req0_seen <> 0) AND NOT req0_ack THEN
    req0_cancel := TRUE;
END_IF;

IF X35 AND (req1_seen <> 0) AND NOT req1_ack THEN
    req1_cancel := TRUE;
END_IF;

IF req0_ack THEN
    D300 := req0_seen;
    D301 := req0_status;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF req1_ack THEN
    D302 := req1_seen;
    D303 := req1_status;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

IF active_req = 1 THEN
    IF (req0_stage = 0) OR req0_ack THEN
        active_req := 0;
    END_IF;
ELSIF active_req = 2 THEN
    IF (req1_stage = 0) OR req1_ack THEN
        active_req := 0;
    END_IF;
END_IF;

IF active_req = 0 THEN
    IF (req0_stage <> 0) AND NOT req0_ack THEN
        active_req := 1;
    ELSIF (req1_stage <> 0) AND NOT req1_ack THEN
        active_req := 2;
    END_IF;
END_IF;

D2001 := 1000;
D2002 := 0;
D2005 := 1000;
D2006 := 0;
D2009 := 1000;
D2010 := 0;
D2013 := 1000;
D2014 := 0;
D2017 := 300;
D2018 := 0;
D2021 := 1000;
D2022 := 0;
D2025 := 250;
D2026 := 0;
D2029 := 500;
D2030 := 0;
D2033 := 1000;
D2034 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := FALSE;

D2000 := 0;
D2004 := 0;
D2008 := 15000;
D2012 := 15000;
D2016 := 0;
D2020 := 0;
D2024 := 100000;
D2028 := 0;
D2032 := 0;

D80 := 0;
D81 := 0;
send_couple := FALSE;
couple_action := 0;
couple_station := 0;

Y70 := FALSE;
Y71 := FALSE;
D700 := 0;
D701 := 0;
D702 := 0;
Y75 := FALSE;
Y76 := FALSE;
D710 := 0;
D711 := 0;
D712 := 0;

cur_id := 0;
cur_origin := 1;
cur_stage := 0;
cur_cancel := FALSE;
cur_sent := FALSE;

IF active_req = 1 THEN
    cur_id := req0_seen;
    cur_stage := req0_stage;
    cur_cancel := req0_cancel;
    cur_sent := req0_sent;
    IF D101 = 2 THEN
        cur_origin := 2;
    ELSE
        cur_origin := 1;
    END_IF;
ELSIF active_req = 2 THEN
    cur_id := req1_seen;
    cur_stage := req1_stage;
    cur_cancel := req1_cancel;
    cur_sent := req1_sent;
    IF D121 = 2 THEN
        cur_origin := 2;
    ELSE
        cur_origin := 1;
    END_IF;
END_IF;

IF cur_origin = 2 THEN
    origin_x := D406;
    origin_port_id := D407;
    origin_ready := X62;
ELSE
    origin_x := D403;
    origin_port_id := D404;
    origin_ready := X61;
END_IF;

fork_in := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
fork_out := (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);

new_stage := cur_stage;

CASE cur_stage OF
0:
    D2000 := 0;
    D2004 := 0;

10:
    D2000 := origin_x;
    D2004 := 0;
    IF cur_origin = 1 THEN
        D2008 := D92;
        D2012 := 15000;
    ELSE
        D2008 := 15000;
        D2012 := D92;
    END_IF;
    IF cur_cancel AND (D90 <> cur_id) THEN
        IF cur_origin = 1 THEN
            D2008 := 15000;
            IF (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) THEN
                IF active_req = 1 THEN
                    req0_ack := TRUE;
                    req0_status := 2;
                ELSIF active_req = 2 THEN
                    req1_ack := TRUE;
                    req1_status := 2;
                END_IF;
                new_stage := 0;
            END_IF;
        ELSE
            D2012 := 15000;
            IF (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
                IF active_req = 1 THEN
                    req0_ack := TRUE;
                    req0_status := 2;
                ELSIF active_req = 2 THEN
                    req1_ack := TRUE;
                    req1_status := 2;
                END_IF;
                new_stage := 0;
            END_IF;
        END_IF;
    ELSE
        aligned := (ABS(D1000 - origin_x) <= 20) AND (ABS(D1001) <= 100) AND fork_in AND origin_ready AND (origin_port_id = cur_id);
        IF cur_origin = 1 THEN
            aligned := aligned AND (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
        ELSE
            aligned := aligned AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
        END_IF;
        IF aligned THEN
            new_stage := 11;
            cur_sent := FALSE;
        END_IF;
    END_IF;

11:
    D2000 := origin_x;
    D2004 := 18000;
    IF cur_origin = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    aligned := (ABS(D1000 - origin_x) <= 20) AND (ABS(D1001) <= 100) AND fork_out AND origin_ready AND (origin_port_id = cur_id);
    IF cur_origin = 1 THEN
        aligned := aligned AND (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        aligned := aligned AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF aligned AND NOT cur_sent THEN
        couple_seq_internal := couple_seq_internal + 1;
        cur_sent := TRUE;
    END_IF;
    IF cur_sent THEN
        D80 := 1;
        D81 := cur_origin;
    END_IF;
    IF D90 = cur_id THEN
        new_stage := 12;
        cur_sent := FALSE;
    END_IF;

12:
    D2000 := origin_x;
    D2004 := 0;
    IF cur_origin = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    IF fork_in THEN
        IF cur_cancel THEN
            new_stage := 80;
        ELSE
            new_stage := 20;
        END_IF;
        cur_sent := FALSE;
    END_IF;

20:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 0;
    IF cur_cancel THEN
        new_stage := 80;
        cur_sent := FALSE;
    ELSE
        aligned := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND fork_in AND X63 AND ((D410 = 0) OR (D410 = cur_id)) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);
        IF aligned THEN
            new_stage := 21;
            cur_sent := FALSE;
        END_IF;
    END_IF;

21:
    D2000 := D409;
    D2004 := 18000;
    D2016 := 0;
    D2020 := 0;
    aligned := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND fork_out AND X63 AND ((D410 = 0) OR (D410 = cur_id)) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);
    IF aligned AND NOT cur_sent THEN
        couple_seq_internal := couple_seq_internal + 1;
        cur_sent := TRUE;
    END_IF;
    IF cur_sent THEN
        D80 := 2;
        D81 := 3;
    END_IF;
    IF (D90 <> cur_id) AND (D410 = cur_id) THEN
        new_stage := 22;
        cur_sent := FALSE;
    END_IF;

22:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 0;
    IF fork_in THEN
        IF cur_cancel THEN
            new_stage := 31;
        ELSE
            new_stage := 30;
        END_IF;
        cur_sent := FALSE;
    END_IF;

30:
    D2000 := D409;
    D2004 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := cur_id;
    D701 := D526;
    D702 := 1000;
    s3_angle_cmd := D500;
    IF s3_angle_cmd > 5000 THEN
        s3_angle_cmd := 5000;
    ELSIF s3_angle_cmd < -5000 THEN
        s3_angle_cmd := -5000;
    END_IF;
    D2016 := s3_angle_cmd;
    s3_angle_real := REAL(D1016) / 100.0;
    s3_counter_real := -45000.0 * SIN(s3_angle_real * pi_value / 180.0);
    s3_counter_cmd := DINT(s3_counter_real);
    IF s3_counter_cmd > 45000 THEN
        s3_counter_cmd := 45000;
    ELSIF s3_counter_cmd < -45000 THEN
        s3_counter_cmd := -45000;
    END_IF;
    D2020 := s3_counter_cmd;
    IF X70 OR cur_cancel THEN
        new_stage := 31;
        cur_sent := FALSE;
    END_IF;

31:
    D2000 := D409;
    D2004 := 0;
    Y70 := TRUE;
    Y71 := TRUE;
    D700 := cur_id;
    D701 := D526;
    D702 := 1000;
    D2016 := 0;
    s3_angle_real := REAL(D1016) / 100.0;
    s3_counter_real := -45000.0 * SIN(s3_angle_real * pi_value / 180.0);
    s3_counter_cmd := DINT(s3_counter_real);
    IF ABS(D1016) <= 30 THEN
        s3_counter_cmd := 0;
    END_IF;
    IF s3_counter_cmd > 45000 THEN
        s3_counter_cmd := 45000;
    ELSIF s3_counter_cmd < -45000 THEN
        s3_counter_cmd := -45000;
    END_IF;
    D2020 := s3_counter_cmd;
    IF X63 AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND fork_in THEN
        new_stage := 40;
        cur_sent := FALSE;
    END_IF;

40:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 0;
    aligned := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND fork_in AND X63 AND (D410 = cur_id) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);
    IF aligned THEN
        new_stage := 41;
        cur_sent := FALSE;
    END_IF;

41:
    D2000 := D409;
    D2004 := 18000;
    D2016 := 0;
    D2020 := 0;
    aligned := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND fork_out AND X63 AND (D410 = cur_id) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);
    IF aligned AND NOT cur_sent THEN
        couple_seq_internal := couple_seq_internal + 1;
        cur_sent := TRUE;
    END_IF;
    IF cur_sent THEN
        D80 := 1;
        D81 := 3;
    END_IF;
    IF D90 = cur_id THEN
        new_stage := 42;
        cur_sent := FALSE;
    END_IF;

42:
    D2000 := D409;
    D2004 := 0;
    D2016 := 0;
    D2020 := 0;
    IF fork_in THEN
        IF cur_cancel THEN
            new_stage := 80;
        ELSE
            new_stage := 50;
        END_IF;
        cur_sent := FALSE;
    END_IF;

50:
    D2000 := D412;
    D2004 := 0;
    D2024 := 100000;
    D2028 := 0;
    D2032 := 0;
    IF cur_cancel THEN
        new_stage := 80;
        cur_sent := FALSE;
    ELSE
        aligned := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND fork_in AND X64 AND ((D413 = 0) OR (D413 = cur_id)) AND (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);
        IF aligned THEN
            new_stage := 51;
            cur_sent := FALSE;
        END_IF;
    END_IF;

51:
    D2000 := D412;
    D2004 := 18000;
    D2024 := 100000;
    D2028 := 0;
    D2032 := 0;
    aligned := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND fork_out AND X64 AND ((D413 = 0) OR (D413 = cur_id)) AND (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);
    IF aligned AND NOT cur_sent THEN
        couple_seq_internal := couple_seq_internal + 1;
        cur_sent := TRUE;
    END_IF;
    IF cur_sent THEN
        D80 := 2;
        D81 := 4;
    END_IF;
    IF (D90 <> cur_id) AND (D413 = cur_id) THEN
        new_stage := 52;
        cur_sent := FALSE;
    END_IF;

52:
    D2000 := D412;
    D2004 := 0;
    D2024 := 100000;
    D2028 := 0;
    D2032 := 0;
    IF fork_in THEN
        IF cur_cancel THEN
            new_stage := 61;
        ELSE
            new_stage := 60;
        END_IF;
        cur_sent := FALSE;
    END_IF;

60:
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := cur_id;
    D711 := D626;
    s4_trolley_cmd := D600;
    IF s4_trolley_cmd > 150000 THEN
        s4_trolley_cmd := 150000;
    ELSIF s4_trolley_cmd < 50000 THEN
        s4_trolley_cmd := 50000;
    END_IF;
    s4_rope_cmd := D601;
    IF s4_rope_cmd > 100000 THEN
        s4_rope_cmd := 100000;
    ELSIF s4_rope_cmd < -100000 THEN
        s4_rope_cmd := -100000;
    END_IF;
    s4_sway_cmd := D602;
    IF s4_sway_cmd > 3000 THEN
        s4_sway_cmd := 3000;
    ELSIF s4_sway_cmd < -3000 THEN
        s4_sway_cmd := -3000;
    END_IF;
    D2024 := s4_trolley_cmd;
    D2028 := s4_rope_cmd;
    D2032 := s4_sway_cmd;
    hoist_accel_real := 0.18 * REAL(s4_trolley_cmd - D1024) - 0.80 * REAL(D1025) - 8.0 * REAL(D1032) - 12.0 * REAL(D1033);
    hoist_accel_cmd := DINT(hoist_accel_real);
    IF hoist_accel_cmd > 1000000 THEN
        hoist_accel_cmd := 1000000;
    ELSIF hoist_accel_cmd < -1000000 THEN
        hoist_accel_cmd := -1000000;
    END_IF;
    D712 := hoist_accel_cmd;
    IF X75 OR cur_cancel THEN
        new_stage := 61;
        cur_sent := FALSE;
    END_IF;

61:
    D2000 := D412;
    D2004 := 0;
    Y75 := TRUE;
    Y76 := TRUE;
    D710 := cur_id;
    D711 := D626;
    D2024 := 100000;
    D2028 := 0;
    D2032 := 0;
    hoist_accel_real := 0.22 * REAL(100000 - D1024) - 0.90 * REAL(D1025) - 10.0 * REAL(D1032) - 14.0 * REAL(D1033);
    hoist_accel_cmd := DINT(hoist_accel_real);
    IF hoist_accel_cmd > 1000000 THEN
        hoist_accel_cmd := 1000000;
    ELSIF hoist_accel_cmd < -1000000 THEN
        hoist_accel_cmd := -1000000;
    END_IF;
    D712 := hoist_accel_cmd;
    IF X64 AND (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) AND fork_in THEN
        new_stage := 70;
        cur_sent := FALSE;
    END_IF;

70:
    D2000 := D412;
    D2004 := 0;
    D2024 := 100000;
    D2028 := 0;
    D2032 := 0;
    aligned := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND fork_in AND X64 AND (D413 = cur_id) AND (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);
    IF aligned THEN
        new_stage := 71;
        cur_sent := FALSE;
    END_IF;

71:
    D2000 := D412;
    D2004 := 18000;
    D2024 := 100000;
    D2028 := 0;
    D2032 := 0;
    aligned := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND fork_out AND X64 AND (D413 = cur_id) AND (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);
    IF aligned AND NOT cur_sent THEN
        couple_seq_internal := couple_seq_internal + 1;
        cur_sent := TRUE;
    END_IF;
    IF cur_sent THEN
        D80 := 1;
        D81 := 4;
    END_IF;
    IF D90 = cur_id THEN
        new_stage := 72;
        cur_sent := FALSE;
    END_IF;

72:
    D2000 := D412;
    D2004 := 0;
    D2024 := 100000;
    D2028 := 0;
    D2032 := 0;
    IF fork_in THEN
        new_stage := 80;
        cur_sent := FALSE;
    END_IF;

80:
    D2000 := origin_x;
    D2004 := 0;
    IF cur_origin = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    aligned := (ABS(D1000 - origin_x) <= 20) AND (ABS(D1001) <= 100) AND fork_in AND origin_ready AND ((origin_port_id = 0) OR (origin_port_id = cur_id));
    IF cur_origin = 1 THEN
        aligned := aligned AND (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        aligned := aligned AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF aligned THEN
        new_stage := 81;
        cur_sent := FALSE;
    END_IF;

81:
    D2000 := origin_x;
    D2004 := 18000;
    IF cur_origin = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    aligned := (ABS(D1000 - origin_x) <= 20) AND (ABS(D1001) <= 100) AND fork_out AND origin_ready AND ((origin_port_id = 0) OR (origin_port_id = cur_id));
    IF cur_origin = 1 THEN
        aligned := aligned AND (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        aligned := aligned AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF aligned AND NOT cur_sent THEN
        couple_seq_internal := couple_seq_internal + 1;
        cur_sent := TRUE;
    END_IF;
    IF cur_sent THEN
        D80 := 2;
        D81 := cur_origin;
    END_IF;
    IF (D90 <> cur_id) AND (origin_port_id = cur_id) THEN
        new_stage := 82;
        cur_sent := FALSE;
    END_IF;

82:
    D2000 := origin_x;
    D2004 := 0;
    IF cur_origin = 1 THEN
        D2008 := D92;
    ELSE
        D2012 := D92;
    END_IF;
    IF fork_in THEN
        new_stage := 90;
        cur_sent := FALSE;
    END_IF;

90:
    D2000 := origin_x;
    D2004 := 0;
    IF cur_origin = 1 THEN
        D2008 := 15000;
        D2012 := 15000;
        IF (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND fork_in THEN
            IF active_req = 1 THEN
                req0_ack := TRUE;
                IF cur_cancel THEN
                    req0_status := 2;
                ELSE
                    req0_status := 1;
                END_IF;
            ELSIF active_req = 2 THEN
                req1_ack := TRUE;
                IF cur_cancel THEN
                    req1_status := 2;
                ELSE
                    req1_status := 1;
                END_IF;
            END_IF;
            new_stage := 0;
            cur_sent := FALSE;
        END_IF;
    ELSE
        D2008 := 15000;
        D2012 := 15000;
        IF (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND fork_in THEN
            IF active_req = 1 THEN
                req0_ack := TRUE;
                IF cur_cancel THEN
                    req0_status := 2;
                ELSE
                    req0_status := 1;
                END_IF;
            ELSIF active_req = 2 THEN
                req1_ack := TRUE;
                IF cur_cancel THEN
                    req1_status := 2;
                ELSE
                    req1_status := 1;
                END_IF;
            END_IF;
            new_stage := 0;
            cur_sent := FALSE;
        END_IF;
    END_IF;

ELSE
    new_stage := 0;
END_CASE;

IF D1004 > 4000 THEN
    IF (cur_stage <> 11) AND (cur_stage <> 21) AND (cur_stage <> 41) AND (cur_stage <> 51) AND (cur_stage <> 71) AND (cur_stage <> 81) THEN
        D2000 := D1000;
    END_IF;
END_IF;

IF new_stage <> cur_stage THEN
    cur_sent := FALSE;
END_IF;

IF active_req = 1 THEN
    req0_stage := new_stage;
    req0_sent := cur_sent;
ELSIF active_req = 2 THEN
    req1_stage := new_stage;
    req1_sent := cur_sent;
END_IF;

IF D2016 > 5000 THEN
    D2016 := 5000;
ELSIF D2016 < -5000 THEN
    D2016 := -5000;
END_IF;

IF D2020 > 45000 THEN
    D2020 := 45000;
ELSIF D2020 < -45000 THEN
    D2020 := -45000;
END_IF;

IF D2024 > 150000 THEN
    D2024 := 150000;
ELSIF D2024 < 50000 THEN
    D2024 := 50000;
END_IF;

IF D2028 > 100000 THEN
    D2028 := 100000;
ELSIF D2028 < -100000 THEN
    D2028 := -100000;
END_IF;

IF D2032 > 3000 THEN
    D2032 := 3000;
ELSIF D2032 < -3000 THEN
    D2032 := -3000;
END_IF;

IF D2000 > 1130000 THEN
    D2000 := 1130000;
ELSIF D2000 < -450000 THEN
    D2000 := -450000;
END_IF;

IF D2004 > 18000 THEN
    D2004 := 18000;
ELSIF D2004 < 0 THEN
    D2004 := 0;
END_IF;

IF D2008 > 120000 THEN
    D2008 := 120000;
ELSIF D2008 < 0 THEN
    D2008 := 0;
END_IF;

IF D2012 > 120000 THEN
    D2012 := 120000;
ELSIF D2012 < 0 THEN
    D2012 := 0;
END_IF;

lift_need_move := (ABS(D2008 - D1008) > 20) OR (ABS(D2012 - D1012) > 20);
IF lift_need_move THEN
    Y30 := FALSE;
ELSE
    IF (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) THEN
        Y30 := TRUE;
    ELSE
        Y30 := FALSE;
    END_IF;
END_IF;

D82 := couple_seq_internal;

final_ready := X51 AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);

IF final_ready THEN
    final_declared := TRUE;
END_IF;

Y2 := final_declared AND final_ready;

END_PROGRAM