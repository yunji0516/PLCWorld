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
    active_req : DINT := -1;
    req_id : DINT := 0;
    req_loc : DINT := 0;
    seq_counter : DINT := 0;
    cancelled : BOOL := FALSE;

    a_target : DINT := 0;
    b_target : DINT := 0;
    c_target : DINT := 40000;
    d_target : DINT := 40000;
    s3_1_target : DINT := 0;
    s3_2_target : DINT := 0;
    s4_0_target : DINT := 0;
    s4_1_target : DINT := 0;
END_VAR

cancelled := (active_req = 0 AND X31) OR (active_req = 1 AND X35);

CASE state OF
    0:
        a_target := 0;
        b_target := 0;
        c_target := 40000;
        d_target := 40000;
        s3_1_target := 0;
        s3_2_target := 0;
        s4_0_target := 0;
        s4_1_target := 0;
        Y75 := FALSE;
        
        IF X51 AND D100 = 0 AND D120 = 0 THEN
            state := 99;
        ELSIF D100 <> 0 AND NOT X30 THEN
            active_req := 0;
            req_id := D100;
            req_loc := D101;
            state := 10;
        ELSIF D120 <> 0 AND NOT X34 THEN
            active_req := 1;
            req_id := D120;
            req_loc := D121;
            state := 10;
        END_IF

    10:
        c_target := 95000;
        d_target := 95000;
        IF req_loc = 1 THEN 
            a_target := -405000; 
        ELSE 
            a_target := -185000; 
        END_IF
        
        IF ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 AND ABS(D1000 - a_target) <= 20 AND 
           ABS(D1009) <= 100 AND ABS(D1013) <= 100 AND ABS(D1001) <= 100 AND
           ((req_loc = 1 AND X61) OR (req_loc = 2 AND X62)) THEN
            state := 11;
        END_IF

    11:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            state := 12;
        END_IF

    12:
        D80 := 1; 
        D81 := req_loc; 
        D82 := seq_counter;
        IF D90 = req_id THEN
            state := 13;
        END_IF

    13:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF cancelled THEN
                state := 50;
            ELSE
                state := 20;
            END_IF
        END_IF

    20:
        a_target := 65000;
        IF ABS(D1000 - 65000) <= 20 AND ABS(D1001) <= 100 AND X63 AND 
           ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND ABS(D1021) <= 100 AND ABS(D1025) <= 100 THEN
            state := 21;
        END_IF

    21:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            state := 22;
        END_IF

    22:
        D80 := 2; 
        D81 := 3; 
        D82 := seq_counter;
        IF D90 = 0 THEN
            state := 23;
        END_IF

    23:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 30;
        END_IF

    30:
        IF cancelled THEN
            state := 33;
        ELSE
            s3_1_target := D501; 
            s3_2_target := D502;
            IF X70 THEN
                state := 31;
            END_IF
        END_IF

    31:
        s3_1_target := 0; 
        s3_2_target := 0;
        IF ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND ABS(D1021) <= 100 AND ABS(D1025) <= 100 THEN
            state := 33;
        END_IF

    33:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            state := 34;
        END_IF

    34:
        D80 := 1; 
        D81 := 3; 
        D82 := seq_counter;
        IF D90 = req_id THEN
            state := 35;
        END_IF

    35:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF cancelled THEN
                state := 50;
            ELSE
                state := 40;
            END_IF
        END_IF

    40:
        a_target := 360000;
        IF ABS(D1000 - 360000) <= 20 AND ABS(D1001) <= 100 AND X64 AND 
           ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
            state := 41;
        END_IF

    41:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            state := 42;
        END_IF

    42:
        D80 := 2; 
        D81 := 4; 
        D82 := seq_counter;
        IF D90 = 0 THEN
            state := 43;
        END_IF

    43:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 44;
        END_IF

    44:
        IF cancelled THEN
            state := 47;
        ELSE
            IF D1017 >= 19800 AND D1017 <= 20200 THEN
                Y75 := TRUE;
                D710 := 1000;
            END_IF
            IF X75 THEN
                Y75 := FALSE;
                state := 45;
            END_IF
        END_IF

    45:
        Y75 := FALSE;
        s4_0_target := 0; 
        s4_1_target := 0;
        IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
            state := 47;
        END_IF

    47:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            state := 48;
        END_IF

    48:
        D80 := 1; 
        D81 := 4; 
        D82 := seq_counter;
        IF D90 = req_id THEN
            state := 49;
        END_IF

    49:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 50;
        END_IF

    50:
        IF req_loc = 1 THEN 
            a_target := -405000; 
        ELSE 
            a_target := -185000; 
        END_IF
        
        IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 AND 
           ((req_loc = 1 AND X61) OR (req_loc = 2 AND X62)) THEN
            state := 51;
        END_IF

    51:
        b_target := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            seq_counter := seq_counter + 1;
            state := 52;
        END_IF

    52:
        D80 := 2; 
        D81 := req_loc; 
        D82 := seq_counter;
        IF D90 = 0 THEN
            state := 53;
        END_IF

    53:
        b_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 535;
        END_IF
        
    535:
        c_target := 40000;
        d_target := 40000;
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
            state := 54;
        END_IF

    54:
        IF active_req = 0 THEN
            D300 := req_id;
            IF X31 THEN 
                D301 := 2; 
            ELSE 
                D301 := 1; 
            END_IF
            
            IF X30 THEN
                D300 := 0; 
                D301 := 0; 
                active_req := -1; 
                state := 0;
            END_IF
        ELSE
            D302 := req_id;
            IF X35 THEN 
                D303 := 2; 
            ELSE 
                D303 := 1; 
            END_IF
            
            IF X34 THEN
                D302 := 0; 
                D303 := 0; 
                active_req := -1; 
                state := 0;
            END_IF
        END_IF

    99:
        Y75 := FALSE;
        a_target := 0; 
        b_target := 0; 
        c_target := 40000; 
        d_target := 40000;
        s3_1_target := 0; 
        s3_2_target := 0; 
        s4_0_target := 0; 
        s4_1_target := 0;
        
        IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND
           ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND
           ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND
           ABS(D1001) <= 100 AND ABS(D1005) <= 100 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 AND
           ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
            Y2 := TRUE;
        END_IF
END_CASE

Y71 := (state > 0 AND state < 99);

Y40 := TRUE; 
Y41 := TRUE; 
Y42 := TRUE; 
Y43 := TRUE; 
Y44 := TRUE; 
Y45 := TRUE; 
Y46 := TRUE; 
Y47 := TRUE; 
Y48 := TRUE;

D2001 := 500; 
D2005 := 500; 
D2009 := 500; 
D2013 := 500;
D2017 := 500; 
D2021 := 500; 
D2025 := 500; 
D2029 := 500; 
D2033 := 500; 

D2000 := a_target;
D2004 := b_target;
D2008 := c_target;
D2012 := d_target;
D2020 := s3_1_target;
D2024 := s3_2_target;
D2028 := s4_0_target;
D2032 := s4_1_target;
D2016 := 0;

END_PROGRAM
```