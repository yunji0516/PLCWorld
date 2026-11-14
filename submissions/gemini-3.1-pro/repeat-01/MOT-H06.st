PROGRAM Main
VAR
    first_scan : BOOL := TRUE;
    i : INT;
    
    id : ARRAY[0..1] OF DINT;
    loc : ARRAY[0..1] OF DINT;
    req_state : ARRAY[0..1] OF DINT;
    is_cancelled : ARRAY[0..1] OF BOOL;
    
    shuttle_owner : DINT;
    shuttle_cmd_station : DINT;
    shuttle_cmd_action : DINT;
    s_state : DINT;
    s_target_x : DINT;
    couple_triggered : BOOL;
    
    c3_id : DINT;
    c3_state : DINT;
    c3_cancelled : BOOL;
    cell3_status_id : DINT;
    cell3_status : DINT;
    
    c4_id : DINT;
    c4_state : DINT;
    c4_cancelled : BOOL;
    cell4_status_id : DINT;
    cell4_status : DINT;
    
    c_must_home, d_must_home : BOOL;
    c_target_req, d_target_req : DINT;
    lift_empty, port_has_us : BOOL;
    
    a_target_out, b_target_out : DINT;
    c_target_out, d_target_out : DINT;
    s3_0_target_out, s3_1_target_out : DINT;
    s4_0_target_out, s4_1_target_out : DINT;
    s4_2_target_out, s4_3_target_out : DINT;
END_VAR

IF first_scan THEN
    first_scan := FALSE;
    c_target_out := 15000;
    d_target_out := 15000;
    s3_1_target_out := 5000;
    s4_0_target_out := -6500;
    s4_2_target_out := 6500;
END_IF

(* Register new requests *)
IF req_state[0] = 0 AND D100 > 0 THEN
    id[0] := D100;
    loc[0] := D101;
    is_cancelled[0] := FALSE;
    req_state[0] := 1;
END_IF
IF req_state[1] = 0 AND D120 > 0 THEN
    id[1] := D120;
    loc[1] := D121;
    is_cancelled[1] := FALSE;
    req_state[1] := 1;
END_IF

(* Update cancellation flags *)
IF D100 > 0 AND D100 = id[0] AND X31 THEN is_cancelled[0] := TRUE; END_IF
IF D120 > 0 AND D120 = id[1] AND X35 THEN is_cancelled[1] := TRUE; END_IF

