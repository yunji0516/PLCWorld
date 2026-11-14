PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT;
    D1012 : DINT; D1013 : DINT; D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT;
    D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT; D1032 : DINT; D1033 : DINT;
    D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT; X30 : BOOL; X31 : BOOL;
    D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT; X34 : BOOL; X35 : BOOL;
    X51 : BOOL; D90 : DINT; D91 : DINT; D92 : DINT; X52 : BOOL; X53 : BOOL;
    D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT; X62 : BOOL;
    D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL;
    D500 : DINT; D501 : DINT; D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT;
    D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL; X71 : BOOL; X72 : BOOL;
    D600 : DINT; D601 : DINT; D602 : DINT; D620 : DINT; D621 : DINT; D622 : DINT;
    D623 : DINT; D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL; X76 : BOOL; X77 : BOOL;
    D2000 : DINT; D2001 : DINT; D2002 : DINT; Y40 : BOOL;
    D2004 : DINT; D2005 : DINT; D2006 : DINT; Y41 : BOOL;
    D2008 : DINT; D2009 : DINT; D2010 : DINT; Y42 : BOOL;
    D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL;
    D2016 : DINT; D2017 : DINT; D2018 : DINT; Y44 : BOOL;
    D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL;
    D2024 : DINT; D2025 : DINT; D2026 : DINT; Y46 : BOOL;
    D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL;
    D2032 : DINT; D2033 : DINT; D2034 : DINT; Y48 : BOOL;
    D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT;
    Y70 : BOOL; Y71 : BOOL; D700 : DINT; D701 : DINT; D702 : DINT;
    Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT;
    D80 : DINT; D81 : DINT; D82 : DINT; Y30 : BOOL; Y2 : BOOL;

    step : INT := 0;
    seq : DINT := 1;
    cur_req : INT := 0;
    cur_loc : DINT := 1;
    is_cancelled : BOOL := FALSE;
    r0_done : BOOL := FALSE;
    r1_done : BOOL := FALSE;
    
    a_tgt, b_tgt, c_tgt, d_tgt : DINT;
    s3_0_tgt, s3_1_tgt, s4_0_tgt, s4_1_tgt, s4_2_tgt : DINT;
    rate_val : INT;
    
    arr_a, arr_b, arr_c, arr_d, arr_s30, arr_s31, arr_s40, arr_s41, arr_s42 : BOOL;
    all_arr : BOOL;
    
    settler : TON;
    arr_edge : R_TRIG;
    y2_timer : TON;
    init_done : BOOL := FALSE;
END_VAR

arr_a := ABS(D1000 - a_tgt) < 50 AND ABS(D1001) < 250;
arr_b := ABS(D1004 - b_tgt) < 50 AND ABS(D1005) < 250;
arr_c := ABS(D1008 - c_tgt) < 50 AND ABS(D1009) < 250;
arr_d := ABS(D1012 - d_tgt) < 50 AND ABS(D1013) < 250;
arr_s30 := ABS(D1016 - s3_0_tgt) < 50 AND ABS(D1017) < 250;
arr_s31 := ABS(D1020 - s3_1_tgt) < 50 AND ABS(D1021) < 250;
arr_s40 := ABS(D1024 - s4_0_tgt) < 50 AND ABS(D1025) < 250;
arr_s41 := ABS(D1028 - s4_1_tgt) < 50 AND ABS(D1029) < 250;
arr_s42 := ABS(D1032 - s4_2_tgt) < 50 AND ABS(D1033) < 250;
all_arr := arr_a AND arr_b AND arr_c AND arr_d AND arr_s30 AND arr_s31 AND arr_s40 AND arr_s41 AND arr_s42;

