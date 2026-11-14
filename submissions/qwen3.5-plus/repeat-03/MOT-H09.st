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
    step : INT := 0;
    sel_req : INT := 0;
    req_cancelled : BOOL := FALSE;
    seq_cnt : DINT := 0;
    tgt_a : DINT := 0;
    tgt_b : DINT := 0;
    tgt_c : DINT := 0;
    tgt_d : DINT := 0;
    tgt_s3_0 : DINT := 0;
    tgt_s3_1 : DINT := 0;
    tgt_s3_2 : DINT := 0;
    tgt_s4_0 : DINT := 0;
    tgt_s4_1 : DINT := 0;
    arr_a : BOOL := FALSE;
    arr_b : BOOL := FALSE;
    arr_c : BOOL := FALSE;
    arr_d : BOOL := FALSE;
    arr_s3_0 : BOOL := FALSE;
    arr_s3_1 : BOOL := FALSE;
    arr_s3_2 : BOOL := FALSE;
    arr_s4_0 : BOOL := FALSE;
    arr_s4_1 : BOOL := FALSE;
    ton_move : TON;
    ton_settle : TON;
    ton_y2_hold : TON;
    C_STN_LIFT_A : DINT := -360000;
    C_STN_LIFT_B : DINT := -230000;
    C_STN_C3 : DINT := 490000;
    C_STN_C4 : DINT := 1140000;
    C_HOME_A : DINT := 0;
    C_HOME_B : DINT := 0;
    C_HOME_C : DINT := 15000;
    C_HOME_D : DINT := 15000;
    C_HOME_S3_0 : DINT := 0;
    C_HOME_S3_1 : DINT := 0;
    C_HOME_S3_2 : DINT := 0;
    C_HOME_S4_0 : DINT := 0;
    C_HOME_S4_1 : DINT := 5000;
    C_B_CONNECT : DINT := 18000;
    C_B_RETRACT : DINT := 0;
    C_TOL : DINT := 20;
    C_RATE : DINT := 500;
END_VAR

arr_a := ABS(D1000 - tgt_a) <= C_TOL;
arr_b := ABS(D1004 - tgt_b) <= C_TOL;
arr_c := ABS(D1008 - tgt_c) <= C_TOL;
arr_d := ABS(D1012 - tgt_d) <= C_TOL;
arr_s3_0 := ABS(D1016 - tgt_s3_0) <= C_TOL;
arr_s3_1 := ABS(D1020 - tgt_s3_1) <= C_TOL;
arr_s3_2 := ABS(D1024 - tgt_s3_2) <= C_TOL;
arr_s4_0 := ABS(D1028 - tgt_s4_0) <= C_TOL;
arr_s4_1 := ABS(D1032 - tgt_s4_1) <= C_TOL;

