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
    
    first_scan : BOOL := TRUE;
    active_req : DINT := 0;
    req_id : DINT := 0;
    req_loc : DINT := 0;
    step : DINT := 0;
    seq : DINT := 1;
    req_cancelled : BOOL := FALSE;
    last_r0_id : DINT := 0;
    last_r1_id : DINT := 0;
    r0_done : DINT := 0;
    r1_done : DINT := 0;
    
    a_tgt : DINT := 0;
    b_tgt : DINT := 0;
    c_tgt : DINT := 0;
    d_tgt : DINT := 0;
    s3_0_tgt : DINT := 0;
    s3_1_tgt : DINT := 0;
    s4_0_tgt : DINT := 0;
    s4_1_tgt : DINT := 0;

    status_val : DINT := 0;
    port_ready : BOOL := FALSE;
    home_timer : TON;
END_VAR

IF first_scan THEN
    first_scan := FALSE;
    a_tgt := D1000;
    b_tgt := D1004;
    c_tgt := D1008;
    d_tgt := D1012;
    s3_0_tgt := D1016;
    s3_1_tgt := D1020;
    s4_0_tgt := D1024;
    s4_1_tgt := D1028;
END_IF;

IF D100 <> 0 AND D100 <> last_r0_id THEN
    r0_done := 0;
    last_r0_id := D100;
END_IF;
IF D120 <> 0 AND D120 <> last_r1_id THEN
    r1_done := 0;
    last_r1_id := D120;
END_IF;

