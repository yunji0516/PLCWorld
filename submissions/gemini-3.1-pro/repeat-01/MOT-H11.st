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

    init_done : BOOL;
    req_id : ARRAY[0..1] OF DINT;
    state : ARRAY[0..1] OF INT;
    req_port : ARRAY[0..1] OF DINT;
    loc : ARRAY[0..1] OF DINT;
    cancelled : ARRAY[0..1] OF BOOL;
    req_due : ARRAY[0..1] OF DINT;
    
    shuttle_task_type : INT;
    shuttle_step : INT;
    shuttle_target_port : DINT;
    shuttle_req_idx : INT;
    seq_num : DINT;
    
    a_target_internal : DINT;
    b_target_internal : DINT;
    lift_target_internal : DINT;
    s3_0_target_internal : DINT;
    s3_1_target_internal : DINT;
    s4_0_target_internal : DINT;
    s4_1_target_internal : DINT;
    s4_2_target_internal : DINT;
    
    a_target_last : DINT;
    c_target_last : DINT;
    d_target_last : DINT;
    s3_0_target_last : DINT;
    s3_1_target_last : DINT;
    s4_0_target_last : DINT;
    s4_1_target_last : DINT;
    s4_2_target_last : DINT;
    
    c3_state : INT;
    c3_req : INT;
    c4_state : INT;
    c4_req : INT;
    
    port_x : DINT;
    port_ready : BOOL;
    held_i : INT;
    i : INT;
    best_i : INT;
    best_priority : INT;
    best_fetch_port : DINT;
    fetch_port : DINT;
    dest : DINT;
    priority : INT;
    dest_empty : BOOL;
END_VAR

IF NOT init_done THEN
    init_done := TRUE;
    a_target_internal := 0;
    b_target_internal := 0;
    lift_target_internal := 40000;
    s3_0_target_internal := 0;
    s3_1_target_internal := 5000;
    s4_0_target_internal := 0;
    s4_1_target_internal := 0;
    s4_2_target_internal := 0;
    
    a_target_last := 0;
    c_target_last := 40000;
    d_target_last := 40000;
    s3_0_target_last := 0;
    s3_1_target_last := 5000;
    s4_0_target_last := 0;
    s4_1_target_last := 0;
    s4_2_target_last := 0;
END_IF

IF D100 > 0 AND req_id[0] <> D100 THEN
    req_id[0] := D100;
    state[0] := 1;
    req_port[0] := D101;
    loc[0] := D101;
    cancelled[0] := FALSE;
    req_due[0] := D103;
END_IF
IF D120 > 0 AND req_id[1] <> D120 THEN
    req_id[1] := D120;
    state[1] := 1;
    req_port[1] := D121;
    loc[1] := D121;
    cancelled[1] := FALSE;
    req_due[1] := D123;
END_IF

IF X31 AND req_id[0] > 0 THEN cancelled[0] := TRUE; END_IF
IF X35 AND req_id[1] > 0 THEN cancelled[1] := TRUE; END_IF

FOR i := 0 TO 1 DO
    IF req_id[i] > 0 AND cancelled[i] AND state[i] = 1 THEN
        state[i] := 9;
    END_IF
END_FOR

IF shuttle_task_type = 0 THEN
    IF D90 > 0 THEN
        held_i := -1;
        IF req_id[0] = D90 THEN held_i := 0; END_IF
        IF req_id[1] = D90 THEN held_i := 1; END_IF

        IF held_i >= 0 THEN
            IF cancelled[held_i] THEN
                dest := req_port[held_i];
            ELSIF state[held_i] = 2 THEN
                dest := 3;
            ELSIF state[held_i] = 5 THEN
                dest := 4;
            ELSIF state[held_i] = 8 THEN
                dest := req_port[held_i];
            ELSE
                dest := req_port[held_i];
            END_IF
            
            shuttle_task_type := 2;
            shuttle_target_port := dest;
            shuttle_req_idx := held_i;
        END_IF
    ELSE
        best_i := -1;
        best_priority := -1;
        best_fetch_port := 0;
        
        FOR i := 0 TO 1 DO
            IF req_id[i] > 0 THEN
                fetch_port := 0;
                dest := 0;
                priority := 0;
                
                IF state[i] = 1 THEN
                    fetch_port := req_port[i];
                    dest := 3;
                    priority := 10;
                ELSIF state[i] = 4 THEN
                    fetch_port := 3;
                    IF cancelled[i] THEN dest := req_port[i]; ELSE dest := 4; END_IF
                    priority := 20;
                ELSIF state[i] = 7 THEN
                    fetch_port := 4;
                    dest := req_port[i];
                    priority := 30;
                END_IF
                
                IF fetch_port > 0 THEN
                    dest_empty := TRUE;
                    IF (req_id[0] > 0 AND loc[0] = dest) OR (req_id[1] > 0 AND loc[1] = dest) THEN
                        dest_empty := FALSE;
                    END_IF
                    
                    IF dest_empty THEN
                        IF priority > best_priority OR (priority = best_priority AND req_due[i] < req_due[best_i]) THEN
                            best_priority := priority;
                            best_i := i;
                            best_fetch_port := fetch_port;
                        END_IF
                    END_IF
                END_IF
            END_IF
        END_FOR
        
        IF best_i >= 0 THEN
            shuttle_task_type := 1;
            shuttle_target_port := best_fetch_port;
            shuttle_req_idx := best_i;
        END_IF
    END_IF
