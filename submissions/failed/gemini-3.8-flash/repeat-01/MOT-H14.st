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
    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    curr_req : INT := 0;
    curr_id : DINT := 0;
    curr_lift : INT := 1;
    dock_ht : DINT := 73250;
    lift_port_x : DINT := -360000;
    cell3_port_x : DINT := 0;
    cell4_port_x : DINT := 360000;
    couple_seq_num : DINT := 0;
    settle_cnt : INT := 0;
    captured_axis : INT := 0;
    captured_val : DINT := 0;
    axis_in_pos : BOOL := FALSE;
    lift_ready : BOOL := FALSE;
    lift_down : BOOL := FALSE;
    all_home : BOOL := FALSE;
END_VAR

IF NOT init_done THEN
    init_done := TRUE;
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

    D2016 := -60000;
    D2017 := 1000;
    D2018 := 0;
    Y44 := TRUE;

    D2020 := -60000;
    D2021 := 1000;
    D2022 := 0;
    Y45 := TRUE;

    D2024 := -60000;
    D2025 := 1000;
    D2026 := 0;
    Y46 := TRUE;

    D2028 := -60000;
    D2029 := 1000;
    D2030 := 0;
    Y47 := TRUE;

    Y30 := TRUE;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
    Y2 := FALSE;
END_IF;

IF D92 <> 0 THEN
    dock_ht := D92;
ELSE
    dock_ht := 73250;
END_IF;

IF D409 <> 0 THEN
    cell3_port_x := D409;
ELSE
    cell3_port_x := 0;
END_IF;

IF D412 <> 0 THEN
    cell4_port_x := D412;
ELSE
    cell4_port_x := 360000;
END_IF;

IF curr_lift = 1 THEN
    IF D403 <> 0 THEN
        lift_port_x := D403;
    ELSE
        lift_port_x := -360000;
    END_IF;
ELSE
    IF D406 <> 0 THEN
        lift_port_x := D406;
    ELSE
        lift_port_x := -230000;
    END_IF;
END_IF;

CASE state OF
    0:
        IF (NOT req0_done) AND (D100 > 0) AND X31 THEN
            D300 := D100;
            D301 := 2;
            req0_done := TRUE;
        ELSIF (NOT req1_done) AND (D120 > 0) AND X35 THEN
            D302 := D120;
            D303 := 2;
            req1_done := TRUE;
        ELSIF (NOT req0_done) AND (D100 > 0) THEN
            curr_req := 0;
            curr_id := D100;
            curr_lift := 1;
            settle_cnt := 0;
            state := 10;
        ELSIF (NOT req1_done) AND (D120 > 0) THEN
            curr_req := 1;
            curr_id := D120;
            curr_lift := 2;
            settle_cnt := 0;
            state := 10;
        ELSIF req0_done AND req1_done AND X51 THEN
            settle_cnt := 0;
            state := 900;
        END_IF;

    10:
        IF curr_lift = 1 THEN
            Y30 := FALSE;
            D2008 := dock_ht;
            IF X53 AND (ABS(D1008 - dock_ht) <= 20) AND (ABS(D1009) <= 100) AND X61 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    Y30 := TRUE;
                    state := 20;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        ELSE
            Y30 := FALSE;
            D2012 := dock_ht;
            IF X53 AND (ABS(D1012 - dock_ht) <= 20) AND (ABS(D1013) <= 100) AND X62 THEN
                settle_cnt := settle_cnt + 1;
                IF settle_cnt >= 2 THEN
                    settle_cnt := 0;
                    Y30 := TRUE;
                    state := 20;
                END_IF;
            ELSE
                settle_cnt := 0;
            END_IF;
        END_IF;

    20:
        D2000 := lift_port_x;
        D2004 := 0;
        IF (ABS(D1000 - lift_port_x) <= 20) AND (ABS(D1001) <= 100) AND
           ((curr_lift = 1 AND X61) OR (curr_lift = 2 AND X62)) THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                state := 30;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    30:
        D2004 := 18000;
        IF (ABS(D1004 - 18000) <= 20) AND (ABS(D1005) <= 100) THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                couple_seq_num := couple_seq_num + 1;
                D80 := 1;
                D81 := INT_TO_DINT(curr_lift);
                D82 := couple_seq_num;
                state := 40;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    40:
        IF D90 = curr_id THEN
            D2004 := 0;
            state := 50;
        END_IF;

    50:
        D2004 := 0;
        IF (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) THEN
            settle_cnt := settle_cnt + 1;
            IF settle_cnt >= 2 THEN
                settle_cnt := 0;
                state := 100;
            END_IF;
        ELSE
            settle_cnt := 0;
        END_IF;

    100:
        D2000 := cell3_port_x;
        D2004 := 0;
        D2016 := -60000;
