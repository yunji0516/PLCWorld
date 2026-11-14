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

    last_r0_id : DINT := -1;
    last_r1_id : DINT := -1;
    done_r0 : BOOL := FALSE;
    done_r1 : BOOL := FALSE;
    req_idx : DINT := 0;
    r_id : DINT;
    r_loc : DINT;
    r_cancelled : BOOL;
    
    a_cmd : DINT := 0;
    b_cmd : DINT := 0;
    c_cmd : DINT := 15000;
    d_cmd : DINT := 15000;
    s3_0_cmd : DINT := -60000;
    s3_1_cmd : DINT := -60000;
    s4_0_cmd : DINT := 0;
    s4_1_cmd : DINT := 0;
    s4_2_cmd : DINT := 0;
    
    at_target_a : BOOL;
    at_target_b : BOOL;
    at_target_c : BOOL;
    at_target_d : BOOL;
    at_target_s3_0 : BOOL;
    at_target_s3_1 : BOOL;
    at_target_s4_0 : BOOL;
    at_target_s4_1 : BOOL;
    at_target_s4_2 : BOOL;

    state : DINT := 0;
    cancel_handled : BOOL := FALSE;
    is_cancelled : BOOL := FALSE;
    cancel_resume_state : DINT := 0;
    
    lane3 : DINT := 0;
    lane4 : DINT := 0;
    reg_vals : ARRAY[0..1] OF DINT;
    is_at_lift : BOOL;
    port_ready : BOOL;
    in_handoff : BOOL;
END_VAR

IF D100 <> last_r0_id THEN
    last_r0_id := D100;
    IF D100 <> 0 THEN done_r0 := FALSE; ELSE done_r0 := TRUE; END_IF;
    D300 := 0; D301 := 0;
END_IF;

IF D120 <> last_r1_id THEN
    last_r1_id := D120;
    IF D120 <> 0 THEN done_r1 := FALSE; ELSE done_r1 := TRUE; END_IF;
    D302 := 0; D303 := 0;
END_IF;

IF req_idx = 0 THEN
    r_id := D100;
    r_loc := D101;
    r_cancelled := X31;
ELSE
    r_id := D120;
    r_loc := D121;
    r_cancelled := X35;
END_IF;

in_handoff := (state = 4 OR state = 9 OR state = 141 OR state = 19 OR state = 251 OR state = 30);

IF state > 0 AND state < 32 AND r_cancelled AND NOT cancel_handled AND NOT in_handoff THEN
    cancel_handled := TRUE;
    is_cancelled := TRUE;
    IF D90 = r_id THEN
        cancel_resume_state := 4;
    ELSE
        IF state >= 1 AND state <= 5 THEN
            cancel_resume_state := 1;
        ELSIF state >= 6 AND state <= 15 THEN
            cancel_resume_state := 2;
        ELSIF state >= 16 AND state <= 26 THEN
            cancel_resume_state := 3;
        ELSE
            cancel_resume_state := 4;
        END_IF;
    END_IF;
    state := 90;
END_IF;

at_target_a := ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100;
at_target_b := ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100;
at_target_c := ABS(D1008 - c_cmd) <= 20 AND ABS(D1009) <= 100;
at_target_d := ABS(D1012 - d_cmd) <= 20 AND ABS(D1013) <= 100;
at_target_s3_0 := ABS(D1016 - s3_0_cmd) <= 20 AND ABS(D1017) <= 100;
at_target_s3_1 := ABS(D1020 - s3_1_cmd) <= 20 AND ABS(D1021) <= 100;
at_target_s4_0 := ABS(D1024 - s4_0_cmd) <= 20 AND ABS(D1025) <= 100;
at_target_s4_1 := ABS(D1028 - s4_1_cmd) <= 20 AND ABS(D1029) <= 100;
at_target_s4_2 := ABS(D1032 - s4_2_cmd) <= 20 AND ABS(D1033) <= 100;

