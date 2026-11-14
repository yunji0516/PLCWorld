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

    r_id : ARRAY[0..1] OF DINT;
    r_loc : ARRAY[0..1] OF DINT;
    r_cancel : ARRAY[0..1] OF BOOL;
    r_returned : ARRAY[0..1] OF BOOL;
    r_active : ARRAY[0..1] OF BOOL;
    r_state : ARRAY[0..1] OF INT;
    r_status : ARRAY[0..1] OF DINT;
    r_pocket : ARRAY[0..1] OF DINT;
    r_ack_id : ARRAY[0..1] OF DINT;
    r_ack_status : ARRAY[0..1] OF DINT;
    c3_target : ARRAY[0..1] OF DINT;
    c4_rot_target : ARRAY[0..1] OF DINT;
    req_needs_shuttle : ARRAY[0..1] OF BOOL;
    req_shuttle_src : ARRAY[0..1] OF INT;
    req_shuttle_dst : ARRAY[0..1] OF INT;
    r_timer : ARRAY[0..1] OF DINT;
    c3_extending_req : INT := -1;
    c4_occupied : BOOL := FALSE;
    sh_state : INT := 0;
    sh_req : INT := -1;
    sh_src : INT := 0;
    sh_dst : INT := 0;
    sh_seq : DINT := 1;
    a_tgt : DINT := 0;
    b_tgt : DINT := 0;
    c_tgt : DINT := 15000;
    d_tgt : DINT := 15000;
    s3_1_tgt : DINT := 0;
    s3_2_tgt : DINT := 0;
    s4_0_tgt : DINT := 0;
    s4_1_tgt : DINT := 5000;
    i : INT;
    s3_axes_home : BOOL;
    shuttle_at_c3 : BOOL;
    fork_extended : BOOL;
    c3_safe_to_extend : BOOL;
    c4_safe_to_process : BOOL;
    done_condition : BOOL;
END_VAR

r_id[0] := D100; r_loc[0] := D101; r_cancel[0] := X31; r_returned[0] := X30;
r_id[1] := D120; r_loc[1] := D121; r_cancel[1] := X35; r_returned[1] := X34;

s3_axes_home := (ABS(D1016) <= 20) AND (ABS(D1020) <= 20) AND (ABS(D1024) <= 20);
shuttle_at_c3 := ABS(D1000 - D409) <= 500;
fork_extended := D1004 > 3000;
c3_safe_to_extend := s3_axes_home AND NOT (shuttle_at_c3 AND fork_extended);
c4_safe_to_process := NOT ((ABS(D1000 - D412) <= 500) AND fork_extended);

