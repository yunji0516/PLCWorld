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
    
    state : DINT := 0;
    req_id : DINT := 0;
    req_loc : DINT := 0;
    req_channel : DINT := 0;
    last_r0_id : DINT := 0;
    last_r1_id : DINT := 0;
    seq : DINT := 1;
    target_x : DINT := 0;
    init_done : BOOL := FALSE;
END_VAR

IF NOT init_done THEN
    Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
    Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE;
    Y48 := TRUE; Y49 := TRUE; Y50 := TRUE;
    Y30 := FALSE;
    
    D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
    D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000;
    D2033 := 1000; D2037 := 1000; D2041 := 1000;
    
    D2000 := 0;
    D2004 := 0;
    D2008 := 40000;
    D2012 := 40000;
    D2016 := -6500; D2020 := 0; D2024 := 6500; D2028 := 0;
    D2032 := -65000; D2036 := 65000; D2040 := 0;
    
    init_done := TRUE;
END_IF;

CASE state OF
0:
    IF D100 > 0 AND D100 <> last_r0_id THEN
        req_id := D100;
        req_loc := D101;
        req_channel := 0;
        state := 1;
    ELSIF D120 > 0 AND D120 <> last_r1_id THEN
        req_id := D120;
        req_loc := D121;
        req_channel := 1;
        state := 1;
    ELSIF X51 THEN
        state := 999;
    END_IF;

1:
    D2008 := 95000;
    D2012 := 95000;
    IF ABS(D1008 - 95000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1012 - 95000) <= 20 AND ABS(D1013) <= 100 THEN
        state := 10;
    END_IF;

10:
    IF req_loc = 1 THEN
        target_x := D403;
    ELSE
        target_x := D406;
    END_IF;
    D2000 := target_x;
    IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 AND D1008 >= 94900 AND D1012 >= 94900 AND D1004 <= 20 THEN
        state := 11;
    END_IF;

11:
    D2004 := 18000;
    IF D1004 >= 17980 AND ABS(D1005) <= 100 AND ((req_loc = 1 AND X61) OR (req_loc = 2 AND X62)) THEN
        state := 12;
    END_IF;

12:
    D80 := 1;
    D81 := req_loc;
    seq := seq + 1;
    D82 := seq;
    state := 13;

13:
    IF D90 = req_id THEN
        state := 14;
    END_IF;

14:
    D2004 := 0;
    IF D1004 <= 20 AND ABS(D1005) <= 100 THEN
        IF (req_channel = 0 AND X31) OR (req_channel = 1 AND X35) THEN
            state := 90;
        ELSE
            state := 20;
        END_IF;
    END_IF;

20:
    D2000 := D409;
    IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
        state := 21;
    END_IF;

21:
    D2004 := 18000;
    IF D1004 >= 17980 AND ABS(D1005) <= 100 AND X63 THEN
        state := 22;
    END_IF;

22:
    D80 := 2;
    D81 := 3;
    seq := seq + 1;
    D82 := seq;
    state := 23;

23:
    IF D90 = 0 THEN
        state := 24;
    END_IF;

24:
    D2004 := 0;
    IF D1004 <= 20 AND ABS(D1005) <= 100 THEN
        state := 30;
    END_IF;

30:
    D700 := req_id;
    Y70 := TRUE;
    D2020 := 0;
    D2028 := 0;
    IF D1020 <= 8000 AND ABS(D1021) <= 100 AND D1028 <= 8000 AND ABS(D1029) <= 100 THEN
        state := 31;
    END_IF;

31:
    D2016 := D500;
    D2024 := D502;
    IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 AND ABS(D1024 - D502) <= 20 AND ABS(D1025) <= 100 THEN
        state := 32;
    END_IF;

32:
    D2020 := D501;
    D2028 := D503;
    IF X70 THEN
        state := 33;
    END_IF;

33:
    D2020 := 0;
    D2028 := 0;
    IF D1020 <= 8000 AND ABS(D1021) <= 100 AND D1028 <= 8000 AND ABS(D1029) <= 100 THEN
        state := 34;
    END_IF;

34:
    D2016 := -6500;
    D2024 := 6500;
    IF ABS(D1016 - (-6500)) <= 20 AND ABS(D1017) <= 100 AND ABS(D1024 - 6500) <= 20 AND ABS(D1025) <= 100 AND ABS(D1020) <= 20 AND ABS(D1021) <= 100 AND ABS(D1028) <= 20 AND ABS(D1029) <= 100 THEN
        Y70 := FALSE;
        state := 40;
    END_IF;

40:
    D2000 := D409;
    IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
        state := 41;
    END_IF;

41:
    D2004 := 18000;
    IF D1004 >= 17980 AND ABS(D1005) <= 100 AND X63 THEN
        state := 42;
    END_IF;

