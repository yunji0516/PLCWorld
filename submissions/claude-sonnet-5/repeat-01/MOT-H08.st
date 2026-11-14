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

    (* ---- internal state ---- *)
    active_req  : INT := 0;   // 0 none, 1 = req0, 2 = req1
    phase       : INT := 0;
    prev_phase  : INT := -1;
    entering    : BOOL;
    is_cancel   : BOOL := FALSE;
    loc         : DINT := 1;
    req_id_cur  : DINT := 0;
    r0_done     : BOOL := FALSE;
    r1_done     : BOOL := FALSE;
    seq_num     : DINT := 0;

    (* home / nominal constants (raw x100) *)
    home_a  : DINT := 0;
    home_b  : DINT := 0;
    home_c  : DINT := 40000;
    home_d  : DINT := 40000;
    home_s30 : DINT := -60000;
    home_s31 : DINT := -60000;
    home_s40 : DINT := 0;
    home_s41 : DINT := 0;
    home_s42 : DINT := 0;

    nom1 : DINT := -405000;
    nom2 : DINT := -185000;
    nom3 : DINT := 490000;
    nom4 : DINT := 1140000;

    station_a_target : DINT;

    tol  : DINT := 20;
    vtol : DINT := 100;

    (* command targets, retained across scans *)
    t_target_a  : DINT := 0;
    t_target_b  : DINT := 0;
    t_target_c  : DINT := 40000;
    t_target_d  : DINT := 40000;
    t_target_s30 : DINT := -60000;
    t_target_s31 : DINT := -60000;
    t_target_s40 : DINT := 0;
    t_target_s41 : DINT := 0;
    t_target_s42 : DINT := 0;

    a_ok : BOOL;
    b_ok : BOOL;
    c_ok : BOOL;
    d_ok : BOOL;
    s3_ok : BOOL;
    pr   : BOOL;

    (* cell4 interlock computation *)
    pi_const : REAL := 3.14159265;
    theta_a_rad : REAL;
    theta_b_rad : REAL;
    x_calc      : REAL;
    s40_cmd : DINT;
    s41_cmd : DINT;
    s42_cmd : DINT;
    m3g0c : DINT;
    m3g1c : DINT;

    (* safety monitors *)
    skew_val    : DINT;
    height_diff : DINT;
    moment4     : REAL;
    theta_a_act : REAL;
    theta_b_act : REAL;
    x_act       : REAL;

    all_axes_home : BOOL;
    hold_timer : TON;
END_VAR

(* ===================== derive arrival flags for previously commanded targets ===================== *)
a_ok := (ABS(D1000 - t_target_a) <= tol) AND (ABS(D1001) <= vtol);
b_ok := (ABS(D1004 - t_target_b) <= tol) AND (ABS(D1005) <= vtol);
c_ok := (ABS(D1008 - t_target_c) <= tol) AND (ABS(D1009) <= vtol);
d_ok := (ABS(D1012 - t_target_d) <= tol) AND (ABS(D1013) <= vtol);
s3_ok := (ABS(D1016 - t_target_s30) <= tol) AND (ABS(D1020 - t_target_s31) <= tol)
         AND (ABS(D1017) <= vtol) AND (ABS(D1021) <= vtol);

(* safety monitor values (always computed) *)
skew_val := ABS(D1016 - D1020);
height_diff := ABS(D1008 - D1012);
theta_a_act := (INT_TO_REAL(DINT(D1024)) / 100.0) * (pi_const / 180.0);
theta_b_act := (INT_TO_REAL(DINT(D1028)) / 100.0) * (pi_const / 180.0);
x_act := INT_TO_REAL(DINT(D1032)) / 100.0;
moment4 := 20.0 * 9.81 / 1000.0 * (225.0 * (SIN(theta_a_act) + SIN(theta_b_act)) + x_act);

(* ===================== cell4 interlock target computation ===================== *)
s40_cmd := LIMIT(-5000, D600, 5000);
s41_cmd := LIMIT(-5000, D601, 5000);
IF D602 <> 0 THEN
    s42_cmd := LIMIT(-45000, D602, 45000);
ELSE
    theta_a_rad := (INT_TO_REAL(s40_cmd) / 100.0) * (pi_const / 180.0);
    theta_b_rad := (INT_TO_REAL(s41_cmd) / 100.0) * (pi_const / 180.0);
    x_calc := -225.0 * (SIN(theta_a_rad) + SIN(theta_b_rad));
    s42_cmd := LIMIT(-45000, DINT(ROUND(x_calc * 100.0)), 45000);
END_IF;

m3g0c := LIMIT(-95000, D500, 95000);
m3g1c := LIMIT(-95000, D501, 95000);

