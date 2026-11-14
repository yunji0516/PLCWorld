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

    sh_cmd : INT := 0;
    sh_port : INT := 0;
    sh_id : DINT := 0;
    sh_step : INT := 0;
    sh_t_a : DINT := 0;
    sh_t_b : DINT := 0;
    
    req_id : ARRAY[0..1] OF DINT := [0, 0];
    req_state : ARRAY[0..1] OF INT := [0, 0];
    req_origin : ARRAY[0..1] OF DINT := [0, 0];
    req_due : ARRAY[0..1] OF DINT := [0, 0];
    
    c3_step : INT := 0;
    c3_t_s3_0 : DINT := 0;
    c3_t_s3_1 : DINT := 5000;
    c3_blocked : BOOL := FALSE;
    
    c4_step : INT := 0;
    c4_t_s4_0 : DINT := 0;
    c4_t_s4_1 : DINT := 0;
    c4_t_s4_2 : DINT := 0;
    c4_blocked : BOOL := FALSE;
    
    lift_target : DINT := 40000;
    need_docking : BOOL := FALSE;
    
    idx : INT;
    best_idx : INT;
    best_due : DINT;
    i : INT;
    port_x : DINT;
    port_ready : BOOL;
    
    action_found : BOOL;
    lift_at_home : BOOL;
    all_home : BOOL;
END_VAR

// Keep all axes enabled and set their speed rates
Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
Y30 := FALSE;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000;

// Read new requests and deadlines
IF D100 > 0 AND req_id[0] = 0 THEN
    req_id[0] := D100;
    req_state[0] := 1;
    req_origin[0] := D101;
END_IF;
IF D120 > 0 AND req_id[1] = 0 THEN
    req_id[1] := D120;
    req_state[1] := 1;
    req_origin[1] := D121;
END_IF;

IF req_id[0] > 0 THEN req_due[0] := D103; END_IF;
IF req_id[1] > 0 THEN req_due[1] := D123; END_IF;

// Handle cancellation flags
IF X31 AND req_id[0] > 0 THEN
    IF req_state[0] > 0 AND req_state[0] < 6 THEN req_state[0] := 7; END_IF;
    IF req_state[0] = 6 THEN req_state[0] := 8; END_IF;
END_IF;
IF X35 AND req_id[1] > 0 THEN
    IF req_state[1] > 0 AND req_state[1] < 6 THEN req_state[1] := 7; END_IF;
    IF req_state[1] = 6 THEN req_state[1] := 8; END_IF;
END_IF;

// Handle requests arriving at destination wait states
FOR i := 0 TO 1 DO
    IF req_state[i] = 5 THEN
        IF (req_origin[i] = 1 AND D404 = req_id[i]) OR (req_origin[i] = 2 AND D407 = req_id[i]) THEN
            IF NOT (sh_cmd = 1 AND sh_port = req_origin[i]) THEN req_state[i] := 6; END_IF;
        END_IF;
    END_IF;
    IF req_state[i] = 7 THEN
        IF (req_origin[i] = 1 AND D404 = req_id[i]) OR (req_origin[i] = 2 AND D407 = req_id[i]) THEN
            IF NOT (sh_cmd = 1 AND sh_port = req_origin[i]) THEN req_state[i] := 8; END_IF;
        END_IF;
    END_IF;
END_FOR;

// Shuttle Manager - Decide next action
IF sh_cmd = 0 THEN
    action_found := FALSE;
    
    // Priority 1: Deliver jig currently on shuttle
    IF D90 > 0 THEN
        idx := -1;
        IF req_id[0] = D90 THEN idx := 0; ELSIF req_id[1] = D90 THEN idx := 1; END_IF;
        IF idx >= 0 THEN
            IF req_state[idx] = 1 OR req_state[idx] = 2 THEN sh_port := 3;
            ELSIF req_state[idx] = 3 OR req_state[idx] = 4 THEN sh_port := 4;
            ELSIF req_state[idx] >= 5 THEN sh_port := DINT_TO_INT(req_origin[idx]);
            END_IF;
            sh_cmd := 2; sh_id := D90; sh_step := 1; action_found := TRUE;
        END_IF;
    END_IF;
    
    // Priority 2: Extract a jig ready to move forward
    IF NOT action_found AND D413 > 0 THEN
        idx := -1;
        IF req_id[0] = D413 THEN idx := 0; ELSIF req_id[1] = D413 THEN idx := 1; END_IF;
        IF idx >= 0 AND (req_state[idx] = 5 OR req_state[idx] = 7) AND c4_step = 0 THEN
            sh_port := 4; sh_cmd := 1; sh_id := D413; sh_step := 1; action_found := TRUE;
        END_IF;
    END_IF;
    
    IF NOT action_found AND D410 > 0 AND D413 = 0 THEN
        idx := -1;
        IF req_id[0] = D410 THEN idx := 0; ELSIF req_id[1] = D410 THEN idx := 1; END_IF;
        IF idx >= 0 AND (req_state[idx] = 3 OR req_state[idx] = 7) AND c3_step = 0 THEN
            sh_port := 3; sh_cmd := 1; sh_id := D410; sh_step := 1; action_found := TRUE;
        END_IF;
    END_IF;
    
    IF NOT action_found AND D410 = 0 THEN
        best_idx := -1;
        best_due := 2147483647;
        FOR i := 0 TO 1 DO
            IF req_state[i] = 1 THEN
                IF (req_origin[i] = 1 AND D404 = req_id[i]) OR (req_origin[i] = 2 AND D407 = req_id[i]) THEN
                    IF req_due[i] < best_due THEN
                        best_due := req_due[i];
                        best_idx := i;
                    END_IF;
                END_IF;
            END_IF;
        END_FOR;
        IF best_idx >= 0 THEN
            sh_port := DINT_TO_INT(req_origin[best_idx]); sh_cmd := 1; sh_id := req_id[best_idx]; sh_step := 1; action_found := TRUE;
        END_IF;
    END_IF;
    
    IF NOT action_found AND X51 THEN
        sh_t_a := 0;
    END_IF;
