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
    D603 : DINT;
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

    init_done : BOOL := FALSE;
    i : DINT;
    id_in : DINT;
    loc_in : DINT;
    cancel_in : BOOL;
    
    req_id : ARRAY[0..1] OF DINT;
    req_loc : ARRAY[0..1] OF DINT;
    req_cancel : ARRAY[0..1] OF BOOL;
    req_state : ARRAY[0..1] OF DINT;
    
    c_t : DINT := 15000;
    d_t : DINT := 15000;
    
    in_cell3 : DINT := -1;
    cell3_step : DINT := 0;
    s3_0_t : DINT := 0;
    s3_1_t : DINT := 5000;
    
    in_cell4 : DINT := -1;
    cell4_step : DINT := 0;
    s4_0_t : DINT := -6500;
    s4_1_t : DINT := 0;
    s4_2_t : DINT := 6500;
    s4_3_t : DINT := 0;
    
    shut_step : DINT := 0;
    shut_cmd : DINT := 0;
    shut_port : DINT := 0;
    shut_req : DINT := -1;
    D80_out : DINT := 0;
    D81_out : DINT := 0;
    D82_out : DINT := 1;
    
    held_req : DINT;
    ext_cand : DINT;
    cell4_busy : BOOL;
    cell3_busy : BOOL;
    
    target_px : DINT;
    p_ready : BOOL;
    done_handover : BOOL;
    req_idx : DINT;
    
    a_t : DINT := 0;
    b_t : DINT := 0;
    
    a_r : DINT;
    b_r : DINT;
    c_r : DINT;
    d_r : DINT;
    s3_0_r : DINT;
    s3_1_r : DINT;
    s4_0_r : DINT;
    s4_1_r : DINT;
    s4_2_r : DINT;
    s4_3_r : DINT;
    
    comp_timer : TON;
END_VAR

IF NOT init_done THEN
    D82_out := 1;
    init_done := TRUE;
END_IF;

FOR i := 0 TO 1 DO
    IF i = 0 THEN
        id_in := D100;
        loc_in := D101;
        cancel_in := X31;
    ELSE
        id_in := D120;
        loc_in := D121;
        cancel_in := X35;
    END_IF;
    
    IF req_state[i] = 0 AND id_in > 0 THEN
        req_id[i] := id_in;
        req_loc[i] := loc_in;
        req_cancel[i] := cancel_in;
        req_state[i] := 1;
    END_IF;

    IF req_state[i] > 0 THEN
        IF cancel_in THEN
            req_cancel[i] := TRUE;
        END_IF;

        CASE req_state[i] OF
            2:
                IF req_cancel[i] THEN req_state[i] := 16; END_IF;
            4:
                IF req_cancel[i] THEN req_state[i] := 14; END_IF;
            9:
                IF req_cancel[i] THEN req_state[i] := 14; END_IF;
            17:
                IF id_in = 0 THEN
                    req_state[i] := 0;
                    req_id[i] := 0;
                    req_cancel[i] := FALSE;
                END_IF;
        END_CASE;
    END_IF;
END_FOR;

c_t := 15000;
FOR i := 0 TO 1 DO
    IF req_id[i] > 0 AND req_loc[i] = 1 THEN
        IF req_state[i] >= 1 AND req_state[i] <= 15 THEN
            c_t := 73250;
            IF req_state[i] = 1 AND ABS(D1008 - 73250) <= 20 AND ABS(D1009) <= 100 THEN
                req_state[i] := 2;
            END_IF;
        ELSIF req_state[i] = 16 THEN
            c_t := 15000;
            IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                req_state[i] := 17;
            END_IF;
        END_IF;
    END_IF;
END_FOR;

d_t := 15000;
FOR i := 0 TO 1 DO
    IF req_id[i] > 0 AND req_loc[i] = 2 THEN
        IF req_state[i] >= 1 AND req_state[i] <= 15 THEN
            d_t := 73250;
            IF req_state[i] = 1 AND ABS(D1012 - 73250) <= 20 AND ABS(D1013) <= 100 THEN
                req_state[i] := 2;
            END_IF;
        ELSIF req_state[i] = 16 THEN
            d_t := 15000;
            IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                req_state[i] := 17;
            END_IF;
        END_IF;
    END_IF;
