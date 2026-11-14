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
    D1040 : DINT;
    D1041 : DINT;
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
    D503 : DINT;
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
    D2040 : DINT;
    D2041 : DINT;
    D2042 : DINT;
    Y50 : BOOL;
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

    init_done : BOOL;
    state : DINT;
    seq : DINT := 1;
    req_idx : DINT;
    req_id : DINT;
    req_loc : DINT;
    req_cancelled : BOOL;
    
    a_target : DINT;
    b_target : DINT;
    c_target : DINT;
    d_target : DINT;
    s3_0_target : DINT;
    s3_1_target : DINT;
    s3_2_target : DINT;
    s3_3_target : DINT;
    s4_0_target : DINT;
    s4_1_target : DINT;
    s4_2_target : DINT;
END_VAR

IF NOT init_done THEN
    a_target := D1000;
    b_target := D1004;
    c_target := D1008;
    d_target := D1012;
    s3_0_target := D1016;
    s3_1_target := D1020;
    s3_2_target := D1024;
    s3_3_target := D1028;
    s4_0_target := D1032;
    s4_1_target := D1036;
    s4_2_target := D1040;
    init_done := TRUE;
END_IF;

IF req_idx = 0 THEN
    req_cancelled := X31;
ELSE
    req_cancelled := X35;
END_IF;