END_IF;

// Shuttle execution state machine
IF sh_cmd > 0 THEN
    CASE sh_port OF
        1: port_x := D403; port_ready := X61;
        2: port_x := D406; port_ready := X62;
        3: port_x := D409; port_ready := X63;
        4: port_x := D412; port_ready := X64;
    END_CASE;
    
    CASE sh_step OF
        1: 
           sh_t_b := 0;
           IF D1004 <= 4000 THEN
               sh_t_a := port_x;
           END_IF;
           IF ABS(D1000 - port_x) <= 20 AND ABS(D1001) <= 100 AND D1004 <= 20 THEN
               sh_step := 2;
           END_IF;
           
        2: 
           sh_t_a := port_x;
           sh_t_b := 0;
           IF port_ready THEN
               sh_step := 3;
           END_IF;
           
        3: 
           sh_t_a := port_x;
           sh_t_b := 18000;
           IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
               sh_step := 4;
           END_IF;
           
        4: 
           sh_t_a := port_x;
           sh_t_b := 18000;
           D81 := INT_TO_DINT(sh_port);
           IF sh_cmd = 1 THEN D80 := 1; ELSE D80 := 2; END_IF;
           D82 := D82 + 1;
           sh_step := 5;
           
        5: 
           sh_t_a := port_x;
           sh_t_b := 18000;
           IF sh_cmd = 1 THEN
               IF D90 = sh_id THEN sh_step := 6; END_IF;
           ELSE
               IF D90 = 0 THEN sh_step := 6; END_IF;
           END_IF;
           
        6: 
           sh_t_a := port_x;
           sh_t_b := 0;
           IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
               sh_cmd := 0;
               sh_step := 0;
           END_IF;
    END_CASE;
END_IF;

// Cell 3 (Rotation & Precision Approach) Control
c3_blocked := (sh_port = 3 AND D1004 > 4000 AND sh_cmd > 0);

IF D410 > 0 THEN
    D700 := D410; Y71 := TRUE;
    idx := -1;
    IF req_id[0] = D410 THEN idx := 0; ELSIF req_id[1] = D410 THEN idx := 1; END_IF;
    
    IF idx >= 0 AND NOT c3_blocked THEN
        IF req_state[idx] = 1 THEN
            req_state[idx] := 2;
        END_IF;
        
        IF req_state[idx] = 2 THEN
            CASE c3_step OF
                0: c3_step := 1;
                1: IF D1020 <= 50000 THEN c3_step := 2; END_IF;
                2: c3_t_s3_0 := D500;
                   IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 THEN c3_step := 3; END_IF;
                3: c3_t_s3_0 := D500; c3_t_s3_1 := 70000;
                   IF ABS(D1020 - 70000) <= 20 AND ABS(D1021) <= 100 THEN c3_step := 4; END_IF;
                4: c3_t_s3_0 := D500; c3_t_s3_1 := 70000;
                   IF X70 THEN c3_step := 5; END_IF;
                5: c3_t_s3_0 := D500; c3_t_s3_1 := 5000;
                   IF ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 THEN c3_step := 6; END_IF;
                6: c3_t_s3_0 := 0; c3_t_s3_1 := 5000;
                   IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN 
                       req_state[idx] := 3; c3_step := 0; 
                   END_IF;
            END_CASE;
        ELSIF req_state[idx] = 7 THEN
            CASE c3_step OF
                0..5: c3_step := 5;
            END_CASE;
        END_IF;
    END_IF;
ELSE
    D700 := 0; Y71 := FALSE; c3_step := 0; c3_t_s3_0 := 0; c3_t_s3_1 := 5000;
END_IF;