FOR i := 0 TO 1 DO
    CASE r_state[i] OF
    0:
        IF r_id[i] > 0 THEN
            r_active[i] := TRUE;
            r_pocket[i] := r_loc[i];
            r_status[i] := 1;
            r_state[i] := 1;
            r_timer[i] := 0;
        END_IF;
    1:
        IF r_cancel[i] THEN
            r_status[i] := 2;
            r_state[i] := 18;
        ELSE
            req_shuttle_src[i] := r_loc[i];
            req_shuttle_dst[i] := 3;
            req_needs_shuttle[i] := TRUE;
            r_state[i] := 2;
        END_IF;
    2:
        ; 
    3:
        IF c3_safe_to_extend THEN
            IF r_pocket[i] = 1 THEN c3_target[i] := D501; ELSE c3_target[i] := D502; END_IF;
            IF c3_extending_req = -1 OR c3_extending_req = i THEN
                c3_extending_req := i;
                r_state[i] := 4;
            END_IF;
        END_IF;
        IF r_cancel[i] THEN r_state[i] := 6; END_IF;
    4:
        IF r_cancel[i] THEN
            r_state[i] := 6;
        ELSE
            IF r_pocket[i] = 1 THEN
                IF ABS(D1020 - c3_target[i]) <= 20 THEN r_timer[i] := 0; r_state[i] := 5; END_IF;
            ELSE
                IF ABS(D1024 - c3_target[i]) <= 20 THEN r_timer[i] := 0; r_state[i] := 5; END_IF;
            END_IF;
        END_IF;
    5:
        IF r_cancel[i] THEN
            r_state[i] := 6;
        ELSE
            r_timer[i] := r_timer[i] + 20;
            IF r_timer[i] >= 100 THEN
                r_state[i] := 6;
            END_IF;
        END_IF;
    6:
        IF r_pocket[i] = 1 THEN
            IF ABS(D1020) <= 20 THEN c3_extending_req := -1; r_state[i] := 7; END_IF;
        ELSE
            IF ABS(D1024) <= 20 THEN c3_extending_req := -1; r_state[i] := 7; END_IF;
        END_IF;
        IF r_state[i] = 7 THEN
            IF r_cancel[i] THEN
                r_status[i] := 2;
                req_shuttle_src[i] := 3;
                req_shuttle_dst[i] := r_loc[i];
                req_needs_shuttle[i] := TRUE;
                r_state[i] := 15;
            ELSE
                req_shuttle_src[i] := 3;
                req_shuttle_dst[i] := 4;
                req_needs_shuttle[i] := TRUE;
            END_IF;
        END_IF;
    7:
        ; 
    9:
        IF c4_safe_to_process THEN
            c4_rot_target[i] := D600;
            r_state[i] := 10;
        END_IF;
    10:
        IF r_cancel[i] THEN
            r_state[i] := 13;
        ELSE
            IF ABS(D1028 - c4_rot_target[i]) <= 20 AND ABS(D1032 - 5000) <= 20 THEN
                r_state[i] := 11;
            END_IF;
        END_IF;
    11:
        IF r_cancel[i] THEN
            r_state[i] := 13;
        ELSE
            IF ABS(D1032 - 70000) <= 20 THEN
                r_timer[i] := 0;
                r_state[i] := 12;
            END_IF;
        END_IF;
    12:
        IF r_cancel[i] THEN
            r_state[i] := 13;
        ELSE
            r_timer[i] := r_timer[i] + 20;
            IF r_timer[i] >= 100 THEN
                r_state[i] := 13;
            END_IF;
        END_IF;
    13:
        IF ABS(D1032 - 5000) <= 20 THEN
            r_state[i] := 14;
        END_IF;
    14:
        IF ABS(D1028) <= 20 THEN
            req_shuttle_src[i] := 4;
            req_shuttle_dst[i] := r_loc[i];
            req_needs_shuttle[i] := TRUE;
            IF r_cancel[i] THEN r_status[i] := 2; END_IF;
            r_state[i] := 15;
        END_IF;
    15:
        ; 
    17:
        r_state[i] := 18;
    18:
        r_ack_id[i] := r_id[i];
        r_ack_status[i] := r_status[i];
        IF r_returned[i] THEN
            r_state[i] := 19;
        END_IF;
    19:
        IF r_id[i] = 0 OR r_id[i] <> r_ack_id[i] THEN
            r_active[i] := FALSE;
            r_state[i] := 0;
        END_IF;
    END_CASE;
END_FOR;

IF c3_extending_req <> -1 THEN
    IF r_state[c3_extending_req] < 4 OR r_state[c3_extending_req] > 6 THEN
        c3_extending_req := -1;
    END_IF;
END_IF;

IF sh_state = 0 THEN
    sh_req := -1;
    FOR i := 0 TO 1 DO
        IF req_needs_shuttle[i] AND req_shuttle_dst[i] <= 2 AND req_shuttle_src[i] = 4 THEN
            sh_req := i;
        END_IF;
    END_FOR;
    IF sh_req = -1 THEN
        FOR i := 0 TO 1 DO
            IF req_needs_shuttle[i] AND req_shuttle_dst[i] <= 2 AND req_shuttle_src[i] = 3 THEN
                sh_req := i;
            END_IF;
        END_FOR;
    END_IF;
    IF sh_req = -1 THEN
        FOR i := 0 TO 1 DO
            IF req_needs_shuttle[i] AND req_shuttle_dst[i] = 4 AND NOT c4_occupied THEN
                sh_req := i;
            END_IF;
        END_FOR;
    END_IF;
    IF sh_req = -1 THEN
        FOR i := 0 TO 1 DO
            IF req_needs_shuttle[i] AND req_shuttle_dst[i] = 3 THEN
                sh_req := i;
            END_IF;
        END_FOR;
    END_IF;
    
    IF sh_req <> -1 THEN
        req_needs_shuttle[sh_req] := FALSE;
        sh_src := req_shuttle_src[sh_req];
        sh_dst := req_shuttle_dst[sh_req];
        IF sh_dst = 4 THEN c4_occupied := TRUE; END_IF;
        IF sh_src = 4 THEN c4_occupied := FALSE; END_IF;
        sh_state := 1;
    END_IF;
END_IF;

IF sh_state = 1 THEN
    IF sh_src = 1 THEN a_tgt := D403;
    ELSIF sh_src = 2 THEN a_tgt := D406;
    ELSIF sh_src = 3 THEN a_tgt := D409;
    ELSIF sh_src = 4 THEN a_tgt := D412;
    END_IF;
    IF sh_src = 3 THEN D700 := r_pocket[sh_req]; END_IF;
    IF ABS(D1000 - a_tgt) <= 20 AND ABS(D1001) <= 10 THEN
        IF sh_src <> 3 OR s3_axes_home THEN
            sh_state := 2;
        END_IF;
    END_IF;