END_FOR;

in_cell3 := -1;
FOR i := 0 TO 1 DO
    IF req_state[i] = 6 OR req_state[i] = 7 THEN
        in_cell3 := i;
    END_IF;
END_FOR;

IF in_cell3 >= 0 THEN
    req_idx := in_cell3;
    IF req_state[req_idx] = 6 THEN
        IF req_cancel[req_idx] AND cell3_step < 100 THEN
            cell3_step := 100;
        END_IF;
        CASE cell3_step OF
            0:
                D700 := req_id[req_idx];
                s3_0_t := D500;
                s3_1_t := 5000;
                IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 THEN
                    cell3_step := 1;
                END_IF;
            1:
                D700 := req_id[req_idx];
                s3_0_t := D500;
                s3_1_t := D501;
                IF X70 THEN
                    cell3_step := 2;
                END_IF;
            2:
                s3_1_t := 5000;
                s3_0_t := D500;
                IF D1020 <= 5020 THEN
                    cell3_step := 3;
                END_IF;
            3:
                s3_1_t := 5000;
                s3_0_t := 0;
                IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
                    req_state[req_idx] := 7;
                    cell3_step := 0;
                END_IF;
            100:
                s3_1_t := 5000;
                s3_0_t := s3_0_t;
                IF D1020 <= 5020 THEN
                    cell3_step := 101;
                END_IF;
            101:
                s3_1_t := 5000;
                s3_0_t := 0;
                IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
                    req_state[req_idx] := 7;
                    cell3_step := 0;
                END_IF;
        END_CASE;
    ELSIF req_state[req_idx] = 7 THEN
        s3_0_t := 0;
        s3_1_t := 5000;
    END_IF;
ELSE
    s3_0_t := 0;
    s3_1_t := 5000;
    cell3_step := 0;
END_IF;

in_cell4 := -1;
FOR i := 0 TO 1 DO
    IF req_state[i] = 11 OR req_state[i] = 12 THEN
        in_cell4 := i;
    END_IF;
END_FOR;

IF in_cell4 >= 0 THEN
    req_idx := in_cell4;
    IF req_state[req_idx] = 11 THEN
        IF req_cancel[req_idx] AND cell4_step < 100 THEN
            cell4_step := 100;
        END_IF;
        CASE cell4_step OF
            0:
                s4_1_t := 0;
                s4_3_t := 0;
                s4_0_t := -6500;
                s4_2_t := 6500;
                IF D1028 <= 8020 AND D1036 <= 8020 THEN
                    cell4_step := 1;
                END_IF;
            1:
                D710 := req_id[req_idx];
                s4_0_t := D600;
                s4_2_t := D602;
                s4_1_t := 0;
                s4_3_t := 0;
                IF ABS(D1024 - D600) <= 20 AND ABS(D1032 - D602) <= 20 AND ABS(D1025) <= 100 AND ABS(D1033) <= 100 THEN
                    cell4_step := 2;
                END_IF;
            2:
                D710 := req_id[req_idx];
                s4_0_t := D600;
                s4_2_t := D602;
                s4_1_t := D601;
                s4_3_t := D603;
                IF X75 THEN
                    cell4_step := 3;
                END_IF;
            3:
                s4_0_t := D600;
                s4_2_t := D602;
                s4_1_t := 0;
                s4_3_t := 0;
                IF D1028 <= 8020 AND D1036 <= 8020 THEN
                    cell4_step := 4;
                END_IF;
            4:
                s4_1_t := 0;
                s4_3_t := 0;
                s4_0_t := -6500;
                s4_2_t := 6500;
                IF ABS(D1024 - -6500) <= 20 AND ABS(D1032 - 6500) <= 20 THEN
                    req_state[req_idx] := 12;
                    cell4_step := 0;
                END_IF;
            100:
                s4_1_t := 0;
                s4_3_t := 0;
                s4_0_t := s4_0_t;
                s4_2_t := s4_2_t;
                IF D1028 <= 8020 AND D1036 <= 8020 THEN
                    cell4_step := 101;
                END_IF;
            101:
                s4_1_t := 0;
                s4_3_t := 0;
                s4_0_t := -6500;
                s4_2_t := 6500;
                IF ABS(D1024 - -6500) <= 20 AND ABS(D1032 - 6500) <= 20 THEN
                    req_state[req_idx] := 12;
                    cell4_step := 0;
                END_IF;
        END_CASE;
    ELSIF req_state[req_idx] = 12 THEN
        s4_0_t := -6500;
        s4_2_t := 6500;
        s4_1_t := 0;
        s4_3_t := 0;
    END_IF;
