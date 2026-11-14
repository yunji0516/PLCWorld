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
    req_cancelled : BOOL := FALSE;
    last_r0_id : DINT := 0;
    last_r1_id : DINT := 0;
    seq : DINT := 1;
    start_a : DINT := 0;
    start_s3 : DINT := 0;

    a_target : DINT := 0;
    b_target : DINT := 0;
    c_target : DINT := 15000;
    d_target : DINT := 15000;
    s3_0_target : DINT := -50000;
    s3_1_target : DINT := -50000;
    s3_2_target : DINT := 0;
    s4_0_target : DINT := 0;
    s4_1_target : DINT := 0;

    a_rate : DINT := 1000;
    b_rate : DINT := 1000;
    c_rate : DINT := 1000;
    d_rate : DINT := 1000;
    s3_0_rate : DINT := 1000;
    s3_1_rate : DINT := 1000;
    s3_2_rate : DINT := 1000;
    s4_0_rate : DINT := 1000;
    s4_1_rate : DINT := 1000;
END_VAR

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
Y30 := FALSE;

a_rate := 1000; b_rate := 1000; c_rate := 1000; d_rate := 1000;
s3_0_rate := 1000; s3_1_rate := 1000; s3_2_rate := 1000;
s4_0_rate := 1000; s4_1_rate := 1000;

IF req_id <> 0 THEN
    IF req_id = D100 THEN
        req_cancelled := X31;
    ELSE
        req_cancelled := X35;
    END_IF
END_IF

IF req_cancelled THEN
    IF state >= 20 AND state < 25 THEN
        state := 25;
    ELSIF state >= 30 AND state < 35 THEN
        state := 35;
    END_IF
END_IF

CASE state OF
0:
    IF X51 THEN
        state := 900;
    ELSIF D100 <> 0 AND D100 <> last_r0_id THEN
        req_id := D100; req_loc := D101; state := 10;
    ELSIF D120 <> 0 AND D120 <> last_r1_id THEN
        req_id := D120; req_loc := D121; state := 10;
    END_IF

10:
    a_target := SEL(req_loc = 1, D406, D403);
    c_target := 73250; d_target := 73250;
    IF ABS(D1000 - a_target) <= 20 AND ABS(SEL(req_loc=1, D1012, D1008) - 73250) <= 20 THEN
        state := 11;
    END_IF

11:
    b_target := 18000;
    IF D1004 >= 17980 THEN
        D80 := 1; D81 := req_loc; seq := seq + 1; D82 := seq;
        state := 12;
    END_IF

12:
    IF D90 = req_id THEN
        b_target := 0;
        state := 13;
    END_IF

13:
    IF D1004 <= 20 THEN
        c_target := 15000; d_target := 15000;
        IF req_cancelled THEN state := 80; ELSE state := 20; END_IF
    END_IF

20:
    a_target := D409;
    s3_0_target := -50000; s3_1_target := -50000; s3_2_target := 0;
    IF ABS(D1000 - D409) <= 20 AND ABS(D1016 - (-50000)) <= 20 THEN
        start_a := D1000;
        state := 21;
    END_IF

21:
    a_target := start_a + 100000;
    s3_0_target := 50000;
    a_rate := 100; s3_0_rate := 100;
    IF D1001 >= 50 AND ABS(D1001 - D1017) <= 100 AND ABS(D1000 - D409) <= 20 THEN
        b_target := 18000;
        state := 22;
    END_IF

22:
    a_target := start_a + 100000; s3_0_target := 50000;
    a_rate := 100; s3_0_rate := 100;
    IF D1004 >= 17980 THEN
        D80 := 2; D81 := 3; seq := seq + 1; D82 := seq;
        state := 23;
    END_IF

23:
    a_target := start_a + 100000; s3_0_target := 50000;
    a_rate := 100; s3_0_rate := 100;
    IF D90 = 0 THEN
        start_s3 := D1016;
        start_a := D1000;
        state := 24;
    END_IF

24:
    s3_0_target := start_s3 + 25000;
    a_target := start_a + 25000;
    IF ABS(D1016 - s3_0_target) <= 20 THEN
        start_s3 := D1016;
        start_a := D1000;
        state := 241;
    END_IF

