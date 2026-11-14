```st
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

    first_scan : BOOL := TRUE;
    a_target_val : DINT;
    b_target_val : DINT;
    c_target_val : DINT;
    d_target_val : DINT;
    s3_0_target_val : DINT;
    s3_1_target_val : DINT;
    s4_0_target_val : DINT;
    s4_1_target_val : DINT;

    req_active : ARRAY[0..1] OF BOOL;
    jig_loc : ARRAY[0..1] OF DINT;
    target_loc : ARRAY[0..1] OF DINT;
    cell3_done : ARRAY[0..1] OF BOOL;
    cell4_done : ARRAY[0..1] OF BOOL;
    req_done : ARRAY[0..1] OF BOOL;

    shut_task_active : BOOL;
    shut_task_req : DINT;
    shut_task_type : DINT;
    shut_task_loc : DINT;
    shut_state : DINT;
    station_to_go : DINT;
    port_x : DINT;
    port_ready : BOOL;
    lift_ready : BOOL;
    expected_d90 : DINT;

    c3_state : DINT;
    req_in_c3 : DINT;
    c3_home_0 : DINT;
    c3_home_1 : DINT;
    old_pos_c3_0 : DINT;
    old_pos_c3_1 : DINT;

    c4_state : DINT;
    req_in_c4 : DINT;
    c4_home_0 : DINT;
    c4_home_1 : DINT;
    old_pos_c4_0 : DINT;
    old_pos_c4_1 : DINT;

    r : DINT;
    r_id : DINT;
    r_canc : BOOL;
    can_pickup : BOOL;
    src_st : DINT;
    lift_pos : DINT;
    lift_spd : DINT;
    all_home : BOOL;
    all_stopped : BOOL;
END_VAR

IF first_scan THEN
    c3_home_0 := -60000; c3_home_1 := -60000;
    c4_home_0 := -60000; c4_home_1 := -60000;
    s3_0_target_val := -60000; s3_1_target_val := -60000;
    s4_0_target_val := -60000; s4_1_target_val := -60000;
    c_target_val := 40000; d_target_val := 40000;
    first_scan := FALSE;
END_IF;

(* Request Management *)
FOR r := 0 TO 1 DO
    IF r = 0 THEN r_id := D100; r_canc := X31; ELSE r_id := D120; r_canc := X35; END_IF;

    IF r_id <> 0 AND NOT req_active[r] THEN
        req_active[r] := TRUE;
        jig_loc[r] := 0;
        cell3_done[r] := FALSE;
        cell4_done[r] := FALSE;
        req_done[r] := FALSE;
        IF r = 0 THEN D300 := 0; D301 := 0; ELSE D302 := 0; D303 := 0; END_IF;
    END_IF;

    IF req_active[r] THEN
        IF r_canc THEN
            target_loc[r] := 0;
        ELSE
            IF NOT cell3_done[r] THEN target_loc[r] := 2;
            ELSIF NOT cell4_done[r] THEN target_loc[r] := 3;
            ELSE target_loc[r] := 0;
            END_IF;
        END_IF;

        IF jig_loc[r] = 0 AND target_loc[r] = 0 AND NOT req_done[r] THEN
            IF r = 0 THEN src_st := D101; ELSE src_st := D121; END_IF;
            IF src_st = 1 THEN lift_pos := D1008; lift_spd := D1009; ELSE lift_pos := D1012; lift_spd := D1013; END_IF;
            
            IF ABS(lift_pos - 40000) <= 20 AND ABS(lift_spd) <= 1 THEN
                req_done[r] := TRUE;
                IF r = 0 THEN
                    D300 := r_id;
                    IF r_canc THEN D301 := 2; ELSE D301 := 1; END_IF;
                ELSE
                    D302 := r_id;
                    IF r_canc THEN D303 := 2; ELSE D303 := 1; END_IF;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

    IF r_id = 0 THEN
        req_active[r] := FALSE;
        IF r = 0 THEN D300 := 0; D301 := 0; ELSE D302 := 0; D303 := 0; END_IF;
    END_IF;
END_FOR;

(* Shuttle Arbiter *)
IF NOT shut_task_active THEN
    shut_task_req := -1;
    FOR r := 0 TO 1 DO
        IF req_active[r] AND jig_loc[r] = 1 THEN
            shut_task_req := r;
            shut_task_type := 2;
            shut_task_loc := target_loc[r];
            EXIT;
        END_IF;
    END_FOR;

    IF shut_task_req = -1 THEN
        FOR r := 0 TO 1 DO
            IF req_active[r] AND jig_loc[r] <> target_loc[r] AND jig_loc[r] <> 1 THEN
                can_pickup := FALSE;
                IF jig_loc[r] = 0 THEN can_pickup := TRUE; END_IF;
                IF jig_loc[r] = 2 AND c3_state = 0 THEN can_pickup := TRUE; END_IF;
                IF jig_loc[r] = 3 AND c4_state = 0 THEN can_pickup := TRUE; END_IF;
                
                IF can_pickup THEN
                    shut_task_req := r;
                    shut_task_type := 1;
                    shut_task_loc := jig_loc[r];
                    EXIT;
                END_IF;
            END_IF;
        END_FOR;
    END_IF;

    IF shut_task_req <> -1 THEN
        shut_task_active := TRUE;
        shut_state := 1;
        IF shut_task_loc = 0 THEN
            IF shut_task_req = 0 THEN station_to_go := D101; ELSE station_to_go := D121; END_IF;
        ELSIF shut_task_loc = 2 THEN
            station_to_go := 3;
        ELSIF shut_task_loc = 3 THEN
            station_to_go := 4;
        END_IF;
    END_IF;
END_IF;

(* Shuttle Transfer Logic *)
IF shut_task_active THEN
    IF station_to_go = 1 THEN port_x := D403; port_ready := X61;
    ELSIF station_to_go = 2 THEN port_x := D406; port_ready := X62;
    ELSIF station_to_go = 3 THEN port_x := D409; port_ready := X63;
    ELSIF station_to_go = 4 THEN port_x := D412; port_ready := X64;
    END_IF;

    CASE shut_state OF
        1:
            a_target_val := port_x;
            IF ABS(D1000 - port_x) <= 20 AND ABS(D1001) <= 1 AND port_ready THEN
                lift_ready := TRUE;
                IF station_to_go = 1 AND NOT (ABS(D1008 - 95000) <= 20 AND ABS(D1009) <= 1) THEN lift_ready := FALSE; END_IF;
                IF station_to_go = 2 AND NOT (ABS(D1012 - 95000) <= 20 AND ABS(D1013) <= 1) THEN lift_ready := FALSE; END_IF;
                IF lift_ready THEN
                    shut_state := 2;
                END_IF;
            END_IF;
        2:
            b_target_val := 18000;
            IF D1004 >= 17980 AND ABS(D1005) <= 1 THEN
                IF shut_task_type = 1 THEN D80 := 1; ELSE D80 := 2; END_IF;
                D81 := station_to_go;
                D82 := D82 + 1;
                shut_state := 3;
            END_IF;
        3:
            IF shut_task_type = 1 THEN
                IF shut_task_req = 0 THEN expected_d90 := D100; ELSE expected_d90 := D120; END_IF;
            ELSE
                expected_d90 := 0;
            END_IF;
            
            IF D90 = expected_d90 THEN
                shut_state := 4;
            END_IF;
        4:
            b_target_val := 0;
            IF D1004 <= 20 AND ABS(D1005) <= 1 THEN
                IF shut_task_type = 1 THEN
                    jig_loc[shut_task_req] := 1;
                ELSE
                    jig_loc[shut_task_req] := shut_task_loc;
                END_IF;
                shut_task_active := FALSE;
                shut_state := 0;
            END_IF;
    END_CASE;
ELSE
    IF NOT req_active[0] AND NOT req_active[1] THEN
        a_target_val := 0;
    END_IF;
    b_target_val := 0;
END_IF;

(* Lift Height Logic *)
c_target_val := 40000;
d_target_val := 40000;
IF shut_task_active AND station_to_go = 1 THEN c_target_val := 95000;
ELSIF shut_task_active AND station_to_go = 2 THEN d_target_val := 95000;
END_IF;

(* Cell 3 Logic *)
req_in_c3 := -1;
IF jig_loc[0] = 2 THEN req_in_c3 := 0; ELSIF jig_loc[1] = 2 THEN req_in_c3 := 1; END_IF;

CASE c3_state OF
    0:
        IF req_in_c3 >= 0 THEN
            IF target_loc[req_in_c3] = 2 THEN c3_state := 1; ELSE c3_state := 9; END_IF;
        END_IF;
    1:
        IF ABS(D1016 - c3_home_0) <= 20 AND ABS(D1017) <= 1 THEN
            IF req_in_c3 = 0 THEN D700 := D100; ELSE D700 := D120; END_IF;
            Y71 := TRUE;
            old_pos_c3_0 := D1016;
            old_pos_c3_1 := D1020;
            Y70 := TRUE;
            c3_state := 2;
        END_IF;
    2:
        c3_home_0 := c3_home_0 + (D1016 - old_pos_c3_0);
        c3_home_1 := c3_home_1 + (D1020 - old_pos_c3_1);
        s3_0_target_val := D1016;
        s3_1_target_val := D1020;
        Y70 := FALSE;
        c3_state := 3;
    3:
        s3_0_target_val := D500;
        s3_1_target_val := D501;
        IF X70 THEN c3_state := 4; END_IF;
        IF target_loc[req_in_c3] <> 2 THEN c3_state := 9; END_IF;
    4:
        Y71 := FALSE;
        c3_state := 5;
    5:
        s3_0_target_val := c3_home_0;
        s3_1_target_val := c3_home_1;
        IF ABS(D1016 - c3_home_0) <= 20 AND ABS(D1017) <= 1 THEN
            cell3_done[req_in_c3] := TRUE;
            c3_state := 0;
        END_IF;
    9:
        Y71 := FALSE;
        s3_0_target_val := c3_home_0;
        s3_1_target_val := c3_home_1;
        IF ABS(D1016 - c3_home_0) <= 20 AND ABS(D1017) <= 1 THEN c3_state := 0; END_IF;
END_CASE;

(* Cell 4 Logic *)
req_in_c4 := -1;
IF jig_loc[0] = 3 THEN req_in_c4 := 0; ELSIF jig_loc[1] = 3 THEN req_in_c4 := 1; END_IF;

CASE c4_state OF
    0:
        IF req_in_c4 >= 0 THEN
            IF target_loc[req_in_c4] = 3 THEN c4_state := 1; ELSE c4_state := 9; END_IF;
        END_IF;
    1:
        IF ABS(D1024 - c4_home_0) <= 20 AND ABS(D1025) <= 1 THEN
            IF req_in_c4 = 0 THEN D710 := D100; ELSE D710 := D120; END_IF;
            Y76 := TRUE;
            old_pos_c4_0 := D1024;
            old_pos_c4_1 := D1028;
            Y75 := TRUE;
            c4_state := 2;
        END_IF;
    2:
        c4_home_0 := c4_home_0 + (D1024 - old_pos_c4_0);
        c4_home_1 := c4_home_1 + (D1028 - old_pos_c4_1);
        s4_0_target_val := D1024;
        s4_1_target_val := D1028;
        Y75 := FALSE;
        c4_state := 3;
    3:
        s4_0_target_val := D600;
        s4_1_target_val := D601;
        IF X75 THEN c4_state := 4; END_IF;
        IF target_loc[req_in_c4] <> 3 THEN c4_state := 9; END_IF;
    4:
        Y76 := FALSE;
        c4_state := 5;
    5:
        s4_0_target_val := c4_home_0;
        s4_1_target_val := c4_home_1;
        IF ABS(D1024 - c4_home_0) <= 20 AND ABS(D1025) <= 1 THEN
            cell4_done[req_in_c4] := TRUE;
            c4_state := 0;
        END_IF;
    9:
        Y76 := FALSE;
        s4_0_target_val := c4_home_0;
        s4_1_target_val := c4_home_1;
        IF ABS(D1024 - c4_home_0) <= 20 AND ABS(D1025) <= 1 THEN c4_state := 0; END_IF;
END_CASE;

(* Drive Outputs *)
D2000 := a_target_val;
D2004 := b_target_val;
D2008 := c_target_val;
D2012 := d_target_val;
D2016 := s3_0_target_val;
D2020 := s3_1_target_val;
D2024 := s4_0_target_val;
D2028 := s4_1_target_val;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000;

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE;

Y30 := FALSE;

(* Completion Check *)
all_home := ABS(D1000) <= 20 AND ABS(D1004) <= 20 
            AND ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20
            AND ABS(D1016 - c3_home_0) <= 20 AND ABS(D1020 - c3_home_1) <= 20
            AND ABS(D1024 - c4_home_0) <= 20 AND ABS(D1028 - c4_home_1) <= 20;

all_stopped := ABS(D1001) <= 1 AND ABS(D1005) <= 1 
               AND ABS(D1009) <= 1 AND ABS(D1013) <= 1
               AND ABS(D1017) <= 1 AND ABS(D1021) <= 1
               AND ABS(D1025) <= 1 AND ABS(D1029) <= 1;

Y2 := X51 AND all_home AND all_stopped;
END_PROGRAM
```