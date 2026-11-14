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
    
    state : DINT := 0;
    req_id : DINT := 0;
    req_loc : DINT := 0;
    req_cancel : BOOL := FALSE;
    r0_mem : DINT := 0;
    r1_mem : DINT := 0;
    couple_seq : DINT := 1;
    port_pos : DINT := 0;
    m3_target : DINT := 0;
    e_m : REAL;
    v_m : REAL;
    th_rad : REAL;
    w_rad : REAL;
    a_m : REAL;
END_VAR

IF req_loc = 1 THEN
    port_pos := -405000;
ELSE
    port_pos := -185000;
END_IF;

IF state = 0 THEN
    IF D100 <> 0 AND D300 = 0 THEN
        req_id := D100;
        req_loc := D101;
        req_cancel := X31;
        r0_mem := D100;
        state := 1;
    ELSIF D120 <> 0 AND D302 = 0 THEN
        req_id := D120;
        req_loc := D121;
        req_cancel := X35;
        r1_mem := D120;
        state := 1;
    ELSIF X51 THEN
        state := 99;
    END_IF;
END_IF;

IF state = 1 THEN
    IF ABS(D1000 - port_pos) <= 20 AND ABS(D1001) <= 100 AND
       ABS(D1008 - 95000) <= 20 AND ABS(D1009) <= 100 AND
       ABS(D1012 - 95000) <= 20 AND ABS(D1013) <= 100 THEN
        state := 2;
    END_IF;
END_IF;

IF state = 2 THEN
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        IF (req_loc = 1 AND X61) OR (req_loc = 2 AND X62) THEN
            state := 3;
            D81 := req_loc;
            D80 := 1;
            couple_seq := couple_seq + 1;
            D82 := couple_seq;
        END_IF;
    END_IF;
END_IF;

IF state = 3 THEN
    IF D90 = req_id THEN
        state := 4;
    END_IF;
END_IF;

IF state = 4 THEN
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        IF req_cancel THEN
            state := 23;
        ELSE
            state := 5;
        END_IF;
    END_IF;
END_IF;

IF state = 5 THEN
    IF ABS(D1000 - 90000) <= 20 AND ABS(D1001) <= 100 THEN
        state := 6;
    END_IF;
END_IF;

IF state = 6 THEN
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND X63 THEN
        state := 7;
        D81 := 3;
        D80 := 2;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
    END_IF;
END_IF;

IF state = 7 THEN
    IF D90 = 0 THEN
        state := 8;
    END_IF;
END_IF;

IF state = 8 THEN
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 9;
    END_IF;
END_IF;

IF state = 9 THEN
    IF D522 = req_id THEN
        IF X70 THEN
            state := 10;
        END_IF;
    END_IF;
END_IF;

IF state = 10 THEN
    IF ABS(D1016 - 100000) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 3 AND 
       ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND ABS(D1025) <= 15 THEN
        state := 11;
    END_IF;
END_IF;

IF state = 11 THEN
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND X63 THEN
        state := 12;
        D81 := 3;
        D80 := 1;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
    END_IF;
END_IF;

IF state = 12 THEN
    IF D90 = req_id THEN
        state := 13;
    END_IF;
END_IF;

IF state = 13 THEN
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 14;
    END_IF;
END_IF;

IF state = 14 THEN
    IF ABS(D1000 - 470000) <= 20 AND ABS(D1001) <= 100 THEN
        state := 15;
    END_IF;
END_IF;

IF state = 15 THEN
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND X64 THEN
        state := 16;
        D81 := 4;
        D80 := 2;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
    END_IF;
END_IF;

IF state = 16 THEN
    IF D90 = 0 THEN
        state := 17;
    END_IF;
END_IF;

IF state = 17 THEN
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 18;
    END_IF;
END_IF;

IF state = 18 THEN
    IF D622 = req_id THEN
        IF X75 THEN
            state := 19;
        END_IF;
    END_IF;
END_IF;

IF state = 19 THEN
    IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
        state := 20;
    END_IF;
END_IF;

IF state = 20 THEN
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 AND X64 THEN
        state := 21;
        D81 := 4;
        D80 := 1;
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
    END_IF;
END_IF;

IF state = 21 THEN
    IF D90 = req_id THEN
        state := 22;
    END_IF;
END_IF;

IF state = 22 THEN
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 23;
    END_IF;
END_IF;

