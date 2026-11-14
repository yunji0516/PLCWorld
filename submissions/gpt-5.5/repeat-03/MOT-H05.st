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
    r0_seen : BOOL;
    r1_seen : BOOL;
    r0_acked : BOOL;
    r1_acked : BOOL;
    r0_id_mem : DINT;
    r1_id_mem : DINT;
    r0_cancel_mem : BOOL;
    r1_cancel_mem : BOOL;
    state : INT;
    cur_req : INT;
    cur_id : DINT;
    cur_source : INT;
    cur_lane : INT;
    cur_cancel : BOOL;
    c4_sub : INT;
    c3_goal0 : DINT;
    c3_goal1 : DINT;
    c4_angle : DINT;
    c3_latched : BOOL;
    c4_latched : BOOL;
    c3_epoch : DINT;
    c4_epoch : DINT;
    keep_m3_retain : BOOL;
    h_active : BOOL;
    h_done : BOOL;
    h_action : INT;
    h_station : INT;
    h_id : DINT;
    h_phase : INT;
    h_sent : BOOL;
    h_retry : INT;
    seq_counter : DINT;
    port_x : DINT;
    port_ready : BOOL;
    port_id : DINT;
    lift_dock : DINT;
    final_ready : BOOL;
    pos_ok : BOOL;
    c3_done : BOOL;
    c4_done : BOOL;
    selected_lane : INT;
END_VAR

IF D100 <> 0 THEN
    IF NOT r0_seen THEN
        r0_id_mem := D100;
    END_IF;
    r0_seen := TRUE;
END_IF;
IF D120 <> 0 THEN
    IF NOT r1_seen THEN
        r1_id_mem := D120;
    END_IF;
    r1_seen := TRUE;
END_IF;
IF X31 THEN
    r0_cancel_mem := TRUE;
END_IF;
IF X35 THEN
    r1_cancel_mem := TRUE;
END_IF;

lift_dock := D92;
IF lift_dock < 0 THEN
    lift_dock := 0;
END_IF;
IF lift_dock > 120000 THEN
    lift_dock := 120000;
END_IF;

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
D2008 := 15000;
D2012 := 15000;
D2016 := -60000;
D2020 := -60000;
D2024 := 0;
D2028 := 0;
D2032 := 0;

D80 := 0;
D81 := 0;
D82 := seq_counter;
h_done := FALSE;

IF state = 0 THEN
    cur_id := 0;
    cur_req := 0;
    cur_cancel := FALSE;
    keep_m3_retain := FALSE;
    c3_latched := FALSE;
    c4_latched := FALSE;
    c4_sub := 0;
    IF r0_seen AND NOT r0_acked THEN
        cur_req := 1;
        cur_id := r0_id_mem;
        cur_cancel := r0_cancel_mem OR X31;
        IF (D101 = 1) OR (D101 = 2) THEN
            cur_source := INT(D101);
        ELSE
            cur_source := 1;
        END_IF;
        cur_lane := 0;
        state := 10;
    ELSIF r1_seen AND NOT r1_acked THEN
        cur_req := 2;
        cur_id := r1_id_mem;
        cur_cancel := r1_cancel_mem OR X35;
        IF (D121 = 1) OR (D121 = 2) THEN
            cur_source := INT(D121);
        ELSE
            cur_source := 2;
        END_IF;
        cur_lane := 1;
        state := 10;
    END_IF;
END_IF;

IF cur_req = 1 THEN
    cur_cancel := cur_cancel OR r0_cancel_mem OR X31;
ELSIF cur_req = 2 THEN
    cur_cancel := cur_cancel OR r1_cancel_mem OR X35;
END_IF;

IF (state = 10) OR (state = 11) OR (state = 80) OR (state = 81) THEN
    IF cur_source = 1 THEN
        D2008 := lift_dock;
    ELSE
        D2012 := lift_dock;
    END_IF;
END_IF;

IF (state = 40) OR (state = 50) OR (state = 51) THEN
    IF NOT c3_latched THEN
        c3_goal0 := D500 + 25000;
        c3_goal1 := D501 + 25000;
        IF c3_goal0 < -95000 THEN
            c3_goal0 := -95000;
        END_IF;
        IF c3_goal0 > 95000 THEN
            c3_goal0 := 95000;
        END_IF;
        IF c3_goal1 < -95000 THEN
            c3_goal1 := -95000;
        END_IF;
        IF c3_goal1 > 95000 THEN
            c3_goal1 := 95000;
        END_IF;
        c3_epoch := D91;
        c3_latched := TRUE;
        keep_m3_retain := TRUE;
    END_IF;
    D2016 := c3_goal0;
    D2020 := c3_goal1;
END_IF;

