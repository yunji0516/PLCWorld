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

    step : INT := 0;
    active_ch : INT := 0;
    active_id : DINT := 0;
    active_loc : DINT := 0;
    active_status : DINT := 1;
    seq_counter : DINT := 0;
    cell3_timer : DINT := 0;
    cell4_timer : DINT := 0;
    comp_timer : DINT := 0;
    init_done : BOOL := FALSE;
    deg_rad : REAL := 0.0174532925;
    rad_a : REAL;
    rad_b : REAL;
    cw_pos : REAL;
    sum_angle : DINT := 0;
    selected_pocket : INT := 1;
    
    r0_completed : BOOL := FALSE;
    r1_completed : BOOL := FALSE;
    
    lift_target : DINT := 40000;
    shuttle_target : DINT := 0;
    fork_target : DINT := 0;
    
    s3_0_cmd : DINT := 0;
    s3_1_cmd : DINT := 0;
    s3_2_cmd : DINT := 0;
    
    s4_0_cmd : DINT := 0;
    s4_1_cmd : DINT := 0;
    s4_2_cmd : DINT := 0;
END_VAR

IF NOT init_done THEN
    lift_target := 40000;
    shuttle_target := 0;
    fork_target := 0;
    s3_0_cmd := 0;
    s3_1_cmd := 0;
    s3_2_cmd := 0;
    s4_0_cmd := 0;
    s4_1_cmd := 0;
    s4_2_cmd := 0;
    init_done := TRUE;
END_VAR

IF X30 THEN r0_completed := TRUE; END_IF;
IF X34 THEN r1_completed := TRUE; END_IF;