ELSE
    s4_0_t := -6500;
    s4_2_t := 6500;
    s4_1_t := 0;
    s4_3_t := 0;
    cell4_step := 0;
END_IF;

IF shut_step = 0 THEN
    shut_cmd := 0;
    IF D90 > 0 THEN
        held_req := -1;
        FOR i := 0 TO 1 DO
            IF req_id[i] = D90 THEN held_req := i; END_IF;
        END_FOR;
        
        IF held_req >= 0 THEN
            IF req_state[held_req] = 4 THEN
                shut_cmd := 2; shut_port := 3; shut_req := held_req;
            ELSIF req_state[held_req] = 9 THEN
                shut_cmd := 2; shut_port := 4; shut_req := held_req;
            ELSIF req_state[held_req] = 14 THEN
                shut_cmd := 2; shut_port := req_loc[held_req]; shut_req := held_req;
            END_IF;
        END_IF;
    ELSE
        ext_cand := -1;
        FOR i := 0 TO 1 DO
            IF req_state[i] = 12 THEN ext_cand := i; END_IF;
        END_FOR;
        
        IF ext_cand >= 0 THEN
            shut_cmd := 1; shut_port := 4; shut_req := ext_cand;
        ELSE
            cell4_busy := FALSE;
            FOR i := 0 TO 1 DO
                IF req_state[i] >= 9 AND req_state[i] <= 12 THEN cell4_busy := TRUE; END_IF;
            END_FOR;
            
            FOR i := 0 TO 1 DO
                IF req_state[i] = 7 AND (NOT cell4_busy OR req_cancel[i]) THEN ext_cand := i; END_IF;
            END_FOR;
            
            IF ext_cand >= 0 THEN
                shut_cmd := 1; shut_port := 3; shut_req := ext_cand;
            ELSE
                cell3_busy := FALSE;
                FOR i := 0 TO 1 DO
                    IF req_state[i] >= 4 AND req_state[i] <= 7 THEN cell3_busy := TRUE; END_IF;
                END_FOR;
                
                FOR i := 0 TO 1 DO
                    IF req_state[i] = 2 AND (NOT cell3_busy OR req_cancel[i]) THEN ext_cand := i; END_IF;
                END_FOR;
                
                IF ext_cand >= 0 THEN
                    shut_cmd := 1; shut_port := req_loc[ext_cand]; shut_req := ext_cand;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
    
    IF shut_cmd > 0 THEN
        shut_step := 1;
    END_IF;
END_IF;

target_px := D1000;
IF shut_port = 1 THEN target_px := D403; p_ready := X61; END_IF;
IF shut_port = 2 THEN target_px := D406; p_ready := X62; END_IF;
IF shut_port = 3 THEN target_px := D409; p_ready := X63; END_IF;
IF shut_port = 4 THEN target_px := D412; p_ready := X64; END_IF;