END_IF

IF shuttle_task_type > 0 THEN
    IF shuttle_target_port = 1 THEN port_x := D403; port_ready := X61;
    ELSIF shuttle_target_port = 2 THEN port_x := D406; port_ready := X62;
    ELSIF shuttle_target_port = 3 THEN port_x := D409; port_ready := X63;
    ELSIF shuttle_target_port = 4 THEN port_x := D412; port_ready := X64;
    END_IF

    CASE shuttle_step OF
        0:
            a_target_internal := port_x;
            IF ABS(D1000 - port_x) <= 20 AND ABS(D1001) <= 100 AND port_ready THEN
                shuttle_step := 1;
            END_IF
        1:
            b_target_internal := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                IF shuttle_task_type = 1 THEN D80 := 1; ELSE D80 := 2; END_IF
                D81 := shuttle_target_port;
                seq_num := seq_num + 1;
                D82 := seq_num;
                IF shuttle_task_type = 1 THEN shuttle_step := 2; ELSE shuttle_step := 3; END_IF
            END_IF
        2:
            IF D90 > 0 THEN
                loc[shuttle_req_idx] := 0;
                IF state[shuttle_req_idx] = 1 THEN state[shuttle_req_idx] := 2;
                ELSIF state[shuttle_req_idx] = 4 THEN state[shuttle_req_idx] := 5;
                ELSIF state[shuttle_req_idx] = 7 THEN state[shuttle_req_idx] := 8;
                END_IF
                seq_num := seq_num + 1;
                shuttle_step := 4;
            END_IF
        3:
            IF D90 = 0 THEN
                loc[shuttle_req_idx] := shuttle_target_port;
                IF shuttle_target_port = 3 THEN state[shuttle_req_idx] := 3;
                ELSIF shuttle_target_port = 4 THEN state[shuttle_req_idx] := 6;
                ELSIF shuttle_target_port = req_port[shuttle_req_idx] THEN state[shuttle_req_idx] := 9;
                END_IF
                seq_num := seq_num + 1;
                shuttle_step := 4;
            END_IF
        4:
            b_target_internal := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                shuttle_task_type := 0;
                shuttle_step := 0;
            END_IF
    END_CASE
ELSE
    IF ABS(D1004) <= 20 THEN
        a_target_internal := 0;
    END_IF
    b_target_internal := 0;
END_IF

lift_target_internal := 40000;
IF (shuttle_task_type > 0 AND (shuttle_target_port = 1 OR shuttle_target_port = 2)) OR 
   (req_id[0] > 0 AND state[0] = 1) OR 
   (req_id[1] > 0 AND state[1] = 1) THEN
    lift_target_internal := D92;
END_IF

c3_req := -1;
IF req_id[0] > 0 AND loc[0] = 3 THEN c3_req := 0; END_IF
IF req_id[1] > 0 AND loc[1] = 3 THEN c3_req := 1; END_IF

IF c3_req >= 0 THEN
    IF state[c3_req] = 3 THEN
        IF cancelled[c3_req] AND c3_state < 3 THEN
            c3_state := 3;
        END_IF
        
        CASE c3_state OF
            0:
                s3_0_target_internal := D500;
                IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 THEN
                    c3_state := 1;
                END_IF
            1:
                s3_1_target_internal := 70000;
                IF ABS(D1020 - 70000) <= 20 AND ABS(D1021) <= 100 THEN
                    c3_state := 2;
                END_IF
            2:
                IF X70 OR cancelled[c3_req] THEN
                    c3_state := 3;
                END_IF
            3:
                s3_1_target_internal := 5000;
                IF ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 THEN
                    c3_state := 4;
                END_IF
            4:
                s3_0_target_internal := 0;
                IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
                    state[c3_req] := 4;
                    c3_state := 0;
                END_IF
        END_CASE
    END_IF