(* ===================== request selection ===================== *)
IF active_req = 0 THEN
    IF (D100 <> 0) AND (NOT r0_done) THEN
        active_req := 1;
        phase := 1;
        loc := D101;
        req_id_cur := D100;
        is_cancel := FALSE;
    ELSIF (D120 <> 0) AND (NOT r1_done) THEN
        active_req := 2;
        phase := 1;
        loc := D121;
        req_id_cur := D120;
        is_cancel := FALSE;
    END_IF;
END_IF;

(* cancellation detection *)
IF (active_req = 1) AND X31 AND (phase >= 1) AND (phase <= 13) AND (NOT is_cancel) THEN
    is_cancel := TRUE;
    phase := 14;
END_IF;
IF (active_req = 2) AND X35 AND (phase >= 1) AND (phase <= 13) AND (NOT is_cancel) THEN
    is_cancel := TRUE;
    phase := 14;
END_IF;

IF loc = 1 THEN
    station_a_target := nom1;
ELSE
    station_a_target := nom2;
END_IF;

(* ===================== main sequencing ===================== *)
IF active_req = 0 THEN
    t_target_a := home_a;
    t_target_b := home_b;
    t_target_c := home_c;
    t_target_d := home_d;
    t_target_s30 := home_s30;
    t_target_s31 := home_s31;
    t_target_s40 := home_s40;
    t_target_s41 := home_s41;
    t_target_s42 := home_s42;
    Y70 := FALSE;
    Y71 := FALSE;
    Y75 := FALSE;
    Y76 := FALSE;
ELSE
    CASE phase OF
        1: (* GOTO_SRC_TRANSIT *)
            t_target_a := station_a_target;
            t_target_b := 0;
            t_target_c := home_c;
            t_target_d := home_d;
            IF a_ok AND b_ok THEN
                phase := 2;
            END_IF;

        2: (* SRC_CONNECT *)
            t_target_a := station_a_target;
            t_target_c := LIMIT(0, D92, 120000);
            t_target_d := LIMIT(0, D92, 120000);
            t_target_b := 18000;
            IF b_ok AND c_ok AND d_ok THEN
                IF loc = 1 THEN
                    pr := X61;
                ELSE
                    pr := X62;
                END_IF;
                IF pr THEN
                    phase := 3;
                END_IF;
            END_IF;

        3: (* SRC_ACTION_PICK -> retrieve fork *)
            t_target_b := 0;
            IF b_ok THEN
                phase := 4;
            END_IF;

        4: (* GOTO_CELL3_TRANSIT *)
            t_target_a := nom3;
            t_target_b := 0;
            t_target_c := home_c;
            t_target_d := home_d;
            IF a_ok AND b_ok THEN
                phase := 5;
            END_IF;

        5: (* CELL3_CONNECT *)
            t_target_a := nom3;
            t_target_b := 18000;
            t_target_s30 := m3g0c;
            t_target_s31 := m3g1c;
            Y70 := TRUE;
            Y71 := TRUE;
            IF b_ok THEN
                IF X63 THEN
                    phase := 6;
                END_IF;
            END_IF;

        6: (* CELL3_ACTION_PLACE *)
            phase := 7;

        7: (* CELL3_WAIT_RESULT *)
            t_target_s30 := m3g0c;
            t_target_s31 := m3g1c;
            IF X70 THEN
                phase := 8;
            END_IF;

        8: (* CELL3_ACTION_RETRIEVE *)
            t_target_b := 0;
            Y70 := FALSE;
            Y71 := FALSE;
            IF b_ok THEN
                phase := 9;
            END_IF;

        9: (* GOTO_CELL4_TRANSIT *)
            t_target_a := nom4;
            t_target_b := 0;
            IF a_ok AND b_ok THEN
                phase := 10;
            END_IF;

        10: (* CELL4_CONNECT *)
            t_target_a := nom4;
            t_target_b := 18000;
            t_target_s40 := s40_cmd;
            t_target_s41 := s41_cmd;
            t_target_s42 := s42_cmd;
            Y75 := TRUE;
            Y76 := TRUE;
            IF b_ok THEN
                IF X64 THEN
                    phase := 11;
                END_IF;
            END_IF;

        11: (* CELL4_ACTION_PLACE *)
            phase := 12;

        12: (* CELL4_WAIT_RESULT *)
            t_target_s40 := s40_cmd;
            t_target_s41 := s41_cmd;
            t_target_s42 := s42_cmd;
            IF X75 AND (ABS(moment4) <= 1.0) THEN
                phase := 13;
            END_IF;

        13: (* CELL4_ACTION_RETRIEVE *)
            t_target_b := 0;
            Y75 := FALSE;
            Y76 := FALSE;
            IF b_ok THEN
                phase := 14;
            END_IF;

        14: (* GOTO_SRC_RETURN_TRANSIT *)
            t_target_a := station_a_target;
            t_target_b := 0;
            t_target_c := home_c;
            t_target_d := home_d;
            Y70 := FALSE;
            Y71 := FALSE;
            Y75 := FALSE;
            Y76 := FALSE;
            IF a_ok AND b_ok THEN
                phase := 15;
            END_IF;

        15: (* SRC_RETURN_CONNECT *)
            t_target_a := station_a_target;
            t_target_c := LIMIT(0, D92, 120000);
            t_target_d := LIMIT(0, D92, 120000);
            t_target_b := 18000;
            IF b_ok AND c_ok AND d_ok THEN
                IF loc = 1 THEN
                    pr := X61;
                ELSE
                    pr := X62;
                END_IF;
                IF pr THEN
                    phase := 16;
                END_IF;
            END_IF;

        16: (* SRC_ACTION_DROP *)
            phase := 17;

        17: (* SRC_RETRACT *)
            t_target_b := 0;
            IF b_ok THEN
                phase := 18;
            END_IF;

        18: (* LOWER *)
            t_target_c := home_c;
            t_target_d := home_d;
            IF c_ok AND d_ok THEN
                phase := 19;
            END_IF;

        19: (* COMPLETE *)
            t_target_c := home_c;
            t_target_d := home_d;
            t_target_b := 0;
            IF active_req = 1 THEN
                D300 := req_id_cur;
                IF is_cancel THEN
                    D301 := 2;
                ELSE
                    D301 := 1;
                END_IF;
                IF X30 THEN
                    r0_done := TRUE;
                    active_req := 0;
                    phase := 0;
                    is_cancel := FALSE;
                END_IF;
            ELSIF active_req = 2 THEN
                D302 := req_id_cur;
                IF is_cancel THEN
                    D303 := 2;
                ELSE
                    D303 := 1;
                END_IF;
                IF X34 THEN
                    r1_done := TRUE;
                    active_req := 0;
                    phase := 0;
                    is_cancel := FALSE;
                END_IF;
            END_IF;

        ELSE
            ;
    END_CASE;
