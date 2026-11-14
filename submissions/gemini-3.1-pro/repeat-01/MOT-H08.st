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

    state : DINT := 0;
    active : DINT := -1;
    req_id : DINT := 0;
    loc : DINT := 0;
    seq_out : DINT := 0;
    is_cancelled : BOOL := FALSE;
END_VAR

Y40 := TRUE; 
Y41 := TRUE; 
Y42 := TRUE; 
Y43 := TRUE; 
Y44 := TRUE; 
Y45 := TRUE; 
Y46 := TRUE; 
Y47 := TRUE; 
Y48 := TRUE; 

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000;
Y30 := FALSE; 

IF state < 10 OR state > 11 THEN
    D2016 := -60000; D2020 := -60000;
END_IF;

IF state < 19 OR state > 20 THEN
    D2024 := 0; D2028 := 0;
END_IF;

IF D602 <> 0 THEN
    D2032 := D602;
ELSE
    D2032 := DINT( -22500.0 * ( SIN(REAL(D1024)*0.000174532925) + SIN(REAL(D1028)*0.000174532925) ) );
END_IF;

is_cancelled := FALSE;
IF active = 0 AND X31 THEN is_cancelled := TRUE; END_IF;
IF active = 1 AND X35 THEN is_cancelled := TRUE; END_IF;

IF is_cancelled THEN
    IF state >= 1 AND state <= 3 THEN state := 99; END_IF;
    IF state = 5 THEN state := 24; END_IF;
    IF state = 6 THEN state := 24; END_IF;
    IF state = 10 THEN state := 11; END_IF;
    IF state = 14 THEN state := 24; END_IF;
    IF state = 15 THEN state := 24; END_IF;
    IF state = 19 THEN state := 20; END_IF;
    IF state = 23 THEN state := 24; END_IF;
END_IF;

CASE state OF
0:
    IF D100 > 0 AND D300 = 0 THEN
        active := 0; req_id := D100; loc := D101; state := 1;
    ELSIF D120 > 0 AND D302 = 0 THEN
        active := 1; req_id := D120; loc := D121; state := 1;
    ELSIF X51 THEN
        D2000 := 0;
        IF ABS(D1000)<=20 AND ABS(D1001)<=100 AND ABS(D1004)<=20 AND ABS(D1005)<=100 AND ABS(D1016 - (-60000))<=20 AND ABS(D1017)<=100 AND ABS(D1020 - (-60000))<=20 AND ABS(D1021)<=100 AND ABS(D1024)<=20 AND ABS(D1025)<=100 AND ABS(D1028)<=20 AND ABS(D1029)<=100 AND ABS(D1032)<=20 AND ABS(D1033)<=100 THEN
            IF ABS(D1008 - 40000)<=20 AND ABS(D1009)<=100 AND ABS(D1012 - 40000)<=20 AND ABS(D1013)<=100 THEN
                Y2 := TRUE;
            ELSE
                D2008 := 40000; D2012 := 40000;
            END_IF;
        END_IF;
    END_IF;

1:
    D2008 := 95000; D2012 := 95000;
    IF ABS(D1008 - 95000)<=20 AND ABS(D1009)<=100 AND ABS(D1012 - 95000)<=20 AND ABS(D1013)<=100 THEN
        state := 2;
    END_IF;

2:
    IF loc = 1 THEN D2000 := D403; ELSE D2000 := D406; END_IF;
    IF ABS(D1000 - D2000)<=20 AND ABS(D1001)<=100 THEN state := 3; END_IF;

3:
    D2004 := 18000;
    IF ABS(D1004 - 18000)<=20 AND ABS(D1005)<=100 THEN
        IF (loc = 1 AND X61) OR (loc = 2 AND X62) THEN state := 4; END_IF;
    END_IF;

4:
    D81 := loc; D80 := 1;
    IF D82 = seq_out THEN seq_out := seq_out + 1; END_IF;
    D82 := seq_out;
    IF D90 = req_id THEN state := 5; END_IF;

5:
    D2004 := 0;
    IF ABS(D1004)<=20 AND ABS(D1005)<=100 THEN state := 6; END_IF;

6:
    D2000 := D409;
    IF ABS(D1000 - D409)<=20 AND ABS(D1001)<=100 THEN state := 7; END_IF;

7:
    D2004 := 18000;
    IF ABS(D1004 - 18000)<=20 AND ABS(D1005)<=100 AND X63 THEN state := 8; END_IF;

8:
    D81 := 3; D80 := 2;
    IF D82 = seq_out THEN seq_out := seq_out + 1; END_IF;
    D82 := seq_out;
    IF D90 = 0 THEN state := 9; END_IF;

