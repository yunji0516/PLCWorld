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

    i : INT;
    req_active : ARRAY[0..1] OF BOOL;
    req_id_mem : ARRAY[0..1] OF DINT;
    req_loc_mem : ARRAY[0..1] OF DINT;
    phy_loc : ARRAY[0..1] OF INT;
    next_dest : ARRAY[0..1] OF INT;
    cell3_done : ARRAY[0..1] OF BOOL;
    cell4_done : ARRAY[0..1] OF BOOL;
    req_cancelled : ARRAY[0..1] OF BOOL;
    req_returned : ARRAY[0..1] OF BOOL;
    
    shuttle_state : INT := 0;
    shuttle_req : INT := -1;
    shuttle_task : INT := 0;
    target_port : INT := 0;
    
    a_target_int : DINT;
    b_target_int : DINT;
    c_target_int : DINT;
    d_target_int : DINT;
    s3_0_target_int : DINT;
    s3_1_target_int : DINT;
    s3_2_target_int : DINT;
    s4_0_target_int : DINT;
    s4_1_target_int : DINT;
    
    seq_counter : DINT := 0;
    lift_rdy : BOOL;
    all_home : BOOL;
    aligned : BOOL;
    port_rdy : BOOL;
    found_task : BOOL;
    cell3_is_processing : BOOL;
    cell4_is_processing : BOOL;
    cell3_ready_for_pickup : BOOL;
    cell4_ready_for_pickup : BOOL;
END_VAR

req_cancelled[0] := X31;
req_cancelled[1] := X35;
req_returned[0] := X30;
req_returned[1] := X34;

IF D100 > 0 AND NOT req_active[0] AND NOT req_returned[0] THEN
    req_active[0] := TRUE;
    req_id_mem[0] := D100;
    req_loc_mem[0] := D101;
    phy_loc[0] := 0;
    next_dest[0] := 1;
    cell3_done[0] := FALSE;
    cell4_done[0] := FALSE;
END_IF;

IF D120 > 0 AND NOT req_active[1] AND NOT req_returned[1] THEN
    req_active[1] := TRUE;
    req_id_mem[1] := D120;
    req_loc_mem[1] := D121;
    phy_loc[1] := 0;
    next_dest[1] := 1;
    cell3_done[1] := FALSE;
    cell4_done[1] := FALSE;
END_IF;

FOR i := 0 TO 1 DO
    IF req_active[i] THEN
        IF req_cancelled[i] THEN 
            next_dest[i] := 3; 
        END_IF;
        
        IF phy_loc[i] = 0 AND next_dest[i] = 3 THEN
            phy_loc[i] := 4;
        END_IF;

        IF phy_loc[i] = 4 THEN
            lift_rdy := FALSE;
            IF req_loc_mem[i] = 0 AND ABS(D1008 - 400) <= 20 AND ABS(D1009) <= 100 THEN lift_rdy := TRUE; END_IF;
            IF req_loc_mem[i] = 1 AND ABS(D1012 - 400) <= 20 AND ABS(D1013) <= 100 THEN lift_rdy := TRUE; END_IF;
            
            IF lift_rdy THEN
                IF i = 0 THEN
                    D300 := req_id_mem[0];
                    IF req_cancelled[0] THEN D301 := 2; ELSE D301 := 1; END_IF;
                ELSE
                    D302 := req_id_mem[1];
                    IF req_cancelled[1] THEN D303 := 2; ELSE D303 := 1; END_IF;
                END_IF;
            END_IF;
            
            IF req_returned[i] THEN
                req_active[i] := FALSE;
                IF i = 0 THEN D300 := 0; D301 := 0; ELSE D302 := 0; D303 := 0; END_IF;
            END_IF;
        END_IF;
    END_IF;
END_FOR;

