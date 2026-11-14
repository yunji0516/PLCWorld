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
    
    active_req : DINT := 0;
    state : INT := 0;
    req_id : DINT := 0;
    lane : DINT := 0;
    record : DINT := 0;
    target_port : DINT := 0;
    is_cancelled : BOOL := FALSE;
    pocket : INT := 0;
    
    c_tgt : DINT := 40000;
    d_tgt : DINT := 40000;
    a_tgt : DINT := 0;
    b_tgt : DINT := 0;
    s3_0_tgt : DINT := 0;
    s3_1_tgt : DINT := 0;
    s3_2_tgt : DINT := 0;
    s4_0_tgt : DINT := 0;
    s4_1_tgt : DINT := 0;
    s4_2_tgt : DINT := 0;
    
    s3_0_rad : REAL := 0.0;
    s3_1_rad : REAL := 0.0;
    x_real : REAL := 0.0;
END_VAR

IF D100 = 0 THEN
    D300 := 0; 
    D301 := 0;
END_IF
IF D120 = 0 THEN
    D302 := 0; 
    D303 := 0;
END_IF

IF active_req = 0 THEN
    IF D100 <> 0 AND NOT X30 AND D300 <> D100 THEN
        active_req := 1;
        req_id := D100;
        lane := D101;
        record := D104;
        state := 10;
    ELSIF D120 <> 0 AND NOT X34 AND D302 <> D120 THEN
        active_req := 2;
        req_id := D120;
        lane := D121;
        record := D124;
        state := 10;
    ELSIF X51 THEN
        state := 99;
    END_IF
END_IF

is_cancelled := (active_req = 1 AND X31) OR (active_req = 2 AND X35);
IF active_req = 1 THEN
    record := D104;
ELSIF active_req = 2 THEN
    record := D124;
END_IF

