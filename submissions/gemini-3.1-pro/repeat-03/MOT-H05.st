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
    
    init : BOOL;
    state : DINT;
    req : DINT;
    id : DINT;
    loc : DINT;
    final_status : DINT;
    last_r0_id : DINT;
    last_r1_id : DINT;
    seq : DINT;
    
    a_target_val : DINT;
    b_target_val : DINT;
    c_target_val : DINT;
    d_target_val : DINT;
    s3_0_target_val : DINT;
    s3_1_target_val : DINT;
    s4_0_target_val : DINT;
    s4_1_target_val : DINT;
    s4_2_target_val : DINT;
    
    cancel_req : BOOL;
    port_ready : BOOL;
    lane3 : DINT;
    cap : DINT;
    lane4 : DINT;
    target_pos : DINT;
END_VAR

IF NOT init THEN
    init := TRUE;
    seq := 1;
    a_target_val := D1000;
    b_target_val := D1004;
    c_target_val := D1008;
    d_target_val := D1012;
    s3_0_target_val := D1016;
    s3_1_target_val := D1020;
    s4_0_target_val := D1024;
    s4_1_target_val := D1028;
    s4_2_target_val := D1032;
END_IF

cancel_req := (req = 0 AND X31) OR (req = 1 AND X35);
IF cancel_req THEN
    final_status := 2;
END_IF

IF final_status = 2 THEN
    IF state <= 2 AND D90 = 0 THEN
        state := 35;
    ELSIF state >= 6 AND state <= 7 THEN
        state := 30;
    ELSIF state = 18 THEN
        state := 30;
    ELSIF state >= 11 AND state <= 13 THEN
        state := 14;
    ELSIF state >= 22 AND state <= 24 THEN
        state := 25;
        Y71 := FALSE;
    END_IF
END_IF

