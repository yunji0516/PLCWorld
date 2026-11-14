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

    req_id : ARRAY[0..1] OF DINT;
    loc : ARRAY[0..1] OF DINT;
    req_cancelled : ARRAY[0..1] OF BOOL;
    ack : ARRAY[0..1] OF DINT;
    status : ARRAY[0..1] OF DINT;
    req_state : ARRAY[0..1] OF INT;
    req_sh_op : ARRAY[0..1] OF INT;
    req_sh_port : ARRAY[0..1] OF INT;
    req_sh_done : ARRAY[0..1] OF BOOL;
    
    cell3_occ : DINT;
    cell4_occ : DINT;
    
    sh_active : BOOL;
    sh_op : INT;
    sh_port : INT;
    sh_req : DINT;
    sh_req_idx : INT;
    sh_step : INT;
    sh_target_x : DINT;
    sh_port_ready : BOOL;
    seq_counter : DINT := 1;
    
    a_target_cmd : DINT;
    b_target_cmd : DINT;
    
    common_lift_target : DINT := 40000;
    need_up_0 : BOOL;
    need_up_1 : BOOL;
    
    accel_cmd : DINT;
    at_home : BOOL;
    i : INT;
END_VAR

req_id[0] := D100; loc[0] := D101; req_cancelled[0] := X31;
req_id[1] := D120; loc[1] := D121; req_cancelled[1] := X35;

FOR i := 0 TO 1 DO
    IF req_id[i] > 0 THEN
        IF req_cancelled[i] AND req_sh_op[i] = 0 AND req_state[i] < 12 THEN
            IF D90 = req_id[i] THEN
                req_state[i] := 11;
            ELSIF cell3_occ = req_id[i] THEN
                req_state[i] := 6;
            ELSIF cell4_occ = req_id[i] THEN
                req_state[i] := 10;
            ELSE
                req_state[i] := 12;
            END_IF
        END_IF
        
        CASE req_state[i] OF
            0:
                req_state[i] := 1;
            1:
                IF (loc[i] = 1 AND ABS(D1008 - 95000) <= 20 AND ABS(D1009) <= 100) OR
                   (loc[i] = 2 AND ABS(D1012 - 95000) <= 20 AND ABS(D1013) <= 100) THEN
                    req_state[i] := 2;
                END_IF
            2:
                req_sh_op[i] := 1; req_sh_port[i] := DINT_TO_INT(loc[i]);
                IF req_sh_done[i] THEN
                    req_sh_done[i] := FALSE; req_sh_op[i] := 0;
                    req_state[i] := 3;
                END_IF
            3:
                IF cell3_occ = 0 THEN
                    req_state[i] := 4;
                END_IF
            4:
                req_sh_op[i] := 2; req_sh_port[i] := 3;
                IF req_sh_done[i] THEN
                    req_sh_done[i] := FALSE; req_sh_op[i] := 0;
                    cell3_occ := req_id[i];
                    req_state[i] := 5;
                END_IF
            5:
                IF X70 AND (cell3_occ = req_id[i]) THEN
                    req_state[i] := 6;
                END_IF
            6:
                req_sh_op[i] := 1; req_sh_port[i] := 3;
                IF req_sh_done[i] THEN
                    req_sh_done[i] := FALSE; req_sh_op[i] := 0;
                    cell3_occ := 0;
                    req_state[i] := 7;
                END_IF
            7:
                IF cell4_occ = 0 THEN
                    req_state[i] := 8;
                END_IF
            8:
                req_sh_op[i] := 2; req_sh_port[i] := 4;
                IF req_sh_done[i] THEN
                    req_sh_done[i] := FALSE; req_sh_op[i] := 0;
                    cell4_occ := req_id[i];
                    req_state[i] := 9;
                END_IF
            9:
                IF X75 AND (cell4_occ = req_id[i]) THEN
                    req_state[i] := 10;
                END_IF
            10:
                req_sh_op[i] := 1; req_sh_port[i] := 4;
                IF req_sh_done[i] THEN
                    req_sh_done[i] := FALSE; req_sh_op[i] := 0;
                    cell4_occ := 0;
                    req_state[i] := 11;
                END_IF
            11:
                req_sh_op[i] := 2; req_sh_port[i] := DINT_TO_INT(loc[i]);
                IF req_sh_done[i] THEN
                    req_sh_done[i] := FALSE; req_sh_op[i] := 0;
                    req_state[i] := 12;
                END_IF
            12:
                IF (loc[i] = 1 AND ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100) OR
                   (loc[i] = 2 AND ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100) THEN
                    req_state[i] := 13;
                END_IF
            13:
                ack[i] := req_id[i];
                IF req_cancelled[i] THEN status[i] := 2; ELSE status[i] := 1; END_IF;
        END_CASE
    ELSE
        req_state[i] := 0;
        ack[i] := 0;
        status[i] := 0;
        req_sh_op[i] := 0;
        req_sh_done[i] := FALSE;
    END_IF
END_FOR

D300 := ack[0]; D301 := status[0];
D302 := ack[1]; D303 := status[1];