42:
    D80 := 1;
    D81 := 3;
    seq := seq + 1;
    D82 := seq;
    state := 43;

43:
    IF D90 = req_id THEN
        state := 44;
    END_IF;

44:
    D2004 := 0;
    IF D1004 <= 20 AND ABS(D1005) <= 100 THEN
        IF (req_channel = 0 AND X31) OR (req_channel = 1 AND X35) THEN
            state := 90;
        ELSE
            state := 50;
        END_IF;
    END_IF;

50:
    D2000 := D412;
    IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
        state := 51;
    END_IF;

51:
    D2004 := 18000;
    IF D1004 >= 17980 AND ABS(D1005) <= 100 AND X64 THEN
        state := 52;
    END_IF;

52:
    D80 := 2;
    D81 := 4;
    seq := seq + 1;
    D82 := seq;
    state := 53;

53:
    IF D90 = 0 THEN
        state := 54;
    END_IF;

54:
    D2004 := 0;
    IF D1004 <= 20 AND ABS(D1005) <= 100 THEN
        state := 60;
    END_IF;

60:
    D710 := req_id;
    Y75 := TRUE;
    IF D602 > 20000 THEN
        D2040 := D602;
    ELSE
        D2040 := 20000;
    END_IF;
    IF ABS(D1040 - D2040) <= 20 AND ABS(D1041) <= 100 THEN
        state := 61;
    END_IF;

61:
    D2032 := D600;
    D2036 := D601;
    IF ABS(D1032 - D600) <= 20 AND ABS(D1033) <= 100 AND ABS(D1036 - D601) <= 20 AND ABS(D1037) <= 100 THEN
        state := 62;
    END_IF;

62:
    D2040 := D602;
    IF X75 THEN
        state := 63;
    END_IF;

63:
    D2040 := 20000;
    IF ABS(D1040 - 20000) <= 20 AND ABS(D1041) <= 100 THEN
        state := 64;
    END_IF;

64:
    D2032 := -65000;
    D2036 := 65000;
    IF ABS(D1032 - (-65000)) <= 20 AND ABS(D1033) <= 100 AND ABS(D1036 - 65000) <= 20 AND ABS(D1037) <= 100 THEN
        state := 65;
    END_IF;

65:
    D2040 := 0;
    IF ABS(D1040) <= 20 AND ABS(D1041) <= 100 THEN
        Y75 := FALSE;
        state := 70;
    END_IF;

70:
    D2000 := D412;
    IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
        state := 71;
    END_IF;

71:
    D2004 := 18000;
    IF D1004 >= 17980 AND ABS(D1005) <= 100 AND X64 THEN
        state := 72;
    END_IF;

72:
    D80 := 1;
    D81 := 4;
    seq := seq + 1;
    D82 := seq;
    state := 73;

73:
    IF D90 = req_id THEN
        state := 74;
    END_IF;

74:
    D2004 := 0;
    IF D1004 <= 20 AND ABS(D1005) <= 100 THEN
        state := 90;
    END_IF;

90:
    IF req_loc = 1 THEN
        target_x := D403;
    ELSE
        target_x := D406;
    END_IF;
    D2000 := target_x;
    IF ABS(D1000 - target_x) <= 20 AND ABS(D1001) <= 100 THEN
        state := 91;
    END_IF;

91:
    D2004 := 18000;
    IF D1004 >= 17980 AND ABS(D1005) <= 100 AND ((req_loc = 1 AND X61) OR (req_loc = 2 AND X62)) THEN
        state := 92;
    END_IF;

92:
    D80 := 2;
    D81 := req_loc;
    seq := seq + 1;
    D82 := seq;
    state := 93;

93:
    IF D90 = 0 THEN
        state := 94;
    END_IF;

94:
    D2004 := 0;
    IF D1004 <= 20 AND ABS(D1005) <= 100 THEN
        state := 95;
    END_IF;

95:
    D2008 := 40000;
    D2012 := 40000;
    IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
        state := 100;
    END_IF;

100:
    IF req_channel = 0 THEN
        D300 := req_id;
        IF X31 THEN
            D301 := 2;
        ELSE
            D301 := 1;
        END_IF;
        last_r0_id := req_id;
    ELSE
        D302 := req_id;
        IF X35 THEN
            D303 := 2;
        ELSE
            D303 := 1;
        END_IF;
        last_r1_id := req_id;
    END_IF;
    state := 0;

999:
    D2008 := 40000;
    D2012 := 40000;
    D2000 := 0;
    IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 AND ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND ABS(D1016 - (-6500)) <= 20 AND ABS(D1024 - 6500) <= 20 AND ABS(D1020) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032 - (-65000)) <= 20 AND ABS(D1036 - 65000) <= 20 AND ABS(D1040) <= 20 THEN
        Y2 := TRUE;
    END_IF;

END_CASE;
END_PROGRAM