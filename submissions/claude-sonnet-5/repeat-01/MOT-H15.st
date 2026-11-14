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
    D1036 : DINT;
    D1037 : DINT;
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
    D2036 : DINT;
    D2037 : DINT;
    D2038 : DINT;
    Y49 : BOOL;
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

    (* internal variables *)
    phase : INT := 0;
    req_idx : INT := 0;
    xfer_mode : INT := 0;
    xfer_station : INT := 0;
    xfer_step : INT := 0;
    next_phase : INT := 0;
    seq_num : DINT := 0;
    cur_id : DINT;
    cur_loc : DINT;
    cur_due : DINT;
    cur_returned : BOOL;
    cur_cancelled : BOOL;
    pocket_sel : INT := 2;
    settle_tmr : TON;
    lift_active : BOOL;
    a_target_i : DINT;
    b_target_i : DINT;
    c_target_i : DINT;
    d_target_i : DINT;
    s3_0_target_i : DINT;
    s3_1_target_i : DINT;
    s3_2_target_i : DINT;
    s4_0_target_i : DINT;
    s4_1_target_i : DINT;
    s4_2_target_i : DINT;
    angleA_rad : REAL;
    angleB_rad : REAL;
    sinA : REAL;
    sinB : REAL;
    xcalc_mm : REAL;
    angleA_act : REAL;
    angleB_act : REAL;
    xact_mm : REAL;
    moment3 : REAL;
    arrived3 : BOOL;
    arrived4 : BOOL;
    s4_at_home : BOOL;
    cnt_over : INT;
    all_home_ok : BOOL;
    RATE_DEF : DINT := 500;
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_CD : DINT := 40000;
    DOCK_H : DINT := 95000;
    FORK_CONNECT : DINT := 18000;
    FORK_RETRIEVE : DINT := 0;
    POS_TOL : DINT := 20;
    VEL_TOL : DINT := 100;
    pi_c : REAL := 3.14159265;
END_VAR

(* ---- defaults each scan ---- *)
a_target_i := HOME_A;
b_target_i := FORK_RETRIEVE;
c_target_i := HOME_CD;
d_target_i := HOME_CD;
s3_0_target_i := 0;
s3_1_target_i := 0;
s3_2_target_i := 0;
s4_0_target_i := 0;
s4_1_target_i := 0;
s4_2_target_i := 0;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;

(* ---- load current request ---- *)
IF req_idx = 0 THEN
    cur_id := D100;
    cur_loc := D101;
    cur_due := D103;
    cur_returned := X30;
    cur_cancelled := X31;
ELSE
    cur_id := D120;
    cur_loc := D121;
    cur_due := D123;
    cur_returned := X34;
    cur_cancelled := X35;
END_IF;

CASE phase OF

0: (* select / wait for request *)
    IF cur_id <> 0 THEN
        IF cur_cancelled THEN
            phase := 500;
        ELSE
            xfer_mode := 1;
            xfer_station := INT(cur_loc);
            xfer_step := 0;
            next_phase := 20;
            phase := 900;
        END_IF;
    END_IF;

20: (* place jig into cell3 *)
    xfer_mode := 2;
    xfer_station := 3;
    xfer_step := 0;
    next_phase := 30;
    phase := 900;