ton_move(IN := NOT (arr_a AND arr_b AND arr_c AND arr_d AND arr_s3_0 AND arr_s3_1 AND arr_s3_2 AND arr_s4_0 AND arr_s4_1), PT := T#30ms);
ton_settle(IN := ton_move.Q AND (arr_a AND arr_b AND arr_c AND arr_d AND arr_s3_0 AND arr_s3_1 AND arr_s3_2 AND arr_s4_0 AND arr_s4_1), PT := T#30ms);
ton_y2_hold(IN := Y2, PT := T#100ms);

CASE step OF
    0: (* Idle / Request Selection *)
        tgt_a := C_HOME_A; tgt_b := C_HOME_B;
        tgt_c := C_HOME_C; tgt_d := C_HOME_D;
        tgt_s3_0 := C_HOME_S3_0; tgt_s3_1 := C_HOME_S3_1; tgt_s3_2 := C_HOME_S3_2;
        tgt_s4_0 := C_HOME_S4_0; tgt_s4_1 := C_HOME_S4_1;
        Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
        Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        D2001 := 0; D2005 := 0; D2009 := 0; D2013 := 0;
        D2017 := 0; D2021 := 0; D2025 := 0; D2029 := 0; D2033 := 0;
        D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
        D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;
        D80 := 0; D81 := 0; D82 := 0;
        Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
        D700 := 0; D701 := 0; D702 := 0; D710 := 0; D711 := 0; D712 := 0;
        D300 := 0; D301 := 0; D302 := 0; D303 := 0;
        Y2 := FALSE;
        Y30 := TRUE; (* Brake on at rest *)
        
        IF D100 <> 0 AND NOT X30 AND NOT X31 THEN
            sel_req := 0;
            step := 1;
        ELSIF D120 <> 0 AND NOT X34 AND NOT X35 THEN
            sel_req := 1;
            step := 1;
        ELSE
            (* Check completion *)
            IF (D100 = 0 OR X30 OR X31) AND (D120 = 0 OR X34 OR X35) THEN
                IF arr_a AND arr_b AND arr_c AND arr_d AND arr_s3_0 AND arr_s3_1 AND arr_s3_2 AND arr_s4_0 AND arr_s4_1 THEN
                    Y2 := TRUE;
                END_IF;
            END_IF;
        END_IF;

    1: (* Move Shuttle to Lift Station *)
        tgt_a := IF sel_req = 0 THEN C_STN_LIFT_A ELSE C_STN_LIFT_B END_IF;
        tgt_b := C_B_RETRACT;
        tgt_c := C_HOME_C; tgt_d := C_HOME_D;
        tgt_s3_0 := C_HOME_S3_0; tgt_s3_1 := C_HOME_S3_1; tgt_s3_2 := C_HOME_S3_2;
        tgt_s4_0 := C_HOME_S4_0; tgt_s4_1 := C_HOME_S4_1;
        Y40 := TRUE; Y41 := TRUE; Y42 := FALSE; Y43 := FALSE;
        Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        D2001 := C_RATE; D2005 := C_RATE;
        D2009 := 0; D2013 := 0; D2017 := 0; D2021 := 0; D2025 := 0; D2029 := 0; D2033 := 0;
        Y30 := FALSE;
        IF arr_a AND arr_b AND ton_settle.Q THEN step := 2; END_IF;

    2: (* Extend Fork *)
        tgt_b := C_B_CONNECT;
        tgt_a := IF sel_req = 0 THEN C_STN_LIFT_A ELSE C_STN_LIFT_B END_IF;
        Y41 := TRUE; Y40 := TRUE;
        IF arr_b AND ton_settle.Q THEN step := 3; END_IF;

    3: (* Lift to Dock Height *)
        tgt_c := IF sel_req = 0 THEN D92 ELSE C_HOME_C END_IF;
        tgt_d := IF sel_req = 1 THEN D92 ELSE C_HOME_D END_IF;
        Y42 := (sel_req = 0); Y43 := (sel_req = 1); Y40 := TRUE; Y41 := TRUE;
        D2009 := C_RATE; D2013 := C_RATE;
        IF (sel_req = 0 AND arr_c) OR (sel_req = 1 AND arr_d) THEN step := 4; END_IF;

    4: (* Wait for Port Ready & Couple *)
        D80 := 2; (* Place *)
        D81 := sel_req + 1; (* 1 or 2 *)
        seq_cnt := seq_cnt + 1;
        D82 := seq_cnt;
        Y40 := TRUE; Y41 := TRUE; Y42 := (sel_req = 0); Y43 := (sel_req = 1);
        IF (sel_req = 0 AND X61) OR (sel_req = 1 AND X62) THEN step := 5; END_IF;

    5: (* Move to Cell 3 *)
        tgt_a := C_STN_C3;
        Y40 := TRUE; Y41 := TRUE; Y42 := FALSE; Y43 := FALSE;
        D2001 := C_RATE; D2005 := 0;
        D2009 := 0; D2013 := 0;
        IF arr_a AND ton_settle.Q THEN step := 6; END_IF;

    6: (* Configure Pocket *)
        D700 := sel_req + 1; (* Lane 1 or 2 *)
        Y70 := TRUE;
        Y40 := TRUE; Y41 := TRUE;
        IF X72 THEN step := 7; END_IF;

    7: (* Retain Pocket / Move to Cell 4 *)
        Y71 := TRUE;
        tgt_a := C_STN_C4;
        D2001 := C_RATE;
        IF arr_a AND ton_settle.Q THEN step := 8; END_IF;

    8: (* Table Setup - Slide to 500 *)
        tgt_s4_1 := 5000;
        Y48 := TRUE; Y40 := TRUE; Y41 := TRUE; Y47 := FALSE;
        D2033 := C_RATE;
        IF arr_s4_1 AND ton_settle.Q THEN step := 9; END_IF;

    9: (* Rotate to Angle *)
        tgt_s4_0 := D627;
        Y47 := TRUE; Y48 := TRUE;
        D2029 := C_RATE;
        IF arr_s4_0 AND ton_settle.Q THEN step := 10; END_IF;

    10: (* Advance Slide to 700 *)
        tgt_s4_1 := 7000;
        Y48 := TRUE; Y47 := TRUE;
        D2033 := C_RATE;
        IF arr_s4_1 AND ton_settle.Q THEN step := 11; END_IF;

    11: (* Wait Cell 4 Served *)
        Y47 := TRUE; Y48 := TRUE; Y40 := TRUE; Y41 := TRUE;
        IF X75 THEN step := 12; END_IF;

    12: (* Table Retract & Rotate Home *)
        tgt_s4_1 := 5000;
        tgt_s4_0 := C_HOME_S4_0;
        D2033 := C_RATE; D2029 := C_RATE;
        IF arr_s4_0 AND arr_s4_1 AND ton_settle.Q THEN step := 13; END_IF;

    13: (* Move back to Cell 3 *)
        tgt_a := C_STN_C3;
        D2001 := C_RATE;
        IF arr_a AND ton_settle.Q THEN step := 14; END_IF;

    14: (* Release Pocket *)
        Y71 := FALSE;
        Y70 := FALSE;
        D700 := 0;
        Y40 := TRUE; Y41 := TRUE;
        IF NOT X72 THEN step := 15; END_IF;

    15: (* Move to Lift Station *)
        tgt_a := IF sel_req = 0 THEN C_STN_LIFT_A ELSE C_STN_LIFT_B END_IF;
        D2001 := C_RATE;
        IF arr_a AND ton_settle.Q THEN step := 16; END_IF;

    16: (* Retract Fork *)
        tgt_b := C_B_RETRACT;
        Y41 := TRUE;
        IF arr_b AND ton_settle.Q THEN step := 17; END_IF;

    17: (* Lower Lift to Home *)
        tgt_c := C_HOME_C; tgt_d := C_HOME_D;
        Y42 := (sel_req = 0); Y43 := (sel_req = 1);
        D2009 := C_RATE; D2013 := C_RATE;
        IF (sel_req = 0 AND arr_c) OR (sel_req = 1 AND arr_d) THEN step := 18; END_IF;

    18: (* Ack Request *)
        D80 := 0; D81 := 0; D82 := 0;
        Y30 := TRUE;
        Y40 := FALSE; Y41 := FALSE; Y42 := FALSE; Y43 := FALSE;
        Y44 := FALSE; Y45 := FALSE; Y46 := FALSE; Y47 := FALSE; Y48 := FALSE;
        req_cancelled := (sel_req = 0 AND X31) OR (sel_req = 1 AND X35);
        IF sel_req = 0 THEN
            D300 := D100;
            D301 := IF req_cancelled THEN 2 ELSE 1 END_IF;
        ELSE
            D302 := D120;
            D303 := IF req_cancelled THEN 2 ELSE 1 END_IF;
        END_IF;
        step := 0;

ELSE
    step := 0;
END_CASE;

(* Default assignments for unassigned outputs in this step *)
D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0; D2034 := 0;
D2017 := 0; D2021 := 0; D2025 := 0; D2029 := 0; D2033 := 0;
D701 := 0; D702 := 0; D710 := 0; D711 := 0; D712 := 0;

END_PROGRAM