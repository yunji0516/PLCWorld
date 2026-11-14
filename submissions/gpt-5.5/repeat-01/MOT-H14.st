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
    phase : DINT;
    active_req : DINT;
    active_id : DINT;
    source_station : DINT;
    conn_action : DINT;
    conn_station : DINT;
    conn_seq : DINT;
    conn_issued : BOOL;
    done0 : BOOL;
    done1 : BOOL;
    done_id0 : DINT;
    done_id1 : DINT;
    done_status0 : DINT;
    done_status1 : DINT;
    prev_id0 : DINT;
    prev_id1 : DINT;
    cancel_active : BOOL;
    stable_count : DINT;
    invalid_count : DINT;
    final_declared : BOOL;
    final_stable : DINT;
    sx : DINT;
    ready_ok : BOOL;
    lift_ok : BOOL;
    pos_ok : BOOL;
    s3_valid : BOOL;
    s4_valid : BOOL;
    premark : DINT;
    finalmark : DINT;
END_VAR

IF D100 <> prev_id0 THEN
    done0 := FALSE;
    done_id0 := 0;
    done_status0 := 0;
    IF active_req = 0 THEN
        state := 0;
        conn_issued := FALSE;
        conn_action := 0;
    END_IF;
END_IF;
IF D120 <> prev_id1 THEN
    done1 := FALSE;
    done_id1 := 0;
    done_status1 := 0;
    IF active_req = 1 THEN
        state := 0;
        conn_issued := FALSE;
        conn_action := 0;
    END_IF;
END_IF;
prev_id0 := D100;
prev_id1 := D120;

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

D2024 := -60000;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := -60000;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

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

IF done0 THEN
    D300 := done_id0;
    D301 := done_status0;
ELSE
    D300 := 0;
    D301 := 0;
END_IF;

IF done1 THEN
    D302 := done_id1;
    D303 := done_status1;
ELSE
    D302 := 0;
    D303 := 0;
END_IF;

IF state = 0 THEN
    conn_action := 0;
    conn_station := 0;
    conn_issued := FALSE;
    phase := 0;
    stable_count := 0;
    invalid_count := 0;
    IF (D100 <> 0) AND (NOT done0) THEN
        active_req := 0;
        active_id := D100;
        cancel_active := X31;
        IF D404 = D100 THEN
            source_station := 1;
        ELSIF D407 = D100 THEN
            source_station := 2;
        ELSIF D101 = 0 THEN
            source_station := 1;
        ELSE
            source_station := 2;
        END_IF;
        state := 10;
    ELSIF (D120 <> 0) AND (NOT done1) THEN
        active_req := 1;
        active_id := D120;
        cancel_active := X35;
        IF D404 = D120 THEN
            source_station := 1;
        ELSIF D407 = D120 THEN
            source_station := 2;
        ELSIF D121 = 0 THEN
            source_station := 1;
        ELSE
            source_station := 2;
        END_IF;
        state := 10;
    ELSIF X51 THEN
        state := 200;
    END_IF;
END_IF;

IF state = 10 THEN
    D2004 := 0;
    IF source_station = 1 THEN
        sx := D403;
        D2008 := D92;
        ready_ok := X61;
        lift_ok := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        sx := D406;
        D2012 := D92;
        ready_ok := X62;
        lift_ok := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := sx;
    pos_ok := (ABS(D1000 - sx) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    IF D90 = active_id THEN
        conn_action := 0;
        conn_station := 0;
        conn_issued := FALSE;
        phase := 0;
        IF cancel_active THEN
            state := 100;
        ELSE
            state := 30;
        END_IF;
    ELSIF ready_ok AND lift_ok AND pos_ok THEN
        IF NOT conn_issued THEN
            conn_seq := conn_seq + 1;
            IF conn_seq <= 0 THEN
                conn_seq := 1;
            END_IF;
            conn_action := 1;
            conn_station := source_station;
            conn_issued := TRUE;
        END_IF;
    END_IF;
END_IF;

IF state = 30 THEN
    D2000 := D409;
    D2004 := 18000;
    pos_ok := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    ready_ok := X63 AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100);
    IF (D90 = 0) AND ((D410 = active_id) OR (conn_issued)) THEN
        conn_action := 0;
        conn_station := 0;
        conn_issued := FALSE;
        phase := 0;
        stable_count := 0;
        state := 50;
    ELSIF (D90 = active_id) AND ready_ok AND pos_ok THEN
        IF NOT conn_issued THEN
            conn_seq := conn_seq + 1;
            IF conn_seq <= 0 THEN
                conn_seq := 1;
            END_IF;
            conn_action := 2;
            conn_station := 3;
            conn_issued := TRUE;
        END_IF;
    END_IF;