241:
    s3_0_target := D500;
    a_target := start_a + (D500 - start_s3);
    s3_1_target := D501;
    s3_2_target := D502;
    IF X70 THEN
        state := 25;
    END_IF

25:
    s3_0_target := -50000; s3_1_target := -50000; s3_2_target := 0;
    a_target := D409;
    IF ABS(D1016 - (-50000)) <= 20 AND ABS(D1000 - D409) <= 20 THEN
        D80 := 1; D81 := 3; seq := seq + 1; D82 := seq;
        state := 26;
    END_IF

26:
    IF D90 = req_id THEN
        b_target := 0;
        state := 27;
    END_IF

27:
    IF D1004 <= 20 THEN
        state := 30;
    END_IF

30:
    a_target := D412;
    IF ABS(D1000 - D412) <= 20 THEN
        b_target := 18000;
        state := 31;
    END_IF

31:
    IF D1004 >= 17980 THEN
        D80 := 2; D81 := 4; seq := seq + 1; D82 := seq;
        state := 32;
    END_IF

32:
    IF D90 = 0 THEN
        state := 33;
    END_IF

33:
    s4_0_target := D600;
    s4_1_target := D601;
    s4_0_rate := 500;
    IF D600 <> 0 THEN 
        s4_1_rate := (500 * ABS(D601)) / ABS(D600); 
    ELSE 
        s4_1_rate := 500; 
    END_IF
    IF s4_1_rate < 20 THEN s4_1_rate := 20; END_IF

    IF ABS(D1029) > 100 THEN
        Y75 := TRUE;
        IF D600 <> 0 THEN D710 := (D601 * 1000) / D600; ELSE D710 := 0; END_IF
        state := 34;
    END_IF

34:
    Y75 := TRUE;
    s4_0_target := D600;
    IF X75 THEN
        Y75 := FALSE;
        state := 35;
    END_IF

35:
    s4_0_target := 0; s4_1_target := 0;
    IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
        D80 := 1; D81 := 4; seq := seq + 1; D82 := seq;
        state := 36;
    END_IF

36:
    IF D90 = req_id THEN
        b_target := 0;
        state := 37;
    END_IF

37:
    IF D1004 <= 20 THEN
        state := 80;
    END_IF

80:
    a_target := SEL(req_loc = 1, D406, D403);
    c_target := 73250; d_target := 73250;
    IF ABS(D1000 - a_target) <= 20 AND ABS(SEL(req_loc=1, D1012, D1008) - 73250) <= 20 THEN
        b_target := 18000;
        state := 81;
    END_IF

81:
    IF D1004 >= 17980 THEN
        D80 := 2; D81 := req_loc; seq := seq + 1; D82 := seq;
        state := 82;
    END_IF

82:
    IF D90 = 0 THEN
        b_target := 0;
        state := 83;
    END_IF

83:
    IF D1004 <= 20 THEN
        c_target := 15000; d_target := 15000;
        IF req_id = D100 THEN
            D300 := req_id; 
            D301 := SEL(req_cancelled, 1, 2); 
            last_r0_id := req_id;
        ELSE
            D302 := req_id; 
            D303 := SEL(req_cancelled, 1, 2); 
            last_r1_id := req_id;
        END_IF
        req_id := 0; state := 0;
    END_IF

900:
    a_target := 0; b_target := 0;
    c_target := 15000; d_target := 15000;
    s3_0_target := -50000; s3_1_target := -50000; s3_2_target := 0;
    s4_0_target := 0; s4_1_target := 0;
    IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND
       ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND
       ABS(D1016 - (-50000)) <= 20 AND ABS(D1020 - (-50000)) <= 20 AND ABS(D1024) <= 20 AND
       ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
        Y2 := TRUE;
    END_IF
END_CASE

D2000 := a_target; D2001 := a_rate;
D2004 := b_target; D2005 := b_rate;
D2008 := c_target; D2009 := c_rate;
D2012 := d_target; D2013 := d_rate;
D2016 := s3_0_target; D2017 := s3_0_rate;
D2020 := s3_1_target; D2021 := s3_1_rate;
D2024 := s3_2_target; D2025 := s3_2_rate;
D2028 := s4_0_target; D2029 := s4_0_rate;
D2032 := s4_1_target; D2033 := s4_1_rate;

END_PROGRAM