CASE state OF
    0:
        IF D100 > 0 AND NOT X30 THEN
            req_idx := 0;
            req_id := D100;
            req_loc := D101;
            state := 1;
        ELSIF D120 > 0 AND NOT X34 THEN
            req_idx := 1;
            req_id := D120;
            req_loc := D121;
            state := 1;
        ELSIF X51 THEN
            state := 100;
        END_IF;

    1:
        c_target := 95000;
        d_target := 95000;
        IF req_loc = 1 THEN a_target := -405000; ELSE a_target := -185000; END_IF;
        b_target := 0;
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1008 - 95000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 95000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 2;
        END_IF;

    2:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq := seq + 1;
            D80 := 1;
            D81 := req_loc;
            D82 := seq;
            state := 3;
        END_IF;

    3:
        IF D90 = req_id THEN
            state := 4;
        END_IF;

    4:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF req_cancelled THEN
                state := 19;
            ELSE
                state := 5;
            END_IF;
        END_IF;

    5:
        a_target := 0;
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 THEN
            state := 6;
        END_IF;

    6:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq := seq + 1;
            D80 := 2;
            D81 := 3;
            D82 := seq;
            state := 7;
        END_IF;

    7:
        IF D90 = 0 THEN
            state := 8;
        END_IF;

    8:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 9;
        END_IF;

    9:
        D700 := req_id;
        Y70 := TRUE;
        Y71 := TRUE;
        s3_0_target := D500;
        s3_2_target := D502;
        IF ABS(D1016 - D500) <= 20 AND ABS(D1024 - D502) <= 20 THEN
            state := 10;
        END_IF;
        IF req_cancelled THEN state := 12; END_IF;

    10:
        s3_1_target := D501;
        s3_3_target := D503;
        IF ABS(D1020 - D501) <= 20 AND ABS(D1028 - D503) <= 20 THEN
            state := 11;
        END_IF;
        IF req_cancelled THEN state := 12; END_IF;

    11:
        IF X70 OR req_cancelled THEN
            state := 12;
        END_IF;

    12:
        s3_1_target := 0;
        s3_3_target := 0;
        IF D1020 <= 8000 AND D1028 <= 8000 THEN
            state := 13;
        END_IF;

    13:
        s3_0_target := -6500;
        s3_2_target := 6500;
        IF ABS(D1016 - -6500) <= 20 AND ABS(D1024 - 6500) <= 20 THEN
            state := 14;
        END_IF;

    14:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq := seq + 1;
            D80 := 1;
            D81 := 3;
            D82 := seq;
            state := 15;
        END_IF;

    15:
        IF D90 = req_id THEN
            state := 16;
        END_IF;

    16:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF req_cancelled THEN
                state := 19;
            ELSE
                state := 17;
            END_IF;
        END_IF;

    17:
        a_target := 670000;
        IF ABS(D1000 - 670000) <= 20 AND ABS(D1001) <= 100 THEN
            state := 171;
        END_IF;

    171:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq := seq + 1;
            D80 := 2;
            D81 := 4;
            D82 := seq;
            state := 172;
        END_IF;

    172:
        IF D90 = 0 THEN
            state := 173;
        END_IF;

    173:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 174;
        END_IF;

    174:
        D710 := req_id;
        Y75 := TRUE;
        Y76 := TRUE;
        IF D602 > 22000 THEN
            s4_2_target := D602;
        ELSE
            s4_2_target := 22000;
        END_IF;
        IF ABS(D1040 - s4_2_target) <= 20 THEN
            state := 175;
        END_IF;
        IF req_cancelled THEN state := 178; END_IF;

    175:
        s4_0_target := D600;
        s4_1_target := D601;
        IF ABS(D1032 - D600) <= 20 AND ABS(D1036 - D601) <= 20 THEN
            state := 176;
        END_IF;
        IF req_cancelled THEN state := 178; END_IF;

    176:
        s4_2_target := D602;
        IF ABS(D1040 - D602) <= 20 THEN
            state := 177;
        END_IF;
        IF req_cancelled THEN state := 178; END_IF;

    177:
        IF X75 OR req_cancelled THEN
            state := 178;
        END_IF;

    178:
        s4_2_target := 22000;
        IF ABS(D1040 - 22000) <= 20 THEN
            state := 179;
        END_IF;

    179:
        s4_0_target := -65000;
        s4_1_target := 65000;
        IF ABS(D1032 - -65000) <= 20 AND ABS(D1036 - 65000) <= 20 THEN
            state := 180;
        END_IF;

    180:
        s4_2_target := 0;
        IF ABS(D1040) <= 20 THEN
            state := 181;
        END_IF;

    181:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq := seq + 1;
            D80 := 1;
            D81 := 4;
            D82 := seq;
            state := 182;
        END_IF;

    182:
        IF D90 = req_id THEN
            state := 183;
        END_IF;

    183:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 19;
        END_IF;

    19:
        IF req_loc = 1 THEN a_target := -405000; ELSE a_target := -185000; END_IF;
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 THEN
            state := 20;
        END_IF;

    20:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq := seq + 1;
            D80 := 2;
            D81 := req_loc;
            D82 := seq;
            state := 21;
        END_IF;

    21:
        IF D90 = 0 THEN
            state := 22;
        END_IF;

    22:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 221;
        END_IF;

    221:
        c_target := 40000;
        d_target := 40000;
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
            state := 23;
        END_IF;

    23:
        IF req_idx = 0 THEN
            D300 := req_id;
            IF req_cancelled THEN D301 := 2; ELSE D301 := 1; END_IF;
        ELSE
            D302 := req_id;
            IF req_cancelled THEN D303 := 2; ELSE D303 := 1; END_IF;
        END_IF;
        state := 24;

    24:
        IF (req_idx = 0 AND (X30 OR D100 = 0 OR D100 <> req_id)) OR 
           (req_idx = 1 AND (X34 OR D120 = 0 OR D120 <> req_id)) THEN
            IF req_idx = 0 THEN D300 := 0; D301 := 0; ELSE D302 := 0; D303 := 0; END_IF;
            Y70 := FALSE;
            Y71 := FALSE;
            Y75 := FALSE;
            Y76 := FALSE;
            D700 := 0;
            D710 := 0;
            state := 0;
        END_IF;

    100:
        a_target := 0;
        b_target := 0;
        c_target := 40000;
        d_target := 40000;
        s3_0_target := -6500;
        s3_1_target := 0;
        s3_2_target := 6500;
        s3_3_target := 0;
        s4_0_target := -65000;
        s4_1_target := 65000;
        s4_2_target := 0;
        
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
           ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
           ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND
           ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND
           ABS(D1016 - -6500) <= 20 AND ABS(D1020) <= 20 AND
           ABS(D1024 - 6500) <= 20 AND ABS(D1028) <= 20 AND
           ABS(D1032 - -65000) <= 20 AND ABS(D1036 - 65000) <= 20 AND ABS(D1040) <= 20 THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;
Y49 := TRUE;
Y50 := TRUE;

Y30 := FALSE;

D2000 := a_target; D2001 := 1000; D2002 := 0;
D2004 := b_target; D2005 := 1000; D2006 := 0;
D2008 := c_target; D2009 := 1000; D2010 := 0;
D2012 := d_target; D2013 := 1000; D2014 := 0;

D2016 := s3_0_target; D2017 := 1000; D2018 := 0;
D2020 := s3_1_target; D2021 := 1000; D2022 := 0;
D2024 := s3_2_target; D2025 := 1000; D2026 := 0;
D2028 := s3_3_target; D2029 := 1000; D2030 := 0;

D2032 := s4_0_target; D2033 := 1000; D2034 := 0;
D2036 := s4_1_target; D2037 := 1000; D2038 := 0;
D2040 := s4_2_target; D2041 := 1000; D2042 := 0;

END_PROGRAM