END_IF;

(* ===================== couple / ownership action edge issuing ===================== *)
entering := (phase <> prev_phase);
IF entering THEN
    CASE phase OF
        3:
            seq_num := seq_num + 1;
            D82 := seq_num;
            D80 := 1;
            D81 := loc;
        6:
            seq_num := seq_num + 1;
            D82 := seq_num;
            D80 := 2;
            D81 := 3;
        8:
            seq_num := seq_num + 1;
            D82 := seq_num;
            D80 := 1;
            D81 := 3;
        11:
            seq_num := seq_num + 1;
            D82 := seq_num;
            D80 := 2;
            D81 := 4;
        13:
            seq_num := seq_num + 1;
            D82 := seq_num;
            D80 := 1;
            D81 := 4;
        16:
            seq_num := seq_num + 1;
            D82 := seq_num;
            D80 := 2;
            D81 := loc;
        ELSE
            ;
    END_CASE;
END_IF;
prev_phase := phase;

(* ===================== cell configure output words ===================== *)
IF Y70 THEN
    D700 := D520;
    D701 := D526;
    D702 := 500;
ELSE
    D700 := 0;
    D701 := 0;
    D702 := 0;
END_IF;

IF Y75 THEN
    D710 := D620;
    D711 := D626;
    D712 := 500;
ELSE
    D710 := 0;
    D711 := 0;
    D712 := 0;
END_IF;

(* ===================== brake management ===================== *)
Y30 := a_ok;

(* ===================== write axis outputs (clamped) ===================== *)
D2000 := LIMIT(-450000, t_target_a, 1461300);
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := LIMIT(0, t_target_b, 18000);
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

D2008 := LIMIT(0, t_target_c, 120000);
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;

D2012 := LIMIT(0, t_target_d, 120000);
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := LIMIT(-95000, t_target_s30, 95000);
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := LIMIT(-95000, t_target_s31, 95000);
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := LIMIT(-5000, t_target_s40, 5000);
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := LIMIT(-5000, t_target_s41, 5000);
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

D2032 := LIMIT(-45000, t_target_s42, 45000);
D2033 := 1000;
D2034 := 0;
Y48 := TRUE;

(* ===================== final completion logic ===================== *)
all_axes_home := (ABS(D1000 - home_a) <= tol) AND (ABS(D1004 - home_b) <= tol)
    AND (ABS(D1008 - home_c) <= tol) AND (ABS(D1012 - home_d) <= tol)
    AND (ABS(D1016 - home_s30) <= tol) AND (ABS(D1020 - home_s31) <= tol)
    AND (ABS(D1024 - home_s40) <= tol) AND (ABS(D1028 - home_s41) <= tol)
    AND (ABS(D1032 - home_s42) <= tol);

hold_timer(IN := (X51 AND all_axes_home), PT := T#100ms);
IF hold_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM