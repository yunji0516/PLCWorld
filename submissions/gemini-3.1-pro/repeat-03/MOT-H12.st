```iecst
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

    state : INT := 0;
    active_req : DINT := 0;
    active_loc : DINT := 0;
    active_is_r0 : BOOL := FALSE;
    my_seq : DINT := 0;
    req_cancelled : BOOL := FALSE;
    
    ack0_mem : DINT := 0;
    ack1_mem : DINT := 0;
    
    a_cmd : DINT := 0;
    b_cmd : DINT := 0;
    c_cmd : DINT := 15000;
    d_cmd : DINT := 15000;
    s3_0_cmd : DINT := -85000;
    s3_1_cmd : DINT := -85000;
    s4_0_cmd : DINT := -65000;
    s4_1_cmd : DINT := 65000;
    s4_2_cmd : DINT := 0;
END_VAR

req_cancelled := (active_is_r0 AND X31) OR (NOT active_is_r0 AND X35);

IF state = 0 THEN
    IF D100 > 0 AND NOT X30 AND ack0_mem <> D100 THEN
        active_req := D100;
        active_loc := D101;
        active_is_r0 := TRUE;
        IF X31 THEN
            state := 90;
        ELSE
            state := 1;
        END_IF;
    ELSIF D120 > 0 AND NOT X34 AND ack1_mem <> D120 THEN
        active_req := D120;
        active_loc := D121;
        active_is_r0 := FALSE;
        IF X35 THEN
            state := 90;
        ELSE
            state := 1;
        END_IF;
    ELSIF X51 THEN
        state := 999;
    END_IF;

ELSIF state = 90 THEN
    IF active_is_r0 THEN
        ack0_mem := active_req;
        D301 := 2;
    ELSE
        ack1_mem := active_req;
        D303 := 2;
    END_IF;
    state := 0;

ELSIF state = 1 THEN
    IF active_loc = 1 THEN
        c_cmd := D92;
        a_cmd := D403;
    ELSE
        d_cmd := D92;
        a_cmd := D406;
    END_IF;
    b_cmd := 0;
    
    IF (ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100) AND 
       (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) AND 
       ((active_loc = 1 AND (ABS(D1008 - c_cmd) <= 20 AND ABS(D1009) <= 100)) OR 
        (active_loc = 2 AND (ABS(D1012 - d_cmd) <= 20 AND ABS(D1013) <= 100))) THEN
        IF req_cancelled THEN
            state := 90;
        ELSE
            state := 2;
        END_IF;
    END_IF;

ELSIF state = 2 THEN
    b_cmd := 18000;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        D81 := active_loc;
        D80 := 1;
        my_seq := my_seq + 1;
        D82 := my_seq;
        state := 21;
    END_IF;

ELSIF state = 21 THEN
    IF D90 = active_req THEN
        state := 3;
    END_IF;

ELSIF state = 3 THEN
    b_cmd := 0;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        IF req_cancelled THEN
            state := 100;
        ELSE
            state := 4;
        END_IF;
    END_IF;

ELSIF state = 4 THEN
    a_cmd := D409;
    IF (ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100) THEN
        IF req_cancelled THEN
            state := 100;
        ELSE
            state := 5;
        END_IF;
    END_IF;

ELSIF state = 5 THEN
    b_cmd := 18000;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        D81 := 3;
        D80 := 2;
        my_seq := my_seq + 1;
        D82 := my_seq;
        state := 51;
    END_IF;

ELSIF state = 51 THEN
    IF D90 = 0 THEN
        state := 6;
    END_IF;

ELSIF state = 6 THEN
    b_cmd := 0;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        state := 7;
    END_IF;

ELSIF state = 7 THEN
    IF req_cancelled THEN
        state := 8;
    ELSE
        D700 := active_req;
        Y70 := TRUE;
        s3_0_cmd := D500;
        s3_1_cmd := D501;
        
        IF X70 THEN
            state := 8;
        END_IF;
    END_IF;

ELSIF state = 8 THEN
    Y70 := FALSE;
    s3_0_cmd := -85000;
    s3_1_cmd := -85000;
    IF (ABS(D1016 - s3_0_cmd) <= 20 AND ABS(D1017) <= 100) AND
       (ABS(D1020 - s3_1_cmd) <= 20 AND ABS(D1021) <= 100) THEN
        state := 9;
    END_IF;

ELSIF state = 9 THEN
    a_cmd := D409;
    IF (ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100) AND
       (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        state := 91;
    END_IF;

ELSIF state = 91 THEN
    b_cmd := 18000;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        D81 := 3;
        D80 := 1;
        my_seq := my_seq + 1;
        D82 := my_seq;
        state := 92;
    END_IF;

ELSIF state = 92 THEN
    IF D90 = active_req THEN
        state := 10;
    END_IF;

ELSIF state = 10 THEN
    b_cmd := 0;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        IF req_cancelled THEN
            state := 100;
        ELSE
            state := 11;
        END_IF;
    END_IF;

ELSIF state = 11 THEN
    a_cmd := D412;
    IF (ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100) THEN
        IF req_cancelled THEN
            state := 100;
        ELSE
            state := 12;
        END_IF;
    END_IF;

ELSIF state = 12 THEN
    b_cmd := 18000;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        D81 := 4;
        D80 := 2;
        my_seq := my_seq + 1;
        D82 := my_seq;
        state := 121;
    END_IF;

ELSIF state = 121 THEN
    IF D90 = 0 THEN
        state := 13;
    END_IF;

ELSIF state = 13 THEN
    b_cmd := 0;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        state := 14;
    END_IF;

ELSIF state = 14 THEN
    IF req_cancelled THEN
        state := 17;
    ELSE
        D710 := active_req;
        Y75 := TRUE;
        IF D602 > 25000 THEN
            s4_2_cmd := D602;
        ELSE
            s4_2_cmd := 25000;
        END_IF;
        IF (ABS(D1032 - s4_2_cmd) <= 20 AND ABS(D1033) <= 100) THEN
            state := 15;
        END_IF;
    END_IF;

ELSIF state = 15 THEN
    IF req_cancelled THEN
        state := 17;
    ELSE
        s4_0_cmd := D600;
        s4_1_cmd := D601;
        IF (ABS(D1024 - s4_0_cmd) <= 20 AND ABS(D1025) <= 100) AND
           (ABS(D1028 - s4_1_cmd) <= 20 AND ABS(D1029) <= 100) THEN
            state := 16;
        END_IF;
    END_IF;

ELSIF state = 16 THEN
    IF req_cancelled THEN
        state := 17;
    ELSE
        s4_2_cmd := D602;
        IF X75 THEN
            state := 17;
        END_IF;
    END_IF;

ELSIF state = 17 THEN
    Y75 := FALSE;
    s4_2_cmd := 25000;
    state := 171;

ELSIF state = 171 THEN
    IF (ABS(D1032 - s4_2_cmd) <= 20 AND ABS(D1033) <= 100) THEN
        s4_0_cmd := -65000;
        s4_1_cmd := 65000;
        state := 172;
    END_IF;

ELSIF state = 172 THEN
    IF (ABS(D1024 - s4_0_cmd) <= 20 AND ABS(D1025) <= 100) AND
       (ABS(D1028 - s4_1_cmd) <= 20 AND ABS(D1029) <= 100) THEN
        s4_2_cmd := 0;
        state := 173;
    END_IF;

ELSIF state = 173 THEN
    IF (ABS(D1032 - s4_2_cmd) <= 20 AND ABS(D1033) <= 100) THEN
        state := 18;
    END_IF;

ELSIF state = 18 THEN
    a_cmd := D412;
    IF (ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100) AND
       (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        state := 181;
    END_IF;

ELSIF state = 181 THEN
    b_cmd := 18000;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        D81 := 4;
        D80 := 1;
        my_seq := my_seq + 1;
        D82 := my_seq;
        state := 182;
    END_IF;

ELSIF state = 182 THEN
    IF D90 = active_req THEN
        state := 19;
    END_IF;

ELSIF state = 19 THEN
    b_cmd := 0;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        state := 100;
    END_IF;

ELSIF state = 100 THEN
    IF active_loc = 1 THEN
        a_cmd := D403;
        c_cmd := D92;
    ELSE
        a_cmd := D406;
        d_cmd := D92;
    END_IF;
    
    IF (ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100) AND 
       ((active_loc = 1 AND (ABS(D1008 - c_cmd) <= 20 AND ABS(D1009) <= 100)) OR 
        (active_loc = 2 AND (ABS(D1012 - d_cmd) <= 20 AND ABS(D1013) <= 100))) THEN
        state := 1001;
    END_IF;

ELSIF state = 1001 THEN
    b_cmd := 18000;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        D81 := active_loc;
        D80 := 2;
        my_seq := my_seq + 1;
        D82 := my_seq;
        state := 1002;
    END_IF;

ELSIF state = 1002 THEN
    IF D90 = 0 THEN
        state := 101;
    END_IF;

ELSIF state = 101 THEN
    b_cmd := 0;
    IF (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) THEN
        state := 102;
    END_IF;

ELSIF state = 102 THEN
    IF active_loc = 1 THEN
        c_cmd := 15000;
        IF (ABS(D1008 - c_cmd) <= 20 AND ABS(D1009) <= 100) THEN
            state := 103;
        END_IF;
    ELSE
        d_cmd := 15000;
        IF (ABS(D1012 - d_cmd) <= 20 AND ABS(D1013) <= 100) THEN
            state := 103;
        END_IF;
    END_IF;

ELSIF state = 103 THEN
    IF active_is_r0 THEN
        ack0_mem := active_req;
        IF X31 THEN D301 := 2; ELSE D301 := 1; END_IF;
    ELSE
        ack1_mem := active_req;
        IF X35 THEN D303 := 2; ELSE D303 := 1; END_IF;
    END_IF;
    state := 0;

ELSIF state = 999 THEN
    a_cmd := 0;
    b_cmd := 0;
    c_cmd := 15000;
    d_cmd := 15000;
    s3_0_cmd := -85000;
    s3_1_cmd := -85000;
    s4_0_cmd := -65000;
    s4_1_cmd := 65000;
    s4_2_cmd := 0;
    
    IF (ABS(D1000 - a_cmd) <= 20 AND ABS(D1001) <= 100) AND
       (ABS(D1004 - b_cmd) <= 20 AND ABS(D1005) <= 100) AND
       (ABS(D1008 - c_cmd) <= 20 AND ABS(D1009) <= 100) AND
       (ABS(D1012 - d_cmd) <= 20 AND ABS(D1013) <= 100) AND
       (ABS(D1016 - s3_0_cmd) <= 20 AND ABS(D1017) <= 100) AND
       (ABS(D1020 - s3_1_cmd) <= 20 AND ABS(D1021) <= 100) AND
       (ABS(D1024 - s4_0_cmd) <= 20 AND ABS(D1025) <= 100) AND
       (ABS(D1028 - s4_1_cmd) <= 20 AND ABS(D1029) <= 100) AND
       (ABS(D1032 - s4_2_cmd) <= 20 AND ABS(D1033) <= 100) THEN
        Y2 := TRUE;
    END_IF;

END_IF;

D2000 := a_cmd;
D2004 := b_cmd;
D2008 := c_cmd;
D2012 := d_cmd;
D2016 := s3_0_cmd;
D2020 := s3_1_cmd;
D2024 := s4_0_cmd;
D2028 := s4_1_cmd;
D2032 := s4_2_cmd;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

Y30 := FALSE;
D300 := ack0_mem;
D302 := ack1_mem;

END_PROGRAM
```