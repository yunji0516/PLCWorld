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

    init : BOOL := FALSE;
    state : DINT := 0;
    curr_idx : DINT := 0;
    curr_id : DINT := 0;
    curr_loc : DINT := 0;
    couple_seq : DINT := 0;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    is_cancelled : BOOL := FALSE;
    final_status : DINT := 1;
END_VAR

IF NOT init THEN
    couple_seq := 1;
    D2000 := 0; D2004 := 0;
    D2008 := 15000; D2012 := 15000;
    D2016 := -85000; D2020 := -85000;
    D2024 := -65000; D2028 := 65000; D2032 := 0;
    init := TRUE;
END_IF;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000;
Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
Y30 := FALSE;

IF D100 = 0 THEN
    r0_done := FALSE;
    D300 := 0;
    D301 := 0;
END_IF;
IF D120 = 0 THEN
    r1_done := FALSE;
    D302 := 0;
    D303 := 0;
END_IF;

is_cancelled := (curr_idx = 0 AND X31) OR (curr_idx = 1 AND X35);
IF is_cancelled THEN
    IF state >= 1 AND state <= 3 THEN
        state := 18;
    ELSIF state = 5 OR state = 6 OR state = 13 OR state = 20 THEN
        state := 14;
    ELSIF state = 9 THEN
        state := 10;
    ELSIF state >= 23 AND state <= 25 THEN
        state := 26;
    END_IF;
END_IF;