CASE step OF
    0: (* Wait for request *)
        IF NOT r0_completed AND D100 > 0 THEN
            active_ch := 0;
            active_id := D100;
            active_loc := D101;
            IF X31 THEN active_status := 2; ELSE active_status := 1; END_IF;
            step := 10;
        ELSIF NOT r1_completed AND D120 > 0 THEN
            active_ch := 1;
            active_id := D120;
            active_loc := D121;
            IF X35 THEN active_status := 2; ELSE active_status := 1; END_IF;
            step := 10;
        ELSIF (r0_completed OR D100 = 0) AND (r1_completed OR D120 = 0) AND X51 THEN
            step := 900;
        END_IF;

    10: (* Check cancellation *)
        IF (active_ch = 0 AND X31) OR (active_ch = 1 AND X35) THEN
            active_status := 2;
        END_IF;
        (* Move lifts to dock height *)
        IF D92 > 0 THEN lift_target := D92; ELSE lift_target := 95000; END_IF;
        (* Move shuttle to origin lift *)
        IF active_loc = 1 THEN
            shuttle_target := D403;
        ELSE
            shuttle_target := D406;
        END_IF;
        fork_target := 0;
        step := 11;

    11: (* Wait for lift and shuttle arrival at pickup *)
        IF ABS(D1008 - lift_target) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - lift_target) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1000 - shuttle_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1; (* extraction *)
            D81 := active_loc;
            fork_target := 18000;
            step := 12;
        END_IF;

    12: (* Fork extend to connect fixture *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            fork_target := 0;
            step := 13;
        END_IF;

    13: (* Fork retract holding fixture *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            IF active_status = 2 THEN
                (* Cancelled: return directly *)
                step := 100;
            ELSE
                (* Proceed to Cell 3 *)
                step := 20;
            END_IF;
        END_IF;

    20: (* Move shuttle to Cell 3 *)
        shuttle_target := D409;
        fork_target := 0;
        s3_0_cmd := 0;
        s3_1_cmd := 0;
        s3_2_cmd := 0;
        step := 21;

    21: (* Wait arrival at Cell 3 *)
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2; (* placement *)
            D81 := 3;
            fork_target := 18000;
            step := 22;
        END_IF;

    22: (* Extend fork to deliver to Cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            fork_target := 0;
            step := 23;
        END_IF;

    23: (* Retract fork from Cell 3 *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            (* Prepare Cell 3 posture *)
            rad_a := REAL(D500) * 0.01 * deg_rad;
            rad_b := REAL(D501) * 0.01 * deg_rad;
            cw_pos := -225.0 * (SIN(rad_a) + SIN(rad_b));
            s3_0_cmd := D500;
            s3_1_cmd := D501;
            s3_2_cmd := ROUND(cw_pos * 100.0);
            sum_angle := D500 + D501;
            Y70 := TRUE;
            cell3_timer := 0;
            step := 24;
        END_IF;

    24: (* Execute Cell 3 process *)
        IF ABS(D1016 - s3_0_cmd) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020 - s3_1_cmd) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024 - s3_2_cmd) <= 20 AND ABS(D1025) <= 100 THEN
            cell3_timer := cell3_timer + 20;
            IF cell3_timer >= 100 OR X70 THEN
                (* Reset Cell 3 back to home *)
                s3_0_cmd := 0;
                s3_1_cmd := 0;
                s3_2_cmd := 0;
                Y70 := FALSE;
                step := 25;
            END_IF;
        ELSE
            cell3_timer := 0;
        END_IF;

    25: (* Wait Cell 3 return to home *)
        IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1; (* extraction *)
            D81 := 3;
            fork_target := 18000;
            step := 26;
        END_IF;

    26: (* Extend fork to retrieve from Cell 3 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            fork_target := 0;
            step := 27;
        END_IF;

    27: (* Retract fork holding jig from Cell 3 *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            step := 30;
        END_IF;

    30: (* Determine pocket for Cell 4 and move shuttle to Cell 4 *)
        IF sum_angle < 0 THEN
            selected_pocket := 1;
        ELSE
            selected_pocket := 2;
        END_IF;
        D710 := selected_pocket;
        shuttle_target := D412;
        fork_target := 0;
        s4_0_cmd := 0;
        s4_1_cmd := 0;
        s4_2_cmd := 0;
        step := 31;

    31: (* Wait arrival at Cell 4 *)
        IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1036) <= 20 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2; (* placement *)
            D81 := 4;
            fork_target := 18000;
            step := 32;
        END_IF;

    32: (* Extend fork to deliver to Cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            fork_target := 0;
            step := 33;
        END_IF;

    33: (* Retract fork from Cell 4 *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            Y75 := TRUE;
            IF selected_pocket = 1 THEN
                s4_0_cmd := D600;
                IF s4_0_cmd = 0 THEN s4_0_cmd := 50000; END_IF;
                s4_1_cmd := 0;
                s4_2_cmd := 0;
            ELSE
                s4_0_cmd := 0;
                s4_1_cmd := D601;
                IF s4_1_cmd = 0 THEN s4_1_cmd := 50000; END_IF;
                s4_2_cmd := 0;
            END_IF;
            cell4_timer := 0;
            step := 34;
        END_IF;

    34: (* Cell 4 pocket stroke *)
        IF (selected_pocket = 1 AND ABS(D1028 - s4_0_cmd) <= 20 AND ABS(D1029) <= 100) OR
           (selected_pocket = 2 AND ABS(D1032 - s4_1_cmd) <= 20 AND ABS(D1033) <= 100) OR
           X75 THEN
            cell4_timer := cell4_timer + 20;
            IF cell4_timer >= 100 OR X75 THEN
                s4_0_cmd := 0;
                s4_1_cmd := 0;
                s4_2_cmd := 0;
                Y75 := FALSE;
                step := 35;
            END_IF;
        ELSE
            cell4_timer := 0;
        END_IF;

    35: (* Wait Cell 4 axes return to home *)
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 AND
           ABS(D1036) <= 20 AND ABS(D1037) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 1; (* extraction *)
            D81 := 4;
            fork_target := 18000;
            step := 36;
        END_IF;

    36: (* Extend fork to retrieve from Cell 4 *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            fork_target := 0;
            step := 37;
        END_IF;

    37: (* Retract fork holding jig from Cell 4 *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            step := 100;
        END_IF;

    100: (* Return to origin lift *)
        IF active_loc = 1 THEN
            shuttle_target := D403;
        ELSE
            shuttle_target := D406;
        END_IF;
        fork_target := 0;
        step := 101;

    101: (* Wait arrival at origin lift *)
        IF ABS(D1000 - shuttle_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - lift_target) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - lift_target) <= 20 AND ABS(D1013) <= 100 THEN
            seq_counter := seq_counter + 1;
            D82 := seq_counter;
            D80 := 2; (* placement *)
            D81 := active_loc;
            fork_target := 18000;
            step := 102;
        END_IF;

    102: (* Extend fork to return jig to lift *)
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            fork_target := 0;
            step := 103;
        END_IF;

    103: (* Retract fork empty *)
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 0;
            (* Return lifts to home height 400 mm *)
            lift_target := 40000;
            step := 104;
        END_IF;

    104: (* Wait lifts at home height *)
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
            (* Acknowledge request *)
            IF active_ch = 0 THEN
                D300 := active_id;
                D301 := active_status;
                r0_completed := TRUE;
            ELSE
                D302 := active_id;
                D303 := active_status;
                r1_completed := TRUE;
            END_IF;
            step := 0;
        END_IF;

    900: (* All done, move all to home *)
        lift_target := 40000;
        shuttle_target := 0;
        fork_target := 0;
        s3_0_cmd := 0;
        s3_1_cmd := 0;
        s3_2_cmd := 0;
        s4_0_cmd := 0;
        s4_1_cmd := 0;
        s4_2_cmd := 0;
        step := 901;

    901: (* Verify all home and hold for 100 ms *)
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016) <= 20 AND ABS(D1017) <= 100 AND
           ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND
           ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND
           ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND
           ABS(D1032) <= 20 AND ABS(D1033) <= 100 AND
           ABS(D1036) <= 20 AND ABS(D1037) <= 100 THEN
            comp_timer := comp_timer + 20;
            IF comp_timer >= 100 THEN
                Y2 := TRUE;
            END_IF;
        ELSE
            comp_timer := 0;
            Y2 := FALSE;
        END_IF;
END_CASE;

(* Drive outputs assignment *)
(* Shuttle a *)
D2000 := shuttle_target;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

(* Connection fork b *)
D2004 := fork_target;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

(* Lift A c *)
D2008 := lift_target;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

(* Lift B d *)
D2012 := lift_target;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

(* Cell 3 s3_0, s3_1, s3_2 *)
D2016 := s3_0_cmd;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := s3_1_cmd;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := s3_2_cmd;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

(* Cell 4 s4_0, s4_1, s4_2 *)
D2028 := s4_0_cmd;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := s4_1_cmd;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

D2036 := s4_2_cmd;
D2037 := 1000;
D2038 := 0;
Y49 := TRUE;

END_PROGRAM