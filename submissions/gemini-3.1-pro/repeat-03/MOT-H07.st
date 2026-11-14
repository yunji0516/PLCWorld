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

    init : INT := 0;
    step : INT := 0;
    req_idx : INT := 0;
    active_req_id : DINT := 0;
    active_loc : DINT := 0;
    original_station : DINT := 1;
    is_abort : BOOL := FALSE;
    
    a_target : DINT := 0;
    b_target : DINT := 0;
    c_target : DINT := 0;
    d_target : DINT := 0;
    s3_0_target : DINT := 0;
    s3_1_target : DINT := 0;
    s3_2_target : DINT := 0;
    s3_3_target : DINT := 0;
    s4_0_target : DINT := 0;
    s4_1_target : DINT := 0;
    s4_2_target : DINT := 0;
END_VAR

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE;
Y48 := TRUE; Y49 := TRUE; Y50 := TRUE;
Y30 := FALSE;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000;
D2033 := 1000; D2037 := 1000; D2041 := 1000;

IF init = 0 THEN
    a_target := D1000; b_target := D1004; c_target := D1008; d_target := D1012;
    s3_0_target := D1016; s3_1_target := D1020; s3_2_target := D1024; s3_3_target := D1028;
    s4_0_target := D1032; s4_1_target := D1036; s4_2_target := D1040;
    init := 1;
END_IF

IF step > 0 AND step < 90 THEN
    IF req_idx = 0 AND X31 THEN is_abort := TRUE; END_IF
    IF req_idx = 1 AND X35 THEN is_abort := TRUE; END_IF
END_IF

CASE step OF
0:
    IF D100 <> 0 AND D300 <> D100 THEN
        active_req_id := D100; active_loc := D101; req_idx := 0; is_abort := X31;
        original_station := active_loc + 1;
        step := 1;
    ELSIF D120 <> 0 AND D302 <> D120 THEN
        active_req_id := D120; active_loc := D121; req_idx := 1; is_abort := X35;
        original_station := active_loc + 1;
        step := 1;
    ELSIF X51 THEN
        step := 100;
    END_IF

1:
    c_target := D92; d_target := D92;
    IF ABS(D1008 - D92) <= 20 AND ABS(D1012 - D92) <= 20 THEN
        IF is_abort THEN step := 90; ELSE step := 2; END_IF
    END_IF

2:
    IF original_station = 1 THEN a_target := D403; ELSE a_target := D406; END_IF
    IF is_abort THEN 
        step := 90; 
    ELSIF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 THEN
        step := 3;
    END_IF

3:
    b_target := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN step := 4; END_IF

4:
    D80 := 1; D81 := original_station; D82 := D82 + 1; step := 5;

5:
    IF D90 = active_req_id THEN step := 6; END_IF

6:
    b_target := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        IF is_abort THEN step := 39; ELSE step := 7; END_IF
    END_IF

7:
    a_target := D409;
    IF is_abort THEN 
        step := 39; 
    ELSIF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN 
        step := 8; 
    END_IF

8:
    b_target := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN step := 9; END_IF

9:
    D80 := 2; D81 := 3; D82 := D82 + 1; step := 10;

10:
    IF D90 = 0 THEN step := 11; END_IF

11:
    b_target := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN step := 12; END_IF

12:
    s3_0_target := D500; s3_2_target := D502;
    IF is_abort THEN 
        step := 15;
    ELSIF ABS(D1016 - D500) <= 20 AND ABS(D1024 - D502) <= 20 AND ABS(D1017) <= 100 AND ABS(D1025) <= 100 THEN 
        step := 13; 
    END_IF

13:
    s3_1_target := D501; s3_3_target := D503;
    IF is_abort THEN 
        step := 15;
    ELSIF ABS(D1020 - D501) <= 20 AND ABS(D1028 - D503) <= 20 AND ABS(D1021) <= 100 AND ABS(D1029) <= 100 THEN 
        step := 14; 
    END_IF

14:
    IF X70 OR is_abort THEN step := 15; END_IF

15:
    s3_1_target := 0; s3_3_target := 0;
    IF ABS(D1020) <= 8000 AND ABS(D1028) <= 8000 THEN step := 16; END_IF

16:
    s3_0_target := -6500; s3_2_target := 6500;
    IF ABS(D1016 + 6500) <= 20 AND ABS(D1024 - 6500) <= 20 AND ABS(D1020) <= 20 AND ABS(D1028) <= 20 
       AND ABS(D1017) <= 100 AND ABS(D1025) <= 100 AND ABS(D1021) <= 100 AND ABS(D1029) <= 100 THEN
        step := 17;
    END_IF

