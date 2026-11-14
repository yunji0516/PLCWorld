PROGRAM Main
VAR
    D1000 : DINT; D1001 : DINT; D1004 : DINT; D1005 : DINT; D1008 : DINT; D1009 : DINT; D1012 : DINT; D1013 : DINT;
    D1016 : DINT; D1017 : DINT; D1020 : DINT; D1021 : DINT; D1024 : DINT; D1025 : DINT; D1028 : DINT; D1029 : DINT;
    D1032 : DINT; D1033 : DINT; D100 : DINT; D101 : DINT; D102 : DINT; D103 : DINT; D104 : DINT; X30 : BOOL; X31 : BOOL;
    D120 : DINT; D121 : DINT; D122 : DINT; D123 : DINT; D124 : DINT; X34 : BOOL; X35 : BOOL; X51 : BOOL; D90 : DINT;
    D91 : DINT; D92 : DINT; X52 : BOOL; X53 : BOOL; D403 : DINT; D404 : DINT; X61 : BOOL; D406 : DINT; D407 : DINT;
    X62 : BOOL; D409 : DINT; D410 : DINT; X63 : BOOL; D412 : DINT; D413 : DINT; X64 : BOOL; D500 : DINT; D501 : DINT;
    D520 : DINT; D521 : DINT; D522 : DINT; D523 : DINT; D524 : DINT; D525 : DINT; D526 : DINT; D527 : DINT; X70 : BOOL;
    X71 : BOOL; X72 : BOOL; D600 : DINT; D601 : DINT; D602 : DINT; D620 : DINT; D621 : DINT; D622 : DINT; D623 : DINT;
    D624 : DINT; D625 : DINT; D626 : DINT; D627 : DINT; X75 : BOOL; X76 : BOOL; X77 : BOOL; D2000 : DINT; D2001 : DINT;
    D2002 : DINT; Y40 : BOOL; D2004 : DINT; D2005 : DINT; D2006 : DINT; Y41 : BOOL; D2008 : DINT; D2009 : DINT;
    D2010 : DINT; Y42 : BOOL; D2012 : DINT; D2013 : DINT; D2014 : DINT; Y43 : BOOL; D2016 : DINT; D2017 : DINT;
    D2018 : DINT; Y44 : BOOL; D2020 : DINT; D2021 : DINT; D2022 : DINT; Y45 : BOOL; D2024 : DINT; D2025 : DINT;
    D2026 : DINT; Y46 : BOOL; D2028 : DINT; D2029 : DINT; D2030 : DINT; Y47 : BOOL; D2032 : DINT; D2033 : DINT;
    D2034 : DINT; Y48 : BOOL; D300 : DINT; D301 : DINT; D302 : DINT; D303 : DINT; Y70 : BOOL; Y71 : BOOL; D700 : DINT;
    D701 : DINT; D702 : DINT; Y75 : BOOL; Y76 : BOOL; D710 : DINT; D711 : DINT; D712 : DINT; D80 : DINT; D81 : DINT;
    D82 : DINT; Y30 : BOOL; Y2 : BOOL;
    
    state : INT := 0;
    req_sel : INT := 0;
    lift_sel : INT := 1;
    seq_cnt : DINT := 0;
    done0 : BOOL := FALSE;
    done1 : BOOL := FALSE;
    req0_id : DINT := 0;
    req1_id : DINT := 0;
    cur_id : DINT := 0;
    cur_loc : INT := 1;
    cur_cancel : BOOL := FALSE;
    
    timer_stab : TON;
    timer_hold : TON;
    
    tgt_a : DINT;
    tgt_b : DINT;
    tgt_c : DINT;
    tgt_d : DINT;
    tgt_s30 : DINT;
    tgt_s31 : DINT;
    tgt_s40 : DINT;
    tgt_s41 : DINT;
    tgt_s42 : DINT;
    
    phase : INT := 0;
    all_home : BOOL;
END_VAR