CASE state OF
    0:
        Y70 := FALSE; Y71 := FALSE;
        Y75 := FALSE; Y76 := FALSE;
        IF D100 > 0 AND NOT r0_done THEN
            curr_idx := 0;
            curr_id := D100;
            curr_loc := D101;
            state := 1;
        ELSIF D120 > 0 AND NOT r1_done THEN
            curr_idx := 1;
            curr_id := D120;
            curr_loc := D121;
            state := 1;
        ELSIF X51 THEN
            state := 99;
        END_IF;

    1:
        IF curr_loc = 1 THEN
            D2008 := D92;
            D2000 := -360000;
            IF ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 AND ABS(D1000 - -360000) <= 20 AND ABS(D1001) <= 100 THEN
                state := 2;
            END_IF;
        ELSE
            D2012 := D92;
            D2000 := -230000;
            IF ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 AND ABS(D1000 - -230000) <= 20 AND ABS(D1001) <= 100 THEN
                state := 2;
            END_IF;
        END_IF;

    2:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 1;
            D81 := curr_loc;
            couple_seq := couple_seq + 1;
            D82 := couple_seq;
            state := 3;
        END_IF;

    3:
        IF D90 = curr_id THEN
            state := 4;
        END_IF;

    4:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 5;
        END_IF;

    5:
        D2000 := 0;
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 THEN
            state := 6;
        END_IF;

    6:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2;
            D81 := 3;
            couple_seq := couple_seq + 1;
            D82 := couple_seq;
            state := 7;
        END_IF;

    7:
        IF D90 = 0 AND D409 = curr_id THEN
            state := 8;
        END_IF;

    8:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 9;
        END_IF;

    9:
        Y70 := TRUE;
        Y71 := TRUE;
        D700 := curr_id;
        D2016 := D500;
        D2020 := D501;
        IF X70 THEN
            state := 10;
        END_IF;

    10:
        D2000 := 0;
        IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
            D2004 := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D80 := 1;
                D81 := 3;
                couple_seq := couple_seq + 1;
                D82 := couple_seq;
                state := 11;
            END_IF;
        END_IF;

    11:
        IF D90 = curr_id THEN
            state := 12;
        END_IF;

    12:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y70 := FALSE;
            Y71 := FALSE;
            state := 125;
        END_IF;

    125:
        D2016 := -85000;
        D2020 := -85000;
        IF ABS(D1016 - -85000) <= 20 AND ABS(D1020 - -85000) <= 20 THEN
            state := 13;
        END_IF;

    13:
        D2000 := 360000;
        IF ABS(D1000 - 360000) <= 20 AND ABS(D1001) <= 100 THEN
            state := 20;
        END_IF;

    20:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2;
            D81 := 4;
            couple_seq := couple_seq + 1;
            D82 := couple_seq;
            state := 21;
        END_IF;

    21:
        IF D90 = 0 AND D412 = curr_id THEN
            state := 22;
        END_IF;

    22:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 23;
        END_IF;

    23:
        Y75 := TRUE;
        Y76 := TRUE;
        D710 := curr_id;
        IF D602 > 18000 THEN
            D2032 := D602;
        ELSE
            D2032 := 18000;
        END_IF;
        IF D1032 >= 17640 OR ABS(D1032 - D2032) <= 20 THEN
            state := 24;
        END_IF;

    24:
        D2024 := D600;
        D2028 := D601;
        IF ABS(D1024 - D600) <= 20 AND ABS(D1028 - D601) <= 20 THEN
            state := 25;
        END_IF;

    25:
        D2032 := D602;
        IF X75 THEN
            state := 26;
        END_IF;

    26:
        IF D1032 > 18000 THEN
            D2032 := D1032;
        ELSE
            D2032 := 18000;
        END_IF;
        IF D1032 >= 17640 THEN
            state := 27;
        END_IF;

    27:
        D2000 := 360000;
        IF ABS(D1000 - 360000) <= 20 AND ABS(D1001) <= 100 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100 AND ABS(D1033) <= 100 THEN
            D2004 := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D80 := 1;
                D81 := 4;
                couple_seq := couple_seq + 1;
                D82 := couple_seq;
                state := 28;
            END_IF;
        END_IF;

    28:
        IF D90 = curr_id THEN
            state := 29;
        END_IF;

    29:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            Y75 := FALSE;
            Y76 := FALSE;
            state := 30;
        END_IF;

    30:
        D2024 := -65000;
        D2028 := 65000;
        IF ABS(D1024 - -65000) <= 20 AND ABS(D1028 - 65000) <= 20 THEN
            state := 31;
        END_IF;

    31:
        D2032 := 0;
        IF ABS(D1032) <= 20 THEN
            state := 14;
        END_IF;

    14:
        IF curr_loc = 1 THEN
            D2000 := -360000;
            IF ABS(D1000 - -360000) <= 20 AND ABS(D1001) <= 100 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100 THEN
                state := 15;
            END_IF;
        ELSE
            D2000 := -230000;
            IF ABS(D1000 - -230000) <= 20 AND ABS(D1001) <= 100 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100 THEN
                state := 15;
            END_IF;
        END_IF;

    15:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            D80 := 2;
            D81 := curr_loc;
            couple_seq := couple_seq + 1;
            D82 := couple_seq;
            state := 16;
        END_IF;

    16:
        IF D90 = 0 THEN
            IF curr_loc = 1 AND D404 = curr_id THEN
                state := 17;
            ELSIF curr_loc = 2 AND D407 = curr_id THEN
                state := 17;
            END_IF;
        END_IF;

    17:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 18;
        END_IF;

    18:
        IF curr_loc = 1 THEN
            D2008 := 15000;
            IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
                state := 19;
            END_IF;
        ELSE
            D2012 := 15000;
            IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
                state := 19;
            END_IF;
        END_IF;

    19:
        IF is_cancelled THEN
            final_status := 2;
        ELSE
            final_status := 1;
        END_IF;
        IF curr_idx = 0 THEN
            D300 := curr_id;
            D301 := final_status;
            r0_done := TRUE;
        ELSE
            D302 := curr_id;
            D303 := final_status;
            r1_done := TRUE;
        END_IF;
        state := 0;

    99:
        D2000 := 0; D2004 := 0;
        D2008 := 15000; D2012 := 15000;
        D2016 := -85000; D2020 := -85000;
        D2024 := -65000; D2028 := 65000; D2032 := 0;
        
        IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20
           AND ABS(D1016 - -85000) <= 20 AND ABS(D1020 - -85000) <= 20
           AND ABS(D1024 - -65000) <= 20 AND ABS(D1028 - 65000) <= 20 AND ABS(D1032) <= 20 THEN
            Y2 := TRUE;
        ELSE
            Y2 := FALSE;
        END_IF;

END_CASE;

END_PROGRAM
```