IF shut_step > 0 THEN
    CASE shut_step OF
        1:
            a_t := target_px;
            b_t := 0;
            IF ABS(D1000 - target_px) <= 20 AND ABS(D1001) <= 100 AND p_ready THEN
                shut_step := 2;
            END_IF;
        2:
            a_t := target_px;
            b_t := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D80_out := shut_cmd;
                D81_out := shut_port;
                D82_out := D82_out + 1;
                shut_step := 3;
            END_IF;
        3:
            a_t := target_px;
            b_t := 18000;
            done_handover := FALSE;
            IF shut_cmd = 1 AND D90 = req_id[shut_req] THEN done_handover := TRUE; END_IF;
            IF shut_cmd = 2 AND D90 = 0 THEN done_handover := TRUE; END_IF;
            IF done_handover THEN
                shut_step := 4;
            END_IF;
        4:
            a_t := target_px;
            b_t := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                IF shut_cmd = 1 THEN
                    IF shut_port = 1 OR shut_port = 2 THEN req_state[shut_req] := 4;
                    ELSIF shut_port = 3 THEN req_state[shut_req] := 9;
                    ELSIF shut_port = 4 THEN req_state[shut_req] := 14;
                    END_IF;
                ELSE
                    IF shut_port = 1 OR shut_port = 2 THEN req_state[shut_req] := 16;
                    ELSIF shut_port = 3 THEN req_state[shut_req] := 6;
                    ELSIF shut_port = 4 THEN req_state[shut_req] := 11;
                    END_IF;
                END_IF;
                
                IF req_cancel[shut_req] THEN
                    IF req_state[shut_req] = 4 OR req_state[shut_req] = 9 THEN
                        req_state[shut_req] := 14;
                    END_IF;
                END_IF;
                
                shut_step := 0;
                shut_cmd := 0;
            END_IF;
    END_CASE;
ELSE
    IF X51 AND D90 = 0 AND req_state[0] = 0 AND req_state[1] = 0 THEN
        a_t := 0;
    ELSE
        a_t := D1000;
    END_IF;
    b_t := 0;
END_IF;

a_r := 1000; b_r := 1000; c_r := 1000; d_r := 1000;
s3_0_r := 1000; s3_1_r := 1000;
s4_0_r := 1000; s4_1_r := 1000; s4_2_r := 1000; s4_3_r := 1000;

IF D1004 > 4000 THEN
    a_r := 0;
    IF shut_port = 1 THEN c_r := 0; END_IF;
    IF shut_port = 2 THEN d_r := 0; END_IF;
    IF shut_port = 3 THEN s3_0_r := 0; s3_1_r := 0; END_IF;
    IF shut_port = 4 THEN s4_0_r := 0; s4_1_r := 0; s4_2_r := 0; s4_3_r := 0; END_IF;
END_IF;

D2000 := a_t; D2001 := a_r; Y40 := TRUE;
D2004 := b_t; D2005 := b_r; Y41 := TRUE;
D2008 := c_t; D2009 := c_r; Y42 := TRUE;
D2012 := d_t; D2013 := d_r; Y43 := TRUE;

D2016 := s3_0_t; D2017 := s3_0_r; Y44 := TRUE;
D2020 := s3_1_t; D2021 := s3_1_r; Y45 := TRUE;

D2024 := s4_0_t; D2025 := s4_0_r; Y46 := TRUE;
D2028 := s4_1_t; D2029 := s4_1_r; Y47 := TRUE;
D2032 := s4_2_t; D2033 := s4_2_r; Y48 := TRUE;
D2036 := s4_3_t; D2037 := s4_3_r; Y49 := TRUE;

Y70 := TRUE; Y71 := TRUE;
Y75 := TRUE; Y76 := TRUE;

D80 := D80_out; D81 := D81_out; D82 := D82_out;
Y30 := FALSE;

IF req_state[0] = 17 THEN
    D300 := req_id[0];
    IF req_cancel[0] THEN D301 := 2; ELSE D301 := 1; END_IF;
ELSE
    D300 := 0; D301 := 0;
END_IF;

IF req_state[1] = 17 THEN
    D302 := req_id[1];
    IF req_cancel[1] THEN D303 := 2; ELSE D303 := 1; END_IF;
ELSE
    D302 := 0; D303 := 0;
END_IF;

IF X51 AND shut_step = 0 AND ABS(D1000) <= 20 AND ABS(D1004) <= 20 
   AND ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20
   AND ABS(D1016) <= 20 AND ABS(D1020 - 5000) <= 20
   AND ABS(D1024 - -6500) <= 20 AND ABS(D1028) <= 20 
   AND ABS(D1032 - 6500) <= 20 AND ABS(D1036) <= 20 THEN
    comp_timer(IN:=TRUE, PT:=T#100ms);
ELSE
    comp_timer(IN:=FALSE, PT:=T#100ms);
END_IF;
Y2 := comp_timer.Q;

END_PROGRAM