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

    step : INT := 0;
    active_req : INT := -1;
    curr_req_id : DINT := 0;
    curr_req_loc : DINT := 0;
    curr_cancelled : BOOL := FALSE;
    seq_counter : DINT := 1;
    timer_ms : DINT := 0;

    r0_finished : BOOL := FALSE;
    r1_finished : BOOL := FALSE;

    a_tgt : DINT := 0;
    b_tgt : DINT := 0;
    c_tgt : DINT := 15000;
    d_tgt : DINT := 15000;
    s3_0_tgt : DINT := -85000;
    s3_1_tgt : DINT := -85000;
    s4_0_tgt : DINT := -65000;
    s4_1_tgt : DINT := 65000;
    s4_2_tgt : DINT := 0;

    c_arr : BOOL := FALSE;
    d_arr : BOOL := FALSE;
    a_arr : BOOL := FALSE;
    b_arr : BOOL := FALSE;
    s3_0_arr : BOOL := FALSE;
    s3_1_arr : BOOL := FALSE;
    s4_0_arr : BOOL := FALSE;
    s4_1_arr : BOOL := FALSE;
    s4_2_arr : BOOL := FALSE;
END_VAR

c_arr := (ABS(D1008 - c_tgt) <= 20) AND (ABS(D1009) <= 100);
d_arr := (ABS(D1012 - d_tgt) <= 20) AND (ABS(D1013) <= 100);
a_arr := (ABS(D1000 - a_tgt) <= 20) AND (ABS(D1001) <= 100);
b_arr := (ABS(D1004 - b_tgt) <= 20) AND (ABS(D1005) <= 100);
s3_0_arr := (ABS(D1016 - s3_0_tgt) <= 20) AND (ABS(D1017) <= 100);
s3_1_arr := (ABS(D1020 - s3_1_tgt) <= 20) AND (ABS(D1021) <= 100);
s4_0_arr := (ABS(D1024 - s4_0_tgt) <= 20) AND (ABS(D1025) <= 100);
s4_1_arr := (ABS(D1028 - s4_1_tgt) <= 20) AND (ABS(D1029) <= 100);
s4_2_arr := (ABS(D1032 - s4_2_tgt) <= 20) AND (ABS(D1033) <= 100);