(* Request State Machine *)
FOR i := 0 TO 1 DO
    CASE req_state[i] OF
        1: (* Wait for lift dock *)
            IF is_cancelled[i] THEN
                req_state[i] := 19;
            ELSE
                IF loc[i] = 1 AND ABS(D1008 - 73250) <= 20 AND D404 = id[i] THEN
                    req_state[i] := 2;
                ELSIF loc[i] = 2 AND ABS(D1012 - 73250) <= 20 AND D407 = id[i] THEN
                    req_state[i] := 2;
                END_IF
            END_IF
        2: (* Claim shuttle to Extract from Lift *)
            port_has_us := FALSE;
            IF loc[i] = 1 AND D404 = id[i] THEN port_has_us := TRUE; END_IF
            IF loc[i] = 2 AND D407 = id[i] THEN port_has_us := TRUE; END_IF
            IF port_has_us THEN
                IF shuttle_owner = 0 OR shuttle_owner = id[i] THEN
                    shuttle_owner := id[i];
                    shuttle_cmd_station := loc[i];
                    shuttle_cmd_action := 1;
                    req_state[i] := 3;
                END_IF
            END_IF
        3: (* Wait Extract from Lift *)
            IF shuttle_cmd_action = 0 THEN
                req_state[i] := 4;
            END_IF
        4: (* Check cancellation before Cell 3 *)
            IF is_cancelled[i] THEN
                req_state[i] := 17;
            ELSE
                req_state[i] := 5;
            END_IF
        5: (* Claim shuttle to Place into Cell 3 *)
            IF D410 = 0 THEN
                IF shuttle_owner = 0 OR shuttle_owner = id[i] THEN
                    shuttle_owner := id[i];
                    shuttle_cmd_station := 3;
                    shuttle_cmd_action := 2;
                    req_state[i] := 6;
                END_IF
            END_IF
        6: (* Wait Place into Cell 3 *)
            IF shuttle_cmd_action = 0 THEN
                shuttle_owner := 0;
                req_state[i] := 7;
            END_IF
        7: (* Wait Cell 3 processing *)
            IF cell3_status_id = id[i] THEN
                IF cell3_status = 1 THEN
                    req_state[i] := 8;
                ELSIF cell3_status = 2 THEN
                    is_cancelled[i] := TRUE;
                    req_state[i] := 8;
                END_IF
            END_IF
        8: (* Claim shuttle to Extract from Cell 3 *)
            IF D410 = id[i] THEN
                IF shuttle_owner = 0 OR shuttle_owner = id[i] THEN
                    shuttle_owner := id[i];
                    shuttle_cmd_station := 3;
                    shuttle_cmd_action := 1;
                    req_state[i] := 9;
                END_IF
            END_IF
        9: (* Wait Extract from Cell 3 *)
            IF shuttle_cmd_action = 0 THEN
                req_state[i] := 10;
            END_IF
        10: (* Check cancellation before Cell 4 *)
            IF is_cancelled[i] THEN
                req_state[i] := 17;
            ELSE
                req_state[i] := 11;
            END_IF
        11: (* Claim shuttle to Place into Cell 4 *)
            IF D413 = 0 THEN
                IF shuttle_owner = 0 OR shuttle_owner = id[i] THEN
                    shuttle_owner := id[i];
                    shuttle_cmd_station := 4;
                    shuttle_cmd_action := 2;
                    req_state[i] := 12;
                END_IF
            END_IF
        12: (* Wait Place into Cell 4 *)
            IF shuttle_cmd_action = 0 THEN
                shuttle_owner := 0;
                req_state[i] := 13;
            END_IF
        13: (* Wait Cell 4 processing *)
            IF cell4_status_id = id[i] THEN
                IF cell4_status = 1 THEN
                    req_state[i] := 14;
                ELSIF cell4_status = 2 THEN
                    is_cancelled[i] := TRUE;
                    req_state[i] := 14;
                END_IF
            END_IF
        14: (* Claim shuttle to Extract from Cell 4 *)
            IF D413 = id[i] THEN
                IF shuttle_owner = 0 OR shuttle_owner = id[i] THEN
                    shuttle_owner := id[i];
                    shuttle_cmd_station := 4;
                    shuttle_cmd_action := 1;
                    req_state[i] := 15;
                END_IF
            END_IF
        15: (* Wait Extract from Cell 4 *)
            IF shuttle_cmd_action = 0 THEN
                req_state[i] := 16;
            END_IF
        16: (* Go to return *)
            req_state[i] := 17;
        17: (* Claim shuttle to Place to Lift *)
            lift_empty := FALSE;
            IF loc[i] = 1 AND D404 = 0 THEN lift_empty := TRUE; END_IF
            IF loc[i] = 2 AND D407 = 0 THEN lift_empty := TRUE; END_IF
            IF lift_empty THEN
                IF shuttle_owner = 0 OR shuttle_owner = id[i] THEN
                    shuttle_owner := id[i];
                    shuttle_cmd_station := loc[i];
                    shuttle_cmd_action := 2;
                    req_state[i] := 18;
                END_IF
            END_IF
        18: (* Wait Place to Lift *)
            IF shuttle_cmd_action = 0 THEN
                shuttle_owner := 0;
                req_state[i] := 19;
            END_IF
        19: (* Wait Lift Home *)
            IF loc[i] = 1 AND ABS(D1008 - 15000) <= 20 THEN
                req_state[i] := 20;
            ELSIF loc[i] = 2 AND ABS(D1012 - 15000) <= 20 THEN
                req_state[i] := 20;
            END_IF
        20: (* Output Completion and wait for clear *)
            IF i = 0 THEN
                D300 := id[0];
                D301 := SEL(is_cancelled[0], 1, 2);
                IF D100 <> id[0] THEN
                    req_state[0] := 0;
                    id[0] := 0;
                    D300 := 0;
                    D301 := 0;
                END_IF
            ELSE
                D302 := id[1];
                D303 := SEL(is_cancelled[1], 1, 2);
                IF D120 <> id[1] THEN
                    req_state[1] := 0;
                    id[1] := 0;
                    D302 := 0;
                    D303 := 0;
                END_IF
            END_IF
    END_CASE