settler(IN := all_arr, PT := T#30ms);
arr_edge(CLK := settler.Q);
y2_timer(IN := step = 14 AND r0_done AND r1_done, PT := T#100ms);

CASE step OF
    0:
        Y30 := TRUE; Y2 := FALSE; D80 := 0; D81 := 0; D82 := 0;
        Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
        rate_val := 20;
        
        IF NOT r0_done AND X30 THEN 
            r0_done := TRUE; D300 := D100; D301 := IF X31 THEN 2 ELSE 1 END_IF; 
        END_IF
        IF NOT r1_done AND X34 THEN 
            r1_done := TRUE; D302 := D120; D303 := IF X35 THEN 2 ELSE 1 END_IF; 
        END_IF
        
        IF NOT r0_done OR NOT r1_done THEN
            IF NOT r0_done AND (r1_done OR (D103 <= D123)) THEN
                cur_req := 0; cur_loc := D101; is_cancelled := X31;
            ELSIF NOT r1_done THEN
                cur_req := 1; cur_loc := D121; is_cancelled := X35;
            END_IF;
            
            IF cur_loc = 1 THEN a_tgt := -405000; D81 := 1;
            ELSIF cur_loc = 2 THEN a_tgt := -185000; D81 := 2;
            END_IF;
            c_tgt := 95000; d_tgt := 95000; b_tgt := 0;
            s3_0_tgt := 0; s3_1_tgt := 5000; s4_0_tgt := 0; s4_1_tgt := 0; s4_2_tgt := 0;
            rate_val := 800; Y30 := FALSE; step := 1;
        END_IF;

    1:
        c_tgt := 95000; d_tgt := 95000; b_tgt := 0;
        s3_0_tgt := 0; s3_1_tgt := 5000; s4_0_tgt := 0; s4_1_tgt := 0; s4_2_tgt := 0;
        rate_val := 800; Y30 := FALSE; D80 := 0;
        IF arr_edge.Q THEN step := 2; END_IF;

    2:
        rate_val := 600; Y30 := FALSE; D80 := 0;
        IF arr_edge.Q THEN step := 3; END_IF;

    3:
        Y30 := TRUE; rate_val := 200; D80 := 1; D82 := seq;
        IF (cur_loc = 1 AND X61) OR (cur_loc = 2 AND X62) THEN
            b_tgt := 18000; rate_val := 400; step := 4;
        END_IF;

    4:
        b_tgt := 0; rate_val := 400; Y30 := TRUE; D80 := 0;
        IF arr_edge.Q THEN Y30 := FALSE; step := 5; END_IF;

    5:
        a_tgt := 0; c_tgt := 95000; d_tgt := 95000; b_tgt := 0;
        rate_val := 800; Y30 := FALSE; D80 := 0;
        IF arr_edge.Q THEN step := 6; END_IF;

    6:
        Y70 := TRUE; D700 := D520; D701 := D526; D702 := 500;
        s3_1_tgt := 5000; rate_val := 200; Y30 := TRUE;
        IF X70 OR X71 THEN Y70 := FALSE; Y71 := TRUE; step := 7; END_IF;

    7:
        a_tgt := 360000; c_tgt := 95000; d_tgt := 95000; b_tgt := 0;
        rate_val := 800; Y30 := FALSE; D80 := 0;
        IF arr_edge.Q THEN step := 8; END_IF;

    8:
        Y75 := TRUE; D710 := D620; D711 := D626; D712 := 500;
        s4_1_tgt := 4000; s4_2_tgt := 4000; rate_val := 200; Y30 := TRUE;
        IF X75 OR X76 THEN Y75 := FALSE; Y76 := TRUE; step := 9; END_IF;

    9:
        IF cur_loc = 1 THEN a_tgt := -405000;
        ELSIF cur_loc = 2 THEN a_tgt := -185000;
        END_IF;
        c_tgt := 95000; d_tgt := 95000; b_tgt := 0;
        rate_val := 800; Y30 := FALSE; D80 := 0;
        IF arr_edge.Q THEN step := 10; END_IF;

    10:
        Y30 := TRUE; rate_val := 200; D80 := 2; D82 := seq + 1;
        IF (cur_loc = 1 AND X61) OR (cur_loc = 2 AND X62) THEN
            b_tgt := 18000; rate_val := 400; step := 11;
        END_IF;

    11:
        b_tgt := 0; rate_val := 400; Y30 := TRUE; D80 := 0;
        IF arr_edge.Q THEN Y30 := FALSE; step := 12; END_IF;

    12:
        D300 := D100; D301 := IF is_cancelled OR X31 THEN 2 ELSE 1 END_IF;
        D302 := D120; D303 := IF is_cancelled OR X35 THEN 2 ELSE 1 END_IF;
        rate_val := 20; Y30 := TRUE;
        IF cur_req = 0 AND X30 THEN r0_done := TRUE; seq := seq + 2; step := 13;
        ELSIF cur_req = 1 AND X34 THEN r1_done := TRUE; seq := seq + 2; step := 13;
        END_IF;

    13:
        a_tgt := 0; b_tgt := 0; c_tgt := 40000; d_tgt := 40000;
        s3_0_tgt := 0; s3_1_tgt := 5000; s4_0_tgt := 0; s4_1_tgt := 0; s4_2_tgt := 0;
        rate_val := 800; Y30 := FALSE; D80 := 0;
        IF arr_edge.Q THEN Y30 := TRUE; step := 14; END_IF;

    14:
        D80 := 0; rate_val := 20;
        IF (r0_done AND r1_done) THEN
            Y2 := TRUE;
            IF y2_timer.Q THEN step := 0; END_IF;
        ELSE
            Y2 := FALSE; step := 0;
        END_IF;
END_CASE;

IF NOT init_done THEN
    a_tgt := D1000; b_tgt := D1004; c_tgt := D1008; d_tgt := D1012;
    s3_0_tgt := D1016; s3_1_tgt := D1020; s4_0_tgt := D1024; s4_1_tgt := D1028; s4_2_tgt := D1032;
    init_done := TRUE;
END_IF;

D2000 := a_tgt; D2001 := rate_val; D2002 := 0; Y40 := TRUE;
D2004 := b_tgt; D2005 := rate_val; D2006 := 0; Y41 := TRUE;
D2008 := c_tgt; D2009 := rate_val; D2010 := 0; Y42 := TRUE;
D2012 := d_tgt; D2013 := rate_val; D2014 := 0; Y43 := TRUE;
D2016 := s3_0_tgt; D2017 := rate_val; D2018 := 0; Y44 := TRUE;
D2020 := s3_1_tgt; D2021 := rate_val; D2022 := 0; Y45 := TRUE;
D2024 := s4_0_tgt; D2025 := rate_val; D2026 := 0; Y46 := TRUE;
D2028 := s4_1_tgt; D2029 := rate_val; D2030 := 0; Y47 := TRUE;
D2032 := s4_2_tgt; D2033 := rate_val; D2034 := 0; Y48 := TRUE;

END_PROGRAM