CASE state OF
    10: 
        c_tgt := 95000;
        d_tgt := 95000;
        IF ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
            state := 11;
        END_IF
        
    11: 
        IF lane = 0 THEN target_port := D403; ELSE target_port := D406; END_IF
        a_tgt := target_port;
        IF ABS(D1000 - target_port) <= 20 AND ABS(D1001) <= 100 THEN
            IF is_cancelled THEN state := 85; ELSE state := 12; END_IF
        END_IF
        
    12: 
        b_tgt := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 13;
        END_IF
        
    13: 
        D80 := 1; 
        IF lane = 0 THEN D81 := 1; ELSE D81 := 2; END_IF
        D82 := D82 + 1; 
        state := 14;
        
    14: 
        IF D90 = req_id THEN
            state := 15;
        END_IF
        
    15: 
        b_tgt := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF is_cancelled THEN state := 80; ELSE state := 20; END_IF
        END_IF
        
    20: 
        IF is_cancelled THEN
            state := 80;
        ELSE
            a_tgt := D409;
            IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
                state := 21;
            END_IF
        END_IF
        
    21: 
        b_tgt := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 22;
        END_IF
        
    22: 
        D80 := 2; 
        D81 := 3; 
        D82 := D82 + 1;
        state := 23;
        
    23: 
        IF D90 = 0 THEN
            state := 24;
        END_IF
        
    24: 
        b_tgt := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 30;
        END_IF
        
    30: 
        D700 := req_id; 
        Y70 := TRUE; 
        Y71 := TRUE; 
        s3_0_tgt := D500;
        s3_1_tgt := D501;
        IF X70 OR is_cancelled THEN 
            state := 32;
        END_IF
        
    32: 
        Y70 := FALSE; 
        Y71 := FALSE; 
        D700 := 0;
        s3_0_tgt := 0;
        s3_1_tgt := 0;
        IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND ABS(D1025) <= 100 THEN
            state := 33;
        END_IF
        
    33: 
        a_tgt := D409;
        IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
            state := 34;
        END_IF
        
    34: 
        b_tgt := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 35;
        END_IF
        
    35: 
        D80 := 1;
        D81 := 3;
        D82 := D82 + 1;
        state := 36;
        
    36: 
        IF D90 = req_id THEN
            state := 37;
        END_IF
        
    37: 
        b_tgt := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF is_cancelled THEN state := 80; ELSE state := 40; END_IF
        END_IF
        
    40: 
        IF is_cancelled THEN
            state := 80;
        ELSE
            a_tgt := D412;
            IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
                state := 41;
            END_IF
        END_IF
        
    41: 
        b_tgt := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 42;
        END_IF
        
    42: 
        D80 := 2;
        D81 := 4;
        D82 := D82 + 1;
        state := 43;
        
    43: 
        IF D90 = 0 THEN
            state := 44;
        END_IF
        
    44: 
        b_tgt := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 50;
        END_IF
        
    50: 
        D710 := req_id;
        Y75 := TRUE; 
        Y76 := TRUE; 
        IF record < 0 THEN
            pocket := 1;
            s4_1_tgt := D601;
            s4_2_tgt := 0;
        ELSE
            pocket := 2;
            s4_2_tgt := D602;
            s4_1_tgt := 0;
        END_IF
        s4_0_tgt := 0;
        IF X75 OR is_cancelled THEN
            state := 52;
        END_IF
        
    52: 
        Y75 := FALSE; 
        Y76 := FALSE; 
        D710 := 0;
        s4_1_tgt := 0;
        s4_2_tgt := 0;
        IF ABS(D1032) <= 20 AND ABS(D1036) <= 20 AND ABS(D1033) <= 100 AND ABS(D1037) <= 100 THEN
            state := 53;
        END_IF
        
    53: 
        b_tgt := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 54;
        END_IF
        
    54: 
        D80 := 1;
        D81 := 4;
        D82 := D82 + 1;
        state := 55;
        
    55: 
        IF D90 = req_id THEN
            state := 56;
        END_IF
        
    56: 
        b_tgt := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 80;
        END_IF
        
    80: 
        IF lane = 0 THEN target_port := D403; ELSE target_port := D406; END_IF
        a_tgt := target_port;
        IF ABS(D1000 - target_port) <= 20 AND ABS(D1001) <= 100 THEN
            state := 81;
        END_IF
        
    81: 
        b_tgt := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 82;
        END_IF
        
    82: 
        D80 := 2;
        IF lane = 0 THEN D81 := 1; ELSE D81 := 2; END_IF
        D82 := D82 + 1;
        state := 83;
        
    83: 
        IF D90 = 0 THEN
            state := 84;
        END_IF
        
    84: 
        b_tgt := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 85;
        END_IF
        
    85: 
        IF active_req = 1 THEN
            D300 := req_id;
            D301 := SEL(is_cancelled, 1, 2);
        ELSE
            D302 := req_id;
            D303 := SEL(is_cancelled, 1, 2);
        END_IF
        active_req := 0;
        state := 0;
        
    99: 
        a_tgt := 0;
        b_tgt := 0;
        c_tgt := 40000;
        d_tgt := 40000;
        s3_0_tgt := 0;
        s3_1_tgt := 0;
        s4_0_tgt := 0;
        s4_1_tgt := 0;
        s4_2_tgt := 0;
END_CASE

s3_0_rad := REAL(D1016) * 0.01 * 3.1415926535 / 180.0;
s3_1_rad := REAL(D1020) * 0.01 * 3.1415926535 / 180.0;
x_real := -225.0 * (SIN(s3_0_rad) + SIN(s3_1_rad));
s3_2_tgt := DINT(x_real * 100.0);

IF state = 99 THEN
    IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND
       ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND
       ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1036) <= 20 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF
ELSE
    Y2 := FALSE;
END_IF

D2000 := a_tgt;
D2001 := 1000;
Y40 := TRUE;

D2004 := b_tgt;
D2005 := 1000;
Y41 := TRUE;

D2008 := c_tgt;
D2009 := 1000;
Y42 := TRUE;

D2012 := d_tgt;
D2013 := 1000;
Y43 := TRUE;

D2016 := s3_0_tgt;
D2017 := 1000;
Y44 := TRUE;

D2020 := s3_1_tgt;
D2021 := 1000;
Y45 := TRUE;

D2024 := s3_2_tgt;
D2025 := 1000;
Y46 := TRUE;

D2028 := s4_0_tgt;
D2029 := 1000;
Y47 := TRUE;

D2032 := s4_1_tgt;
D2033 := 1000;
Y48 := TRUE;

D2036 := s4_2_tgt;
D2037 := 1000;
Y49 := TRUE;

Y30 := FALSE;

END_PROGRAM