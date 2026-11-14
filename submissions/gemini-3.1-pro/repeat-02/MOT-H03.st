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

    init : BOOL;
    state : DINT;
    req_idx : DINT;
    req_id : DINT;
    req_loc : DINT;
    req_cancelled : BOOL;
    r0_req : BOOL;
    r1_req : BOOL;
    dir3 : DINT;
    c3_pos : DINT;
    base3 : DINT;
    sync_timer : DINT;
    c4_tick : DINT;
    all_done_timer : DINT;
END_VAR

IF NOT init THEN
    D2000 := D1000;
    D2004 := D1004;
    D2008 := 15000;
    D2012 := 15000;
    D2016 := -50000;
    D2020 := -50000;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    D82 := 1;
    init := TRUE;
END_IF

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0; 
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;

r0_req := (D100 <> 0) AND NOT X30;
r1_req := (D120 <> 0) AND NOT X34;

IF state = 0 THEN
    req_cancelled := FALSE;
    IF r0_req THEN
        req_idx := 0;
        req_id := D100;
        req_loc := D101;
        state := 10;
    ELSIF r1_req THEN
        req_idx := 1;
        req_id := D120;
        req_loc := D121;
        state := 10;
    ELSIF X51 THEN
        state := 100;
    END_IF
END_IF

IF state > 0 AND state < 50 THEN
    IF (req_idx = 0 AND X31) OR (req_idx = 1 AND X35) THEN
        req_cancelled := TRUE;
        state := 90;
    END_IF
END_IF