END_FOR

(* Lift Targets *)
c_must_home := FALSE;
d_must_home := FALSE;
FOR i := 0 TO 1 DO
    IF req_state[i] >= 19 THEN
        IF loc[i] = 1 THEN c_must_home := TRUE; END_IF
        IF loc[i] = 2 THEN d_must_home := TRUE; END_IF
    END_IF
END_FOR

c_target_req := 15000;
d_target_req := 15000;
FOR i := 0 TO 1 DO
    IF req_state[i] >= 1 AND req_state[i] <= 18 THEN
        IF loc[i] = 1 AND NOT c_must_home THEN c_target_req := 73250; END_IF
        IF loc[i] = 2 AND NOT d_must_home THEN d_target_req := 73250; END_IF
    END_IF
END_FOR
c_target_out := c_target_req;
d_target_out := d_target_req;

(* Shuttle Execution Machine *)
IF shuttle_cmd_action > 0 THEN
    CASE s_state OF
        0:
            IF shuttle_cmd_station = 1 THEN s_target_x := D403; END_IF
            IF shuttle_cmd_station = 2 THEN s_target_x := D406; END_IF
            IF shuttle_cmd_station = 3 THEN s_target_x := D409; END_IF
            IF shuttle_cmd_station = 4 THEN s_target_x := D412; END_IF
            s_state := 1;
        1:
            a_target_out := s_target_x;
            b_target_out := 0;
            IF ABS(D1000 - s_target_x) <= 20 AND ABS(D1001) <= 100 AND ABS(D1004) <= 20 THEN
                s_state := 2;
            END_IF
        2:
            b_target_out := 18000;
            IF D1004 >= 17980 AND ABS(D1005) <= 100 THEN
                s_state := 3;
                couple_triggered := FALSE;
            END_IF
        3:
            IF NOT couple_triggered THEN
                D80 := shuttle_cmd_action;
                D81 := shuttle_cmd_station;
                D82 := D82 + 1;
                couple_triggered := TRUE;
            END_IF
            IF shuttle_cmd_action = 1 AND D90 = shuttle_owner THEN
                s_state := 4;
            ELSIF shuttle_cmd_action = 2 AND D90 = 0 THEN
                s_state := 4;
            END_IF
        4:
            b_target_out := 0;
            IF D1004 <= 20 AND ABS(D1005) <= 100 THEN
                s_state := 5;
            END_IF
        5:
            shuttle_cmd_action := 0;
            s_state := 0;
    END_CASE
END_IF

(* Cell 3 Logic *)
IF D410 > 0 THEN
    D700 := D410;
    Y70 := TRUE;
    Y71 := TRUE;
    IF c3_state = 0 THEN
        c3_id := D410;
        c3_state := 1;
    END_IF
ELSE
    Y70 := FALSE;
    Y71 := FALSE;
    c3_state := 0;
    c3_id := 0;
    cell3_status_id := 0;
    cell3_status := 0;
END_IF

c3_cancelled := FALSE;
IF c3_id > 0 THEN
    IF c3_id = id[0] AND is_cancelled[0] THEN c3_cancelled := TRUE; END_IF
    IF c3_id = id[1] AND is_cancelled[1] THEN c3_cancelled := TRUE; END_IF
END_IF

CASE c3_state OF
    1:
        c3_state := 2;
    2:
        s3_0_target_out := D500;
        s3_1_target_out := 5000;
        IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 THEN
            IF c3_cancelled THEN c3_state := 5; ELSE c3_state := 3; END_IF
        END_IF
    3:
        s3_1_target_out := 70000;
        IF X70 OR c3_cancelled THEN
            c3_state := 4;
        END_IF
    4:
        s3_1_target_out := 5000;
        IF D1020 <= 5020 AND ABS(D1021) <= 100 THEN
            c3_state := 5;
        END_IF
    5:
        s3_0_target_out := 0;
        IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
            c3_state := 6;
        END_IF
    6:
        cell3_status_id := c3_id;
        IF c3_cancelled THEN cell3_status := 2; ELSE cell3_status := 1; END_IF
END_CASE

(* Cell 4 Logic *)
IF D413 > 0 THEN
    D710 := D413;
    Y75 := TRUE;
    Y76 := TRUE;
    IF c4_state = 0 THEN
        c4_id := D413;
        c4_state := 1;
    END_IF
ELSE
    Y75 := FALSE;
    Y76 := FALSE;
    c4_state := 0;
    c4_id := 0;
    cell4_status_id := 0;
    cell4_status := 0;
END_IF

c4_cancelled := FALSE;
IF c4_id > 0 THEN
    IF c4_id = id[0] AND is_cancelled[0] THEN c4_cancelled := TRUE; END_IF
    IF c4_id = id[1] AND is_cancelled[1] THEN c4_cancelled := TRUE; END_IF
END_IF

CASE c4_state OF
    1:
        c4_state := 2;
    2:
        s4_0_target_out := D600;
        s4_2_target_out := D602;
        s4_1_target_out := 0;
        s4_3_target_out := 0;
        IF ABS(D1024 - D600) <= 20 AND ABS(D1032 - D602) <= 20 AND 
           ABS(D1025) <= 100 AND ABS(D1033) <= 100 THEN
            IF c4_cancelled THEN c4_state := 5; ELSE c4_state := 3; END_IF
        END_IF
    3:
        s4_1_target_out := D601;
        s4_3_target_out := D603;
        IF X75 OR c4_cancelled THEN
            c4_state := 4;
        END_IF
    4:
        s4_1_target_out := 0;
        s4_3_target_out := 0;
        IF D1028 <= 20 AND D1036 <= 20 AND ABS(D1029) <= 100 AND ABS(D1037) <= 100 THEN
            c4_state := 5;
        END_IF
    5:
        s4_0_target_out := -6500;
        s4_2_target_out := 6500;
        IF ABS(D1024 + 6500) <= 20 AND ABS(D1032 - 6500) <= 20 AND 
           ABS(D1025) <= 100 AND ABS(D1033) <= 100 THEN
            c4_state := 6;
        END_IF
    6:
        cell4_status_id := c4_id;
        IF c4_cancelled THEN cell4_status := 2; ELSE cell4_status := 1; END_IF
END_CASE

(* All Done Check *)
IF X51 AND req_state[0] = 0 AND req_state[1] = 0 THEN
    a_target_out := 0;
    b_target_out := 0;
    c_target_out := 15000;
    d_target_out := 15000;
    s3_0_target_out := 0;
    s3_1_target_out := 5000;
    s4_0_target_out := -6500;
    s4_1_target_out := 0;
    s4_2_target_out := 6500;
    s4_3_target_out := 0;
    
    IF ABS(D1000 - 0) <= 20 AND ABS(D1004 - 0) <= 20 AND
       ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND
       ABS(D1016 - 0) <= 20 AND ABS(D1020 - 5000) <= 20 AND
       ABS(D1024 - (-6500)) <= 20 AND ABS(D1028 - 0) <= 20 AND
       ABS(D1032 - 6500) <= 20 AND ABS(D1036 - 0) <= 20 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
ELSE
    Y2 := FALSE;
END_IF

(* Output clamping and assignment *)
a_target_out := LIMIT(-450000, a_target_out, 730000);
b_target_out := LIMIT(0, b_target_out, 18000);
c_target_out := LIMIT(0, c_target_out, 120000);
d_target_out := LIMIT(0, d_target_out, 120000);
s3_0_target_out := LIMIT(0, s3_0_target_out, 27000);
s3_1_target_out := LIMIT(0, s3_1_target_out, 74000);
s4_0_target_out := LIMIT(-9000, s4_0_target_out, 9000);
s4_1_target_out := LIMIT(0, s4_1_target_out, 65000);
s4_2_target_out := LIMIT(-9000, s4_2_target_out, 9000);
s4_3_target_out := LIMIT(0, s4_3_target_out, 65000);

D2000 := a_target_out;
D2004 := b_target_out;
D2008 := c_target_out;
D2012 := d_target_out;
D2016 := s3_0_target_out;
D2020 := s3_1_target_out;
D2024 := s4_0_target_out;
D2028 := s4_1_target_out;
D2032 := s4_2_target_out;
D2036 := s4_3_target_out;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000;
D2033 := 1000; D2037 := 1000;

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0;
D2034 := 0; D2038 := 0;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE;
Y48 := TRUE; Y49 := TRUE;
Y30 := FALSE;
END_PROGRAM