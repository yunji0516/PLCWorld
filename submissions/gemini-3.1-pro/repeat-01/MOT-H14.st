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

    init : BOOL;
    i : DINT;
    other_in_lift : BOOL;
    
    req_id_arr : ARRAY[0..1] OF DINT;
    req_loc_arr : ARRAY[0..1] OF DINT;
    req_cancel_arr : ARRAY[0..1] OF BOOL;
    ack_out_arr : ARRAY[0..1] OF DINT;
    status_out_arr : ARRAY[0..1] OF DINT;
    r_state : ARRAY[0..1] OF DINT;
    is_cancelled : ARRAY[0..1] OF BOOL;
    
    ShuttleOwner : DINT;
    Cell3Owner : DINT;
    Cell4Owner : DINT;
    LiftOwner : ARRAY[1..2] OF DINT;
    
    a_req_target : ARRAY[0..1] OF DINT;
    b_req_target : ARRAY[0..1] OF DINT;
    c_req_target : ARRAY[0..1] OF DINT;
    d_req_target : ARRAY[0..1] OF DINT;
    
    s3_0_req : ARRAY[0..1] OF DINT;
    s3_1_req : ARRAY[0..1] OF DINT;
    Y70_req : ARRAY[0..1] OF BOOL;
    m3_select_req : ARRAY[0..1] OF DINT;
    
    s4_0_req : ARRAY[0..1] OF DINT;
    s4_1_req : ARRAY[0..1] OF DINT;
    m4_select_req : ARRAY[0..1] OF DINT;
    
    D81_req : ARRAY[0..1] OF DINT;
    D80_req : ARRAY[0..1] OF DINT;
    trigger_handover : ARRAY[0..1] OF BOOL;

    req_id : DINT;
    req_loc : DINT;
    req_cancel : BOOL;
END_VAR

IF NOT init THEN
    init := TRUE;
    c_req_target[0] := 15000; c_req_target[1] := 15000;
    d_req_target[0] := 15000; d_req_target[1] := 15000;
    s3_0_req[0] := -60000; s3_0_req[1] := -60000;
    s3_1_req[0] := -60000; s3_1_req[1] := -60000;
    s4_0_req[0] := -60000; s4_0_req[1] := -60000;
    s4_1_req[0] := -60000; s4_1_req[1] := -60000;
END_IF;

req_id_arr[0] := D100;
req_id_arr[1] := D120;
req_loc_arr[0] := D101;
req_loc_arr[1] := D121;
req_cancel_arr[0] := X31;
req_cancel_arr[1] := X35;