CASE step OF
    0:
        IF NOT r0_finished AND (D100 > 0) THEN
            active_req := 0;
            curr_req_id := D100;
            curr_req_loc := D101;
            curr_cancelled := X31;
            step := 10;
        ELSIF NOT r1_finished AND (D120 > 0) THEN
            active_req := 1;
            curr_req_id := D120;
            curr_req_loc := D121;
            curr_cancelled := X35;
            step := 10;
        ELSIF (D100 = 0 OR r0_finished) AND (D120 = 0 OR r1_finished) AND X51 THEN
            step := 990;
        END_IF;

    10:
        IF curr_req_loc = 1 THEN
            c_tgt := D92;
            IF c_arr AND (X61 OR (ABS(D1008 - D92) <= 20)) THEN
                step := 20;
            END_IF;
        ELSE
            d_tgt := D92;
            IF d_arr AND (X62 OR (ABS(D1012 - D92) <= 20)) THEN
                step := 20;
            END_IF;
        END_IF;

    20:
        IF curr_req_loc = 1 THEN
            a_tgt := D403;
        ELSE
            a_tgt := D406;
        END_IF;
        IF a_arr THEN
            step := 30;
        END_IF;

    30:
        b_tgt := 18000;
        IF b_arr THEN
            D80 := 1;
            D81 := curr_req_loc;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            step := 40;
        END_IF;

    40:
        IF D90 = curr_req_id THEN
            b_tgt := 0;
            IF b_arr THEN
                D80 := 0;
                D81 := 0;
                IF curr_req_loc = 1 THEN
                    c_tgt := 15000;
                ELSE
                    d_tgt := 15000;
                END_IF;
                IF curr_cancelled THEN
                    step := 700;
                ELSE
                    step := 100;
                END_IF;
            END_IF;
        END_IF;

    100:
        a_tgt := D409;
        IF a_arr THEN
            step := 110;
        END_IF;

    110:
        b_tgt := 18000;
        IF b_arr THEN
            D80 := 2;
            D81 := 3;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            step := 120;
        END_IF;

    120:
        IF D410 = curr_req_id THEN
            b_tgt := 0;
            IF b_arr THEN
                D80 := 0;
                D81 := 0;
                step := 130;
            END_IF;
        END_IF;

    130:
        s3_0_tgt := D500;
        s3_1_tgt := D501;
        IF s3_0_arr AND s3_1_arr THEN
            timer_ms := timer_ms + 20;
            IF timer_ms >= 100 AND X70 THEN
                timer_ms := 0;
                step := 140;
            END_IF;
        ELSE
            timer_ms := 0;
        END_IF;

    140:
        s3_0_tgt := -85000;
        s3_1_tgt := -85000;
        IF s3_0_arr AND s3_1_arr AND X63 THEN
            step := 150;
        END_IF;

    150:
        b_tgt := 18000;
        IF b_arr THEN
            D80 := 1;
            D81 := 3;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            step := 160;
        END_IF;

    160:
        IF D90 = curr_req_id THEN
            b_tgt := 0;
            IF b_arr THEN
                D80 := 0;
                D81 := 0;
                step := 200;
            END_IF;
        END_IF;

    200:
        a_tgt := D412;
        IF a_arr THEN
            step := 210;
        END_IF;

    210:
        b_tgt := 18000;
        IF b_arr THEN
            D80 := 2;
            D81 := 4;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            step := 220;
        END_IF;

    220:
        IF D413 = curr_req_id THEN
            b_tgt := 0;
            IF b_arr THEN
                D80 := 0;
                D81 := 0;
                step := 230;
            END_IF;
        END_IF;

    230:
        s4_2_tgt := 25000;
        IF s4_2_arr THEN
            step := 240;
        END_IF;

    240:
        s4_0_tgt := D600;
        s4_1_tgt := D601;
        IF s4_0_arr AND s4_1_arr THEN
            step := 250;
        END_IF;

    250:
        s4_2_tgt := D602;
        IF s4_2_arr THEN
            timer_ms := timer_ms + 20;
            IF timer_ms >= 100 AND X75 THEN
                timer_ms := 0;
                step := 260;
            END_IF;
        ELSE
            timer_ms := 0;
        END_IF;

    260:
        s4_2_tgt := 25000;
        IF s4_2_arr THEN
            step := 270;
        END_IF;

    270:
        s4_0_tgt := -65000;
        s4_1_tgt := 65000;
        IF s4_0_arr AND s4_1_arr THEN
            step := 280;
        END_IF;

    280:
        s4_2_tgt := 0;
        IF s4_2_arr AND X64 THEN
            step := 290;
        END_IF;

    290:
        b_tgt := 18000;
        IF b_arr THEN
            D80 := 1;
            D81 := 4;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            step := 300;
        END_IF;

    300:
        IF D90 = curr_req_id THEN
            b_tgt := 0;
            IF b_arr THEN
                D80 := 0;
                D81 := 0;
                step := 700;
            END_IF;
        END_IF;

    700:
        IF curr_req_loc = 1 THEN
            c_tgt := D92;
            IF c_arr THEN
                step := 710;
            END_IF;
        ELSE
            d_tgt := D92;
            IF d_arr THEN
                step := 710;
            END_IF;
        END_IF;

    710:
        IF curr_req_loc = 1 THEN
            a_tgt := D403;
        ELSE
            a_tgt := D406;
        END_IF;
        IF a_arr THEN
            step := 720;
        END_IF;

    720:
        b_tgt := 18000;
        IF b_arr THEN
            D80 := 2;
            D81 := curr_req_loc;
            D82 := seq_counter;
            seq_counter := seq_counter + 1;
            step := 730;
        END_IF;

    730:
        IF ((curr_req_loc = 1) AND (D404 = curr_req_id)) OR ((curr_req_loc = 2) AND (D407 = curr_req_id)) THEN
            b_tgt := 0;
            IF b_arr THEN
                D80 := 0;
                D81 := 0;
                IF curr_req_loc = 1 THEN
                    c_tgt := 15000;
                ELSE
                    d_tgt := 15000;
                END_IF;
                step := 740;
            END_IF;
        END_IF;

    740:
        IF ((curr_req_loc = 1) AND c_arr) OR ((curr_req_loc = 2) AND d_arr) THEN
            IF active_req = 0 THEN
                D300 := curr_req_id;
                IF curr_cancelled THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                r0_finished := TRUE;
            ELSE
                D302 := curr_req_id;
                IF curr_cancelled THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                r1_finished := TRUE;
            END_IF;
            step := 0;
        END_IF;

    990:
        a_tgt := 0;
        b_tgt := 0;
        c_tgt := 15000;
        d_tgt := 15000;
        s3_0_tgt := -85000;
        s3_1_tgt := -85000;
        s4_0_tgt := -65000;
        s4_1_tgt := 65000;
        s4_2_tgt := 0;
        IF a_arr AND b_arr AND c_arr AND d_arr AND s3_0_arr AND s3_1_arr AND s4_0_arr AND s4_1_arr AND s4_2_arr THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

D2000 := a_tgt;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := b_tgt;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := c_tgt;
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := d_tgt;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := s3_0_tgt;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := s3_1_tgt;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := s4_0_tgt;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := s4_1_tgt;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := s4_2_tgt;
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

Y30 := FALSE;
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

END_PROGRAM