9:
    D2004 := 0;
    IF ABS(D1004)<=20 AND ABS(D1005)<=100 THEN state := 10; END_IF;

10:
    D2016 := D500; D2020 := D501;
    IF X70 THEN state := 11; END_IF;

11:
    D2016 := -60000; D2020 := -60000;
    IF ABS(D1016 - (-60000))<=20 AND ABS(D1017)<=100 AND ABS(D1020 - (-60000))<=20 AND ABS(D1021)<=100 THEN state := 12; END_IF;

12:
    D2004 := 18000;
    IF ABS(D1004 - 18000)<=20 AND ABS(D1005)<=100 AND X63 THEN state := 13; END_IF;

13:
    D81 := 3; D80 := 1;
    IF D82 = seq_out THEN seq_out := seq_out + 1; END_IF;
    D82 := seq_out;
    IF D90 = req_id THEN state := 14; END_IF;

14:
    D2004 := 0;
    IF ABS(D1004)<=20 AND ABS(D1005)<=100 THEN state := 15; END_IF;

15:
    D2000 := D412;
    IF ABS(D1000 - D412)<=20 AND ABS(D1001)<=100 THEN state := 16; END_IF;

16:
    D2004 := 18000;
    IF ABS(D1004 - 18000)<=20 AND ABS(D1005)<=100 AND X64 THEN state := 17; END_IF;

17:
    D81 := 4; D80 := 2;
    IF D82 = seq_out THEN seq_out := seq_out + 1; END_IF;
    D82 := seq_out;
    IF D90 = 0 THEN state := 18; END_IF;

18:
    D2004 := 0;
    IF ABS(D1004)<=20 AND ABS(D1005)<=100 THEN state := 19; END_IF;

19:
    D2024 := D600; D2028 := D601;
    IF X75 THEN state := 20; END_IF;

20:
    D2024 := 0; D2028 := 0;
    IF ABS(D1024)<=20 AND ABS(D1025)<=100 AND ABS(D1028)<=20 AND ABS(D1029)<=100 AND ABS(D1032)<=20 AND ABS(D1033)<=100 THEN state := 21; END_IF;

21:
    D2004 := 18000;
    IF ABS(D1004 - 18000)<=20 AND ABS(D1005)<=100 AND X64 THEN state := 22; END_IF;

22:
    D81 := 4; D80 := 1;
    IF D82 = seq_out THEN seq_out := seq_out + 1; END_IF;
    D82 := seq_out;
    IF D90 = req_id THEN state := 23; END_IF;

23:
    D2004 := 0;
    IF ABS(D1004)<=20 AND ABS(D1005)<=100 THEN state := 24; END_IF;

24:
    IF loc = 1 THEN D2000 := D403; ELSE D2000 := D406; END_IF;
    IF ABS(D1000 - D2000)<=20 AND ABS(D1001)<=100 THEN state := 25; END_IF;

25:
    D2004 := 18000;
    IF ABS(D1004 - 18000)<=20 AND ABS(D1005)<=100 THEN
        IF (loc = 1 AND X61) OR (loc = 2 AND X62) THEN state := 26; END_IF;
    END_IF;

26:
    D81 := loc; D80 := 2;
    IF D82 = seq_out THEN seq_out := seq_out + 1; END_IF;
    D82 := seq_out;
    IF D90 = 0 THEN state := 27; END_IF;

27:
    D2004 := 0;
    IF ABS(D1004)<=20 AND ABS(D1005)<=100 THEN state := 28; END_IF;

28:
    D2008 := 40000; D2012 := 40000;
    IF ABS(D1008 - 40000)<=20 AND ABS(D1009)<=100 AND ABS(D1012 - 40000)<=20 AND ABS(D1013)<=100 THEN state := 29; END_IF;

29:
    IF active = 0 THEN
        D300 := req_id; D301 := SEL(is_cancelled, 1, 2);
    ELSE
        D302 := req_id; D303 := SEL(is_cancelled, 1, 2);
    END_IF;
    state := 30;

30:
    IF (active = 0 AND D100 <> req_id) OR (active = 1 AND D120 <> req_id) THEN
        IF active = 0 THEN D300 := 0; D301 := 0; ELSE D302 := 0; D303 := 0; END_IF;
        active := -1; state := 0;
    END_IF;

99:
    D2004 := 0;
    IF ABS(D1004)<=20 AND ABS(D1005)<=100 THEN state := 28; END_IF;

END_CASE;

END_PROGRAM