CASE state OF
    0:
        IF NOT done_r0 AND D100 <> 0 THEN
            req_idx := 0; 
            state := 1; 
            is_cancelled := FALSE; 
            cancel_handled := FALSE;
        ELSIF NOT done_r1 AND D120 <> 0 THEN
            req_idx := 1; 
            state := 1; 
            is_cancelled := FALSE; 
            cancel_handled := FALSE;
        ELSIF done_r0 AND done_r1 AND X51 THEN
            a_cmd := 0;
            b_cmd := 0;
            c_cmd := 15000;
            d_cmd := 15000;
            s3_0_cmd := -60000;
            s3_1_cmd := -60000;
            s4_0_cmd := 0;
            s4_1_cmd := 0;
            s4_2_cmd := 0;
            IF at_target_a AND at_target_b AND at_target_c AND at_target_d AND at_target_s3_0 AND at_target_s3_1 AND at_target_s4_0 AND at_target_s4_1 AND at_target_s4_2 THEN
                Y2 := TRUE;
            ELSE
                Y2 := FALSE;
            END_IF;
        END_IF;
        
        IF NOT X51 OR NOT (done_r0 AND done_r1) THEN
            Y2 := FALSE;
        END_IF;

    1:
        IF r_loc = 1 THEN c_cmd := D92; ELSE d_cmd := D92; END_IF;
        IF (r_loc = 1 AND at_target_c) OR (r_loc = 2 AND at_target_d) THEN 
            state := 2; 
        END_IF;

    2:
        IF r_loc = 1 THEN 
            a_cmd := D403; 
            port_ready := X61;
        ELSE 
            a_cmd := D406; 
            port_ready := X62;
        END_IF;
        IF at_target_a AND port_ready THEN 
            state := 3; 
        END_IF;

    3:
        b_cmd := 18000;
        IF at_target_b THEN
            D80 := 1; 
            D81 := r_loc; 
            D82 := D82 + 1; 
            state := 4;
        END_IF;

    4:
        IF D90 = r_id THEN 
            state := 5; 
        END_IF;

    5:
        b_cmd := 0;
        IF at_target_b THEN 
            state := 6; 
        END_IF;

    6:
        a_cmd := D409;
        IF at_target_a AND X63 THEN 
            state := 7; 
        END_IF;

    7:
        b_cmd := 18000;
        IF at_target_b THEN
            D80 := 2; 
            D81 := 3; 
            D82 := D82 + 1; 
            state := 9;
        END_IF;

    9:
        IF D90 = 0 THEN 
            state := 10; 
        END_IF;

    10:
        b_cmd := 0;
        IF at_target_b THEN
            state := 101;
            lane3 := D520;
        END_IF;

    101:
        D700 := r_id;
        IF lane3 = 0 THEN s3_0_cmd := 95000; ELSE s3_1_cmd := 95000; END_IF;
        IF D522 = r_id THEN
            reg_vals[req_idx] := D523;
            state := 102;
        END_IF;

    102:
        IF lane3 = 0 THEN s3_0_cmd := reg_vals[req_idx] + 25000; ELSE s3_1_cmd := reg_vals[req_idx] + 25000; END_IF;
        IF ((lane3 = 0 AND at_target_s3_0) OR (lane3 = 1 AND at_target_s3_1)) AND X70 THEN
            state := 12;
        END_IF;

    12:
        s3_0_cmd := -60000; 
        s3_1_cmd := -60000;
        IF at_target_s3_0 AND at_target_s3_1 THEN 
            state := 13; 
        END_IF;

    13:
        a_cmd := D409;
        IF at_target_a AND X63 THEN
            b_cmd := 18000;
            IF at_target_b THEN
                D80 := 1; 
                D81 := 3; 
                D82 := D82 + 1; 
                state := 141;
            END_IF;
        END_IF;

    141:
        IF D90 = r_id THEN 
            state := 15; 
        END_IF;

    15:
        b_cmd := 0;
        IF at_target_b THEN 
            state := 16; 
        END_IF;

    16:
        a_cmd := D412;
        IF at_target_a AND X64 THEN 
            state := 17; 
        END_IF;

    17:
        b_cmd := 18000;
        IF at_target_b THEN
            D80 := 2; 
            D81 := 4; 
            D82 := D82 + 1; 
            state := 19;
        END_IF;

    19:
        IF D90 = 0 THEN 
            state := 20; 
        END_IF;

    20:
        b_cmd := 0;
        IF at_target_b THEN
            state := 201;
            lane4 := D620;
        END_IF;

    201:
        D710 := r_id;
        s4_0_cmd := reg_vals[req_idx];
        s4_1_cmd := 0; 
        s4_2_cmd := 0;
        IF at_target_s4_0 AND at_target_s4_1 AND at_target_s4_2 THEN 
            state := 21; 
        END_IF;

    21:
        IF lane4 = 0 THEN s4_1_cmd := 4000; ELSE s4_2_cmd := 4000; END_IF;
        IF ((lane4 = 0 AND at_target_s4_1) OR (lane4 = 1 AND at_target_s4_2)) AND X75 THEN
            state := 22;
        END_IF;

    22:
        s4_1_cmd := 0; 
        s4_2_cmd := 0;
        IF at_target_s4_1 AND at_target_s4_2 THEN 
            state := 23; 
        END_IF;

    23:
        s4_0_cmd := 0;
        IF at_target_s4_0 THEN 
            state := 24; 
        END_IF;

    24:
        a_cmd := D412;
        IF at_target_a AND X64 THEN
            b_cmd := 18000;
            IF at_target_b THEN
                D80 := 1; 
                D81 := 4; 
                D82 := D82 + 1; 
                state := 251;
            END_IF;
        END_IF;

    251:
        IF D90 = r_id THEN 
            state := 26; 
        END_IF;

    26:
        b_cmd := 0;
        IF at_target_b THEN 
            state := 27; 
        END_IF;

    27:
        IF r_loc = 1 THEN 
            a_cmd := D403; 
            port_ready := X61;
        ELSE 
            a_cmd := D406; 
            port_ready := X62;
        END_IF;
        IF at_target_a AND port_ready THEN 
            state := 28; 
        END_IF;

    28:
        b_cmd := 18000;
        IF at_target_b THEN
            D80 := 2; 
            D81 := r_loc; 
            D82 := D82 + 1; 
            state := 30;
        END_IF;

    30:
        IF D90 = 0 THEN 
            state := 301; 
        END_IF;

    301:
        b_cmd := 0;
        IF at_target_b THEN 
            state := 31; 
        END_IF;

    31:
        IF r_loc = 1 THEN 
            c_cmd := 15000; 
            is_at_lift := at_target_c;
        ELSE 
            d_cmd := 15000; 
            is_at_lift := at_target_d;
        END_IF;
        IF is_at_lift THEN 
            state := 32; 
        END_IF;

    32:
        IF req_idx = 0 THEN
            D300 := r_id; 
            IF is_cancelled THEN D301 := 2; ELSE D301 := 1; END_IF;
            done_r0 := TRUE;
        ELSE
            D302 := r_id; 
            IF is_cancelled THEN D303 := 2; ELSE D303 := 1; END_IF;
            done_r1 := TRUE;
        END_IF;
        state := 0;

    90:
        b_cmd := 0;
        IF at_target_b THEN
            IF cancel_resume_state = 1 THEN state := 31;
            ELSIF cancel_resume_state = 2 THEN state := 12;
            ELSIF cancel_resume_state = 3 THEN state := 22;
            ELSIF cancel_resume_state = 4 THEN state := 27;
            END_IF;
        END_IF;
END_CASE;

D2001 := 1000; Y40 := TRUE;
D2005 := 1000; Y41 := TRUE;
D2009 := 1000; Y42 := TRUE;
D2013 := 1000; Y43 := TRUE;
D2017 := 1000; Y44 := TRUE;
D2021 := 1000; Y45 := TRUE;
D2025 := 1000; Y46 := TRUE;
D2029 := 1000; Y47 := TRUE;
D2033 := 1000; Y48 := TRUE;

D2000 := a_cmd;
D2004 := b_cmd;
D2008 := c_cmd;
D2012 := d_cmd;
D2016 := s3_0_cmd;
D2020 := s3_1_cmd;
D2024 := s4_0_cmd;
D2028 := s4_1_cmd;
D2032 := s4_2_cmd;

Y30 := FALSE;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;

END_PROGRAM