IF state = 70 THEN
    IF NOT c4_latched THEN
        c4_angle := D600;
        IF c4_angle < 0 THEN
            c4_angle := 0;
        END_IF;
        IF c4_angle > 27000 THEN
            c4_angle := 27000;
        END_IF;
        c4_epoch := D91;
        c4_latched := TRUE;
        c4_sub := 0;
    END_IF;
    selected_lane := cur_lane;
    IF (D620 = 0) OR (D620 = 1) THEN
        selected_lane := INT(D620);
    END_IF;
    IF c4_sub = 0 THEN
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        IF (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
            c4_sub := 1;
        END_IF;
    ELSIF c4_sub = 1 THEN
        D2024 := c4_angle;
        D2028 := 0;
        D2032 := 0;
        IF (ABS(D1024 - c4_angle) <= 20) AND (ABS(D1025) <= 100) THEN
            keep_m3_retain := FALSE;
            c4_sub := 2;
        END_IF;
    ELSIF c4_sub = 2 THEN
        D2024 := c4_angle;
        IF selected_lane = 0 THEN
            D2028 := 4000;
            D2032 := 0;
        ELSE
            D2028 := 0;
            D2032 := 4000;
        END_IF;
    ELSE
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
    END_IF;
END_IF;

Y70 := (state = 40);
Y71 := keep_m3_retain;
IF Y71 OR Y70 THEN
    D700 := cur_id;
    D701 := D526;
    IF (cur_lane = 0) OR (cur_lane = 1) THEN
        D702 := cur_lane;
    ELSE
        D702 := 0;
    END_IF;
ELSE
    D700 := 0;
    D701 := 0;
    D702 := 0;
END_IF;

Y75 := (state = 70);
Y76 := (state = 70) OR (state = 75) OR (state = 76);
IF Y75 OR Y76 THEN
    D710 := cur_id;
    D711 := D626;
    IF (cur_lane = 0) OR (cur_lane = 1) THEN
        D712 := cur_lane;
    ELSE
        D712 := 0;
    END_IF;
ELSE
    D710 := 0;
    D711 := 0;
    D712 := 0;
END_IF;

IF NOT h_active THEN
    IF state = 10 THEN
        IF cur_source = 1 THEN
            pos_ok := (ABS(D1008 - lift_dock) <= 20) AND (ABS(D1009) <= 100);
        ELSE
            pos_ok := (ABS(D1012 - lift_dock) <= 20) AND (ABS(D1013) <= 100);
        END_IF;
        IF pos_ok THEN
            h_active := TRUE;
            h_action := 1;
            h_station := cur_source;
            h_id := cur_id;
            h_phase := 0;
            h_sent := FALSE;
            h_retry := 0;
            state := 11;
        END_IF;
    ELSIF state = 30 THEN
        h_active := TRUE;
        h_action := 2;
        h_station := 3;
        h_id := cur_id;
        h_phase := 0;
        h_sent := FALSE;
        h_retry := 0;
        state := 31;
    ELSIF state = 50 THEN
        h_active := TRUE;
        h_action := 1;
        h_station := 3;
        h_id := cur_id;
        h_phase := 0;
        h_sent := FALSE;
        h_retry := 0;
        state := 51;
    ELSIF state = 60 THEN
        h_active := TRUE;
        h_action := 2;
        h_station := 4;
        h_id := cur_id;
        h_phase := 0;
        h_sent := FALSE;
        h_retry := 0;
        state := 61;
    ELSIF state = 75 THEN
        h_active := TRUE;
        h_action := 1;
        h_station := 4;
        h_id := cur_id;
        h_phase := 0;
        h_sent := FALSE;
        h_retry := 0;
        state := 76;
    ELSIF state = 80 THEN
        IF cur_source = 1 THEN
            pos_ok := (ABS(D1008 - lift_dock) <= 20) AND (ABS(D1009) <= 100);
        ELSE
            pos_ok := (ABS(D1012 - lift_dock) <= 20) AND (ABS(D1013) <= 100);
        END_IF;
        IF pos_ok THEN
            h_active := TRUE;
            h_action := 2;
            h_station := cur_source;
            h_id := cur_id;
            h_phase := 0;
            h_sent := FALSE;
            h_retry := 0;
            state := 81;
        END_IF;
    END_IF;
END_IF;

IF h_active THEN
    IF h_station = 1 THEN
        port_x := D403;
        port_ready := X61;
        port_id := D404;
    ELSIF h_station = 2 THEN
        port_x := D406;
        port_ready := X62;
        port_id := D407;
    ELSIF h_station = 3 THEN
        port_x := D409;
        port_ready := X63;
        port_id := D410;
    ELSE
        port_x := D412;
        port_ready := X64;
        port_id := D413;
    END_IF;
    IF port_x < -450000 THEN
        port_x := -450000;
    END_IF;
    IF port_x > 1130000 THEN
        port_x := 1130000;
    END_IF;

    IF h_phase = 0 THEN
        D2004 := 0;
        IF ABS(D1004) <= 4000 THEN
            D2000 := port_x;
        ELSE
            D2000 := D1000;
        END_IF;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1000 - port_x) <= 20) AND (ABS(D1001) <= 100) AND port_ready THEN
            h_phase := 1;
        END_IF;
    ELSIF h_phase = 1 THEN
        D2000 := port_x;
        D2004 := 18000;
        IF (ABS(D1000 - port_x) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND port_ready THEN
            IF NOT h_sent THEN
                seq_counter := seq_counter + 1;
                h_sent := TRUE;
                h_retry := 0;
            END_IF;
            h_phase := 2;
        END_IF;
    ELSIF h_phase = 2 THEN
        D2000 := port_x;
        D2004 := 18000;
        D80 := DINT(h_action);
        D81 := DINT(h_station);
        IF (h_action = 1) THEN
            IF D90 = h_id THEN
                h_phase := 3;
            END_IF;
        ELSE
            IF (D90 <> h_id) AND ((port_id = h_id) OR (port_id = 0)) THEN
                h_phase := 3;
            END_IF;
        END_IF;
        IF h_phase = 2 THEN
            h_retry := h_retry + 1;
            IF h_retry > 50 THEN
                IF (ABS(D1000 - port_x) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND port_ready THEN
                    seq_counter := seq_counter + 1;
                END_IF;
                h_retry := 0;
            END_IF;
        END_IF;
    ELSE
        D2000 := port_x;
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            h_active := FALSE;
            h_done := TRUE;
            h_phase := 0;
            h_sent := FALSE;
            D80 := 0;
            D81 := 0;
        END_IF;
    END_IF;
END_IF;

D82 := seq_counter;

IF h_done THEN
    IF state = 11 THEN
        IF cur_cancel THEN
            state := 80;
        ELSE
            state := 30;
        END_IF;
    ELSIF state = 31 THEN
        IF cur_cancel THEN
            state := 50;
        ELSE
            state := 40;
        END_IF;
    ELSIF state = 51 THEN
        c3_latched := FALSE;
        IF cur_cancel THEN
            state := 80;
        ELSE
            state := 60;
        END_IF;
    ELSIF state = 61 THEN
        IF cur_cancel THEN
            state := 75;
        ELSE
            state := 70;
        END_IF;
    ELSIF state = 76 THEN
        c4_latched := FALSE;
        state := 80;
    ELSIF state = 81 THEN
        state := 90;
    END_IF;
END_IF;

IF state = 40 THEN
    c3_done := X70 AND X72 AND (ABS(D1016 - c3_goal0) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - c3_goal1) <= 20) AND (ABS(D1021) <= 100) AND ((D522 = cur_id) OR (D523 = cur_id)) AND (D524 = c3_epoch);
    IF cur_cancel THEN
        state := 50;
    ELSIF c3_done THEN
        state := 50;
    END_IF;
END_IF;

IF state = 70 THEN
    c4_done := X75 AND X77 AND ((D622 = cur_id) OR (D623 = cur_id)) AND (D624 = c4_epoch);
    IF cur_cancel THEN
        c4_sub := 3;
    ELSIF (c4_sub = 2) AND c4_done THEN
        c4_sub := 3;
    END_IF;
    IF c4_sub = 3 THEN
        IF (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
            Y76 := FALSE;
            state := 75;
        END_IF;
    END_IF;
END_IF;

IF state = 90 THEN
    IF cur_source = 1 THEN
        D2008 := 15000;
        IF (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) THEN
            IF cur_req = 1 THEN
                D300 := cur_id;
                IF cur_cancel THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                r0_acked := TRUE;
            ELSE
                D302 := cur_id;
                IF cur_cancel THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                r1_acked := TRUE;
            END_IF;
            state := 0;
            cur_id := 0;
            keep_m3_retain := FALSE;
        END_IF;
    ELSE
        D2012 := 15000;
        IF (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) THEN
            IF cur_req = 1 THEN
                D300 := cur_id;
                IF cur_cancel THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                r0_acked := TRUE;
            ELSE
                D302 := cur_id;
                IF cur_cancel THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                r1_acked := TRUE;
            END_IF;
            state := 0;
            cur_id := 0;
            keep_m3_retain := FALSE;
        END_IF;
    END_IF;
END_IF;

final_ready := X51 AND (state = 0) AND (NOT h_active) AND ((NOT r0_seen) OR r0_acked) AND ((NOT r1_seen) OR r1_acked) AND (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) AND (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);

Y2 := final_ready;
Y30 := final_ready;
END_PROGRAM