CASE state OF
    0:
        IF D100 > 0 AND D100 <> last_r0_id THEN
            req := 0; id := D100; loc := D101; final_status := 1; state := 1;
        ELSIF D120 > 0 AND D120 <> last_r1_id THEN
            req := 1; id := D120; loc := D121; final_status := 1; state := 1;
        END_IF

    1:
        IF loc = 1 THEN c_target_val := 73250; ELSE d_target_val := 73250; END_IF
        IF (loc = 1 AND ABS(D1008 - 73250) <= 20) OR (loc = 2 AND ABS(D1012 - 73250) <= 20) THEN
            state := 2;
        END_IF

    2:
        a_target_val := SEL(loc = 1, D406, D403);
        IF ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100 THEN
            state := 3;
        END_IF

    3:
        b_target_val := 18000;
        port_ready := SEL(loc = 1, X62, X61);
        IF port_ready AND ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100 THEN
            seq := seq + 1; D82 := seq; D80 := 1; D81 := loc;
            state := 4;
        END_IF

    4:
        IF D90 = id THEN
            state := 5;
        END_IF

    5:
        b_target_val := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 6;
        END_IF

    6:
        IF loc = 1 THEN c_target_val := 15000; ELSE d_target_val := 15000; END_IF
        state := 7;

    7:
        a_target_val := D409;
        IF ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100 THEN
            state := 8;
        END_IF

    8:
        b_target_val := 18000;
        IF X63 AND ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
            seq := seq + 1; D82 := seq; D80 := 2; D81 := 3;
            state := 9;
        END_IF

    9:
        IF D90 = 0 THEN
            state := 10;
        END_IF

    10:
        b_target_val := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y70 := TRUE; D700 := id;
            state := 11;
        END_IF

    11:
        IF D522 = id THEN
            lane3 := D520;
            state := 12;
        END_IF

    12:
        IF lane3 = 0 THEN s3_0_target_val := 95000; ELSE s3_1_target_val := 95000; END_IF
        IF D524 = D91 AND D522 = id THEN
            cap := D523;
            state := 13;
        END_IF

    13:
        target_pos := cap + 25000;
        IF target_pos > 95000 THEN target_pos := 95000; END_IF
        IF lane3 = 0 THEN s3_0_target_val := target_pos; ELSE s3_1_target_val := target_pos; END_IF
        IF (lane3 = 0 AND ABS(D1016 - target_pos) <= 20 AND ABS(D1017) <= 100) OR 
           (lane3 = 1 AND ABS(D1020 - target_pos) <= 20 AND ABS(D1021) <= 100) THEN
            state := 14;
        END_IF

    14:
        Y71 := TRUE;
        s3_0_target_val := -60000;
        s3_1_target_val := -60000;
        IF ABS(D1016 - -60000) <= 20 AND ABS(D1017) <= 100 AND ABS(D1020 - -60000) <= 20 AND ABS(D1021) <= 100 THEN
            state := 15;
        END_IF

    15:
        a_target_val := D409;
        IF ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100 THEN
            b_target_val := 18000;
            IF X63 AND ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
                seq := seq + 1; D82 := seq; D80 := 1; D81 := 3;
                state := 16;
            END_IF
        END_IF

    16:
        IF D90 = id THEN
            state := 17;
        END_IF

    17:
        b_target_val := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 18;
        END_IF

    18:
        a_target_val := D412;
        IF ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100 THEN
            state := 19;
        END_IF

    19:
        b_target_val := 18000;
        IF X64 AND ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
            seq := seq + 1; D82 := seq; D80 := 2; D81 := 4;
            state := 20;
        END_IF

    20:
        IF D90 = 0 THEN
            state := 21;
        END_IF

    21:
        b_target_val := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y75 := TRUE; D710 := id;
            state := 22;
        END_IF

    22:
        s4_1_target_val := 0; s4_2_target_val := 0;
        IF D622 = id AND ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            lane4 := D620;
            state := 23;
        END_IF

    23:
        s4_0_target_val := D600;
        IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 THEN
            Y71 := FALSE;
            state := 24;
        END_IF

    24:
        IF lane4 = 0 THEN s4_1_target_val := 4000; ELSE s4_2_target_val := 4000; END_IF
        IF (lane4 = 0 AND ABS(D1028 - 4000) <= 20 AND ABS(D1029) <= 100) OR 
           (lane4 = 1 AND ABS(D1032 - 4000) <= 20 AND ABS(D1033) <= 100) THEN
            state := 25;
        END_IF

    25:
        s4_1_target_val := 0; s4_2_target_val := 0;
        IF ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
            state := 26;
        END_IF

    26:
        s4_0_target_val := 0;
        IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN
            Y75 := FALSE;
            state := 27;
        END_IF

    27:
        a_target_val := D412;
        IF ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100 THEN
            b_target_val := 18000;
            IF X64 AND ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
                seq := seq + 1; D82 := seq; D80 := 1; D81 := 4;
                state := 28;
            END_IF
        END_IF

    28:
        IF D90 = id THEN
            state := 29;
        END_IF

    29:
        b_target_val := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 30;
        END_IF

    30:
        Y71 := FALSE; Y75 := FALSE; Y70 := FALSE;
        IF loc = 1 THEN c_target_val := 73250; ELSE d_target_val := 73250; END_IF
        IF (loc = 1 AND ABS(D1008 - 73250) <= 20) OR (loc = 2 AND ABS(D1012 - 73250) <= 20) THEN
            state := 31;
        END_IF

    31:
        a_target_val := SEL(loc = 1, D406, D403);
        IF ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100 THEN
            state := 32;
        END_IF

    32:
        b_target_val := 18000;
        port_ready := SEL(loc = 1, X62, X61);
        IF port_ready AND ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100 THEN
            seq := seq + 1; D82 := seq; D80 := 2; D81 := loc;
            state := 33;
        END_IF

    33:
        IF D90 = 0 THEN
            state := 34;
        END_IF

    34:
        b_target_val := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 35;
        END_IF

    35:
        IF loc = 1 THEN c_target_val := 15000; ELSE d_target_val := 15000; END_IF
        IF (loc = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR 
           (loc = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
            state := 36;
        END_IF

    36:
        IF req = 0 THEN D300 := id; D301 := final_status; END_IF
        IF req = 1 THEN D302 := id; D303 := final_status; END_IF
        state := 37;

    37:
        IF req = 0 AND X30 THEN 
            last_r0_id := id; D300 := 0; D301 := 0; state := 0; 
        END_IF
        IF req = 1 AND X34 THEN 
            last_r1_id := id; D302 := 0; D303 := 0; state := 0; 
        END_IF
END_CASE

IF X51 AND state = 0 THEN
    a_target_val := 0;
    b_target_val := 0;
    c_target_val := 15000;
    d_target_val := 15000;
    s3_0_target_val := -60000;
    s3_1_target_val := -60000;
    s4_0_target_val := 0;
    s4_1_target_val := 0;
    s4_2_target_val := 0;
    
    IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND 
       ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND 
       ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND 
       ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND 
       ABS(D1016 - -60000) <= 20 AND ABS(D1017) <= 100 AND 
       ABS(D1020 - -60000) <= 20 AND ABS(D1021) <= 100 AND 
       ABS(D1024) <= 20 AND ABS(D1025) <= 100 AND 
       ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND 
       ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
ELSE
    Y2 := FALSE;
END_IF

D2000 := a_target_val;
D2004 := b_target_val;
D2008 := c_target_val;
D2012 := d_target_val;
D2016 := s3_0_target_val;
D2020 := s3_1_target_val;
D2024 := s4_0_target_val;
D2028 := s4_1_target_val;
D2032 := s4_2_target_val;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
Y30 := FALSE;
END_PROGRAM