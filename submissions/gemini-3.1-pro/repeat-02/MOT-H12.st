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

    step : DINT := 0;
    req : DINT := 0;
    r_id : DINT := 0;
    r_loc : DINT := 0;
    is_cancelled : BOOL := FALSE;
    couple_seq_internal : DINT := 1;
    
    a_target : DINT := 0;
    b_target : DINT := 0;
    c_target : DINT := 15000;
    d_target : DINT := 15000;
    s3_0_target : DINT := -85000;
    s3_1_target : DINT := -85000;
    s4_0_target : DINT := -65000;
    s4_1_target : DINT := 65000;
    s4_2_target : DINT := 0;
END_VAR

is_cancelled := (req = 0 AND X31) OR (req = 1 AND X35);

CASE step OF
    0:
        IF D100 > 0 AND NOT X30 THEN
            req := 0; r_id := D100; r_loc := D101; step := 10;
        ELSIF D120 > 0 AND NOT X34 THEN
            req := 1; r_id := D120; r_loc := D121; step := 10;
        ELSIF X51 THEN
            step := 100;
        END_IF

    10:
        c_target := SEL(r_loc = 1, 15000, 73250);
        d_target := SEL(r_loc = 2, 15000, 73250);
        a_target := SEL(r_loc = 1, -230000, -360000);
        IF is_cancelled THEN
            step := 60;
        ELSIF ABS(D1008 - c_target) <= 20 AND ABS(D1012 - d_target) <= 20 AND ABS(D1000 - a_target) <= 20 THEN
            IF (r_loc = 1 AND X61) OR (r_loc = 2 AND X62) THEN
                step := 11;
            END_IF
        END_IF

    11:
        b_target := 18000;
        IF is_cancelled THEN
            step := 60;
        ELSIF D1004 >= 17980 THEN
            couple_seq_internal := couple_seq_internal + 1;
            D80 := 1; D81 := r_loc; D82 := couple_seq_internal;
            step := 12;
        END_IF

    12:
        IF D90 = r_id THEN
            step := 13;
        END_IF

    13:
        b_target := 0;
        IF D1004 <= 20 THEN
            IF is_cancelled THEN
                step := 50;
            ELSE
                step := 14;
            END_IF
        END_IF

    14:
        a_target := 0;
        IF ABS(D1000) <= 20 AND X63 THEN
            step := 15;
        END_IF

    15:
        b_target := 18000;
        IF D1004 >= 17980 THEN
            couple_seq_internal := couple_seq_internal + 1;
            D80 := 2; D81 := 3; D82 := couple_seq_internal;
            step := 16;
        END_IF

    16:
        IF D90 = 0 THEN
            step := 17;
        END_IF

    17:
        b_target := 0;
        IF D1004 <= 20 THEN
            step := 18;
        END_IF

    18:
        Y70 := TRUE; 
        D700 := r_id;
        IF is_cancelled THEN
            step := 20;
        ELSIF X72 THEN
            step := 19;
        END_IF

    19:
        s3_0_target := D500; 
        s3_1_target := D501;
        IF is_cancelled OR X70 THEN
            step := 20;
        END_IF

    20:
        s3_0_target := -85000; 
        s3_1_target := -85000;
        IF ABS(D1016 - (-85000)) <= 20 AND ABS(D1020 - (-85000)) <= 20 AND X63 THEN
            step := 21;
        END_IF

    21:
        a_target := 0;
        IF ABS(D1000) <= 20 THEN
            step := 22;
        END_IF

    22:
        b_target := 18000;
        IF D1004 >= 17980 THEN
            couple_seq_internal := couple_seq_internal + 1;
            D80 := 1; D81 := 3; D82 := couple_seq_internal;
            step := 23;
        END_IF

    23:
        IF D90 = r_id THEN
            step := 24;
        END_IF

    24:
        b_target := 0;
        Y70 := FALSE;
        IF D1004 <= 20 THEN
            IF is_cancelled THEN
                step := 50;
            ELSE
                step := 25;
            END_IF
        END_IF

    25:
        a_target := 360000;
        IF ABS(D1000 - 360000) <= 20 AND X64 THEN
            step := 26;
        END_IF

    26:
        b_target := 18000;
        IF D1004 >= 17980 THEN
            couple_seq_internal := couple_seq_internal + 1;
            D80 := 2; D81 := 4; D82 := couple_seq_internal;
            step := 27;
        END_IF

    27:
        IF D90 = 0 THEN
            step := 28;
        END_IF

    28:
        b_target := 0;
        IF D1004 <= 20 THEN
            step := 29;
        END_IF

    29:
        Y75 := TRUE; 
        D710 := r_id;
        IF is_cancelled THEN
            step := 33;
        ELSIF X77 THEN
            step := 30;
        END_IF

    30:
        s4_2_target := 18000;
        IF D1032 >= 17640 THEN
            step := 31;
        END_IF

    31:
        s4_0_target := D600; 
        s4_1_target := D601;
        IF ABS(D1024 - D600) <= 20 AND ABS(D1028 - D601) <= 20 THEN
            step := 32;
        END_IF

    32:
        s4_2_target := D602;
        IF is_cancelled OR X75 THEN
            step := 33;
        END_IF

    33:
        s4_2_target := 18000;
        IF D1032 >= 17640 THEN
            step := 34;
        END_IF

    34:
        s4_0_target := -65000; 
        s4_1_target := 65000;
        IF ABS(D1024 - (-65000)) <= 20 AND ABS(D1028 - 65000) <= 20 THEN
            step := 35;
        END_IF

    35:
        s4_2_target := 0;
        IF ABS(D1032) <= 20 AND X64 THEN
            step := 36;
        END_IF

    36:
        a_target := 360000;
        IF ABS(D1000 - 360000) <= 20 THEN
            step := 37;
        END_IF

    37:
        b_target := 18000;
        IF D1004 >= 17980 THEN
            couple_seq_internal := couple_seq_internal + 1;
            D80 := 1; D81 := 4; D82 := couple_seq_internal;
            step := 38;
        END_IF

    38:
        IF D90 = r_id THEN
            step := 39;
        END_IF

    39:
        b_target := 0;
        Y75 := FALSE;
        IF D1004 <= 20 THEN
            step := 50;
        END_IF

    50:
        a_target := SEL(r_loc = 1, -230000, -360000);
        c_target := SEL(r_loc = 1, 15000, 73250);
        d_target := SEL(r_loc = 2, 15000, 73250);
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1008 - c_target) <= 20 AND ABS(D1012 - d_target) <= 20 THEN
            IF (r_loc = 1 AND X61) OR (r_loc = 2 AND X62) THEN
                step := 51;
            END_IF
        END_IF

    51:
        b_target := 18000;
        IF D1004 >= 17980 THEN
            couple_seq_internal := couple_seq_internal + 1;
            D80 := 2; D81 := r_loc; D82 := couple_seq_internal;
            step := 52;
        END_IF

    52:
        IF D90 = 0 THEN
            step := 53;
        END_IF

    53:
        b_target := 0;
        IF D1004 <= 20 THEN
            step := 54;
        END_IF

    54:
        c_target := 15000; 
        d_target := 15000;
        IF ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 THEN
            step := 55;
        END_IF

    55:
        IF req = 0 THEN
            D300 := r_id; 
            D301 := SEL(is_cancelled, 1, 2);
            IF X30 THEN
                D300 := 0; D301 := 0; step := 0;
            END_IF
        ELSE
            D302 := r_id; 
            D303 := SEL(is_cancelled, 1, 2);
            IF X34 THEN
                D302 := 0; D303 := 0; step := 0;
            END_IF
        END_IF

    60:
        b_target := 0; 
        Y70 := FALSE; 
        Y75 := FALSE;
        IF D1004 <= 20 THEN
            step := 54;
        END_IF

    100:
        a_target := 0; 
        b_target := 0;
        c_target := 15000; 
        d_target := 15000;
        s3_0_target := -85000; 
        s3_1_target := -85000;
        s4_0_target := -65000; 
        s4_1_target := 65000; 
        s4_2_target := 0;
        
        IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND
           ABS(D1016 - (-85000)) <= 20 AND ABS(D1020 - (-85000)) <= 20 AND
           ABS(D1024 - (-65000)) <= 20 AND ABS(D1028 - 65000) <= 20 AND ABS(D1032) <= 20 THEN
            Y2 := TRUE;
        END_IF
END_CASE

D2000 := a_target; D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2004 := b_target; D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2008 := c_target; D2009 := 1000; D2010 := 0; Y42 := TRUE;
D2012 := d_target; D2013 := 1000; D2014 := 0; Y43 := TRUE;
D2016 := s3_0_target; D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2020 := s3_1_target; D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2024 := s4_0_target; D2025 := 1000; D2026 := 0; Y46 := TRUE;
D2028 := s4_1_target; D2029 := 1000; D2030 := 0; Y47 := TRUE;
D2032 := s4_2_target; D2033 := 1000; D2034 := 0; Y48 := TRUE;

Y30 := FALSE;
Y71 := FALSE;
Y76 := FALSE;
D701 := 0; 
D702 := 0;
D711 := 0; 
D712 := 0;

END_PROGRAM
```