ELSIF sh_state = 2 THEN
    b_tgt := 18000;
    IF ABS(D1004 - 18000) <= 20 THEN
        sh_seq := sh_seq + 1;
        D80 := 1;
        D81 := sh_src;
        D82 := sh_seq;
        sh_state := 3;
    END_IF;
ELSIF sh_state = 3 THEN
    IF D90 = r_id[sh_req] THEN
        sh_state := 4;
    END_IF;
ELSIF sh_state = 4 THEN
    b_tgt := 0;
    IF ABS(D1004) <= 20 THEN
        D80 := 0;
        sh_state := 5;
    END_IF;
ELSIF sh_state = 5 THEN
    IF sh_dst = 1 THEN a_tgt := D403;
    ELSIF sh_dst = 2 THEN a_tgt := D406;
    ELSIF sh_dst = 3 THEN a_tgt := D409;
    ELSIF sh_dst = 4 THEN a_tgt := D412;
    END_IF;
    IF sh_dst = 3 THEN D700 := r_pocket[sh_req]; END_IF;
    IF ABS(D1000 - a_tgt) <= 20 AND ABS(D1001) <= 10 THEN
        IF sh_dst <> 3 OR s3_axes_home THEN
            sh_state := 6;
        END_IF;
    END_IF;
ELSIF sh_state = 6 THEN
    b_tgt := 18000;
    IF ABS(D1004 - 18000) <= 20 THEN
        sh_seq := sh_seq + 1;
        D80 := 2;
        D81 := sh_dst;
        D82 := sh_seq;
        sh_state := 7;
    END_IF;
ELSIF sh_state = 7 THEN
    IF D90 = 0 THEN
        sh_state := 8;
    END_IF;
ELSIF sh_state = 8 THEN
    b_tgt := 0;
    IF ABS(D1004) <= 20 THEN
        D80 := 0;
        sh_state := 9;
    END_IF;
ELSIF sh_state = 9 THEN
    IF sh_dst = 3 THEN r_state[sh_req] := 3;
    ELSIF sh_dst = 4 THEN r_state[sh_req] := 9;
    ELSIF sh_dst <= 2 THEN r_state[sh_req] := 17;
    END_IF;
    sh_state := 0;
END_IF;

s3_1_tgt := 0;
s3_2_tgt := 0;
s4_0_tgt := 0;
s4_1_tgt := 5000;

FOR i := 0 TO 1 DO
    IF r_state[i] = 4 OR r_state[i] = 5 THEN
        IF r_pocket[i] = 1 THEN s3_1_tgt := c3_target[i];
        ELSIF r_pocket[i] = 2 THEN s3_2_tgt := c3_target[i];
        END_IF;
    END_IF;
    IF r_state[i] >= 10 AND r_state[i] <= 13 THEN
        s4_0_tgt := c4_rot_target[i];
    END_IF;
    IF r_state[i] = 11 OR r_state[i] = 12 THEN
        s4_1_tgt := 70000;
    END_IF;
END_FOR;

IF X51 AND r_state[0] = 0 AND r_state[1] = 0 THEN
    a_tgt := 0;
    b_tgt := 0;
    c_tgt := 15000;
    d_tgt := 15000;
ELSE
    c_tgt := D92;
    d_tgt := D92;
END_IF;

D2000 := a_tgt;
D2004 := b_tgt;
D2008 := c_tgt;
D2012 := d_tgt;
D2016 := 0;
D2020 := s3_1_tgt;
D2024 := s3_2_tgt;
D2028 := s4_0_tgt;
D2032 := s4_1_tgt;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000;
D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;
Y30 := FALSE;
Y70 := TRUE; Y71 := TRUE; Y75 := TRUE; Y76 := TRUE;

D710 := 0;
FOR i := 0 TO 1 DO
    IF r_state[i] >= 9 AND r_state[i] <= 15 THEN
        D710 := r_id[i];
    END_IF;
END_FOR;

D300 := SEL(r_state[0] >= 18, 0, r_ack_id[0]);
D301 := SEL(r_state[0] >= 18, 0, r_ack_status[0]);
D302 := SEL(r_state[1] >= 18, 0, r_ack_id[1]);
D303 := SEL(r_state[1] >= 18, 0, r_ack_status[1]);

done_condition := X51 AND 
    (ABS(D1000) <= 20) AND (ABS(D1004) <= 20) AND
    (ABS(D1008 - 15000) <= 20) AND (ABS(D1012 - 15000) <= 20) AND
    (ABS(D1016) <= 20) AND (ABS(D1020) <= 20) AND (ABS(D1024) <= 20) AND
    (ABS(D1028) <= 20) AND (ABS(D1032 - 5000) <= 20);

Y2 := done_condition;

END_PROGRAM