CONST
    TOL_POS : DINT := 20;
    TOL_SPD : DINT := 100;
    RATE : DINT := 500;
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_C : DINT := 15000;
    HOME_D : DINT := 15000;
    HOME_S30 : DINT := -60000;
    HOME_S31 : DINT := -60000;
    HOME_S40 : DINT := 0;
    HOME_S41 : DINT := 0;
    HOME_S42 : DINT := 0;
    DOCK1 : DINT := -360000;
    DOCK2 : DINT := -230000;
    DOCK3 : DINT := 230000;
    DOCK4 : DINT := 990000;
END_CONST

all_home := (ABS(D1000 - HOME_A) < TOL_POS) AND (ABS(D1001) < TOL_SPD) AND
            (ABS(D1004 - HOME_B) < TOL_POS) AND (ABS(D1005) < TOL_SPD) AND
            (ABS(D1008 - HOME_C) < TOL_POS) AND (ABS(D1009) < TOL_SPD) AND
            (ABS(D1012 - HOME_D) < TOL_POS) AND (ABS(D1013) < TOL_SPD) AND
            (ABS(D1016 - HOME_S30) < TOL_POS) AND (ABS(D1017) < TOL_SPD) AND
            (ABS(D1020 - HOME_S31) < TOL_POS) AND (ABS(D1021) < TOL_SPD) AND
            (ABS(D1024 - HOME_S40) < TOL_POS) AND (ABS(D1025) < TOL_SPD) AND
            (ABS(D1028 - HOME_S41) < TOL_POS) AND (ABS(D1029) < TOL_SPD) AND
            (ABS(D1032 - HOME_S42) < TOL_POS) AND (ABS(D1033) < TOL_SPD);