FOR i := 0 TO 1 DO
    req_id := req_id_arr[i];
    req_loc := req_loc_arr[i];
    req_cancel := req_cancel_arr[i];

    IF req_cancel AND NOT is_cancelled[i] AND r_state[i] > 0 AND r_state[i] < 50 THEN
        IF r_state[i] <> 5 AND r_state[i] <> 11 AND r_state[i] <> 21 AND r_state[i] <> 27 AND r_state[i] <> 37 AND r_state[i] <> 43 THEN
            is_cancelled[i] := TRUE;
            IF D90 = req_id THEN
                r_state[i] := 101;
            ELSIF Cell4Owner = (i + 1) THEN
                r_state[i] := 32;
            ELSIF Cell3Owner = (i + 1) THEN
                r_state[i] := 16;
            ELSE
                IF ShuttleOwner = (i + 1) THEN ShuttleOwner := 0; END_IF;
                r_state[i] := 103;
            END_IF;
        END_IF;
    END_IF;

    CASE r_state[i] OF
        0:
            IF req_id > 0 AND ack_out_arr[i] <> req_id THEN
                is_cancelled[i] := FALSE;
                IF req_cancel THEN
                    ack_out_arr[i] := req_id;
                    status_out_arr[i] := 2;
                ELSE
                    r_state[i] := 1;
                END_IF;
            END_IF;
            
        1:
            IF ShuttleOwner = 0 AND LiftOwner[req_loc] = 0 AND Cell3Owner = 0 THEN
                ShuttleOwner := i + 1;
                LiftOwner[req_loc] := i + 1;
                a_req_target[i] := SEL(req_loc = 1, D406, D403);
                IF req_loc = 1 THEN c_req_target[i] := 73250; ELSE d_req_target[i] := 73250; END_IF;
                r_state[i] := 2;
            END_IF;
            
        2:
            IF ABS(D1000 - a_req_target[i]) <= 20 AND ABS(D1001) <= 100 THEN
                IF (req_loc = 1 AND ABS(D1008 - 73250) <= 20 AND ABS(D1009) <= 100) OR
                   (req_loc = 2 AND ABS(D1012 - 73250) <= 20 AND ABS(D1013) <= 100) THEN
                    b_req_target[i] := 18000;
                    r_state[i] := 3;
                END_IF;
            END_IF;
            
        3:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D81_req[i] := req_loc;
                D80_req[i] := 1;
                trigger_handover[i] := TRUE;
                r_state[i] := 4;
            END_IF;
            
        4:
            r_state[i] := 5;
            
        5:
            IF D90 = req_id THEN
                b_req_target[i] := 0;
                r_state[i] := 6;
            END_IF;
            
        6:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                LiftOwner[req_loc] := 0;
                r_state[i] := 7;
            END_IF;
            
        7:
            IF Cell3Owner = 0 THEN
                Cell3Owner := i + 1;
                a_req_target[i] := D409;
                r_state[i] := 8;
            END_IF;
            
        8:
            IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
                b_req_target[i] := 18000;
                r_state[i] := 9;
            END_IF;
            
        9:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D81_req[i] := 3;
                D80_req[i] := 2;
                trigger_handover[i] := TRUE;
                r_state[i] := 10;
            END_IF;
            
        10:
            r_state[i] := 11;
            
        11:
            IF D90 = 0 THEN
                b_req_target[i] := 0;
                r_state[i] := 12;
            END_IF;
            
        12:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                ShuttleOwner := 0;
                m3_select_req[i] := req_id;
                r_state[i] := 13;
            END_IF;
            
        13:
            IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND ABS(D1020 - (-60000)) <= 20 AND ABS(D1021) <= 100 THEN
                Y70_req[i] := TRUE;
                r_state[i] := 14;
            END_IF;
            
        14:
            Y70_req[i] := FALSE;
            s3_0_req[i] := D500;
            s3_1_req[i] := D501;
            r_state[i] := 15;
            
        15:
            IF X70 THEN
                s3_0_req[i] := -60000;
                s3_1_req[i] := -60000;
                r_state[i] := 16;
            END_IF;
            
        16:
            IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
                r_state[i] := 17;
            END_IF;
            
        17:
            IF ShuttleOwner = 0 AND Cell4Owner = 0 THEN
                ShuttleOwner := i + 1;
                a_req_target[i] := D409;
                r_state[i] := 18;
            END_IF;
            
        18:
            IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
                b_req_target[i] := 18000;
                r_state[i] := 19;
            END_IF;
            
        19:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D81_req[i] := 3;
                D80_req[i] := 1;
                trigger_handover[i] := TRUE;
                r_state[i] := 20;
            END_IF;
            
        20:
            r_state[i] := 21;
            
        21:
            IF D90 = req_id THEN
                b_req_target[i] := 0;
                r_state[i] := 22;
            END_IF;
            
        22:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                Cell3Owner := 0;
                r_state[i] := 23;
            END_IF;
            
        23:
            IF Cell4Owner = 0 THEN
                Cell4Owner := i + 1;
                a_req_target[i] := D412;
                r_state[i] := 24;
            END_IF;
            
        24:
            IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
                b_req_target[i] := 18000;
                r_state[i] := 25;
            END_IF;
            
        25:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D81_req[i] := 4;
                D80_req[i] := 2;
                trigger_handover[i] := TRUE;
                r_state[i] := 26;
            END_IF;
            
        26:
            r_state[i] := 27;
            
        27:
            IF D90 = 0 THEN
                b_req_target[i] := 0;
                r_state[i] := 28;
            END_IF;
            
        28:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                ShuttleOwner := 0;
                m4_select_req[i] := req_id;
                s4_0_req[i] := D600;
                s4_1_req[i] := D601;
                r_state[i] := 29;
            END_IF;
            
        29:
            r_state[i] := 30;
            
        30:
            IF D624 = D91 AND D622 = req_id THEN
                s4_0_req[i] := D623 + 25000;
                s4_1_req[i] := D623 + 25000;
                r_state[i] := 31;
            END_IF;
            IF X75 THEN 
                s4_0_req[i] := -60000;
                s4_1_req[i] := -60000;
                r_state[i] := 32; 
            END_IF;
            
        31:
            IF X75 THEN
                s4_0_req[i] := -60000;
                s4_1_req[i] := -60000;
                r_state[i] := 32;
            END_IF;
            
        32:
            IF ABS(D1024 - (-60000)) <= 20 AND ABS(D1028 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100 THEN
                r_state[i] := 33;
            END_IF;
            
        33:
            other_in_lift := (r_state[1 - i] >= 1 AND r_state[1 - i] <= 5 AND req_loc_arr[1 - i] = req_loc);
            IF ShuttleOwner = 0 AND LiftOwner[req_loc] = 0 AND NOT other_in_lift THEN
                ShuttleOwner := i + 1;
                a_req_target[i] := D412;
                r_state[i] := 34;
            END_IF;
            
        34:
            IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
                b_req_target[i] := 18000;
                r_state[i] := 35;
            END_IF;
            
        35:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D81_req[i] := 4;
                D80_req[i] := 1;
                trigger_handover[i] := TRUE;
                r_state[i] := 36;
            END_IF;
            
        36:
            r_state[i] := 37;
            
        37:
            IF D90 = req_id THEN
                b_req_target[i] := 0;
                r_state[i] := 38;
            END_IF;
            
        38:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                Cell4Owner := 0;
                r_state[i] := 39;
            END_IF;
            
        39:
            IF LiftOwner[req_loc] = 0 THEN
                LiftOwner[req_loc] := i + 1;
                a_req_target[i] := SEL(req_loc = 1, D406, D403);
                IF req_loc = 1 THEN c_req_target[i] := 73250; ELSE d_req_target[i] := 73250; END_IF;
                r_state[i] := 40;
            END_IF;
            
        40:
            IF ABS(D1000 - a_req_target[i]) <= 20 AND ABS(D1001) <= 100 THEN
                IF (req_loc = 1 AND ABS(D1008 - 73250) <= 20 AND ABS(D1009) <= 100) OR
                   (req_loc = 2 AND ABS(D1012 - 73250) <= 20 AND ABS(D1013) <= 100) THEN
                    b_req_target[i] := 18000;
                    r_state[i] := 41;
                END_IF;
            END_IF;
            
        41:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D81_req[i] := req_loc;
                D80_req[i] := 2;
                trigger_handover[i] := TRUE;
                r_state[i] := 42;
            END_IF;
            
        42:
            r_state[i] := 43;
            
        43:
            IF D90 = 0 THEN
                b_req_target[i] := 0;
                r_state[i] := 44;
            END_IF;
            
        44:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                ShuttleOwner := 0;
                IF req_loc = 1 THEN c_req_target[i] := 15000; ELSE d_req_target[i] := 15000; END_IF;
                r_state[i] := 45;
            END_IF;
            
        45:
            IF (req_loc = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
               (req_loc = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
                r_state[i] := 46;
            END_IF;
            
        46:
            ack_out_arr[i] := req_id;
            status_out_arr[i] := SEL(is_cancelled[i], 1, 2);
            LiftOwner[req_loc] := 0;
            r_state[i] := 47;
            
        47:
            IF req_id = 0 OR req_id <> ack_out_arr[i] THEN
                r_state[i] := 0;
                ack_out_arr[i] := 0;
                status_out_arr[i] := 0;
            END_IF;
            
        101:
            b_req_target[i] := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                IF Cell3Owner = (i + 1) THEN Cell3Owner := 0; END_IF;
                IF Cell4Owner = (i + 1) THEN Cell4Owner := 0; END_IF;
                r_state[i] := 39;
            END_IF;
            
        103:
            IF LiftOwner[req_loc] = 0 OR LiftOwner[req_loc] = (i + 1) THEN
                LiftOwner[req_loc] := i + 1;
                IF req_loc = 1 THEN c_req_target[i] := 15000; ELSE d_req_target[i] := 15000; END_IF;
                r_state[i] := 104;
            END_IF;
            
        104:
            IF (req_loc = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
               (req_loc = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
                r_state[i] := 46;
            END_IF;
    END_CASE;
END_FOR;

IF trigger_handover[0] THEN
    D81 := D81_req[0];
    D80 := D80_req[0];
    D82 := D82 + 1;
    trigger_handover[0] := FALSE;
ELSIF trigger_handover[1] THEN
    D81 := D81_req[1];
    D80 := D80_req[1];
    D82 := D82 + 1;
    trigger_handover[1] := FALSE;
END_IF;

IF ShuttleOwner = 1 THEN
    D2000 := a_req_target[0];
    D2004 := b_req_target[0];
ELSIF ShuttleOwner = 2 THEN
    D2000 := a_req_target[1];
    D2004 := b_req_target[1];
ELSE
    D2004 := 0;
END_IF;

IF LiftOwner[1] = 1 THEN
    D2008 := c_req_target[0];
ELSIF LiftOwner[1] = 2 THEN
    D2008 := c_req_target[1];
ELSE
    D2008 := 15000;
END_IF;

IF LiftOwner[2] = 1 THEN
    D2012 := d_req_target[0];
ELSIF LiftOwner[2] = 2 THEN
    D2012 := d_req_target[1];
ELSE
    D2012 := 15000;
END_IF;

IF Cell3Owner = 1 THEN
    D2016 := s3_0_req[0];
    D2020 := s3_1_req[0];
    Y70 := Y70_req[0];
    D700 := m3_select_req[0];
ELSIF Cell3Owner = 2 THEN
    D2016 := s3_0_req[1];
    D2020 := s3_1_req[1];
    Y70 := Y70_req[1];
    D700 := m3_select_req[1];
ELSE
    D2016 := -60000;
    D2020 := -60000;
    Y70 := FALSE;
END_IF;

IF Cell4Owner = 1 THEN
    D2024 := s4_0_req[0];
    D2028 := s4_1_req[0];
    D710 := m4_select_req[0];
ELSIF Cell4Owner = 2 THEN
    D2024 := s4_0_req[1];
    D2028 := s4_1_req[1];
    D710 := m4_select_req[1];
ELSE
    D2024 := -60000;
    D2028 := -60000;
END_IF;

D300 := ack_out_arr[0];
D301 := status_out_arr[0];
D302 := ack_out_arr[1];
D303 := status_out_arr[1];

D2001 := 1000; Y40 := TRUE;
D2005 := 1000; Y41 := TRUE;
D2009 := 1000; Y42 := TRUE;
D2013 := 1000; Y43 := TRUE;
D2017 := 1000; Y44 := TRUE;
D2021 := 1000; Y45 := TRUE;
D2025 := 1000; Y46 := TRUE;
D2029 := 1000; Y47 := TRUE;

Y30 := FALSE;
Y71 := FALSE;
Y76 := FALSE;

Y2 := X51 AND r_state[0] = 0 AND r_state[1] = 0 AND 
      ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND 
      ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND
      ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 AND
      ABS(D1024 - (-60000)) <= 20 AND ABS(D1028 - (-60000)) <= 20 AND
      ABS(D1001) <= 100 AND ABS(D1005) <= 100 AND 
      ABS(D1009) <= 100 AND ABS(D1013) <= 100 AND
      ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND 
      ABS(D1025) <= 100 AND ABS(D1029) <= 100;

END_PROGRAM
```