CASE state OF
    10:
        IF req_loc = 0 THEN
            D2008 := 73250;
            D2000 := D403;
            IF ABS(D1008 - 73250) <= 20 AND ABS(D1000 - D403) <= 20 THEN
                state := 11;
            END_IF
        ELSE
            D2012 := 73250;
            D2000 := D406;
            IF ABS(D1012 - 73250) <= 20 AND ABS(D1000 - D406) <= 20 THEN
                state := 11;
            END_IF
        END_IF

    11:
        D2004 := 18000;
        IF D1004 >= 17980 THEN
            state := 12;
        END_IF

    12:
        D80 := 1;
        D81 := req_loc + 1;
        D82 := D82 + 1;
        state := 13;

    13:
        IF D90 = req_id THEN
            state := 14;
        END_IF

    14:
        D2004 := 0;
        IF D1004 <= 20 THEN
            state := 20;
        END_IF

    20:
        IF D500 >= 0 THEN dir3 := 1; ELSE dir3 := -1; END_IF
        c3_pos := D500 - 30000 * dir3;
        D2016 := c3_pos;
        D2020 := D501;
        D2024 := D502;
        D2000 := D409;
        IF ABS(D1016 - c3_pos) <= 20 AND ABS(D1020 - D501) <= 20 AND ABS(D1024 - D502) <= 20 AND ABS(D1000 - D409) <= 20 THEN
            base3 := D409 - D1016;
            sync_timer := 0;
            state := 21;
        END_IF

    21:
        c3_pos := c3_pos + 300 * dir3;
        D2016 := c3_pos;
        D2000 := base3 + c3_pos;
        D2018 := 15000 * dir3;
        D2002 := 15000 * dir3;
        sync_timer := sync_timer + 1;
        IF sync_timer >= 3 THEN
            state := 22;
        END_IF

    22:
        c3_pos := c3_pos + 300 * dir3;
        D2016 := c3_pos;
        D2000 := base3 + c3_pos;
        D2018 := 15000 * dir3;
        D2002 := 15000 * dir3;
        D2004 := 18000;
        IF D1004 >= 17980 THEN
            state := 23;
        END_IF

    23:
        c3_pos := c3_pos + 300 * dir3;
        IF (dir3 = 1 AND c3_pos >= D500) OR (dir3 = -1 AND c3_pos <= D500) THEN
            c3_pos := D500;
            state := 24;
        END_IF
        D2016 := c3_pos;
        D2000 := base3 + c3_pos;
        IF state = 23 THEN
            D2018 := 15000 * dir3;
            D2002 := 15000 * dir3;
        END_IF

    24:
        D2016 := D500;
        D2000 := base3 + D500;
        IF X70 THEN
            state := 25;
        END_IF

    25:
        D2004 := 0;
        IF D1004 <= 20 THEN
            state := 30;
        END_IF

    30:
        D2000 := D412;
        D2028 := 0;
        D2032 := 0;
        IF ABS(D1000 - D412) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
            state := 31;
        END_IF

    31:
        D2004 := 18000;
        IF D1004 >= 17980 THEN
            c4_tick := 0;
            state := 32;
        END_IF

    32:
        c4_tick := c4_tick + 1;
        IF c4_tick >= 100 THEN
            D2028 := D600;
            D2032 := D601;
            state := 33;
        ELSE
            D2028 := (D600 * c4_tick) / 100;
            D2032 := (D601 * c4_tick) / 100;
            D2030 := D600 / 2;
            D2034 := D601 / 2;
        END_IF

    33:
        IF X75 THEN
            state := 34;
        END_IF

    34:
        D2004 := 0;
        IF D1004 <= 20 THEN
            state := 50;
        END_IF

    90:
        D2004 := 0;
        IF D1004 <= 20 THEN
            state := 50;
        END_IF

    50:
        D2004 := 0;
        IF req_loc = 0 THEN
            D2008 := 73250;
            D2000 := D403;
            IF ABS(D1008 - 73250) <= 20 AND ABS(D1000 - D403) <= 20 THEN
                state := 51;
            END_IF
        ELSE
            D2012 := 73250;
            D2000 := D406;
            IF ABS(D1012 - 73250) <= 20 AND ABS(D1000 - D406) <= 20 THEN
                state := 51;
            END_IF
        END_IF

    51:
        D2004 := 18000;
        IF D1004 >= 17980 THEN
            state := 52;
        END_IF

    52:
        D80 := 2;
        D81 := req_loc + 1;
        D82 := D82 + 1;
        state := 53;

    53:
        IF D90 = 0 THEN
            state := 54;
        END_IF

    54:
        D2004 := 0;
        IF D1004 <= 20 THEN
            state := 55;
        END_IF

    55:
        D2008 := 15000;
        D2012 := 15000;
        IF req_loc = 0 THEN
            IF ABS(D1008 - 15000) <= 20 THEN state := 56; END_IF
        ELSE
            IF ABS(D1012 - 15000) <= 20 THEN state := 56; END_IF
        END_IF

    56:
        IF req_idx = 0 THEN
            D300 := req_id;
            D301 := SEL(req_cancelled, 1, 2);
            IF X30 THEN state := 57; END_IF
        ELSE
            D302 := req_id;
            D303 := SEL(req_cancelled, 1, 2);
            IF X34 THEN state := 57; END_IF
        END_IF

    57:
        IF req_idx = 0 THEN
            D300 := 0;
            D301 := 0;
        ELSE
            D302 := 0;
            D303 := 0;
        END_IF
        state := 0;

    100:
        D2000 := 0;
        D2004 := 0;
        D2008 := 15000;
        D2012 := 15000;
        D2016 := -50000;
        D2020 := -50000;
        D2024 := 0;
        D2028 := 0;
        D2032 := 0;
        IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND 
           ABS(D1016 + 50000) <= 20 AND ABS(D1020 + 50000) <= 20 AND ABS(D1024) <= 20 AND 
           ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
            all_done_timer := all_done_timer + 1;
            IF all_done_timer >= 5 THEN
                Y2 := TRUE;
            END_IF
        ELSE
            all_done_timer := 0;
            Y2 := FALSE;
        END_IF
END_CASE

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE; Y44 := TRUE;
Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
Y30 := FALSE;

END_PROGRAM