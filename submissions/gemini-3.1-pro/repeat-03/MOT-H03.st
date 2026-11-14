```st
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

    state : INT := 0;
    req_idx : INT := 0;
    curr_id : DINT := 0;
    curr_loc : DINT := 0;
    curr_goal : DINT := 0;
    curr_cancel : BOOL := FALSE;
    is_holding : BOOL := FALSE;
    
    seq : DINT := 1;
    
    v_pos : REAL := 0.0;
    v_spd : REAL := 0.0;
    v_target : REAL := 0.0;
    v_max_v : REAL := 5000.0;
    v_acc : REAL := 5000.0;
    dist : REAL;
    req_v : REAL;
    
    sync_timer : INT := 0;
    final_timer : INT := 0;
    
    a_tgt : DINT := 0;
    b_tgt : DINT := 0;
    c_tgt : DINT := 15000;
    d_tgt : DINT := 15000;
    s3_0_tgt : DINT := -50000;
    s3_1_tgt : DINT := -50000;
    s3_2_tgt : DINT := 0;
    s4_0_tgt : DINT := 0;
    s4_1_tgt : DINT := 0;
    
    a_ff : DINT := 0;
    b_ff : DINT := 0;
    c_ff : DINT := 0;
    d_ff : DINT := 0;
    s3_0_ff : DINT := 0;
    s3_1_ff : DINT := 0;
    s3_2_ff : DINT := 0;
    s4_0_ff : DINT := 0;
    s4_1_ff : DINT := 0;
END_VAR

is_holding := (D90 <> 0);

IF (req_idx = 0 AND X31) OR (req_idx = 1 AND X35) THEN
    curr_cancel := TRUE;
END_IF;

IF curr_cancel THEN
    IF D90 <> 0 THEN
        IF state > 4 AND state < 12 THEN
            state := 12;
        END_IF;
    ELSE
        IF state > 0 AND state < 16 AND state <> 99 THEN
            state := 99;
        END_IF;
    END_IF;
END_IF;

IF state = 99 THEN
    b_tgt := 0;
    IF D1004 <= 20 THEN
        state := 16;
    END_IF;
END_IF;

IF state = 0 THEN
    IF req_idx = 0 AND D100 <> 0 THEN
        curr_id := D100;
        curr_loc := D101;
        curr_goal := D600;
        state := 1;
    ELSIF req_idx = 1 AND D120 <> 0 THEN
        curr_id := D120;
        curr_loc := D121;
        curr_goal := D601;
        state := 1;
    ELSIF X51 THEN
        state := 100;
    END_IF;
END_IF;

IF state = 1 THEN
    IF curr_loc = 1 THEN
        a_tgt := -360000;
        c_tgt := 73250;
    ELSE
        a_tgt := -230000;
        d_tgt := 73250;
    END_IF;
    state := 2;
END_IF;

IF state = 2 THEN
    IF curr_loc = 1 THEN
        IF ABS(D1000 - a_tgt) <= 20 AND ABS(D1008 - 73250) <= 20 AND D1001 = 0 THEN
            state := 3;
            seq := seq + 1;
        END_IF;
    ELSE
        IF ABS(D1000 - a_tgt) <= 20 AND ABS(D1012 - 73250) <= 20 AND D1001 = 0 THEN
            state := 3;
            seq := seq + 1;
        END_IF;
    END_IF;
END_IF;

IF state = 3 THEN
    b_tgt := 18000;
    D80 := 1;
    D81 := curr_loc;
    D82 := seq;
    IF D1004 >= 17980 AND D90 = curr_id THEN
        state := 4;
    END_IF;
END_IF;

IF state = 4 THEN
    b_tgt := 0;
    IF D1004 <= 20 THEN
        state := 5;
    END_IF;
END_IF;

IF state = 5 THEN
    a_tgt := 230000;
    s3_0_tgt := -50000;
    IF ABS(D1000 - 230000) <= 20 AND ABS(D1016 - -50000) <= 20 AND D1001 = 0 THEN
        state := 6;
        v_pos := 0.0; 
        v_spd := 0.0;
        v_target := 80000.0; 
        v_max_v := 5000.0; 
        v_acc := 5000.0;
        sync_timer := 0;
    END_IF;
END_IF;

IF state = 6 THEN
    IF ABS(D1000 - D409) <= 20 AND ABS(D1001 - D1017) <= 100 AND v_spd > 100.0 THEN
        sync_timer := sync_timer + 20;
    ELSE
        sync_timer := 0;
    END_IF;
    IF sync_timer >= 50 THEN
        state := 7;
    END_IF;
END_IF;

IF state = 7 THEN
    b_tgt := 18000;
    IF X70 THEN
        state := 8;
    END_IF;
END_IF;

IF state = 8 THEN
    b_tgt := 0;
    IF D1004 <= 20 THEN
        state := 9;
    END_IF;
END_IF;

IF state = 9 THEN
    a_tgt := 990000;
    s3_0_tgt := -50000;
    s4_0_tgt := 0;
    IF ABS(D1000 - 990000) <= 20 AND ABS(D1028) <= 20 AND D1001 = 0 THEN
        state := 10;
    END_IF;
END_IF;

IF state = 10 THEN
    b_tgt := 18000;
    IF D1004 >= 17980 THEN
        state := 11;
        v_pos := 0.0; 
        v_spd := 0.0;
        v_target := DINT_TO_REAL(curr_goal);
        v_max_v := 5000.0; 
        v_acc := 5000.0;
    END_IF;
END_IF;

IF state = 11 THEN
    IF X75 THEN
        state := 12;
    END_IF;
END_IF;

IF state = 12 THEN
    b_tgt := 0;
    IF D1004 <= 20 THEN
        state := 13;
        seq := seq + 1;
    END_IF;
END_IF;

IF state = 13 THEN
    IF curr_loc = 1 THEN
        a_tgt := -360000;
    ELSE
        a_tgt := -230000;
    END_IF;
    s3_0_tgt := -50000;
    s4_0_tgt := 0;
    IF ABS(D1000 - a_tgt) <= 20 AND D1004 <= 20 AND D1001 = 0 THEN
        state := 14;
    END_IF;
END_IF;

IF state = 14 THEN
    b_tgt := 18000;
    D80 := 2;
    D81 := curr_loc;
    D82 := seq;
    IF D1004 >= 17980 AND D90 = 0 THEN
        state := 15;
    END_IF;
END_IF;

IF state = 15 THEN
    b_tgt := 0;
    IF D1004 <= 20 THEN
        state := 16;
    END_IF;
END_IF;

IF state = 16 THEN
    D80 := 0;
    D81 := 0;
    IF req_idx = 0 THEN
        D300 := curr_id;
        D301 := SEL(curr_cancel, 1, 2);
        IF X30 OR X31 THEN
            D300 := 0; 
            D301 := 0;
            req_idx := 1;
            curr_cancel := FALSE;
            state := 0;
        END_IF;
    ELSE
        D302 := curr_id;
        D303 := SEL(curr_cancel, 1, 2);
        IF X34 OR X35 THEN
            D302 := 0; 
            D303 := 0;
            req_idx := 2;
            curr_cancel := FALSE;
            state := 0;
        END_IF;
    END_IF;
END_IF;

IF state = 100 THEN
    a_tgt := 0;
    b_tgt := 0;
    c_tgt := 15000;
    d_tgt := 15000;
    s3_0_tgt := -50000;
    s4_0_tgt := 0;
    IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND ABS(D1016 - -50000) <= 20 AND ABS(D1028) <= 20 THEN
        final_timer := final_timer + 20;
    ELSE
        final_timer := 0;
    END_IF;
    IF final_timer >= 100 THEN
        Y2 := TRUE;
    END_IF;
END_IF;

a_ff := 0; 
s3_0_ff := 0; 
s4_0_ff := 0;

IF state = 6 OR state = 7 OR state = 8 OR state = 11 OR state = 12 THEN
    dist := v_target - v_pos;
    IF dist > 0.0 THEN
        req_v := SQRT(2.0 * v_acc * dist);
        IF req_v > v_max_v THEN 
            req_v := v_max_v; 
        END_IF;
        IF v_spd < req_v THEN
            v_spd := v_spd + v_acc * 0.02;
            IF v_spd > req_v THEN 
                v_spd := req_v; 
            END_IF;
        ELSIF v_spd > req_v THEN
            v_spd := v_spd - v_acc * 0.02;
            IF v_spd < req_v THEN 
                v_spd := req_v; 
            END_IF;
        END_IF;
        v_pos := v_pos + v_spd * 0.02;
        IF v_pos > v_target THEN 
            v_pos := v_target; 
        END_IF;
    ELSE
        v_spd := 0.0;
    END_IF;
    
    IF state = 6 OR state = 7 OR state = 8 THEN
        a_tgt := 230000 + REAL_TO_DINT(v_pos);
        s3_0_tgt := -50000 + REAL_TO_DINT(v_pos);
        a_ff := REAL_TO_DINT(v_spd);
        s3_0_ff := REAL_TO_DINT(v_spd);
    ELSIF state = 11 OR state = 12 THEN
        a_tgt := 990000 + REAL_TO_DINT(v_pos);
        s4_0_tgt := REAL_TO_DINT(v_pos);
        a_ff := REAL_TO_DINT(v_spd);
        s4_0_ff := REAL_TO_DINT(v_spd);
    END_IF;
END_IF;

D2000 := a_tgt; D2001 := 1000; D2002 := a_ff; Y40 := TRUE;
D2004 := b_tgt; D2005 := 1000; D2006 := b_ff; Y41 := TRUE;
D2008 := c_tgt; D2009 := 1000; D2010 := c_ff; Y42 := TRUE;
D2012 := d_tgt; D2013 := 1000; D2014 := d_ff; Y43 := TRUE;
D2016 := s3_0_tgt; D2017 := 1000; D2018 := s3_0_ff; Y44 := TRUE;
D2020 := s3_1_tgt; D2021 := 1000; D2022 := s3_1_ff; Y45 := TRUE;
D2024 := s3_2_tgt; D2025 := 1000; D2026 := s3_2_ff; Y46 := TRUE;
D2028 := s4_0_tgt; D2029 := 1000; D2030 := s4_0_ff; Y47 := TRUE;
D2032 := s4_1_tgt; D2033 := 1000; D2034 := s4_1_ff; Y48 := TRUE;

Y30 := FALSE;
END_PROGRAM
```