// Cell 4 (Index & Approach pin) Control
c4_blocked := (sh_port = 4 AND D1004 > 4000 AND sh_cmd > 0);

IF D413 > 0 THEN
    D710 := D413; Y76 := TRUE;
    idx := -1;
    IF req_id[0] = D413 THEN idx := 0; ELSIF req_id[1] = D413 THEN idx := 1; END_IF;
    
    IF idx >= 0 AND NOT c4_blocked THEN
        IF req_state[idx] = 3 THEN
            req_state[idx] := 4;
        END_IF;
        
        IF req_state[idx] = 4 THEN
            CASE c4_step OF
                0: c4_step := 1;
                1: IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN c4_step := 2; END_IF;
                2: c4_t_s4_0 := D600;
                   IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 THEN c4_step := 3; END_IF;
                3: c4_t_s4_0 := D600;
                   IF D620 = 0 THEN c4_t_s4_1 := 4000; ELSE c4_t_s4_2 := 4000; END_IF;
                   IF D620 = 0 AND ABS(D1028 - 4000) <= 20 AND ABS(D1029) <= 100 THEN c4_step := 4; END_IF;
                   IF D620 <> 0 AND ABS(D1032 - 4000) <= 20 AND ABS(D1033) <= 100 THEN c4_step := 4; END_IF;
                4: c4_t_s4_0 := D600;
                   IF D620 = 0 THEN c4_t_s4_1 := 4000; ELSE c4_t_s4_2 := 4000; END_IF;
                   IF X75 THEN c4_step := 5; END_IF;
                5: c4_t_s4_0 := D600; c4_t_s4_1 := 0; c4_t_s4_2 := 0;
                   IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN c4_step := 6; END_IF;
                6: c4_t_s4_0 := 0; c4_t_s4_1 := 0; c4_t_s4_2 := 0;
                   IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
                       req_state[idx] := 5; c4_step := 0;
                   END_IF;
            END_CASE;
        ELSIF req_state[idx] = 7 THEN
            CASE c4_step OF
                0..4: c4_step := 5;
            END_CASE;
        END_IF;
    END_IF;
ELSE
    D710 := 0; Y76 := FALSE; c4_step := 0; c4_t_s4_0 := 0; c4_t_s4_1 := 0; c4_t_s4_2 := 0;
END_IF;

// Lifts Target Determination
need_docking := FALSE;
IF sh_cmd > 0 AND (sh_port = 1 OR sh_port = 2) THEN need_docking := TRUE; END_IF;
FOR i := 0 TO 1 DO
    IF req_state[i] = 1 AND (req_origin[i] = 1 OR req_origin[i] = 2) THEN
        IF (req_origin[i] = 1 AND D404 = req_id[i]) OR (req_origin[i] = 2 AND D407 = req_id[i]) THEN need_docking := TRUE; END_IF;
    END_IF;
    IF (req_state[i] = 5 OR req_state[i] = 7) AND D90 = req_id[i] THEN need_docking := TRUE; END_IF;
END_FOR;

IF need_docking THEN lift_target := D92; ELSE lift_target := 40000; END_IF;

// Acknowledge Completed or Cancelled Requests
lift_at_home := ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100;

FOR i := 0 TO 1 DO
    IF req_state[i] = 6 AND lift_at_home THEN
        IF i = 0 THEN D300 := req_id[0]; D301 := 1; END_IF;
        IF i = 1 THEN D302 := req_id[1]; D303 := 1; END_IF;
        req_state[i] := 9;
    ELSIF req_state[i] = 8 AND lift_at_home THEN
        IF i = 0 THEN D300 := req_id[0]; D301 := 2; END_IF;
        IF i = 1 THEN D302 := req_id[1]; D303 := 2; END_IF;
        req_state[i] := 9;
    END_IF;
END_FOR;

// Clean up removed requests
IF D100 = 0 THEN req_id[0] := 0; req_state[0] := 0; D300 := 0; D301 := 0; END_IF;
IF D120 = 0 THEN req_id[1] := 0; req_state[1] := 0; D302 := 0; D303 := 0; END_IF;

// Drive Outputs Mapping
D2000 := sh_t_a; D2004 := sh_t_b;
D2008 := lift_target; D2012 := lift_target;
D2016 := c3_t_s3_0; D2020 := c3_t_s3_1;
D2024 := c4_t_s4_0; D2028 := c4_t_s4_1; D2032 := c4_t_s4_2;

// Check Completion conditions
all_home := X51 AND
    ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND
    ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND
    ABS(D1016) <= 20 AND ABS(D1020 - 5000) <= 20 AND
    ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND
    ABS(D1001) <= 100 AND ABS(D1005) <= 100 AND
    ABS(D1009) <= 100 AND ABS(D1013) <= 100 AND
    ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND
    ABS(D1025) <= 100 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100;

Y2 := all_home;

END_PROGRAM