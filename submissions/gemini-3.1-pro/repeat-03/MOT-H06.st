PROGRAM Main
VAR
    i : DINT;
    req_id : ARRAY[0..1] OF DINT;
    req_lift : ARRAY[0..1] OF DINT;
    req_step : ARRAY[0..1] OF DINT;
    req_cancelled : ARRAY[0..1] OF BOOL;
    
    shuttle_state : DINT;
    target_req : DINT;
    target_action : DINT;
    target_station : DINT;
    target_a : DINT;
    best_req : DINT;
    best_prio : DINT;
    lift_ready : BOOL;
    station_ready : BOOL;
    handoff_done : BOOL;
    is_shuttle_handling : BOOL;
    
    c3_state : DINT;
    req_in_c3 : DINT;
    c3_target_angle : DINT;
    c3_target_slide : DINT;
    
    c4_state : DINT;
    req_in_c4 : DINT;
    c4_target0 : DINT;
    c4_target1 : DINT;
    c4_target2 : DINT;
    c4_target3 : DINT;
    
    a_target_val : DINT;
    b_target_val : DINT;
    lift_target : ARRAY[0..1] OF DINT := [15000, 15000];
    c3_s0_target : DINT;
    c3_s1_target : DINT := 5000;
    c4_s0_target : DINT := -6500;
    c4_s1_target : DINT;
    c4_s2_target : DINT := 6500;
    c4_s3_target : DINT;
    
    couple_seq_int : DINT;
    
    lowering : BOOL;
    raising : BOOL;
    lift_idx : DINT;
    
    all_idle : BOOL;
    at_home : BOOL;
    is_cancelled : BOOL;
END_VAR

// Enable axes and set maximum drive ratios
Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE; Y44 := TRUE;
Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE; Y49 := TRUE;
Y30 := FALSE; // Common brake open

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000; D2017 := 1000;
D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000; D2037 := 1000;

// Request tracking
IF D100 <> 0 AND D100 <> req_id[0] AND req_step[0] = 0 THEN
    req_id[0] := D100;
    IF D101 = 0 THEN req_lift[0] := 1; ELSE req_lift[0] := 2; END_IF;
    req_step[0] := 1;
    req_cancelled[0] := FALSE;
END_IF;

IF D120 <> 0 AND D120 <> req_id[1] AND req_step[1] = 0 THEN
    req_id[1] := D120;
    IF D121 = 0 THEN req_lift[1] := 1; ELSE req_lift[1] := 2; END_IF;
    req_step[1] := 1;
    req_cancelled[1] := FALSE;
END_IF;

// Cancellation Monitor
FOR i := 0 TO 1 DO
    is_cancelled := ((i = 0) AND X31) OR ((i = 1) AND X35);
    IF is_cancelled AND NOT req_cancelled[i] THEN
        req_cancelled[i] := TRUE;
    END_IF;

    is_shuttle_handling := (shuttle_state > 0) AND (target_req = i);
    
    IF req_cancelled[i] AND NOT is_shuttle_handling THEN
        CASE req_step[i] OF
            1: req_step[i] := 9;
            2: req_step[i] := 8;
            3: req_step[i] := 4;
            5: req_step[i] := 8;
            6: req_step[i] := 7;
        END_CASE;
    END_IF;
END_FOR;

// Lift Target logic
FOR lift_idx := 0 TO 1 DO
    lowering := FALSE;
    FOR i := 0 TO 1 DO
        IF (req_lift[i] - 1 = lift_idx) AND (req_step[i] = 9) THEN
            lowering := TRUE;
        END_IF;
    END_FOR;
    
    IF lowering THEN
        lift_target[lift_idx] := 15000;
    ELSE
        raising := FALSE;
        FOR i := 0 TO 1 DO
            IF (req_lift[i] - 1 = lift_idx) AND (req_step[i] = 1 OR req_step[i] = 8) THEN
                raising := TRUE;
            END_IF;
        END_FOR;
        IF raising THEN
            lift_target[lift_idx] := 73250;
        ELSE
            lift_target[lift_idx] := 15000;
        END_IF;
    END_IF;