30: (* balance recipe at cell3 *)
    angleA_rad := REAL(D500) / 100.0 * pi_c / 180.0;
    angleB_rad := REAL(D501) / 100.0 * pi_c / 180.0;
    sinA := SIN(angleA_rad);
    sinB := SIN(angleB_rad);
    IF D502 = 0 THEN
        xcalc_mm := -225.0 * (sinA + sinB);
        s3_2_target_i := DINT(ROUND(xcalc_mm * 100.0));
    ELSE
        s3_2_target_i := D502;
    END_IF;
    s3_2_target_i := LIMIT(-45000, s3_2_target_i, 45000);
    s3_0_target_i := LIMIT(-5000, D500, 5000);
    s3_1_target_i := LIMIT(-5000, D501, 5000);

    angleA_act := REAL(D1016) / 100.0 * pi_c / 180.0;
    angleB_act := REAL(D1020) / 100.0 * pi_c / 180.0;
    xact_mm := REAL(D1024) / 100.0;
    moment3 := 20.0 * 9.81 / 1000.0 * (225.0 * (SIN(angleA_act) + SIN(angleB_act)) + xact_mm);

    arrived3 := (ABS(D1016 - s3_0_target_i) <= POS_TOL) AND (ABS(D1017) <= VEL_TOL)
            AND (ABS(D1020 - s3_1_target_i) <= POS_TOL) AND (ABS(D1021) <= VEL_TOL)
            AND (ABS(D1024 - s3_2_target_i) <= POS_TOL) AND (ABS(D1025) <= VEL_TOL)
            AND (ABS(moment3) <= 1.0);

    Y70 := TRUE;
    D700 := 1;
    D701 := D526;
    D702 := 0;

    IF arrived3 THEN
        settle_tmr(IN := TRUE, PT := T#30ms);
        Y71 := TRUE;
        IF settle_tmr.Q AND X70 THEN
            settle_tmr(IN := FALSE, PT := T#30ms);
            phase := 40;
        END_IF;
    ELSE
        settle_tmr(IN := FALSE, PT := T#30ms);
    END_IF;

40: (* retrieve from cell3 *)
    xfer_mode := 1;
    xfer_station := 3;
    xfer_step := 0;
    next_phase := 50;
    phase := 900;

50: (* place into cell4 *)
    xfer_mode := 2;
    xfer_station := 4;
    xfer_step := 0;
    next_phase := 60;
    phase := 900;

60: (* pocket move at cell4 *)
    s4_at_home := (ABS(D1028 - HOME_A) <= POS_TOL) AND (ABS(D1032 - HOME_A) <= POS_TOL) AND (ABS(D1036 - HOME_A) <= POS_TOL);
    IF s4_at_home THEN
        IF D527 < 0 THEN
            pocket_sel := 1;
        ELSE
            pocket_sel := 2;
        END_IF;
    END_IF;
    D710 := DINT(pocket_sel);
    D711 := D626;
    D712 := 0;
    Y75 := TRUE;

    s4_0_target_i := LIMIT(0, D600, 100000);
    s4_1_target_i := LIMIT(0, D601, 100000);
    s4_2_target_i := LIMIT(0, D602, 100000);

    cnt_over := 0;
    IF s4_0_target_i > 8000 THEN
        cnt_over := cnt_over + 1;
    END_IF;
    IF s4_1_target_i > 8000 THEN
        cnt_over := cnt_over + 1;
    END_IF;
    IF s4_2_target_i > 8000 THEN
        cnt_over := cnt_over + 1;
    END_IF;

    IF cnt_over > 1 THEN
        IF (s4_0_target_i >= s4_1_target_i) AND (s4_0_target_i >= s4_2_target_i) THEN
            s4_1_target_i := MIN(s4_1_target_i, 8000);
            s4_2_target_i := MIN(s4_2_target_i, 8000);
        ELSIF (s4_1_target_i >= s4_0_target_i) AND (s4_1_target_i >= s4_2_target_i) THEN
            s4_0_target_i := MIN(s4_0_target_i, 8000);
            s4_2_target_i := MIN(s4_2_target_i, 8000);
        ELSE
            s4_0_target_i := MIN(s4_0_target_i, 8000);
            s4_1_target_i := MIN(s4_1_target_i, 8000);
        END_IF;
    END_IF;

    arrived4 := (ABS(D1028 - s4_0_target_i) <= POS_TOL) AND (ABS(D1029) <= VEL_TOL)
            AND (ABS(D1032 - s4_1_target_i) <= POS_TOL) AND (ABS(D1033) <= VEL_TOL)
            AND (ABS(D1036 - s4_2_target_i) <= POS_TOL) AND (ABS(D1037) <= VEL_TOL);

    IF arrived4 THEN
        settle_tmr(IN := TRUE, PT := T#30ms);
        Y76 := TRUE;
        IF settle_tmr.Q AND X75 THEN
            settle_tmr(IN := FALSE, PT := T#30ms);
            phase := 70;
        END_IF;
    ELSE
        settle_tmr(IN := FALSE, PT := T#30ms);
    END_IF;

70: (* retrieve from cell4 *)
    xfer_mode := 1;
    xfer_station := 4;
    xfer_step := 0;
    next_phase := 80;
    phase := 900;

80: (* place back into origin lift *)
    xfer_mode := 2;
    xfer_station := INT(cur_loc);
    xfer_step := 0;
    next_phase := 90;
    phase := 900;

90: (* lower lift to home *)
    c_target_i := HOME_CD;
    d_target_i := HOME_CD;
    IF (ABS(D1008 - HOME_CD) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
       AND (ABS(D1012 - HOME_CD) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL) THEN
        settle_tmr(IN := TRUE, PT := T#30ms);
        IF settle_tmr.Q THEN
            settle_tmr(IN := FALSE, PT := T#30ms);
            phase := 100;
        END_IF;
    ELSE
        settle_tmr(IN := FALSE, PT := T#30ms);
    END_IF;

100: (* respond completion *)
    IF req_idx = 0 THEN
        D300 := cur_id;
        D301 := 1;
    ELSE
        D302 := cur_id;
        D303 := 1;
    END_IF;
    phase := 200;

200: (* advance to next request *)
    IF req_idx = 0 THEN
        req_idx := 1;
        phase := 0;
    ELSE
        phase := 1000;
    END_IF;

500: (* cancellation response *)
    IF req_idx = 0 THEN
        D300 := cur_id;
        D301 := 2;
    ELSE
        D302 := cur_id;
        D303 := 2;
    END_IF;
    phase := 200;

900: (* generic transfer executor *)
    lift_active := (xfer_station = 1) OR (xfer_station = 2);
    CASE xfer_station OF
        1: a_target_i := -405000;
        2: a_target_i := -185000;
        3: a_target_i := 0;
        4: a_target_i := 375000;
    ELSE
        a_target_i := 0;
    END_CASE;
    IF lift_active THEN
        c_target_i := DOCK_H;
        d_target_i := DOCK_H;
    ELSE
        c_target_i := HOME_CD;
        d_target_i := HOME_CD;
    END_IF;

    CASE xfer_step OF
        0:
            b_target_i := FORK_RETRIEVE;
            IF (ABS(D1000 - a_target_i) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL)
               AND (ABS(D1008 - c_target_i) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
               AND (ABS(D1012 - d_target_i) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL) THEN
                settle_tmr(IN := TRUE, PT := T#30ms);
                IF settle_tmr.Q THEN
                    settle_tmr(IN := FALSE, PT := T#30ms);
                    xfer_step := 1;
                END_IF;
            ELSE
                settle_tmr(IN := FALSE, PT := T#30ms);
            END_IF;
        1:
            b_target_i := FORK_CONNECT;
            IF (ABS(D1004 - b_target_i) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL) THEN
                settle_tmr(IN := TRUE, PT := T#30ms);
                IF settle_tmr.Q THEN
                    settle_tmr(IN := FALSE, PT := T#30ms);
                    xfer_step := 2;
                END_IF;
            ELSE
                settle_tmr(IN := FALSE, PT := T#30ms);
            END_IF;
        2:
            b_target_i := FORK_CONNECT;
            seq_num := seq_num + 1;
            D80 := DINT(xfer_mode);
            D81 := DINT(xfer_station);
            D82 := seq_num;
            xfer_step := 3;
        3:
            b_target_i := FORK_RETRIEVE;
            IF (ABS(D1004 - b_target_i) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL) THEN
                settle_tmr(IN := TRUE, PT := T#30ms);
                IF settle_tmr.Q THEN
                    settle_tmr(IN := FALSE, PT := T#30ms);
                    xfer_step := 4;
                END_IF;
            ELSE
                settle_tmr(IN := FALSE, PT := T#30ms);
            END_IF;
        4:
            phase := next_phase;
    END_CASE;

1000: (* final homing and completion *)
    all_home_ok := (ABS(D1000 - HOME_A) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL)
        AND (ABS(D1004 - HOME_B) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL)
        AND (ABS(D1008 - HOME_CD) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL)
        AND (ABS(D1012 - HOME_CD) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL)
        AND (ABS(D1016) <= POS_TOL) AND (ABS(D1017) <= VEL_TOL)
        AND (ABS(D1020) <= POS_TOL) AND (ABS(D1021) <= VEL_TOL)
        AND (ABS(D1024) <= POS_TOL) AND (ABS(D1025) <= VEL_TOL)
        AND (ABS(D1028) <= POS_TOL) AND (ABS(D1029) <= VEL_TOL)
        AND (ABS(D1032) <= POS_TOL) AND (ABS(D1033) <= VEL_TOL)
        AND (ABS(D1036) <= POS_TOL) AND (ABS(D1037) <= VEL_TOL);
    IF X51 AND all_home_ok THEN
        Y2 := TRUE;
    END_IF;

ELSE
    phase := 0;

END_CASE;

(* ---- brake handling ---- *)
Y30 := (ABS(D1001) <= VEL_TOL) AND (ABS(D1005) <= VEL_TOL) AND (ABS(D1009) <= VEL_TOL) AND (ABS(D1013) <= VEL_TOL);

(* ---- output assignment with clipping ---- *)
D2000 := LIMIT(-450000, a_target_i, 450000);
D2001 := RATE_DEF;
D2002 := 0;
Y40 := TRUE;

D2004 := LIMIT(0, b_target_i, 18000);
D2005 := RATE_DEF;
D2006 := 0;
Y41 := TRUE;

D2008 := LIMIT(0, c_target_i, 120000);
D2009 := RATE_DEF;
D2010 := 0;
Y42 := TRUE;

D2012 := LIMIT(0, d_target_i, 120000);
D2013 := RATE_DEF;
D2014 := 0;
Y43 := TRUE;

D2016 := LIMIT(-5000, s3_0_target_i, 5000);
D2017 := RATE_DEF;
D2018 := 0;
Y44 := TRUE;

D2020 := LIMIT(-5000, s3_1_target_i, 5000);
D2021 := RATE_DEF;
D2022 := 0;
Y45 := TRUE;

D2024 := LIMIT(-45000, s3_2_target_i, 45000);
D2025 := RATE_DEF;
D2026 := 0;
Y46 := TRUE;

D2028 := LIMIT(0, s4_0_target_i, 100000);
D2029 := RATE_DEF;
D2030 := 0;
Y47 := TRUE;

D2032 := LIMIT(0, s4_1_target_i, 100000);
D2033 := RATE_DEF;
D2034 := 0;
Y48 := TRUE;

D2036 := LIMIT(0, s4_2_target_i, 100000);
D2037 := RATE_DEF;
D2038 := 0;
Y49 := TRUE;

END_PROGRAM