cell3_is_processing := FALSE;
cell3_ready_for_pickup := FALSE;
FOR i := 0 TO 1 DO
    IF req_active[i] AND phy_loc[i] = 2 THEN
        cell3_is_processing := TRUE;
        IF req_cancelled[i] THEN cell3_done[i] := TRUE; END_IF;
        
        IF NOT cell3_done[i] THEN
            s3_1_target_int := D501;
            s3_2_target_int := D502;
            IF X70 THEN cell3_done[i] := TRUE; END_IF;
        ELSE
            s3_1_target_int := 0;
            s3_2_target_int := 0;
            IF ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
                cell3_ready_for_pickup := TRUE;
            END_IF;
        END_IF;
    END_IF;
END_FOR;

IF NOT cell3_is_processing THEN
    s3_1_target_int := 0;
    s3_2_target_int := 0;
END_IF;

cell4_is_processing := FALSE;
cell4_ready_for_pickup := FALSE;
FOR i := 0 TO 1 DO
    IF req_active[i] AND phy_loc[i] = 3 THEN
        cell4_is_processing := TRUE;
        IF req_cancelled[i] THEN cell4_done[i] := TRUE; END_IF;
        
        IF NOT cell4_done[i] THEN
            Y75 := TRUE;
            Y76 := TRUE;
            D710 := 700;
            IF X75 THEN cell4_done[i] := TRUE; END_IF;
        ELSE
            Y75 := FALSE;
            Y76 := FALSE;
            s4_0_target_int := 0;
            s4_1_target_int := 0;
            IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
                cell4_ready_for_pickup := TRUE;
            END_IF;
        END_IF;
    END_IF;
END_FOR;

IF NOT cell4_is_processing THEN
    Y75 := FALSE;
    Y76 := FALSE;
    s4_0_target_int := 0;
    s4_1_target_int := 0;
END_IF;

IF shuttle_state = 0 THEN
    found_task := FALSE;
    IF D90 > 0 THEN
        FOR i := 0 TO 1 DO
            IF NOT found_task AND req_active[i] AND req_id_mem[i] = D90 THEN
                shuttle_req := i;
                IF next_dest[i] = 1 THEN target_port := 3; END_IF;
                IF next_dest[i] = 2 THEN target_port := 4; END_IF;
                IF next_dest[i] = 3 THEN
                    IF req_loc_mem[i] = 0 THEN target_port := 1; ELSE target_port := 2; END_IF;
                END_IF;
                shuttle_task := 2;
                shuttle_state := 10;
                found_task := TRUE;
            END_IF;
        END_FOR;
    ELSE
        FOR i := 0 TO 1 DO
            IF NOT found_task AND req_active[i] THEN
                IF phy_loc[i] = 3 AND cell4_ready_for_pickup THEN
                    shuttle_req := i; target_port := 4; shuttle_task := 1; shuttle_state := 10; found_task := TRUE;
                ELSIF phy_loc[i] = 2 AND cell3_ready_for_pickup THEN
                    shuttle_req := i; target_port := 3; shuttle_task := 1; shuttle_state := 10; found_task := TRUE;
                ELSIF phy_loc[i] = 0 AND next_dest[i] <> 3 THEN
                    shuttle_req := i; 
                    IF req_loc_mem[i] = 0 THEN target_port := 1; ELSE target_port := 2; END_IF;
                    shuttle_task := 1; shuttle_state := 10; found_task := TRUE;
                END_IF;
            END_IF;
        END_FOR;
    END_IF;
END_IF;

IF shuttle_state = 10 THEN
    IF shuttle_task = 2 AND next_dest[shuttle_req] = 3 THEN
        IF req_loc_mem[shuttle_req] = 0 THEN target_port := 1; ELSE target_port := 2; END_IF;
    END_IF;

    IF target_port = 1 THEN a_target_int := D403; port_rdy := X61; END_IF;
    IF target_port = 2 THEN a_target_int := D406; port_rdy := X62; END_IF;
    IF target_port = 3 THEN a_target_int := D409; port_rdy := X63; END_IF;
    IF target_port = 4 THEN a_target_int := D412; port_rdy := X64; END_IF;
    
    aligned := (ABS(D1000 - a_target_int) <= 20) AND (ABS(D1001) <= 100);
    IF target_port = 1 THEN
        aligned := aligned AND (ABS(D1008 - 950) <= 20) AND (ABS(D1009) <= 100);
    END_IF;
    IF target_port = 2 THEN
        aligned := aligned AND (ABS(D1012 - 950) <= 20) AND (ABS(D1013) <= 100);
    END_IF;
    
    IF aligned AND port_rdy THEN
        shuttle_state := 11;
    END_IF;