ELSE
    c3_state := 0;
    s3_0_target_internal := 0;
    s3_1_target_internal := 5000;
END_IF

c4_req := -1;
IF req_id[0] > 0 AND loc[0] = 4 THEN c4_req := 0; END_IF
IF req_id[1] > 0 AND loc[1] = 4 THEN c4_req := 1; END_IF

IF c4_req >= 0 THEN
    IF state[c4_req] = 6 THEN
        IF cancelled[c4_req] AND c4_state < 3 THEN
            c4_state := 3;
        END_IF
        
        CASE c4_state OF
            0:
                s4_0_target_internal := D600;
                IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 THEN
                    c4_state := 1;
                END_IF
            1:
                s4_1_target_internal := D601;
                s4_2_target_internal := D602;
                IF ABS(D1028 - D601) <= 20 AND ABS(D1032 - D602) <= 20 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
                    c4_state := 2;
                END_IF
            2:
                IF X75 OR cancelled[c4_req] THEN
                    c4_state := 3;
                END_IF
            3:
                s4_1_target_internal := 0;
                s4_2_target_internal := 0;
                IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
                    c4_state := 4;
                END_IF
            4:
                s4_0_target_internal := 0;
                IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
                    state[c4_req] := 7;
                    c4_state := 0;
                END_IF
        END_CASE
    END_IF
ELSE
    c4_state := 0;
    s4_0_target_internal := 0;
    s4_1_target_internal := 0;
    s4_2_target_internal := 0;
END_IF

IF state[0] = 9 THEN
    IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND lift_target_internal = 40000 THEN
        state[0] := 10;
    END_IF
END_IF
IF state[0] = 10 THEN
    D300 := req_id[0];
    IF cancelled[0] THEN D301 := 2; ELSE D301 := 1; END_IF
    IF X30 THEN
        state[0] := 11;
        req_id[0] := 0;
        loc[0] := 0;
        D300 := 0;
        D301 := 0;
    END_IF
ELSE
    D300 := 0;
    D301 := 0;
END_IF

IF state[1] = 9 THEN
    IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND lift_target_internal = 40000 THEN
        state[1] := 10;
    END_IF
END_IF
IF state[1] = 10 THEN
    D302 := req_id[1];
    IF cancelled[1] THEN D303 := 2; ELSE D303 := 1; END_IF
    IF X34 THEN
        state[1] := 11;
        req_id[1] := 0;
        loc[1] := 0;
        D302 := 0;
        D303 := 0;
    END_IF
ELSE
    D302 := 0;
    D303 := 0;
END_IF

IF X51 AND ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND 
   ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND 
   ABS(D1016) <= 20 AND ABS(D1020 - 5000) <= 20 AND 
   ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
    Y30 := TRUE;
    IF X52 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
ELSE
    Y30 := FALSE;
    Y2 := FALSE;
END_IF

IF D1004 > 4000 THEN
    D2000 := a_target_last;
    D2008 := c_target_last;
    D2012 := d_target_last;
    D2016 := s3_0_target_last;
    D2020 := s3_1_target_last;
    D2024 := s4_0_target_last;
    D2028 := s4_1_target_last;
    D2032 := s4_2_target_last;
ELSE
    D2000 := a_target_internal;
    D2008 := lift_target_internal;
    D2012 := lift_target_internal;
    D2016 := s3_0_target_internal;
    D2020 := s3_1_target_internal;
    D2024 := s4_0_target_internal;
    D2028 := s4_1_target_internal;
    D2032 := s4_2_target_internal;
    
    a_target_last := D2000;
    c_target_last := D2008;
    d_target_last := D2012;
    s3_0_target_last := D2016;
    s3_1_target_last := D2020;
    s4_0_target_last := D2024;
    s4_1_target_last := D2028;
    s4_2_target_last := D2032;
END_IF

D2004 := b_target_internal;

D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2009 := 1000; D2010 := 0; Y42 := TRUE;
D2013 := 1000; D2014 := 0; Y43 := TRUE;
D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2025 := 1000; D2026 := 0; Y46 := TRUE;
D2029 := 1000; D2030 := 0; Y47 := TRUE;
D2033 := 1000; D2034 := 0; Y48 := TRUE;

END_PROGRAM