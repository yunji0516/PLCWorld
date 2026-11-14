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
    substate : INT := 0;
    timer_ticks : DINT := 0;
    completion_ticks : DINT := 0;

    active_channel : INT := 0;
    cur_req_id : DINT := 0;
    cur_station : DINT := 1;
    dock_pos : DINT := -360000;

    rad : REAL := 0.0;
    cw_pos : REAL := 0.0;

    lift_at_dock : BOOL := FALSE;
    shuttle_at_dock : BOOL := FALSE;
    c3_at_home : BOOL := FALSE;
    c4_at_home : BOOL := FALSE;
    lifts_at_home : BOOL := FALSE;
    all_idle_at_home : BOOL := FALSE;
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

    D2016 := 0;
    D2017 := 1000;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := 0;
    D2021 := 1000;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := 100000;
    D2025 := 1000;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := 0;
    D2029 := 1000;
    D2030 := 0;
    Y47 := TRUE;

    D2032 := 0;
    D2033 := 0;
    D2034 := 0;
    Y48 := FALSE;

    Y30 := TRUE;
    Y2 := FALSE;

    D80 := 0;
    D81 := 0;
    D82 := 0;

    D300 := 0;
    D301 := 0;
    D302 := 0;
    D303 := 0;

    Y70 := FALSE;
    Y71 := FALSE;
    D700 := 0;
    D701 := 0;
    D702 := 0;

    Y75 := FALSE;
    Y76 := FALSE;
    D710 := 0;
    D711 := 0;
    D712 := 0;

    init_done := TRUE;
END_IF;

D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := FALSE;

rad := REAL(D1016) * 0.01 * 3.141592653589793 / 180.0;
cw_pos := -450.0 * SIN(rad);
D2020 := DINT(cw_pos * 100.0);