END_IF;

IF state = 50 THEN
    D700 := active_id;
    D701 := D526;
    D702 := 1000;
    IF phase = 0 THEN
        D2016 := -60000;
        D2020 := -60000;
        IF (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
            phase := 1;
        END_IF;
    ELSIF phase = 1 THEN
        D2016 := -60000;
        D2020 := -60000;
        IF (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
            Y70 := TRUE;
            phase := 2;
        END_IF;
    ELSIF phase = 2 THEN
        D2016 := D500;
        D2020 := D501;
        s3_valid := X70 AND ((D522 = active_id) OR (D522 = 0)) AND ((D524 = D91) OR (D524 = 0));
        IF s3_valid AND (ABS(D1016 - D500) <= 20) AND (ABS(D1020 - D501) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
            stable_count := stable_count + 1;
        ELSE
            stable_count := 0;
        END_IF;
        IF stable_count >= 4 THEN
            phase := 3;
            stable_count := 0;
        END_IF;
    ELSIF phase = 3 THEN
        Y71 := TRUE;
        D2016 := -60000;
        D2020 := -60000;
        IF (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) THEN
            phase := 0;
            state := 60;
        END_IF;
    END_IF;
END_IF;

IF state = 60 THEN
    D2000 := D409;
    D2004 := 0;
    D2016 := -60000;
    D2020 := -60000;
    pos_ok := (ABS(D1000 - D409) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    ready_ok := X63 AND (ABS(D1016 + 60000) <= 20) AND (ABS(D1020 + 60000) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1021) <= 100);
    IF D90 = active_id THEN
        conn_action := 0;
        conn_station := 0;
        conn_issued := FALSE;
        phase := 0;
        state := 70;
    ELSIF ready_ok AND pos_ok THEN
        IF NOT conn_issued THEN
            conn_seq := conn_seq + 1;
            IF conn_seq <= 0 THEN
                conn_seq := 1;
            END_IF;
            conn_action := 1;
            conn_station := 3;
            conn_issued := TRUE;
        END_IF;
    END_IF;
END_IF;

IF state = 70 THEN
    D2000 := D412;
    D2004 := 18000;
    D2024 := -60000;
    D2028 := -60000;
    pos_ok := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    ready_ok := X64 AND (ABS(D1024 + 60000) <= 20) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100);
    IF (D90 = 0) AND ((D413 = active_id) OR (conn_issued)) THEN
        conn_action := 0;
        conn_station := 0;
        conn_issued := FALSE;
        phase := 0;
        stable_count := 0;
        invalid_count := 0;
        state := 80;
    ELSIF (D90 = active_id) AND ready_ok AND pos_ok THEN
        IF NOT conn_issued THEN
            conn_seq := conn_seq + 1;
            IF conn_seq <= 0 THEN
                conn_seq := 1;
            END_IF;
            conn_action := 2;
            conn_station := 4;
            conn_issued := TRUE;
        END_IF;
    END_IF;
END_IF;

IF state = 80 THEN
    D711 := D626;
    D712 := 1000;
    premark := D600 - 10000;
    finalmark := D600 + 25000;
    IF premark < -95000 THEN
        premark := -95000;
    END_IF;
    IF finalmark > 95000 THEN
        finalmark := 95000;
    END_IF;

    IF phase = 0 THEN
        D710 := active_id;
        D2024 := -60000;
        D2028 := -60000;
        IF (ABS(D1024 + 60000) <= 20) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) THEN
            phase := 1;
        END_IF;
    ELSIF phase = 1 THEN
        D710 := active_id;
        D2024 := premark;
        D2028 := D601;
        IF (ABS(D1024 - premark) <= 20) AND (ABS(D1028 - D601) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) THEN
            phase := 2;
            stable_count := 0;
            invalid_count := 0;
        END_IF;
    ELSIF phase = 2 THEN
        D710 := active_id;
        D2024 := finalmark;
        D2028 := D601;
        s4_valid := X75 AND (D622 = active_id) AND (D624 = D91);
        IF s4_valid AND (ABS(D1024 - finalmark) <= 20) AND (ABS(D1028 - D601) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) THEN
            stable_count := stable_count + 1;
            invalid_count := 0;
        ELSE
            stable_count := 0;
            IF (ABS(D1024 - finalmark) <= 20) AND (ABS(D1025) <= 100) THEN
                invalid_count := invalid_count + 1;
            END_IF;
        END_IF;
        IF stable_count >= 4 THEN
            phase := 3;
            stable_count := 0;
        ELSIF invalid_count >= 10 THEN
            phase := 1;
            invalid_count := 0;
        END_IF;
    ELSIF phase = 3 THEN
        Y76 := TRUE;
        D710 := active_id;
        D2024 := -60000;
        D2028 := -60000;
        IF (ABS(D1024 + 60000) <= 20) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) THEN
            phase := 0;
            state := 90;
        END_IF;
    END_IF;
