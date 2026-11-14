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

    step : INT;
    cur_req : INT;
    cur_id : DINT;
    cur_loc : DINT;
    is_cancel : BOOL;
    seq_counter : DINT;

    r0_done : BOOL;
    r1_done : BOOL;

    timer_cnt : DINT;
    all_completed : BOOL;

    target_port_x : DINT;
    target_lift_pos : DINT;
    dock_h : DINT;
    target_a : DINT;
    target_b : DINT;
    target_c : DINT;
    target_d : DINT;
    target_s3_0 : DINT;
    target_s3_1 : DINT;
    target_s4_0 : DINT;
    target_s4_1 : DINT;
    target_s4_2 : DINT;

    a_arrived : BOOL;
    b_arrived : BOOL;
    lift_arrived : BOOL;
    s3_arrived : BOOL;
    s4_arrived : BOOL;
END_VAR

IF step = 0 THEN
    target_a := 0;
    target_b := 0;
    target_c := 15000;
    target_d := 15000;
    target_s3_0 := -85000;
    target_s3_1 := -85000;
    target_s4_0 := -65000;
    target_s4_1 := 65000;
    target_s4_2 := 0;

    dock_h := 73250;
    IF D92 <> 0 THEN
        dock_h := D92;
    END_IF;

    IF (NOT r0_done) AND (D100 <> 0) THEN
        cur_req := 0;
        cur_id := D100;
        cur_loc := D101;
        is_cancel := X31;
        step := 10;
    ELSIF (NOT r1_done) AND (D120 <> 0) THEN
        cur_req := 1;
        cur_id := D120;
        cur_loc := D121;
        is_cancel := X35;
        step := 10;
    ELSIF X51 AND r0_done AND r1_done THEN
        step := 900;
    END_IF;
END_IF;

IF cur_req = 0 THEN
    IF X31 THEN
        is_cancel := TRUE;
    END_IF;
ELSIF cur_req = 1 THEN
    IF X35 THEN
        is_cancel := TRUE;
    END_IF;
END_IF;

IF cur_loc = 1 THEN
    target_port_x := D403;
    IF target_port_x = 0 THEN
        target_port_x := -360000;
    END_IF;
ELSE
    target_port_x := D406;
    IF target_port_x = 0 THEN
        target_port_x := -230000;
    END_IF;
END_IF;

a_arrived := (ABS(D1000 - target_a) <= 20) AND (ABS(D1001) <= 100);
b_arrived := (ABS(D1004 - target_b) <= 20) AND (ABS(D1005) <= 100);
IF cur_loc = 1 THEN
    lift_arrived := (ABS(D1008 - target_c) <= 20) AND (ABS(D1009) <= 100);
ELSE
    lift_arrived := (ABS(D1012 - target_d) <= 20) AND (ABS(D1013) <= 100);
END_IF;
s3_arrived := (ABS(D1016 - target_s3_0) <= 20) AND (ABS(D1017) <= 100) AND (ABS(D1020 - target_s3_1) <= 20) AND (ABS(D1021) <= 100);
s4_arrived := (ABS(D1024 - target_s4_0) <= 20) AND (ABS(D1025) <= 100) AND (ABS(D1028 - target_s4_1) <= 20) AND (ABS(D1029) <= 100) AND (ABS(D1032 - target_s4_2) <= 20) AND (ABS(D1033) <= 100);