c3_at_home := (ABS(D1016) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020) <= 20) AND (ABS(D1021) <= 100);
c4_at_home := (ABS(D1024 - 100000) <= 20) AND (ABS(D1025) <= 100) AND
              (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
              (ABS(D1032) <= 3) AND (ABS(D1033) <= 15);
lifts_at_home := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
                 (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);

CASE state OF
    0:
        IF D100 > 0 AND D300 <> D100 THEN
            active_channel := 0;
            cur_req_id := D100;
            state := 10;
            substate := 0;
            timer_ticks := 0;
        ELSIF D120 > 0 AND D302 <> D120 THEN
            active_channel := 1;
            cur_req_id := D120;
            state := 10;
            substate := 0;
            timer_ticks := 0;
        END_IF;

    10:
        IF D407 = cur_req_id OR (active_channel = 0 AND D101 = 2) OR (active_channel = 1 AND D121 = 2) THEN
            cur_station := 2;
            IF D406 <> 0 THEN dock_pos := D406; ELSE dock_pos := -230000; END_IF;
        ELSE
            cur_station := 1;
            IF D403 <> 0 THEN dock_pos := D403; ELSE dock_pos := -360000; END_IF;
        END_IF;
        state := 20;
        substate := 0;
        timer_ticks := 0;

    20:
        CASE substate OF
            0:
                Y30 := FALSE;
                timer_ticks := timer_ticks + 1;
                IF X53 OR timer_ticks >= 5 THEN
                    substate := 1;
                    timer_ticks := 0;
                END_IF;

            1:
                IF cur_station = 1 THEN
                    IF D92 <> 0 THEN D2008 := D92; ELSE D2008 := 73250; END_IF;
                ELSE
                    IF D92 <> 0 THEN D2012 := D92; ELSE D2012 := 73250; END_IF;
                END_IF;
                D2000 := dock_pos;

                IF cur_station = 1 THEN
                    lift_at_dock := (ABS(D1008 - D2008) <= 20) AND (ABS(D1009) <= 100);
                ELSE
                    lift_at_dock := (ABS(D1012 - D2012) <= 20) AND (ABS(D1013) <= 100);
                END_IF;
                shuttle_at_dock := (ABS(D1000 - dock_pos) <= 20) AND (ABS(D1001) <= 100);

                IF (lift_at_dock OR (cur_station = 1 AND X61) OR (cur_station = 2 AND X62)) AND shuttle_at_dock THEN
                    substate := 2;
                    timer_ticks := 0;
                END_IF;

            2:
                IF ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
                    Y30 := TRUE;
                    timer_ticks := timer_ticks + 1;
                    IF X52 OR timer_ticks >= 5 THEN
                        state := 30;
                        substate := 0;
                        timer_ticks := 0;
                    END_IF;
                END_IF;
        END_CASE;

    30:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 31;
            timer_ticks := 0;
        END_IF;

    31:
        D80 := 1;
        D81 := cur_station;
        D82 := D82 + 1;
        state := 32;
        timer_ticks := 0;

    32:
        timer_ticks := timer_ticks + 1;
        IF D90 = cur_req_id OR timer_ticks >= 5 THEN
            state := 33;
            timer_ticks := 0;
        END_IF;

    33:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 40;
            substate := 0;
            timer_ticks := 0;
        END_IF;

    40:
        IF D409 <> 0 THEN D2000 := D409; ELSE D2000 := 230000; END_IF;
        D2016 := 0;
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (X63 OR c3_at_home) THEN
            state := 50;
            timer_ticks := 0;
        END_IF;

    50:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 51;
            timer_ticks := 0;
        END_IF;

    51:
        D80 := 2;
        D81 := 3;
        D82 := D82 + 1;
        state := 52;
        timer_ticks := 0;

    52:
        timer_ticks := timer_ticks + 1;
        IF D90 = 0 OR timer_ticks >= 5 THEN
            state := 53;
            timer_ticks := 0;
        END_IF;

    53:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 60;
            timer_ticks := 0;
        END_IF;

    60:
        D2016 := D500;
        IF (ABS(D1016 - D500) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020 - D2020) <= 20) AND (ABS(D1021) <= 100) THEN
            timer_ticks := timer_ticks + 1;
            IF X70 OR timer_ticks >= 5 THEN
                state := 65;
                timer_ticks := 0;
            END_IF;
        END_IF;

    65:
        D2016 := 0;
        IF X63 OR c3_at_home THEN
            state := 70;
            timer_ticks := 0;
        END_IF;

    70:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 71;
            timer_ticks := 0;
        END_IF;

    71:
        D80 := 1;
        D81 := 3;
        D82 := D82 + 1;
        state := 72;
        timer_ticks := 0;

    72:
        timer_ticks := timer_ticks + 1;
        IF D90 = cur_req_id OR timer_ticks >= 5 THEN
            state := 73;
            timer_ticks := 0;
        END_IF;

    73:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 80;
            timer_ticks := 0;
        END_IF;

    80:
        IF D412 <> 0 THEN D2000 := D412; ELSE D2000 := 990000; END_IF;
        D2024 := 100000;
        D2028 := 0;
        IF (ABS(D1000 - D2000) <= 20) AND (ABS(D1001) <= 100) AND (X64 OR c4_at_home) THEN
            state := 90;
            timer_ticks := 0;
        END_IF;

    90:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 91;
            timer_ticks := 0;
        END_IF;

    91:
        D80 := 2;
        D81 := 4;
        D82 := D82 + 1;
        state := 92;
        timer_ticks := 0;

    92:
        timer_ticks := timer_ticks + 1;
        IF D90 = 0 OR timer_ticks >= 5 THEN
            state := 93;
            timer_ticks := 0;
        END_IF;

    93:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 100;
            timer_ticks := 0;
        END_IF;

    100:
        IF D600 <> 0 THEN D2024 := D600; ELSE D2024 := 70000; END_IF;
        D2028 := D601;
        IF (ABS(D1024 - D2024) <= 20) AND (ABS(D1025) <= 100) AND
           (ABS(D1028 - D2028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032) <= 3) AND (ABS(D1033) <= 15) THEN
            timer_ticks := timer_ticks + 1;
            IF X75 OR timer_ticks >= 5 THEN
                state := 105;
                timer_ticks := 0;
            END_IF;
        END_IF;

    105:
        D2024 := 100000;
        D2028 := 0;
        IF X64 OR c4_at_home THEN
            state := 110;
            timer_ticks := 0;
        END_IF;

    110:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 111;
            timer_ticks := 0;
        END_IF;

    111:
        D80 := 1;
        D81 := 4;
        D82 := D82 + 1;
        state := 112;
        timer_ticks := 0;

    112:
        timer_ticks := timer_ticks + 1;
        IF D90 = cur_req_id OR timer_ticks >= 5 THEN
            state := 113;
            timer_ticks := 0;
        END_IF;

    113:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 120;
            timer_ticks := 0;
        END_IF;

    120:
        D2000 := dock_pos;
        IF ABS(D1000 - dock_pos) <= 20 AND ABS(D1001) <= 100 THEN
            state := 130;
            timer_ticks := 0;
        END_IF;

    130:
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            state := 131;
            timer_ticks := 0;
        END_IF;

    131:
        D80 := 2;
        D81 := cur_station;
        D82 := D82 + 1;
        state := 132;
        timer_ticks := 0;

    132:
        timer_ticks := timer_ticks + 1;
        IF D90 = 0 OR timer_ticks >= 5 THEN
            state := 133;
            timer_ticks := 0;
        END_IF;

    133:
        D2004 := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            state := 140;
            substate := 0;
            timer_ticks := 0;
        END_IF;

    140:
        CASE substate OF
            0:
                Y30 := FALSE;
                timer_ticks := timer_ticks + 1;
                IF X53 OR timer_ticks >= 5 THEN
                    substate := 1;
                    timer_ticks := 0;
                END_IF;

            1:
                IF cur_station = 1 THEN D2008 := 15000; ELSE D2012 := 15000; END_IF;
                D2000 := 0;

                IF (cur_station = 1 AND ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100) OR
                   (cur_station = 2 AND ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100) THEN
                    substate := 2;
                    timer_ticks := 0;
                END_IF;

            2:
                IF ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
                    Y30 := TRUE;
                    timer_ticks := timer_ticks + 1;
                    IF X52 OR timer_ticks >= 5 THEN
                        state := 150;
                        substate := 0;
                        timer_ticks := 0;
                    END_IF;
                END_IF;
        END_CASE;

    150:
        IF active_channel = 0 THEN
            D300 := cur_req_id;
            IF X31 THEN D301 := 2; ELSE D301 := 1; END_IF;
        ELSE
            D302 := cur_req_id;
            IF X35 THEN D303 := 2; ELSE D303 := 1; END_IF;
        END_IF;
        active_channel := 0;
        cur_req_id := 0;
        state := 0;
        timer_ticks := 0;
END_CASE;

all_idle_at_home := (state = 0) AND
                    (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
                    (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
                    lifts_at_home AND c3_at_home AND c4_at_home;

IF X51 AND (D100 = 0 OR D300 = D100) AND (D120 = 0 OR D302 = D120) AND all_idle_at_home THEN
    completion_ticks := completion_ticks + 1;
    IF completion_ticks >= 5 THEN
        Y2 := TRUE;
    END_IF;
ELSE
    completion_ticks := 0;
END_IF;

END_PROGRAM