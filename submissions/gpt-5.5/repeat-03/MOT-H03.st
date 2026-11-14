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
    state : INT;
    req_index : INT;
    req_id : DINT;
    req_origin : INT;
    req_cancel : BOOL;
    req_returned : BOOL;
    seq : DINT;
    issued : BOOL;
    move_active : BOOL;
    move_start : DINT;
    final_declared : BOOL;
    ack0_done : BOOL;
    ack1_done : BOOL;
    ta : DINT;
    tb : DINT;
    tc : DINT;
    td : DINT;
    ts30 : DINT;
    ts31 : DINT;
    ts32 : DINT;
    ts40 : DINT;
    ts41 : DINT;
    source_x : DINT;
    source_id : DINT;
    source_ready : BOOL;
    lift_pos : DINT;
    lift_vel : DINT;
    action_cmd : DINT;
    station_cmd : DINT;
    arr_a : BOOL;
    arr_b : BOOL;
    arr_lift : BOOL;
    arr_s30 : BOOL;
    arr_s31 : BOOL;
    arr_s32 : BOOL;
    arr_s40 : BOOL;
    arr_s41 : BOOL;
    home_ok : BOOL;
    sync3_condition : BOOL;
    sync4_condition : BOOL;
    couple_wait : BOOL;
    ratio : DINT;
    master_expected_slave : DINT;
    master_expected_slave_vel : DINT;
    t_sync3 : TON;
    t_sync4 : TON;
    t_home : TON;
    t_couple : TON;
END_VAR

IF state = 0 THEN
    state := 10;
    req_index := 0;
    seq := 0;
    issued := FALSE;
    move_active := FALSE;
    final_declared := FALSE;
    ack0_done := FALSE;
    ack1_done := FALSE;
END_IF;

IF req_index = 0 THEN
    req_id := D100;
    IF D101 = 2 THEN
        req_origin := 2;
    ELSE
        req_origin := 1;
    END_IF;
    req_cancel := X31;
    req_returned := X30;
ELSE
    req_id := D120;
    IF D121 = 2 THEN
        req_origin := 2;
    ELSE
        req_origin := 1;
    END_IF;
    req_cancel := X35;
    req_returned := X34;
END_IF;

IF req_origin = 2 THEN
    source_x := D406;
    source_id := D407;
    source_ready := X62;
    lift_pos := D1012;
    lift_vel := D1013;
ELSE
    source_x := D403;
    source_id := D404;
    source_ready := X61;
    lift_pos := D1008;
    lift_vel := D1009;
END_IF;

ta := 0;
tb := 0;
tc := 15000;
td := 15000;
ts30 := -50000;
ts31 := -50000;
ts32 := 0;
ts40 := 0;
ts41 := 0;
action_cmd := 0;
station_cmd := 0;
sync3_condition := FALSE;
sync4_condition := FALSE;
couple_wait := FALSE;

ratio := 700;
IF D600 <> 0 THEN
    IF D601 > 3000 THEN
        ratio := LIMIT(100, (D601 * 1000) / D600, 1000);
    END_IF;
END_IF;