END_FOR;

// Lift Completion (Step 9 -> 10)
FOR i := 0 TO 1 DO
    IF req_step[i] = 9 THEN
        lift_idx := req_lift[i] - 1;
        IF (lift_idx = 0 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
           (lift_idx = 1 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
            req_step[i] := 10;
        END_IF;
    END_IF;
END_FOR;

// Cell 3 Logic
req_in_c3 := -1;
FOR i := 0 TO 1 DO
    IF req_step[i] = 3 OR req_step[i] = 4 THEN
        req_in_c3 := i;
    END_IF;
END_FOR;

CASE c3_state OF
    0:
        c3_s0_target := 0;
        c3_s1_target := 5000;
        IF req_in_c3 >= 0 THEN
            IF req_step[req_in_c3] = 3 THEN
                c3_state := 1;
            END_IF;
        END_IF;
    1:
        IF D410 = req_id[req_in_c3] THEN
            c3_target_angle := D500;
            c3_target_slide := D501;
            c3_state := 2;
        END_IF;
        IF req_in_c3 >= 0 AND_THEN req_step[req_in_c3] = 4 THEN
            c3_state := 6;
        END_IF;
    2:
        c3_s0_target := c3_target_angle;
        IF ABS(D1016 - c3_s0_target) <= 20 AND ABS(D1017) <= 100 THEN
            c3_state := 3;
        END_IF;
        IF req_in_c3 >= 0 AND_THEN req_cancelled[req_in_c3] THEN c3_state := 5; END_IF;
    3:
        c3_s1_target := c3_target_slide;
        IF ABS(D1020 - c3_s1_target) <= 20 AND ABS(D1021) <= 100 THEN
            c3_state := 4;
        END_IF;
        IF req_in_c3 >= 0 AND_THEN req_cancelled[req_in_c3] THEN c3_state := 5; END_IF;
    4:
        IF X70 THEN
            c3_state := 5;
        END_IF;
        IF req_in_c3 >= 0 AND_THEN req_cancelled[req_in_c3] THEN c3_state := 5; END_IF;
    5:
        c3_s1_target := 5000;
        IF ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 THEN
            c3_state := 6;
        END_IF;
    6:
        c3_s0_target := 0;
        IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
            c3_state := 7;
            IF req_in_c3 >= 0 THEN
                req_step[req_in_c3] := 4;
            END_IF;
        END_IF;
    7:
        IF D410 = 0 THEN
            c3_state := 0;
        END_IF;
END_CASE;

// Cell 4 Logic
req_in_c4 := -1;
FOR i := 0 TO 1 DO
    IF req_step[i] = 6 OR req_step[i] = 7 THEN
        req_in_c4 := i;
    END_IF;
END_FOR;

CASE c4_state OF
    0:
        c4_s0_target := -6500;
        c4_s1_target := 0;
        c4_s2_target := 6500;
        c4_s3_target := 0;
        IF req_in_c4 >= 0 THEN
            IF req_step[req_in_c4] = 6 THEN
                c4_state := 1;
            END_IF;
        END_IF;
    1:
        IF D413 = req_id[req_in_c4] THEN
            c4_target0 := D600;
            c4_target1 := D601;
            c4_target2 := D602;
            c4_target3 := D603;
            c4_state := 2;
        END_IF;
        IF req_in_c4 >= 0 AND_THEN req_step[req_in_c4] = 7 THEN c4_state := 6; END_IF;
    2:
        c4_s1_target := 0;
        c4_s3_target := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1036) <= 20 AND ABS(D1037) <= 100 THEN
            c4_state := 3;
        END_IF;
        IF req_in_c4 >= 0 AND_THEN req_cancelled[req_in_c4] THEN c4_state := 6; END_IF;
    3:
        c4_s0_target := c4_target0;
        c4_s2_target := c4_target2;
        IF ABS(D1024 - c4_s0_target) <= 20 AND ABS(D1025) <= 100 AND 
           ABS(D1032 - c4_s2_target) <= 20 AND ABS(D1033) <= 100 THEN
            c4_state := 4;
        END_IF;
        IF req_in_c4 >= 0 AND_THEN req_cancelled[req_in_c4] THEN c4_state := 6; END_IF;
    4:
        c4_s1_target := c4_target1;
        c4_s3_target := c4_target3;
        IF ABS(D1028 - c4_s1_target) <= 20 AND ABS(D1029) <= 100 AND 
           ABS(D1036 - c4_s3_target) <= 20 AND ABS(D1037) <= 100 THEN
            c4_state := 5;
        END_IF;
        IF req_in_c4 >= 0 AND_THEN req_cancelled[req_in_c4] THEN c4_state := 6; END_IF;
    5:
        IF X75 THEN
            c4_state := 6;
        END_IF;
        IF req_in_c4 >= 0 AND_THEN req_cancelled[req_in_c4] THEN c4_state := 6; END_IF;
    6:
        c4_s1_target := 0;
        c4_s3_target := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1036) <= 20 AND ABS(D1037) <= 100 THEN
            c4_state := 7;
        END_IF;
    7:
        c4_s0_target := -6500;
        c4_s2_target := 6500;
        IF ABS(D1024 - (-6500)) <= 20 AND ABS(D1025) <= 100 AND 
           ABS(D1032 - 6500) <= 20 AND ABS(D1033) <= 100 THEN
            c4_state := 8;
            IF req_in_c4 >= 0 THEN
                req_step[req_in_c4] := 7;
            END_IF;
        END_IF;
    8:
        IF D413 = 0 THEN
            c4_state := 0;
        END_IF;