END_IF;

IF shuttle_state = 11 THEN
    b_target_int := 180;
    IF ABS(D1004 - 180) <= 20 AND ABS(D1005) <= 100 THEN
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D81 := target_port;
        IF shuttle_task = 1 THEN D80 := 1; ELSE D80 := 2; END_IF;
        shuttle_state := 12;
    END_IF;
END_IF;

IF shuttle_state = 12 THEN
    IF shuttle_task = 1 THEN
        IF D90 = req_id_mem[shuttle_req] THEN
            phy_loc[shuttle_req] := 1;
            shuttle_state := 13;
        END_IF;
    ELSE
        IF D90 = 0 THEN
            IF target_port = 3 THEN 
                phy_loc[shuttle_req] := 2; 
                IF NOT req_cancelled[shuttle_req] THEN next_dest[shuttle_req] := 2; END_IF;
            END_IF;
            IF target_port = 4 THEN 
                phy_loc[shuttle_req] := 3; 
                IF NOT req_cancelled[shuttle_req] THEN next_dest[shuttle_req] := 3; END_IF;
            END_IF;
            IF target_port = 1 OR target_port = 2 THEN 
                phy_loc[shuttle_req] := 4; 
            END_IF;
            shuttle_state := 13;
        END_IF;
    END_IF;
END_IF;

IF shuttle_state = 13 THEN
    b_target_int := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        shuttle_state := 0;
    END_IF;
END_IF;

c_target_int := 400;
d_target_int := 400;
IF NOT X51 THEN
    IF shuttle_state >= 10 AND shuttle_state <= 13 THEN
        IF target_port = 1 THEN c_target_int := 950; END_IF;
        IF target_port = 2 THEN d_target_int := 950; END_IF;
    END_IF;
    Y44 := TRUE;
    Y71 := TRUE;
    Y30 := FALSE;
    Y2 := FALSE;
ELSE
    a_target_int := 0; 
    b_target_int := 0;
    s3_0_target_int := 0; 
    s3_1_target_int := 0; 
    s3_2_target_int := 0;
    s4_0_target_int := 0; 
    s4_1_target_int := 0;
    
    Y44 := TRUE;
    Y71 := FALSE;
    Y30 := TRUE;
    
    all_home := (ABS(D1000) <= 20) AND (ABS(D1004) <= 20) AND (ABS(D1008 - 400) <= 20) AND (ABS(D1012 - 400) <= 20) AND
                (ABS(D1016) <= 20) AND (ABS(D1020) <= 20) AND (ABS(D1024) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 20) AND
                (ABS(D1001) <= 100) AND (ABS(D1005) <= 100) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND
                (ABS(D1017) <= 100) AND (ABS(D1021) <= 100) AND (ABS(D1025) <= 100) AND (ABS(D1029) <= 100) AND (ABS(D1033) <= 100);
    
    IF all_home THEN
        Y2 := TRUE;
    END_IF;
END_IF;

D2000 := a_target_int;
D2004 := b_target_int;
D2008 := c_target_int;
D2012 := d_target_int;
D2016 := s3_0_target_int;
D2020 := s3_1_target_int;
D2024 := s3_2_target_int;
D2028 := s4_0_target_int;
D2032 := s4_1_target_int;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000;
D2029 := 1000; D2033 := 1000;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y45 := TRUE; Y46 := TRUE;
Y47 := TRUE; Y48 := TRUE;

END_PROGRAM