IF state = 23 THEN
    IF ABS(D1000 - port_pos) <= 20 AND ABS(D1001) <= 100 AND
       ABS(D1008 - 95000) <= 20 AND ABS(D1009) <= 100 AND
       ABS(D1012 - 95000) <= 20 AND ABS(D1013) <= 100 THEN
        state := 24;
    END_IF;
END_IF;

IF state = 24 THEN
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
        IF (req_loc = 1 AND X61) OR (req_loc = 2 AND X62) THEN
            state := 25;
            D81 := req_loc;
            D80 := 2;
            couple_seq := couple_seq + 1;
            D82 := couple_seq;
        END_IF;
    END_IF;
END_IF;

IF state = 25 THEN
    IF D90 = 0 THEN
        state := 26;
    END_IF;
END_IF;

IF state = 26 THEN
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        state := 27;
    END_IF;
END_IF;

IF state = 27 THEN
    IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
        state := 28;
    END_IF;
END_IF;

IF state = 28 THEN
    IF req_id = r0_mem THEN
        D300 := req_id;
        D301 := SEL(req_cancel, 1, 2);
        IF D100 = 0 THEN
            D300 := 0; D301 := 0;
            state := 0;
            req_id := 0;
        END_IF;
    ELSIF req_id = r1_mem THEN
        D302 := req_id;
        D303 := SEL(req_cancel, 1, 2);
        IF D120 = 0 THEN
            D302 := 0; D303 := 0;
            state := 0;
            req_id := 0;
        END_IF;
    END_IF;
END_IF;

IF state = 4 OR state = 8 OR state = 13 OR state = 17 OR state = 22 OR state = 26 OR state = 0 THEN
    D80 := 0;
    D81 := 0;
END_IF;

IF state >= 1 AND state <= 26 THEN
    D2008 := 95000;
    D2012 := 95000;
ELSE
    D2008 := 40000;
    D2012 := 40000;
END_IF;

IF state >= 1 AND state <= 4 THEN
    D2000 := port_pos;
ELSIF state >= 5 AND state <= 13 THEN
    D2000 := 90000;
ELSIF state >= 14 AND state <= 22 THEN
    D2000 := 470000;
ELSIF state >= 23 AND state <= 26 THEN
    D2000 := port_pos;
ELSE
    D2000 := 0;
END_IF;

IF state = 2 OR state = 3 OR state = 6 OR state = 7 OR state = 11 OR state = 12 OR state = 15 OR state = 16 OR state = 20 OR state = 21 OR state = 24 OR state = 25 THEN
    D2004 := 18000;
ELSE
    D2004 := 0;
END_IF;

IF state >= 5 AND state <= 13 THEN
    D700 := req_id;
    Y70 := TRUE;
    Y71 := TRUE;
ELSE
    D700 := 0;
    Y70 := FALSE;
    Y71 := FALSE;
END_IF;

IF state = 9 THEN
    IF D501 >= 50000 AND D501 <= 150000 THEN
        D2016 := D501;
    ELSE
        D2016 := 100000;
    END_IF;
    m3_target := D500;
ELSE
    D2016 := 100000;
    m3_target := 0;
END_IF;

e_m := REAL(m3_target - D1020) * 0.00001;
v_m := REAL(D1021) * 0.00001;
th_rad := REAL(D1024) * 0.000174533;
w_rad := REAL(D1025) * 0.000174533;

a_m := 0.5 * e_m - 1.0 * v_m + 15.0 * th_rad + 5.0 * w_rad;

IF a_m > 0.1 THEN a_m := 0.1; END_IF;
IF a_m < -0.1 THEN a_m := -0.1; END_IF;
D2020 := DINT(a_m * 100000.0);

IF state >= 14 AND state <= 22 THEN
    D710 := req_id;
    Y75 := TRUE;
    Y76 := TRUE;
ELSE
    D710 := 0;
    Y75 := FALSE;
    Y76 := FALSE;
END_IF;

IF state = 18 THEN
    D2028 := D600;
ELSE
    D2028 := 0;
END_IF;

D2032 := DINT(-45000.0 * SIN(REAL(D1028) * 0.000174533));

IF state = 99 THEN
    IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND
       ABS(D1016 - 100000) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 3 AND 
       ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
        
        IF ABS(D1001) <= 100 AND ABS(D1005) <= 100 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 AND
           ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND ABS(D1025) <= 15 AND
           ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
           Y2 := TRUE;
        ELSE
           Y2 := FALSE;
        END_IF;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y2 := FALSE;
END_IF;

D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;
Y30 := FALSE;
END_PROGRAM