need_up_0 := (req_state[0] >= 1 AND req_state[0] <= 2) OR (req_state[0] >= 11 AND req_state[0] <= 12);
need_up_1 := (req_state[1] >= 1 AND req_state[1] <= 2) OR (req_state[1] >= 11 AND req_state[1] <= 12);

IF need_up_0 OR need_up_1 THEN
    common_lift_target := 95000;
ELSE
    common_lift_target := 40000;
END_IF

D2008 := common_lift_target; D2009 := 1000; Y42 := TRUE;
D2012 := common_lift_target; D2013 := 1000; Y43 := TRUE;

Y30 := (ABS(D1008 - common_lift_target) < 100) AND (ABS(D1012 - common_lift_target) < 100);

IF NOT sh_active THEN
    IF req_sh_op[0] <> 0 THEN
        sh_op := req_sh_op[0]; sh_port := req_sh_port[0]; sh_req := req_id[0]; sh_req_idx := 0; sh_active := TRUE; sh_step := 0;
    ELSIF req_sh_op[1] <> 0 THEN
        sh_op := req_sh_op[1]; sh_port := req_sh_port[1]; sh_req := req_id[1]; sh_req_idx := 1; sh_active := TRUE; sh_step := 0;
    END_IF
END_IF

IF sh_active THEN
    CASE sh_port OF
        1: sh_target_x := D403; sh_port_ready := X61;
        2: sh_target_x := D406; sh_port_ready := X62;
        3: sh_target_x := D409; sh_port_ready := X63;
        4: sh_target_x := D412; sh_port_ready := X64;
    END_CASE
    
    a_target_cmd := sh_target_x;
    
    CASE sh_step OF
        0:
            IF ABS(D1000 - sh_target_x) <= 20 AND ABS(D1001) <= 100 AND sh_port_ready THEN
                sh_step := 1;
            END_IF
        1:
            b_target_cmd := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                sh_step := 2;
                seq_counter := seq_counter + 1;
            END_IF
        2:
            b_target_cmd := 18000;
            D80 := DINT(sh_op); D81 := DINT(sh_port); D82 := seq_counter;
            IF (sh_op = 1 AND D90 = sh_req) OR (sh_op = 2 AND D90 = 0) THEN
                sh_step := 3;
            END_IF
        3:
            b_target_cmd := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                sh_step := 4;
            END_IF
        4:
            req_sh_done[sh_req_idx] := TRUE;
            sh_active := FALSE;
    END_CASE
END_IF

IF X51 AND req_id[0] = 0 AND req_id[1] = 0 AND NOT sh_active THEN
    a_target_cmd := 0;
END_IF

D2000 := a_target_cmd; D2001 := 1000; Y40 := TRUE;
D2004 := b_target_cmd; D2005 := 1000; Y41 := TRUE;

IF cell3_occ = 0 THEN
    D2016 := 100000; D2017 := 1000; Y44 := TRUE;
    D2020 := 0; D2021 := 1000;
    accel_cmd := (0 - D1020) / 2 - D1021 + 174 * D1024 + 87 * D1025;
    D702 := LIMIT(-10000, accel_cmd, 10000);
    Y45 := TRUE; Y46 := TRUE;
    Y70 := FALSE; Y71 := FALSE;
ELSE
    D2016 := D500; D2017 := 1000; Y44 := TRUE;
    D2020 := D501; D2021 := 1000;
    accel_cmd := (D501 - D1020) / 2 - D1021 + 174 * D1024 + 87 * D1025;
    D702 := LIMIT(-10000, accel_cmd, 10000);
    Y45 := TRUE; Y46 := TRUE;
    D700 := cell3_occ;
    Y70 := TRUE; Y71 := TRUE;
END_IF

D2024 := 0; D2025 := 0; D701 := 0;

IF cell4_occ = 0 THEN
    D2028 := 0; D2029 := 1000; Y47 := TRUE;
    D2032 := 0; D2033 := 1000; Y48 := TRUE;
    Y75 := FALSE; Y76 := FALSE;
ELSE
    D2028 := D600; D2029 := 1000; Y47 := TRUE;
    IF D601 = 0 THEN
        D2032 := DINT(-45000.0 * SIN(REAL(D1028) * 0.00017453292));
    ELSE
        D2032 := D601;
    END_IF
    D2033 := 1000; Y48 := TRUE;
    D710 := cell4_occ;
    Y75 := TRUE; Y76 := TRUE;
END_IF

D711 := 0; D712 := 0;

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;

at_home := (ABS(D1000) <= 20) AND (ABS(D1004) <= 20) AND
           (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND
           (ABS(D1016 - 100000) <= 20) AND (ABS(D1020) <= 20) AND (ABS(D1024) <= 3) AND
           (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) AND
           (ABS(D1001) <= 100) AND (ABS(D1005) <= 100) AND
           (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND
           (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND (ABS(D1025) <= 15) AND
           (ABS(D1029) <= 100) AND (ABS(D1033) <= 100);

IF X51 AND at_home AND (req_id[0] = 0) AND (req_id[1] = 0) THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF

END_PROGRAM