IF active_req = 0 THEN
    IF X51 THEN
        a_tgt := 0; b_tgt := 0; c_tgt := 40000; d_tgt := 40000;
        s3_0_tgt := -60000; s3_1_tgt := -60000; s4_0_tgt := 0; s4_1_tgt := 0;
        IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 
           AND ABS(D1016 + 60000) <= 20 AND ABS(D1020 + 60000) <= 20 AND ABS(D1024) <= 20 AND ABS(D1028) <= 20 THEN
            home_timer(IN:=TRUE, PT:=T#100ms);
            IF home_timer.Q THEN Y2 := TRUE; END_IF;
        ELSE
            home_timer(IN:=FALSE);
            Y2 := FALSE;
        END_IF;
    ELSE
        home_timer(IN:=FALSE);
        Y2 := FALSE;
        IF D100 <> 0 AND NOT X30 AND NOT X31 AND D102 < 5 AND r0_done = 0 THEN
            active_req := 1; req_id := D100; req_loc := D101; step := 1; req_cancelled := FALSE;
        ELSIF D120 <> 0 AND NOT X34 AND NOT X35 AND D122 < 5 AND r1_done = 0 THEN
            active_req := 2; req_id := D120; req_loc := D121; step := 1; req_cancelled := FALSE;
        END_IF;
    END_IF;
ELSE
    home_timer(IN:=FALSE);
    Y2 := FALSE;

    IF active_req = 1 AND X31 THEN req_cancelled := TRUE; END_IF;
    IF active_req = 2 AND X35 THEN req_cancelled := TRUE; END_IF;

    IF req_cancelled THEN
        IF step = 1 OR step = 2 THEN step := 34; END_IF;
        IF (step = 7 OR step = 18) AND b_tgt = 0 AND ABS(D1004) <= 20 THEN step := 29; END_IF;
        IF step = 12 THEN step := 13; END_IF;
        IF step = 23 THEN step := 24; END_IF;
    END_IF;

    CASE step OF
    1: 
       c_tgt := 95000; d_tgt := 95000;
       IF ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 AND D1009 = 0 AND D1013 = 0 THEN step := 2; END_IF;
    2:
       a_tgt := SEL(req_loc = 1, D406, D403);
       IF ABS(D1000 - a_tgt) <= 20 AND D1001 = 0 THEN step := 3; END_IF;
    3:
       D81 := req_loc; D80 := 1; D82 := seq; seq := seq + 1;
       step := 4;
    4:
       port_ready := (req_loc = 1 AND X61) OR (req_loc = 2 AND X62);
       IF port_ready THEN b_tgt := 18000; step := 5; END_IF;
    5:
       IF D1004 >= 17980 THEN b_tgt := 0; step := 6; END_IF;
    6:
       IF D1004 <= 20 THEN step := 7; END_IF;
    7:
       a_tgt := D409; 
       IF ABS(D1000 - D409) <= 20 AND D1001 = 0 THEN step := 8; END_IF;
    8:
       D81 := 3; D80 := 2; D82 := seq; seq := seq + 1;
       step := 9;
    9:
       IF X63 THEN b_tgt := 18000; step := 10; END_IF;
    10:
       IF D1004 >= 17980 THEN b_tgt := 0; step := 11; END_IF;
    11:
       IF D1004 <= 20 THEN 
           D700 := req_id; Y71 := TRUE; Y70 := TRUE; 
           step := 12; 
       END_IF;
    12:
       s3_0_tgt := D500; 
       s3_1_tgt := LIMIT(D500 - 300, D501, D500 + 300);
       IF X70 OR X71 THEN step := 13; END_IF;
    13:
       s3_0_tgt := -60000; s3_1_tgt := -60000;
       IF ABS(D1016 + 60000) <= 20 AND ABS(D1020 + 60000) <= 20 THEN
           Y70 := FALSE; Y71 := FALSE; D700 := 0;
           step := 14;
       END_IF;
    14:
       D81 := 3; D80 := 1; D82 := seq; seq := seq + 1;
       step := 15;
    15:
       IF X63 THEN b_tgt := 18000; step := 16; END_IF;
    16:
       IF D1004 >= 17980 THEN b_tgt := 0; step := 17; END_IF;
    17:
       IF D1004 <= 20 THEN step := 18; END_IF;
    18:
       a_tgt := D412;
       IF ABS(D1000 - D412) <= 20 AND D1001 = 0 THEN step := 19; END_IF;
    19:
       D81 := 4; D80 := 2; D82 := seq; seq := seq + 1;
       step := 20;
    20:
       IF X64 THEN b_tgt := 18000; step := 21; END_IF;
    21:
       IF D1004 >= 17980 THEN b_tgt := 0; step := 22; END_IF;
    22:
       IF D1004 <= 20 THEN
           D710 := req_id; Y76 := TRUE; Y75 := TRUE;
           step := 23;
       END_IF;
    23:
       s4_0_tgt := D600; s4_1_tgt := D601;
       IF X75 OR X76 THEN step := 24; END_IF;
    24:
       s4_0_tgt := 0; s4_1_tgt := 0;
       IF ABS(D1024) <= 20 AND ABS(D1028) <= 20 THEN
           Y75 := FALSE; Y76 := FALSE; D710 := 0;
           step := 25;
       END_IF;
    25:
       D81 := 4; D80 := 1; D82 := seq; seq := seq + 1;
       step := 26;
    26:
       IF X64 THEN b_tgt := 18000; step := 27; END_IF;
    27:
       IF D1004 >= 17980 THEN b_tgt := 0; step := 28; END_IF;
    28:
       IF D1004 <= 20 THEN step := 29; END_IF;
    29:
       a_tgt := SEL(req_loc = 1, D406, D403);
       IF ABS(D1000 - a_tgt) <= 20 AND D1001 = 0 THEN step := 30; END_IF;
    30:
       D81 := req_loc; D80 := 2; D82 := seq; seq := seq + 1;
       step := 31;
    31:
       port_ready := (req_loc = 1 AND X61) OR (req_loc = 2 AND X62);
       IF port_ready THEN b_tgt := 18000; step := 32; END_IF;
    32:
       IF D1004 >= 17980 THEN b_tgt := 0; step := 33; END_IF;
    33:
       IF D1004 <= 20 THEN step := 34; END_IF;
    34:
       c_tgt := 40000; d_tgt := 40000;
       IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND D1009 = 0 AND D1013 = 0 THEN step := 35; END_IF;
    35:
       status_val := SEL(req_cancelled, 1, 2);
       IF active_req = 1 THEN
           D300 := req_id; D301 := status_val;
           IF X30 THEN
               D300 := 0; D301 := 0; active_req := 0; r0_done := 1; step := 0; req_cancelled := FALSE;
           END_IF;
       ELSIF active_req = 2 THEN
           D302 := req_id; D303 := status_val;
           IF X34 THEN
               D302 := 0; D303 := 0; active_req := 0; r1_done := 1; step := 0; req_cancelled := FALSE;
           END_IF;
       END_IF;
    END_CASE;
END_IF;

Y30 := FALSE;
Y40 := TRUE; D2000 := a_tgt; D2001 := 1000;
Y41 := TRUE; D2004 := b_tgt; D2005 := 1000;
Y42 := TRUE; D2008 := c_tgt; D2009 := 1000;
Y43 := TRUE; D2012 := d_tgt; D2013 := 1000;
Y44 := TRUE; D2016 := s3_0_tgt; D2017 := 1000;
Y45 := TRUE; D2020 := s3_1_tgt; D2021 := 1000;
Y46 := TRUE; D2024 := s4_0_tgt; D2025 := 1000;
Y47 := TRUE; D2028 := s4_1_tgt; D2029 := 1000;
Y48 := TRUE; D2032 := DINT(-22500.0 * (SIN(REAL(D1024) * 0.000174532925) + SIN(REAL(D1028) * 0.000174532925))); D2033 := 1000;

END_PROGRAM