CASE state OF
    0: (* IDLE / HOME *)
        Y30 := FALSE;
        Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
        Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
        D2000 := HOME_A; D2001 := RATE; D2002 := 0;
        D2004 := HOME_B; D2005 := RATE; D2006 := 0;
        D2008 := HOME_C; D2009 := RATE; D2010 := 0;
        D2012 := HOME_D; D2013 := RATE; D2014 := 0;
        D2016 := HOME_S30; D2017 := RATE; D2018 := 0;
        D2020 := HOME_S31; D2021 := RATE; D2022 := 0;
        D2024 := HOME_S40; D2025 := RATE; D2026 := 0;
        D2028 := HOME_S41; D2029 := RATE; D2030 := 0;
        D2032 := HOME_S42; D2033 := RATE; D2034 := 0;
        Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
        Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
        D80 := 0; D81 := 0; D82 := 0;
        Y2 := FALSE;
        D300 := 0; D301 := 0; D302 := 0; D303 := 0;
        
        IF all_home THEN
            req_sel := 0;
            IF (D102 > 0) AND NOT done0 THEN
                req_sel := 0;
                req0_id := D100;
                cur_loc := DINT_TO_INT(D101);
                IF cur_loc < 1 OR cur_loc > 2 THEN cur_loc := 1; END_IF;
                cur_cancel := X31;
            ELSIF (D122 > 0) AND NOT done1 THEN
                req_sel := 1;
                req1_id := D120;
                cur_loc := DINT_TO_INT(D121);
                IF cur_loc < 1 OR cur_loc > 2 THEN cur_loc := 1; END_IF;
                cur_cancel := X35;
            END_IF;
            
            IF req_sel > 0 THEN
                seq_cnt := seq_cnt + 1;
                D82 := seq_cnt;
                IF req_sel = 0 THEN cur_id := req0_id; ELSE cur_id := req1_id; END_IF;
                lift_sel := cur_loc;
                state := 1;
            END_IF;
        END_IF;

    1: (* MOVE_TO_LIFT *)
        tgt_a := IF lift_sel = 1 THEN DOCK1 ELSE DOCK2 END_IF;
        tgt_b := 18000;
        tgt_c := HOME_C; tgt_d := HOME_D;
        tgt_s30 := HOME_S30; tgt_s31 := HOME_S31;
        tgt_s40 := HOME_S40; tgt_s41 := HOME_S41; tgt_s42 := HOME_S42;
        Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
        Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        D80 := 1; D81 := lift_sel;
        
        D2000 := tgt_a; D2001 := RATE; D2002 := 0;
        D2004 := tgt_b; D2005 := RATE; D2006 := 0;
        D2008 := tgt_c; D2009 := RATE; D2010 := 0;
        D2012 := tgt_d; D2013 := RATE; D2014 := 0;
        D2016 := tgt_s30; D2017 := RATE; D2018 := 0;
        D2020 := tgt_s31; D2021 := RATE; D2022 := 0;
        D2024 := tgt_s40; D2025 := RATE; D2026 := 0;
        D2028 := tgt_s41; D2029 := RATE; D2030 := 0;
        D2032 := tgt_s42; D2033 := RATE; D2034 := 0;
        
        IF (ABS(D1000 - tgt_a) < TOL_POS) AND (ABS(D1001) < TOL_SPD) AND
           (ABS(D1004 - tgt_b) < TOL_POS) AND (ABS(D1005) < TOL_SPD) THEN
            IF (lift_sel = 1 AND X61) OR (lift_sel = 2 AND X62) THEN
                state := 2;
            END_IF;
        END_IF;

    2: (* CONNECT_HOLD *)
        D80 := 1; D81 := lift_sel;
        IF D90 = cur_id THEN
            state := 3;
        END_IF;

    3: (* MOVE_TO_CELL3 *)
        tgt_a := DOCK3; tgt_b := 0;
        tgt_c := HOME_C; tgt_d := HOME_D;
        tgt_s30 := HOME_S30; tgt_s31 := HOME_S31;
        tgt_s40 := HOME_S40; tgt_s41 := HOME_S41; tgt_s42 := HOME_S42;
        Y40 := TRUE; Y41 := TRUE; Y42 := FALSE; Y43 := FALSE;
        Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        D80 := 2; D81 := 3;
        
        D2000 := tgt_a; D2001 := RATE; D2002 := 0;
        D2004 := tgt_b; D2005 := RATE; D2006 := 0;
        D2008 := HOME_C; D2009 := RATE; D2010 := 0;
        D2012 := HOME_D; D2013 := RATE; D2014 := 0;
        D2016 := HOME_S30; D2017 := RATE; D2018 := 0;
        D2020 := HOME_S31; D2021 := RATE; D2022 := 0;
        D2024 := HOME_S40; D2025 := RATE; D2026 := 0;
        D2028 := HOME_S41; D2029 := RATE; D2030 := 0;
        D2032 := HOME_S42; D2033 := RATE; D2034 := 0;
        
        IF (ABS(D1000 - tgt_a) < TOL_POS) AND (ABS(D1001) < TOL_SPD) THEN
            state := 4;
        END_IF;

    4: (* CELL3_SETUP *)
        Y70 := TRUE; Y71 := TRUE;
        D700 := cur_id;
        D701 := IF req_sel = 0 THEN D520 ELSE D620 END_IF;
        D702 := RATE;
        phase := 0;
        state := 5;

    5: (* CELL3_MOVE *)
        tgt_s30 := D500 + 25000;
        tgt_s31 := D501 + 25000;
        tgt_a := DOCK3; tgt_b := 0;
        tgt_c := HOME_C; tgt_d := HOME_D;
        tgt_s40 := HOME_S40; tgt_s41 := HOME_S41; tgt_s42 := HOME_S42;
        Y44 := TRUE; Y45 := TRUE;
        
        D2000 := tgt_a; D2001 := RATE; D2002 := 0;
        D2004 := tgt_b; D2005 := RATE; D2006 := 0;
        D2008 := HOME_C; D2009 := RATE; D2010 := 0;
        D2012 := HOME_D; D2013 := RATE; D2014 := 0;
        D2016 := tgt_s30; D2017 := RATE; D2018 := 0;
        D2020 := tgt_s31; D2021 := RATE; D2022 := 0;
        D2024 := HOME_S40; D2025 := RATE; D2026 := 0;
        D2028 := HOME_S41; D2029 := RATE; D2030 := 0;
        D2032 := HOME_S42; D2033 := RATE; D2034 := 0;
        
        IF (ABS(D1016 - tgt_s30) < TOL_POS) AND (ABS(D1017) < TOL_SPD) AND
           (ABS(D1020 - tgt_s31) < TOL_POS) AND (ABS(D1021) < TOL_SPD) THEN
            phase := 1;
            timer_stab(IN := TRUE, PT := T#80ms);
            IF timer_stab.Q THEN
                state := 6;
                timer_stab(IN := FALSE);
            END_IF;
        END_IF;

    6: (* CELL3_WAIT *)
        IF X70 OR X72 THEN
            state := 7;
        END_IF;

    7: (* MOVE_TO_CELL4 *)
        tgt_a := DOCK4; tgt_b := 0;
        tgt_c := HOME_C; tgt_d := HOME_D;
        tgt_s30 := HOME_S30; tgt_s31 := HOME_S31;
        tgt_s40 := HOME_S40; tgt_s41 := HOME_S41; tgt_s42 := HOME_S42;
        Y40 := TRUE; Y41 := TRUE; Y44 := TRUE; Y45 := TRUE;
        
        D2000 := tgt_a; D2001 := RATE; D2002 := 0;
        D2004 := tgt_b; D2005 := RATE; D2006 := 0;
        D2008 := HOME_C; D2009 := RATE; D2010 := 0;
        D2012 := HOME_D; D2013 := RATE; D2014 := 0;
        D2016 := HOME_S30; D2017 := RATE; D2018 := 0;
        D2020 := HOME_S31; D2021 := RATE; D2022 := 0;
        D2024 := HOME_S40; D2025 := RATE; D2026 := 0;
        D2028 := HOME_S41; D2029 := RATE; D2030 := 0;
        D2032 := HOME_S42; D2033 := RATE; D2034 := 0;
        
        IF (ABS(D1000 - tgt_a) < TOL_POS) AND (ABS(D1001) < TOL_SPD) THEN
            state := 8;
        END_IF;

    8: (* CELL4_SETUP *)
        Y75 := TRUE; Y76 := TRUE;
        D710 := cur_id;
        D711 := IF req_sel = 0 THEN D620 ELSE D620 END_IF;
        D712 := RATE;
        phase := 0;
        state := 9;

    9: (* CELL4_INDEX_PHASE0: RETRIEVE PINS *)
        tgt_s40 := HOME_S40;
        tgt_s41 := 0; tgt_s42 := 0;
        Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
        
        D2024 := tgt_s40; D2025 := RATE; D2026 := 0;
        D2028 := tgt_s41; D2029 := RATE; D2030 := 0;
        D2032 := tgt_s42; D2033 := RATE; D2034 := 0;
        
        IF (ABS(D1024 - tgt_s40) < TOL_POS) AND (ABS(D1028 - tgt_s41) < TOL_POS) AND (ABS(D1032 - tgt_s42) < TOL_POS) THEN
            phase := 1;
            state := 10;
        END_IF;

    10: (* CELL4_INDEX_PHASE1: ROTATE *)
        tgt_s40 := D600;
        tgt_s41 := 0; tgt_s42 := 0;
        
        D2024 := tgt_s40; D2025 := RATE; D2026 := 0;
        D2028 := tgt_s41; D2029 := RATE; D2030 := 0;
        D2032 := tgt_s42; D2033 := RATE; D2034 := 0;
        
        IF (ABS(D1024 - tgt_s40) < TOL_POS) AND (ABS(D1025) < TOL_SPD) THEN
            phase := 2;
            state := 11;
        END_IF;

    11: (* CELL4_INDEX_PHASE2: INSERT PIN 40MM *)
        tgt_s40 := D600;
        tgt_s41 := 4000; tgt_s42 := 4000;
        
        D2024 := tgt_s40; D2025 := RATE; D2026 := 0;
        D2028 := tgt_s41; D2029 := RATE; D2030 := 0;
        D2032 := tgt_s42; D2033 := RATE; D2034 := 0;
        
        IF (ABS(D1028 - tgt_s41) < TOL_POS) AND (ABS(D1032 - tgt_s42) < TOL_POS) THEN
            phase := 3;
            timer_stab(IN := TRUE, PT := T#80ms);
            IF timer_stab.Q THEN
                state := 12;
                timer_stab(IN := FALSE);
            END_IF;
        END_IF;

    12: (* CELL4_WAIT *)
        IF X75 OR X77 THEN
            state := 13;
        END_IF;

    13: (* MOVE_BACK_TO_LIFT *)
        tgt_a := IF lift_sel = 1 THEN DOCK1 ELSE DOCK2 END_IF;
        tgt_b := 0;
        tgt_c := HOME_C; tgt_d := HOME_D;
        tgt_s30 := HOME_S30; tgt_s31 := HOME_S31;
        tgt_s40 := HOME_S40; tgt_s41 := HOME_S41; tgt_s42 := HOME_S42;
        Y40 := TRUE; Y41 := TRUE; Y42 := FALSE; Y43 := FALSE;
        Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
        D80 := 2; D81 := lift_sel;
        
        D2000 := tgt_a; D2001 := RATE; D2002 := 0;
        D2004 := tgt_b; D2005 := RATE; D2006 := 0;
        D2008 := HOME_C; D2009 := RATE; D2010 := 0;
        D2012 := HOME_D; D2013 := RATE; D2014 := 0;
        D2016 := HOME_S30; D2017 := RATE; D2018 := 0;
        D2020 := HOME_S31; D2021 := RATE; D2022 := 0;
        D2024 := HOME_S40; D2025 := RATE; D2026 := 0;
        D2028 := HOME_S41; D2029 := RATE; D2030 := 0;
        D2032 := HOME_S42; D2033 := RATE; D2034 := 0;
        
        IF (ABS(D1000 - tgt_a) < TOL_POS) AND (ABS(D1001) < TOL_SPD) THEN
            state := 14;
        END_IF;

    14: (* DISCONNECT & RETURN *)
        tgt_b := 0;
        tgt_c := HOME_C; tgt_d := HOME_D;
        D80 := 2; D81 := lift_sel;
        Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
        
        D2004 := tgt_b; D2005 := RATE; D2006 := 0;
        D2008 := HOME_C; D2009 := RATE; D2010 := 0;
        D2012 := HOME_D; D2013 := RATE; D2014 := 0;
        
        IF (ABS(D1004 - tgt_b) < TOL_POS) AND (ABS(D1005) < TOL_SPD) THEN
            IF (lift_sel = 1 AND X61) OR (lift_sel = 2 AND X62) OR ((lift_sel = 1 AND X30) OR (lift_sel = 2 AND X34)) THEN
                state := 15;
            END_IF;
        END_IF;

    15: (* ACK_REQ *)
        Y70 := FALSE; Y71 := FALSE;
        Y75 := FALSE; Y76 := FALSE;
        IF req_sel = 0 THEN
            D300 := cur_id;
            D301 := IF cur_cancel THEN 2 ELSE 1 END_IF;
            done0 := TRUE;
        ELSE
            D302 := cur_id;
            D303 := IF cur_cancel THEN 2 ELSE 1 END_IF;
            done1 := TRUE;
        END_IF;
        state := 16;

    16: (* CHECK_NEXT *)
        IF (NOT done0 AND (D102 > 0)) OR (NOT done1 AND (D122 > 0)) THEN
            state := 0;
        ELSE
            state := 17;
        END_IF;

    17: (* FINISH_HOME *)
        Y30 := FALSE;
        Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
        Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
        D2000 := HOME_A; D2001 := RATE; D2002 := 0;
        D2004 := HOME_B; D2005 := RATE; D2006 := 0;
        D2008 := HOME_C; D2009 := RATE; D2010 := 0;
        D2012 := HOME_D; D2013 := RATE; D2014 := 0;
        D2016 := HOME_S30; D2017 := RATE; D2018 := 0;
        D2020 := HOME_S31; D2021 := RATE; D2022 := 0;
        D2024 := HOME_S40; D2025 := RATE; D2026 := 0;
        D2028 := HOME_S41; D2029 := RATE; D2030 := 0;
        D2032 := HOME_S42; D2033 := RATE; D2034 := 0;
        
        IF all_home THEN
            state := 18;
        END_IF;

    18: (* HOLD_COMPLETE *)
        Y30 := TRUE;
        Y2 := TRUE;
        timer_hold(IN := TRUE, PT := T#100ms);
        IF timer_hold.Q THEN
            (* Maintain Y2 as per task requirement, loop stays here *)
        END_IF;
END_CASE;

END_PROGRAM