END_IF;

IF state = 90 THEN
    D2000 := D412;
    D2004 := 0;
    D2024 := -60000;
    D2028 := -60000;
    pos_ok := (ABS(D1000 - D412) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
    ready_ok := X64 AND (ABS(D1024 + 60000) <= 20) AND (ABS(D1028 + 60000) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100);
    IF D90 = active_id THEN
        conn_action := 0;
        conn_station := 0;
        conn_issued := FALSE;
        phase := 0;
        state := 100;
    ELSIF ready_ok AND pos_ok THEN
        IF NOT conn_issued THEN
            conn_seq := conn_seq + 1;
            IF conn_seq <= 0 THEN
                conn_seq := 1;
            END_IF;
            conn_action := 1;
            conn_station := 4;
            conn_issued := TRUE;
        END_IF;
    END_IF;
END_IF;

IF state = 100 THEN
    D2004 := 18000;
    IF source_station = 1 THEN
        sx := D403;
        D2008 := D92;
        ready_ok := X61;
        lift_ok := (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        sx := D406;
        D2012 := D92;
        ready_ok := X62;
        lift_ok := (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    D2000 := sx;
    pos_ok := (ABS(D1000 - sx) <= 20) AND (ABS(D1001) <= 100) AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100);
    IF (D90 = 0) AND conn_issued THEN
        conn_action := 0;
        conn_station := 0;
        conn_issued := FALSE;
        state := 110;
    ELSIF (D90 = active_id) AND ready_ok AND lift_ok AND pos_ok THEN
        IF NOT conn_issued THEN
            conn_seq := conn_seq + 1;
            IF conn_seq <= 0 THEN
                conn_seq := 1;
            END_IF;
            conn_action := 2;
            conn_station := source_station;
            conn_issued := TRUE;
        END_IF;
    END_IF;
END_IF;

IF state = 110 THEN
    D2004 := 0;
    IF source_station = 1 THEN
        D2000 := D403;
        D2008 := 15000;
        lift_ok := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
    ELSE
        D2000 := D406;
        D2012 := 15000;
        lift_ok := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    IF lift_ok AND (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
        IF active_req = 0 THEN
            done0 := TRUE;
            done_id0 := active_id;
            IF cancel_active THEN
                done_status0 := 2;
            ELSE
                done_status0 := 1;
            END_IF;
        ELSE
            done1 := TRUE;
            done_id1 := active_id;
            IF cancel_active THEN
                done_status1 := 2;
            ELSE
                done_status1 := 1;
            END_IF;
        END_IF;
        state := 0;
    END_IF;
END_IF;

IF state = 200 THEN
    conn_action := 0;
    conn_station := 0;
    conn_issued := FALSE;
    D2000 := 0;
    D2004 := 0;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -60000;
    D2020 := -60000;
    D2024 := -60000;
    D2028 := -60000;
    Y30 := TRUE;
    IF X51 AND
       (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
       (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
       (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
       (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
       (ABS(D1016 + 60000) <= 20) AND (ABS(D1017) <= 100) AND
       (ABS(D1020 + 60000) <= 20) AND (ABS(D1021) <= 100) AND
       (ABS(D1024 + 60000) <= 20) AND (ABS(D1025) <= 100) AND
       (ABS(D1028 + 60000) <= 20) AND (ABS(D1029) <= 100) THEN
        final_stable := final_stable + 1;
    ELSE
        IF NOT final_declared THEN
            final_stable := 0;
        END_IF;
    END_IF;
    IF final_stable >= 5 THEN
        final_declared := TRUE;
    END_IF;
END_IF;

D80 := conn_action;
D81 := conn_station;
D82 := conn_seq;

IF done0 THEN
    D300 := done_id0;
    D301 := done_status0;
END_IF;
IF done1 THEN
    D302 := done_id1;
    D303 := done_status1;
END_IF;

Y2 := final_declared;

END_PROGRAM