END_CASE;

// Shuttle Logic
CASE shuttle_state OF
    0:
        IF D90 <> 0 THEN
            target_req := -1;
            FOR i := 0 TO 1 DO
                IF req_id[i] = D90 THEN target_req := i; END_IF;
            END_FOR;
            
            IF target_req >= 0 THEN
                target_action := 2;
                IF req_step[target_req] = 2 THEN target_station := 3; target_a := 0; END_IF;
                IF req_step[target_req] = 5 THEN target_station := 4; target_a := 670000; END_IF;
                IF req_step[target_req] = 8 THEN 
                    target_station := req_lift[target_req]; 
                    IF target_station = 1 THEN target_a := -360000; ELSE target_a := -230000; END_IF;
                END_IF;
                IF target_station > 0 THEN shuttle_state := 1; END_IF;
            END_IF;
        ELSE
            best_req := -1;
            best_prio := 0;
            FOR i := 0 TO 1 DO
                IF req_step[i] = 7 AND c4_state = 8 THEN
                    IF 3 > best_prio THEN best_prio := 3; best_req := i; END_IF;
                ELSIF req_step[i] = 4 AND c3_state = 7 THEN
                    IF 2 > best_prio THEN best_prio := 2; best_req := i; END_IF;
                ELSIF req_step[i] = 1 THEN 
                    lift_ready := FALSE;
                    IF req_lift[i] = 1 AND ABS(D1008 - 73250) <= 20 AND ABS(D1009) <= 100 THEN lift_ready := TRUE; END_IF;
                    IF req_lift[i] = 2 AND ABS(D1012 - 73250) <= 20 AND ABS(D1013) <= 100 THEN lift_ready := TRUE; END_IF;
                    IF lift_ready THEN
                        IF 1 > best_prio THEN best_prio := 1; best_req := i; END_IF;
                    END_IF;
                END_IF;
            END_FOR;
            
            IF best_req >= 0 THEN
                target_req := best_req;
                target_action := 1;
                IF req_step[best_req] = 7 THEN target_station := 4; target_a := 670000; END_IF;
                IF req_step[best_req] = 4 THEN target_station := 3; target_a := 0; END_IF;
                IF req_step[best_req] = 1 THEN 
                    target_station := req_lift[best_req]; 
                    IF target_station = 1 THEN target_a := -360000; ELSE target_a := -230000; END_IF;
                END_IF;
                shuttle_state := 1;
            END_IF;
        END_IF;

    1:
        a_target_val := target_a;
        IF ABS(D1000 - target_a) <= 20 AND ABS(D1001) <= 100 THEN
            shuttle_state := 2;
        END_IF;

    2:
        a_target_val := target_a;
        b_target_val := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            shuttle_state := 3;
        END_IF;

    3:
        a_target_val := target_a;
        b_target_val := 18000;
        station_ready := FALSE;
        IF target_station = 1 AND X61 THEN station_ready := TRUE; END_IF;
        IF target_station = 2 AND X62 THEN station_ready := TRUE; END_IF;
        IF target_station = 3 AND X63 THEN station_ready := TRUE; END_IF;
        IF target_station = 4 AND X64 THEN station_ready := TRUE; END_IF;
        
        IF station_ready THEN
            D80 := target_action;
            D81 := target_station;
            couple_seq_int := couple_seq_int + 1;
            shuttle_state := 4;
        END_IF;

    4:
        a_target_val := target_a;
        b_target_val := 18000;
        D80 := target_action;
        D81 := target_station;
        
        handoff_done := FALSE;
        IF target_action = 1 THEN
            IF D90 = req_id[target_req] THEN handoff_done := TRUE; END_IF;
        ELSE
            IF D90 = 0 THEN handoff_done := TRUE; END_IF;
        END_IF;
        
        IF handoff_done THEN
            shuttle_state := 5;
        END_IF;

    5:
        a_target_val := target_a;
        b_target_val := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            shuttle_state := 6;
        END_IF;

    6:
        a_target_val := target_a;
        IF target_action = 1 THEN
            IF target_station = 1 OR target_station = 2 THEN req_step[target_req] := 2; END_IF;
            IF target_station = 3 THEN req_step[target_req] := 5; END_IF;
            IF target_station = 4 THEN req_step[target_req] := 8; END_IF;
        ELSE
            IF target_station = 3 THEN req_step[target_req] := 3; END_IF;
            IF target_station = 4 THEN req_step[target_req] := 6; END_IF;
            IF target_station = 1 OR target_station = 2 THEN req_step[target_req] := 9; END_IF;
        END_IF;
        shuttle_state := 0;