CASE step OF
    10:
        IF cur_loc = 1 THEN
            target_c := dock_h;
            IF lift_arrived AND X61 THEN
                step := 11;
            END_IF;
        ELSE
            target_d := dock_h;
            IF lift_arrived AND X62 THEN
                step := 11;
            END_IF;
        END_IF;

    11:
        target_a := target_port_x;
        IF a_arrived THEN
            step := 12;
        END_IF;

    12:
        target_b := 18000;
        IF b_arrived THEN
            seq_counter := seq_counter + 1;
            D80 := 1;
            D81 := cur_loc;
            D82 := seq_counter;
            step := 13;
        END_IF;

    13:
        target_b := 0;
        IF b_arrived THEN
            D80 := 0;
            D81 := 0;
            IF is_cancel THEN
                step := 60;
            ELSE
                step := 20;
            END_IF;
        END_IF;

    20:
        target_port_x := D409;
        IF target_port_x = 0 THEN
            target_port_x := 0;
        END_IF;
        target_a := target_port_x;
        IF a_arrived AND X63 THEN
            step := 21;
        END_IF;

    21:
        target_b := 18000;
        IF b_arrived THEN
            seq_counter := seq_counter + 1;
            D80 := 2;
            D81 := 3;
            D82 := seq_counter;
            step := 22;
        END_IF;

    22:
        target_b := 0;
        IF b_arrived THEN
            D80 := 0;
            D81 := 0;
            step := 30;
        END_IF;

    30:
        target_s3_0 := D500;
        target_s3_1 := D501;
        IF is_cancel THEN
            step := 32;
        ELSIF X70 OR (s3_arrived AND (D1016 <> -85000)) THEN
            step := 31;
        END_IF;

    31:
        timer_cnt := timer_cnt + 1;
        IF timer_cnt >= 5 THEN
            timer_cnt := 0;
            step := 32;
        END_IF;

    32:
        target_s3_0 := -85000;
        target_s3_1 := -85000;
        IF s3_arrived AND X63 THEN
            step := 33;
        END_IF;

    33:
        target_b := 18000;
        IF b_arrived THEN
            seq_counter := seq_counter + 1;
            D80 := 1;
            D81 := 3;
            D82 := seq_counter;
            step := 34;
        END_IF;

    34:
        target_b := 0;
        IF b_arrived THEN
            D80 := 0;
            D81 := 0;
            IF is_cancel THEN
                step := 60;
            ELSE
                step := 40;
            END_IF;
        END_IF;

    40:
        target_port_x := D412;
        IF target_port_x = 0 THEN
            target_port_x := 360000;
        END_IF;
        target_a := target_port_x;
        IF a_arrived AND X64 THEN
            step := 41;
        END_IF;

    41:
        target_b := 18000;
        IF b_arrived THEN
            seq_counter := seq_counter + 1;
            D80 := 2;
            D81 := 4;
            D82 := seq_counter;
            step := 42;
        END_IF;

    42:
        target_b := 0;
        IF b_arrived THEN
            D80 := 0;
            D81 := 0;
            step := 50;
        END_IF;

    50:
        target_s4_2 := 25000;
        IF (ABS(D1032 - target_s4_2) <= 20) AND (ABS(D1033) <= 100) THEN
            target_s4_0 := D600;
            target_s4_1 := D601;
            IF is_cancel THEN
                step := 53;
            ELSIF X75 OR ((ABS(D1024 - target_s4_0) <= 20) AND (ABS(D1028 - target_s4_1) <= 20)) THEN
                step := 51;
            END_IF;
        END_IF;

    51:
        target_s4_2 := D602;
        IF s4_arrived OR X75 THEN
            step := 52;
        END_IF;

    52:
        timer_cnt := timer_cnt + 1;
        IF timer_cnt >= 5 THEN
            timer_cnt := 0;
            step := 53;
        END_IF;

    53:
        target_s4_2 := 25000;
        IF (ABS(D1032 - target_s4_2) <= 20) AND (ABS(D1033) <= 100) THEN
            target_s4_0 := -65000;
            target_s4_1 := 65000;
            IF (ABS(D1024 - target_s4_0) <= 20) AND (ABS(D1028 - target_s4_1) <= 20) THEN
                target_s4_2 := 0;
                IF s4_arrived AND X64 THEN
                    step := 54;
                END_IF;
            END_IF;
        END_IF;

    54:
        target_b := 18000;
        IF b_arrived THEN
            seq_counter := seq_counter + 1;
            D80 := 1;
            D81 := 4;
            D82 := seq_counter;
            step := 55;
        END_IF;

    55:
        target_b := 0;
        IF b_arrived THEN
            D80 := 0;
            D81 := 0;
            step := 60;
        END_IF;

    60:
        IF cur_loc = 1 THEN
            target_port_x := D403;
            IF target_port_x = 0 THEN
                target_port_x := -360000;
            END_IF;
        ELSE
            target_port_x := D406;
            IF target_port_x = 0 THEN
                target_port_x := -230000;
            END_IF;
        END_IF;
        target_a := target_port_x;
        IF a_arrived THEN
            step := 61;
        END_IF;

    61:
        target_b := 18000;
        IF b_arrived THEN
            seq_counter := seq_counter + 1;
            D80 := 2;
            D81 := cur_loc;
            D82 := seq_counter;
            step := 62;
        END_IF;

    62:
        target_b := 0;
        IF b_arrived THEN
            D80 := 0;
            D81 := 0;
            step := 70;
        END_IF;

    70:
        IF cur_loc = 1 THEN
            target_c := 15000;
            IF lift_arrived THEN
                step := 80;
            END_IF;
        ELSE
            target_d := 15000;
            IF lift_arrived THEN
                step := 80;
            END_IF;
        END_IF;

    80:
        IF cur_req = 0 THEN
            D300 := cur_id;
            IF is_cancel THEN
                D301 := 2;
            ELSE
                D301 := 1;
            END_IF;
            r0_done := TRUE;
        ELSIF cur_req = 1 THEN
            D302 := cur_id;
            IF is_cancel THEN
                D303 := 2;
            ELSE
                D303 := 1;
            END_IF;
            r1_done := TRUE;
        END_IF;
        target_a := 0;
        step := 0;

    900:
        target_a := 0;
        target_b := 0;
        target_c := 15000;
        target_d := 15000;
        target_s3_0 := -85000;
        target_s3_1 := -85000;
        target_s4_0 := -65000;
        target_s4_1 := 65000;
        target_s4_2 := 0;

        IF (ABS(D1000) <= 20) AND (ABS(D1001) <= 100) AND
           (ABS(D1004) <= 20) AND (ABS(D1005) <= 100) AND
           (ABS(D1008 - 15000) <= 20) AND (ABS(D1009) <= 100) AND
           (ABS(D1012 - 15000) <= 20) AND (ABS(D1013) <= 100) AND
           (ABS(D1016 - (-85000)) <= 20) AND (ABS(D1017) <= 100) AND
           (ABS(D1020 - (-85000)) <= 20) AND (ABS(D1021) <= 100) AND
           (ABS(D1024 - (-65000)) <= 20) AND (ABS(D1025) <= 100) AND
           (ABS(D1028 - 65000) <= 20) AND (ABS(D1029) <= 100) AND
           (ABS(D1032) <= 20) AND (ABS(D1033) <= 100) THEN
            all_completed := TRUE;
        END_IF;
END_CASE;

D2000 := target_a;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := target_b;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := target_c;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := target_d;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := target_s3_0;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := target_s3_1;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := target_s4_0;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := target_s4_1;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := target_s4_2;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

Y30 := FALSE;
Y2 := all_completed;

END_PROGRAM