CASE state OF
    10:
        ta := source_x;
        tb := 0;
        IF req_origin = 2 THEN
            td := LIMIT(0, D92, 120000);
            tc := 15000;
        ELSE
            tc := LIMIT(0, D92, 120000);
            td := 15000;
        END_IF;
        IF req_id <> 0 THEN
            arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
            arr_b := (ABS(D1004 - tb) <= 20) AND (ABS(D1005) <= 100);
            arr_lift := (ABS(lift_pos - LIMIT(0, D92, 120000)) <= 20) AND (ABS(lift_vel) <= 100);
            IF arr_a AND arr_b AND arr_lift AND source_ready THEN
                issued := FALSE;
                state := 12;
            END_IF;
        END_IF;

    12:
        ta := source_x;
        tb := 18000;
        IF req_origin = 2 THEN
            td := LIMIT(0, D92, 120000);
            tc := 15000;
        ELSE
            tc := LIMIT(0, D92, 120000);
            td := 15000;
        END_IF;
        action_cmd := 1;
        station_cmd := req_origin;
        arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
        arr_b := (ABS(D1004 - tb) <= 20) AND (ABS(D1005) <= 100);
        arr_lift := (ABS(lift_pos - LIMIT(0, D92, 120000)) <= 20) AND (ABS(lift_vel) <= 100);
        IF arr_a AND arr_b AND arr_lift AND source_ready THEN
            IF NOT issued THEN
                seq := seq + 1;
                issued := TRUE;
            END_IF;
            couple_wait := TRUE;
            IF D90 = req_id THEN
                issued := FALSE;
                state := 14;
            END_IF;
        END_IF;

    14:
        ta := source_x;
        tb := 0;
        IF req_origin = 2 THEN
            td := LIMIT(0, D92, 120000);
            tc := 15000;
        ELSE
            tc := LIMIT(0, D92, 120000);
            td := 15000;
        END_IF;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            IF req_cancel THEN
                state := 60;
            ELSE
                move_active := FALSE;
                state := 20;
            END_IF;
        END_IF;

    20:
        ta := D409;
        tb := 0;
        ts30 := -50000;
        ts31 := -50000;
        ts32 := 0;
        arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
        arr_b := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        arr_s30 := (ABS(D1016 - ts30) <= 20) AND (ABS(D1017) <= 100);
        arr_s31 := (ABS(D1020 - ts31) <= 20) AND (ABS(D1021) <= 100);
        arr_s32 := (ABS(D1024 - ts32) <= 20) AND (ABS(D1025) <= 100);
        IF arr_a AND arr_b AND arr_s30 AND arr_s31 AND arr_s32 AND X63 THEN
            issued := FALSE;
            move_active := FALSE;
            state := 22;
        END_IF;

    22:
        ta := D409;
        tb := 18000;
        ts30 := -50000;
        ts31 := 70000;
        ts32 := 0;
        action_cmd := 2;
        station_cmd := 3;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) AND NOT move_active THEN
            move_start := D1000;
            move_active := TRUE;
        END_IF;
        sync3_condition := move_active AND (ABS(D1004 - 18000) <= 20) AND (ABS(D1000 - D409) <= 20) AND (ABS(D1001 - D1021) <= 100) AND (ABS(D1001) > 20);
        IF t_sync3.Q AND (ABS(D1000 - move_start) >= 20000) THEN
            IF NOT issued THEN
                seq := seq + 1;
                issued := TRUE;
            END_IF;
            couple_wait := TRUE;
            IF D410 = req_id THEN
                issued := FALSE;
                move_active := FALSE;
                state := 24;
            END_IF;
        END_IF;

    24:
        ta := D409;
        tb := 0;
        ts30 := D500;
        ts31 := D501;
        ts32 := D502;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 30;
        END_IF;

    30:
        ta := D409;
        tb := 0;
        ts30 := D500;
        ts31 := D501;
        ts32 := D502;
        Y70 := TRUE;
        Y71 := TRUE;
        IF X70 THEN
            issued := FALSE;
            state := 32;
        END_IF;

    32:
        ta := D409;
        tb := 18000;
        ts30 := D500;
        ts31 := D501;
        ts32 := D502;
        action_cmd := 1;
        station_cmd := 3;
        arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
        arr_b := (ABS(D1004 - tb) <= 20) AND (ABS(D1005) <= 100);
        IF arr_a AND arr_b AND X63 THEN
            IF NOT issued THEN
                seq := seq + 1;
                issued := TRUE;
            END_IF;
            couple_wait := TRUE;
            IF D90 = req_id THEN
                issued := FALSE;
                state := 34;
            END_IF;
        END_IF;

    34:
        ta := D409;
        tb := 0;
        ts30 := D500;
        ts31 := D501;
        ts32 := D502;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 40;
        END_IF;

    40:
        ta := D412;
        tb := 0;
        ts40 := 0;
        ts41 := 0;
        arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
        arr_b := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        arr_s40 := (ABS(D1028) <= 20) AND (ABS(D1029) <= 100);
        arr_s41 := (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
        IF arr_a AND arr_b AND arr_s40 AND arr_s41 AND X64 THEN
            issued := FALSE;
            state := 42;
        END_IF;

    42:
        ta := D412;
        tb := 18000;
        ts40 := 0;
        ts41 := 0;
        action_cmd := 2;
        station_cmd := 4;
        arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
        arr_b := (ABS(D1004 - tb) <= 20) AND (ABS(D1005) <= 100);
        IF arr_a AND arr_b AND X64 THEN
            IF NOT issued THEN
                seq := seq + 1;
                issued := TRUE;
            END_IF;
            couple_wait := TRUE;
            IF D413 = req_id THEN
                issued := FALSE;
                state := 44;
            END_IF;
        END_IF;

    44:
        ta := D412;
        tb := 0;
        ts40 := 0;
        ts41 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 50;
        END_IF;

    50:
        ta := D412;
        tb := 0;
        ts40 := D600;
        IF D601 > 3000 THEN
            ts41 := D601;
        ELSE
            ts41 := (D600 * ratio) / 1000;
        END_IF;
        Y75 := TRUE;
        Y76 := TRUE;
        master_expected_slave := (D1028 * ratio) / 1000;
        master_expected_slave_vel := (D1029 * ratio) / 1000;
        sync4_condition := (ABS(D1029) > 100) AND (ABS(D1032 - master_expected_slave) <= 20) AND (ABS(D1033 - master_expected_slave_vel) <= 100);
        IF X75 AND t_sync4.Q THEN
            issued := FALSE;
            state := 52;
        END_IF;

    52:
        ta := D412;
        tb := 18000;
        ts40 := D600;
        IF D601 > 3000 THEN
            ts41 := D601;
        ELSE
            ts41 := (D600 * ratio) / 1000;
        END_IF;
        action_cmd := 1;
        station_cmd := 4;
        arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
        arr_b := (ABS(D1004 - tb) <= 20) AND (ABS(D1005) <= 100);
        IF arr_a AND arr_b AND X64 THEN
            IF NOT issued THEN
                seq := seq + 1;
                issued := TRUE;
            END_IF;
            couple_wait := TRUE;
            IF D90 = req_id THEN
                issued := FALSE;
                state := 54;
            END_IF;
        END_IF;

    54:
        ta := D412;
        tb := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            state := 60;
        END_IF;

    60:
        ta := source_x;
        tb := 0;
        IF req_origin = 2 THEN
            td := LIMIT(0, D92, 120000);
            tc := 15000;
        ELSE
            tc := LIMIT(0, D92, 120000);
            td := 15000;
        END_IF;
        arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
        arr_b := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        arr_lift := (ABS(lift_pos - LIMIT(0, D92, 120000)) <= 20) AND (ABS(lift_vel) <= 100);
        IF arr_a AND arr_b AND arr_lift AND source_ready THEN
            issued := FALSE;
            state := 62;
        END_IF;

    62:
        ta := source_x;
        tb := 18000;
        IF req_origin = 2 THEN
            td := LIMIT(0, D92, 120000);
            tc := 15000;
        ELSE
            tc := LIMIT(0, D92, 120000);
            td := 15000;
        END_IF;
        action_cmd := 2;
        station_cmd := req_origin;
        arr_a := (ABS(D1000 - ta) <= 20) AND (ABS(D1001) <= 100);
        arr_b := (ABS(D1004 - tb) <= 20) AND (ABS(D1005) <= 100);
        arr_lift := (ABS(lift_pos - LIMIT(0, D92, 120000)) <= 20) AND (ABS(lift_vel) <= 100);
        IF arr_a AND arr_b AND arr_lift AND source_ready THEN
            IF NOT issued THEN
                seq := seq + 1;
                issued := TRUE;
            END_IF;
            couple_wait := TRUE;
            IF req_returned OR (source_id = req_id) THEN
                issued := FALSE;
                state := 64;
            END_IF;
        END_IF;

    64:
        ta := source_x;
        tb := 0;
        tc := 15000;
        td := 15000;
        arr_b := (ABS(D1004) <= 20) AND (ABS(D1005) <= 100);
        IF req_origin = 2 THEN
            arr_lift := (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100);
        ELSE
            arr_lift := (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100);
        END_IF;
        IF arr_b AND arr_lift THEN
            IF req_index = 0 THEN
                D300 := D100;
                IF X31 THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                ack0_done := TRUE;
                req_index := 1;
                state := 10;
            ELSE
                D302 := D120;
                IF X35 THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                ack1_done := TRUE;
                state := 100;
            END_IF;
        END_IF;

    100:
        ta := 0;
        tb := 0;
        tc := 15000;
        td := 15000;
        ts30 := -50000;
        ts31 := -50000;
        ts32 := 0;
        ts40 := 0;
        ts41 := 0;
        home_ok := (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
                   (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
                   (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
                   (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
                   (ABS(D1016 + 50000) <= 20) AND (ABS(D1017) <= 100) AND
                   (ABS(D1020 + 50000) <= 20) AND (ABS(D1021) <= 100) AND
                   (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
                   (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
                   (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
        IF X51 AND ack0_done AND ack1_done AND home_ok AND t_home.Q THEN
            final_declared := TRUE;
        END_IF;
ELSE
    state := 10;
END_CASE;

t_sync3(IN := sync3_condition, PT := T#60ms);
t_sync4(IN := sync4_condition, PT := T#60ms);

home_ok := (state = 100) AND X51 AND ack0_done AND ack1_done AND
           (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
           (ABS(D1016 + 50000) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020 + 50000) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024) <= 20) AND (ABS(D1025) <= 100) AND
           (ABS(D1028) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032) <= 20) AND (ABS(D1033) <= 100);
t_home(IN := home_ok, PT := T#40ms);
t_couple(IN := couple_wait AND issued, PT := T#1000ms);

D2000 := LIMIT(-450000, ta, 1130000);
D2004 := LIMIT(0, tb, 18000);
D2008 := LIMIT(0, tc, 120000);
D2012 := LIMIT(0, td, 120000);
D2016 := LIMIT(-95000, ts30, 95000);
D2020 := LIMIT(-95000, ts31, 95000);
D2024 := LIMIT(0, ts32, 18000);
D2028 := LIMIT(-360000, ts40, 360000);
D2032 := LIMIT(-360000, ts41, 360000);

D2001 := 1000;
D2005 := 1000;
D2009 := 1000;
D2013 := 1000;
D2017 := 1000;
D2021 := 1000;
D2025 := 1000;
D2029 := 1000;
D2033 := 1000;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;
D2034 := 0;

Y40 := TRUE;
Y41 := TRUE;
Y42 := TRUE;
Y43 := TRUE;
Y44 := TRUE;
Y45 := TRUE;
Y46 := TRUE;
Y47 := TRUE;
Y48 := TRUE;

IF NOT ((state = 30) OR (state = 32) OR (state = 34)) THEN
    Y70 := FALSE;
    Y71 := FALSE;
END_IF;
D700 := 1000;
D701 := D526;
D702 := 1000;

IF NOT ((state = 50) OR (state = 52) OR (state = 54)) THEN
    Y75 := FALSE;
    Y76 := FALSE;
END_IF;
D710 := ratio;
D711 := D626;
D712 := 1000;

D80 := action_cmd;
D81 := station_cmd;
D82 := seq;
Y30 := FALSE;

IF final_declared THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;
END_PROGRAM