17:
    a_target := D409;
    IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN step := 18; END_IF

18:
    b_target := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN step := 19; END_IF

19:
    D80 := 1; D81 := 3; D82 := D82 + 1; step := 20;

20:
    IF D90 = active_req_id THEN step := 21; END_IF

21:
    b_target := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
        IF is_abort THEN step := 39; ELSE step := 22; END_IF
    END_IF

22:
    a_target := D412;
    IF is_abort THEN 
        step := 39;
    ELSIF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN 
        step := 23; 
    END_IF

23:
    b_target := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN step := 24; END_IF

24:
    D80 := 2; D81 := 4; D82 := D82 + 1; step := 25;

25:
    IF D90 = 0 THEN step := 26; END_IF

26:
    b_target := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN step := 27; END_IF

27:
    s4_2_target := 18000;
    IF is_abort THEN 
        step := 31;
    ELSIF D1040 >= 17700 THEN 
        step := 28; 
    END_IF

28:
    s4_0_target := D600; s4_1_target := D601;
    IF is_abort THEN 
        step := 31;
    ELSIF ABS(D1032 - D600) <= 20 AND ABS(D1036 - D601) <= 20 AND ABS(D1033) <= 100 AND ABS(D1037) <= 100 THEN 
        step := 29; 
    END_IF

29:
    s4_2_target := D602;
    IF is_abort THEN 
        step := 31;
    ELSIF ABS(D1040 - D602) <= 20 AND ABS(D1041) <= 100 THEN 
        step := 30; 
    END_IF

30:
    IF X75 OR is_abort THEN step := 31; END_IF

31:
    s4_2_target := 18000;
    IF D1040 >= 17700 THEN step := 32; END_IF

32:
    s4_0_target := -65000; s4_1_target := 65000;
    IF ABS(D1032 + 65000) <= 20 AND ABS(D1036 - 65000) <= 20 AND ABS(D1033) <= 100 AND ABS(D1037) <= 100 THEN step := 33; END_IF

33:
    s4_2_target := 0;
    IF ABS(D1040) <= 20 AND ABS(D1041) <= 100 THEN step := 34; END_IF

34:
    a_target := D412;
    IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN step := 35; END_IF

35:
    b_target := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN step := 36; END_IF

36:
    D80 := 1; D81 := 4; D82 := D82 + 1; step := 37;

37:
    IF D90 = active_req_id THEN step := 38; END_IF

38:
    b_target := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN step := 39; END_IF

39:
    IF original_station = 1 THEN a_target := D403; ELSE a_target := D406; END_IF
    IF ABS(D1000 - a_target) <= 20 AND ABS(D1001) <= 100 THEN step := 40; END_IF

40:
    b_target := 18000;
    IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN step := 41; END_IF

41:
    D80 := 2; D81 := original_station; D82 := D82 + 1; step := 42;

42:
    IF D90 = 0 THEN step := 43; END_IF

43:
    b_target := 0;
    IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN step := 90; END_IF

90:
    IF req_idx = 0 THEN
        D300 := active_req_id;
        D301 := SEL(is_abort, 1, 2);
    ELSE
        D302 := active_req_id;
        D303 := SEL(is_abort, 1, 2);
    END_IF
    step := 91;

91:
    step := 0;

100:
    c_target := 40000; d_target := 40000;
    a_target := 0; b_target := 0;
    s3_0_target := -6500; s3_1_target := 0; s3_2_target := 6500; s3_3_target := 0;
    s4_0_target := -65000; s4_1_target := 65000; s4_2_target := 0;
    
    Y2 := (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND 
          (ABS(D1000) <= 20) AND (ABS(D1004) <= 20) AND
          (ABS(D1016 + 6500) <= 20) AND (ABS(D1020) <= 20) AND 
          (ABS(D1024 - 6500) <= 20) AND (ABS(D1028) <= 20) AND
          (ABS(D1032 + 65000) <= 20) AND (ABS(D1036 - 65000) <= 20) AND (ABS(D1040) <= 20) AND X51;
END_CASE

IF step <> 100 THEN
    Y2 := FALSE;
END_IF

D2000 := a_target;
D2004 := b_target;
D2008 := c_target;
D2012 := d_target;
D2016 := s3_0_target;
D2020 := s3_1_target;
D2024 := s3_2_target;
D2028 := s3_3_target;
D2032 := s4_0_target;
D2036 := s4_1_target;
D2040 := s4_2_target;

END_PROGRAM
```