END_CASE;

// Completion Check
all_idle := (req_step[0] = 0 OR req_step[0] = 10) AND (req_step[1] = 0 OR req_step[1] = 10);
IF X51 AND all_idle AND shuttle_state = 0 AND c3_state = 0 AND c4_state = 0 THEN
    a_target_val := 0;
    b_target_val := 0;
    lift_target[0] := 15000;
    lift_target[1] := 15000;
    c3_s0_target := 0;
    c3_s1_target := 5000;
    c4_s0_target := -6500;
    c4_s1_target := 0;
    c4_s2_target := 6500;
    c4_s3_target := 0;
    
    at_home := ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
               ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
               ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
               ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
               ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 AND
               ABS(D1024 - (-6500)) <= 20 AND ABS(D1025) <= 100 AND
               ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
               ABS(D1032 - 6500) <= 20 AND ABS(D1033) <= 100 AND
               ABS(D1036) <= 20 AND ABS(D1037) <= 100;
    IF at_home THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y2 := FALSE;
END_IF;

// Write Outputs
D2000 := a_target_val;
D2004 := b_target_val;
D2008 := lift_target[0];
D2012 := lift_target[1];
D2016 := c3_s0_target;
D2020 := c3_s1_target;
D2024 := c4_s0_target;
D2028 := c4_s1_target;
D2032 := c4_s2_target;
D2036 := c4_s3_target;

D82 := couple_seq_int;

D300 := 0; D301 := 0;
IF req_step[0] = 10 THEN
    D300 := req_id[0];
    IF req_cancelled[0] THEN D301 := 2; ELSE D301 := 1; END_IF;
END_IF;

D302 := 0; D303 := 0;
IF req_step[1] = 10 THEN
    D302 := req_id[1];
    IF req_cancelled[1] THEN D303 := 2; ELSE D303 := 1; END_IF;
END_IF;

END_PROGRAM