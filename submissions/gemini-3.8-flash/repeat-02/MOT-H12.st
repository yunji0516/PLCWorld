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

    init_done : BOOL := FALSE;
    state : INT := 0;
    seq_counter : DINT := 1;
    curr_req : INT := 0;
    curr_id : DINT := 0;
    curr_origin : DINT := 0;
    curr_cancelled : BOOL := FALSE;
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    wait_cnt : DINT := 0;

    c3_exec : BOOL := FALSE;
    c4_exec : BOOL := FALSE;

    all_finished : BOOL := FALSE;
    comp_cnt : DINT := 0;
END_VAR

IF NOT init_done THEN
    D2000 := 0;
    D2001 := 1000;
    D2002 := 0;
    Y40 := TRUE;

    D2004 := 0;
    D2005 := 1000;
    D2006 := 0;
    Y41 := TRUE;

    D2008 := 15000;
    D2009 := 1000;
    D2010 := 0;
    Y42 := TRUE;

    D2012 := 15000;
    D2013 := 1000;
    D2014 := 0;
    Y43 := TRUE;

    D2016 := -85000;
    D2017 := 1000;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := -85000;
    D2021 := 1000;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := -65000;
    D2025 := 1000;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := 65000;
    D2029 := 1000;
    D2030 := 0;
    Y47 := TRUE;

    D2032 := 0;
    D2033 := 1000;
    D2034 := 0;
    Y48 := TRUE;

    Y30 := FALSE;
    Y2 := FALSE;
    D80 := 0;
    D81 := 0;
    D82 := 0;

    init_done := TRUE;
END_IF;

IF NOT all_finished THEN
    CASE state OF
        0:
            IF D100 > 0 AND NOT req0_done THEN
                curr_req := 0;
                curr_id := D100;
                curr_origin := D101;
                curr_cancelled := X31;
                state := 10;
            ELSIF D120 > 0 AND NOT req1_done THEN
                curr_req := 1;
                curr_id := D120;
                curr_origin := D121;
                curr_cancelled := X35;
                state := 10;
            ELSIF (req0_done OR D100 = 0) AND (req1_done OR D120 = 0) AND X51 THEN
                state := 900;
            END_IF;

        10:
            IF curr_origin = 1 THEN
                D2008 := D92;
                D2000 := D403;
            ELSE
                D2012 := D92;
                D2000 := D406;
            END_IF;
            state := 11;

        11:
            IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
                IF (curr_origin = 1 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100) OR
                   (curr_origin = 2 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100) THEN
                    D80 := 1;
                    D81 := curr_origin;
                    seq_counter := seq_counter + 1;
                    D82 := seq_counter;
                    D2004 := 18000;
                    state := 12;
                END_IF;
            END_IF;

        12:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D2004 := 0;
                state := 13;
            END_IF;

        13:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                D80 := 0;
                D81 := 0;
                IF curr_origin = 1 THEN
                    D2008 := 15000;
                ELSE
                    D2012 := 15000;
                END_IF;
                IF curr_cancelled THEN
                    state := 400;
                ELSE
                    state := 100;
                END_IF;
            END_IF;

        100:
            D2000 := D409;
            state := 101;

        101:
            IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
                D80 := 2;
                D81 := 3;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                D2004 := 18000;
                state := 102;
            END_IF;

        102:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D2004 := 0;
                state := 103;
            END_IF;

        103:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                D80 := 0;
                D81 := 0;
                c3_exec := FALSE;
                state := 110;
            END_IF;

        110:
            IF NOT c3_exec THEN
                IF D520 = 0 THEN
                    D2016 := D500;
                ELSE
                    D2020 := D501;
                END_IF;
                c3_exec := TRUE;
            END_IF;
            IF X70 THEN
                D2016 := -85000;
                D2020 := -85000;
                state := 120;
            END_IF;

        120:
            IF ABS(D1016 - (-85000)) <= 20 AND ABS(D1017) <= 100 AND
               ABS(D1020 - (-85000)) <= 20 AND ABS(D1021) <= 100 THEN
                D80 := 1;
                D81 := 3;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                D2004 := 18000;
                state := 121;
            END_IF;

        121:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D2004 := 0;
                state := 122;
            END_IF;

        122:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                D80 := 0;
                D81 := 0;
                state := 200;
            END_IF;

        200:
            D2000 := D412;
            state := 201;

        201:
            IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
                D80 := 2;
                D81 := 4;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                D2004 := 18000;
                state := 202;
            END_IF;

        202:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D2004 := 0;
                state := 203;
            END_IF;

        203:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                D80 := 0;
                D81 := 0;
                c4_exec := FALSE;
                state := 210;
            END_IF;

        210:
            IF NOT c4_exec THEN
                D2032 := 25000;
                state := 211;
            END_IF;

        211:
            IF ABS(D1032 - 25000) <= 20 AND ABS(D1033) <= 100 THEN
                IF D620 = 0 THEN
                    D2024 := D600;
                ELSE
                    D2028 := D601;
                END_IF;
                c4_exec := TRUE;
                state := 212;
            END_IF;

        212:
            IF X75 THEN
                D2024 := -65000;
                D2028 := 65000;
                state := 213;
            END_IF;

        213:
            IF ABS(D1024 - (-65000)) <= 20 AND ABS(D1025) <= 100 AND
               ABS(D1028 - 65000) <= 20 AND ABS(D1029) <= 100 THEN
                D2032 := 0;
                state := 214;
            END_IF;

        214:
            IF ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
                D80 := 1;
                D81 := 4;
                seq_counter := seq_counter + 1;
                D82 := seq_counter;
                D2004 := 18000;
                state := 220;
            END_IF;

        220:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D2004 := 0;
                state := 221;
            END_IF;

        221:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                D80 := 0;
                D81 := 0;
                state := 400;
            END_IF;

        400:
            IF curr_origin = 1 THEN
                D2000 := D403;
                D2008 := D92;
            ELSE
                D2000 := D406;
                D2012 := D92;
            END_IF;
            state := 401;

        401:
            IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
                IF (curr_origin = 1 AND ABS(D1008 - D92) <= 20 AND ABS(D1009) <= 100) OR
                   (curr_origin = 2 AND ABS(D1012 - D92) <= 20 AND ABS(D1013) <= 100) THEN
                    D80 := 2;
                    D81 := curr_origin;
                    seq_counter := seq_counter + 1;
                    D82 := seq_counter;
                    D2004 := 18000;
                    state := 402;
                END_IF;
            END_IF;

        402:
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                D2004 := 0;
                state := 403;
            END_IF;

        403:
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
                D80 := 0;
                D81 := 0;
                IF curr_origin = 1 THEN
                    D2008 := 15000;
                ELSE
                    D2012 := 15000;
                END_IF;
                state := 404;
            END_IF;

        404:
            IF (curr_origin = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
               (curr_origin = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
                IF curr_req = 0 THEN
                    D300 := curr_id;
                    IF curr_cancelled THEN
                        D301 := 2;
                    ELSE
                        D301 := 1;
                    END_IF;
                    req0_done := TRUE;
                ELSE
                    D302 := curr_id;
                    IF curr_cancelled THEN
                        D303 := 2;
                    ELSE
                        D303 := 1;
                    END_IF;
                    req1_done := TRUE;
                END_IF;
                state := 0;
            END_IF;

        900:
            D2000 := 0;
            D2004 := 0;
            D2008 := 15000;
            D2012 := 15000;
            D2016 := -85000;
            D2020 := -85000;
            D2024 := -65000;
            D2028 := 65000;
            D2032 := 0;
            state := 901;

        901:
            IF ABS(D1000) <= 20 AND ABS(D1001) <= 100 AND
               ABS(D1004) <= 20 AND ABS(D1005) <= 100 AND
               ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 AND
               ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 AND
               ABS(D1016 - (-85000)) <= 20 AND ABS(D1017) <= 100 AND
               ABS(D1020 - (-85000)) <= 20 AND ABS(D1021) <= 100 AND
               ABS(D1024 - (-65000)) <= 20 AND ABS(D1025) <= 100 AND
               ABS(D1028 - 65000) <= 20 AND ABS(D1029) <= 100 AND
               ABS(D1032) <= 20 AND ABS(D1033) <= 100 THEN
                all_finished := TRUE;
            END_IF;
    END_CASE;
END_IF;

IF all_finished THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM