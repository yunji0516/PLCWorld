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

    (* --- internal constants (scaled x100 raw values) --- *)
    DOCK1 : DINT := -405000;
    DOCK2 : DINT := -185000;
    DOCK3 : DINT := 0;
    DOCK4 : DINT := 360000;
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HOME_S3_0 : DINT := 0;
    HOME_S3_1 : DINT := 5000;
    HOME_S4_0 : DINT := 0;
    HOME_S4_1 : DINT := 0;
    HOME_S4_2 : DINT := 0;
    LIFT_DOCK_HEIGHT : DINT := 95000;
    FORK_RETRIEVE : DINT := 0;
    FORK_CONNECT : DINT := 18000;
    POS_TOL : DINT := 20;
    VEL_TOL : DINT := 100;

    (* --- scan / time --- *)
    elapsed_ms : DINT := 0;

    (* --- request 0 state --- *)
    r0_phase : DINT := 0;
    r0_last_id : DINT := 0;
    r0_arrival_ms : DINT := 0;
    r0_acked : BOOL := FALSE;
    r0_couple_new : BOOL := FALSE;
    r0_dock_x : DINT := 0;
    r0_remaining : DINT := 0;
    r0_wait : BOOL := FALSE;
    r0_all_clear : BOOL := TRUE;

    (* --- request 1 state --- *)
    r1_phase : DINT := 0;
    r1_last_id : DINT := 0;
    r1_arrival_ms : DINT := 0;
    r1_acked : BOOL := FALSE;
    r1_couple_new : BOOL := FALSE;
    r1_dock_x : DINT := 0;
    r1_remaining : DINT := 0;
    r1_wait : BOOL := FALSE;
    r1_all_clear : BOOL := TRUE;

    (* --- shared mutexes --- *)
    shuttle_owner : DINT := 0;
    couple_seq_ctr : DINT := 0;
    cell3_occupied_by : DINT := 0;
    cell4_occupied_by : DINT := 0;

    (* --- scratch flags --- *)
    a_ok : BOOL;
    b_ok : BOOL;
    lift_ok : BOOL;
    rot_ok : BOOL;
    slide_ok : BOOL;
    pin_ok : BOOL;
    home_ok : BOOL;

    (* --- output staging --- *)
    a_target_v : DINT; a_rate_v : DINT; a_enable_v : BOOL;
    b_target_v : DINT; b_rate_v : DINT; b_enable_v : BOOL;
    c_target_v : DINT; c_rate_v : DINT; c_enable_v : BOOL;
    d_target_v : DINT; d_rate_v : DINT; d_enable_v : BOOL;
    s3_0_target_v : DINT; s3_0_rate_v : DINT; s3_0_enable_v : BOOL;
    s3_1_target_v : DINT; s3_1_rate_v : DINT; s3_1_enable_v : BOOL;
    s4_0_target_v : DINT; s4_0_rate_v : DINT; s4_0_enable_v : BOOL;
    s4_1_target_v : DINT; s4_1_rate_v : DINT; s4_1_enable_v : BOOL;
    s4_2_target_v : DINT; s4_2_rate_v : DINT; s4_2_enable_v : BOOL;

    stable_timer : TON;
END_VAR

(* ============ scan timer ============ *)
elapsed_ms := elapsed_ms + 20;

(* ============ new-request arrival detection ============ *)
IF D100 <> r0_last_id THEN
    r0_last_id := D100;
    IF D100 <> 0 THEN
        r0_phase := 0;
        r0_acked := FALSE;
        r0_couple_new := FALSE;
        r0_arrival_ms := elapsed_ms;
    END_IF;
END_IF;

IF D120 <> r1_last_id THEN
    r1_last_id := D120;
    IF D120 <> 0 THEN
        r1_phase := 0;
        r1_acked := FALSE;
        r1_couple_new := FALSE;
        r1_arrival_ms := elapsed_ms;
    END_IF;
END_IF;

(* ============ default output staging (safe hold) ============ *)
a_target_v := D1000; a_rate_v := 50; a_enable_v := TRUE;
b_target_v := D1004; b_rate_v := 50; b_enable_v := TRUE;
c_target_v := HOME_C; c_rate_v := 50; c_enable_v := TRUE;
d_target_v := HOME_D; d_rate_v := 50; d_enable_v := TRUE;
s3_0_target_v := HOME_S3_0; s3_0_rate_v := 50; s3_0_enable_v := TRUE;
s3_1_target_v := HOME_S3_1; s3_1_rate_v := 50; s3_1_enable_v := TRUE;
s4_0_target_v := HOME_S4_0; s4_0_rate_v := 50; s4_0_enable_v := TRUE;
s4_1_target_v := HOME_S4_1; s4_1_rate_v := 50; s4_1_enable_v := TRUE;
s4_2_target_v := HOME_S4_2; s4_2_rate_v := 50; s4_2_enable_v := TRUE;
Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;

(* ============ shuttle arbitration (deadline based) ============ *)
r0_wait := (r0_phase = 0 AND D100 <> 0 AND NOT X31) OR (r0_phase = 12) OR (r0_phase = 23);
r1_wait := (r1_phase = 0 AND D120 <> 0 AND NOT X35) OR (r1_phase = 12) OR (r1_phase = 23);

IF shuttle_owner = 0 THEN
    IF r0_wait AND r1_wait THEN
        r0_remaining := D103 - (elapsed_ms - r0_arrival_ms);
        r1_remaining := D123 - (elapsed_ms - r1_arrival_ms);
        IF r0_remaining <= r1_remaining THEN
            shuttle_owner := 1;
        ELSE
            shuttle_owner := 2;
        END_IF;
    ELSIF r0_wait THEN
        shuttle_owner := 1;
    ELSIF r1_wait THEN
        shuttle_owner := 2;
    END_IF;
END_IF;

(* ============ request 0 sequence ============ *)
CASE r0_phase OF

0:
    IF D100 <> 0 AND X31 AND NOT r0_acked THEN
        D300 := D100; D301 := 2; r0_acked := TRUE; r0_phase := 99;
    ELSIF shuttle_owner = 1 THEN
        r0_phase := 1;
    END_IF;

1:
    r0_dock_x := SEL(D101 = 2, DOCK1, DOCK2);
    a_target_v := r0_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    IF D101 = 2 THEN
        d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
        lift_ok := ABS(D1012 - LIFT_DOCK_HEIGHT) <= POS_TOL AND ABS(D1013) <= VEL_TOL;
    ELSE
        c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE;
        lift_ok := ABS(D1008 - LIFT_DOCK_HEIGHT) <= POS_TOL AND ABS(D1009) <= VEL_TOL;
    END_IF;
    a_ok := ABS(D1000 - r0_dock_x) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok AND lift_ok THEN
        r0_phase := 2; r0_couple_new := TRUE;
    END_IF;

2:
    IF r0_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 1; D81 := SEL(D101 = 2, 1, 2);
        r0_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := r0_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    IF D101 = 2 THEN d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
    ELSE c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE; END_IF;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r0_phase := 3; END_IF;

3:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := r0_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    IF D101 = 2 THEN d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
    ELSE c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE; END_IF;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r0_phase := 4; END_IF;

4:
    a_target_v := r0_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    IF D101 = 2 THEN
        d_target_v := HOME_D; d_rate_v := 300; d_enable_v := TRUE;
        lift_ok := ABS(D1012 - HOME_D) <= POS_TOL AND ABS(D1013) <= VEL_TOL;
    ELSE
        c_target_v := HOME_C; c_rate_v := 300; c_enable_v := TRUE;
        lift_ok := ABS(D1008 - HOME_C) <= POS_TOL AND ABS(D1009) <= VEL_TOL;
    END_IF;
    IF lift_ok THEN r0_phase := 5; END_IF;

5:
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_ok := ABS(D1000 - DOCK3) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok AND (cell3_occupied_by = 0 OR cell3_occupied_by = 1) THEN
        cell3_occupied_by := 1; r0_phase := 6; r0_couple_new := TRUE;
    END_IF;

6:
    IF r0_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 2; D81 := 3;
        r0_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r0_phase := 7; END_IF;

7:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN shuttle_owner := 0; r0_phase := 8; END_IF;

8:
    Y70 := TRUE; D700 := D100; D701 := D526; D702 := 500;
    s3_0_target_v := D500; s3_0_rate_v := 300; s3_0_enable_v := TRUE;
    s3_1_target_v := HOME_S3_1; s3_1_rate_v := 300; s3_1_enable_v := TRUE;
    rot_ok := ABS(D1016 - D500) <= POS_TOL AND ABS(D1017) <= VEL_TOL;
    IF rot_ok THEN r0_phase := 9; END_IF;

9:
    Y70 := TRUE; Y71 := TRUE;
    s3_0_target_v := D500; s3_0_rate_v := 300; s3_0_enable_v := TRUE;
    s3_1_target_v := D501; s3_1_rate_v := 300; s3_1_enable_v := TRUE;
    IF X70 THEN r0_phase := 10; END_IF;

10:
    s3_1_target_v := HOME_S3_1; s3_1_rate_v := 300; s3_1_enable_v := TRUE;
    s3_0_target_v := D500; s3_0_rate_v := 300; s3_0_enable_v := TRUE;
    slide_ok := ABS(D1020 - HOME_S3_1) <= POS_TOL AND ABS(D1021) <= VEL_TOL;
    IF slide_ok THEN r0_phase := 11; END_IF;

11:
    s3_0_target_v := HOME_S3_0; s3_0_rate_v := 300; s3_0_enable_v := TRUE;
    s3_1_target_v := HOME_S3_1; s3_1_rate_v := 300; s3_1_enable_v := TRUE;
    rot_ok := ABS(D1016 - HOME_S3_0) <= POS_TOL AND ABS(D1017) <= VEL_TOL;
    IF rot_ok THEN r0_phase := 12; END_IF;

12:
    IF shuttle_owner = 1 THEN r0_phase := 13; END_IF;

13:
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_ok := ABS(D1000 - DOCK3) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok THEN r0_phase := 14; r0_couple_new := TRUE; END_IF;

14:
    IF r0_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 1; D81 := 3;
        r0_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r0_phase := 15; END_IF;

15:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN cell3_occupied_by := 0; r0_phase := 16; END_IF;

16:
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_ok := ABS(D1000 - DOCK4) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok AND (cell4_occupied_by = 0 OR cell4_occupied_by = 1) THEN
        cell4_occupied_by := 1; r0_phase := 17; r0_couple_new := TRUE;
    END_IF;

17:
    IF r0_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 2; D81 := 4;
        r0_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r0_phase := 18; END_IF;

18:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN shuttle_owner := 0; r0_phase := 19; END_IF;

19:
    Y75 := TRUE; D710 := 1; D711 := D626; D712 := 500;
    s4_0_target_v := D600; s4_0_rate_v := 300; s4_0_enable_v := TRUE;
    s4_1_target_v := HOME_S4_1; s4_1_rate_v := 300; s4_1_enable_v := TRUE;
    s4_2_target_v := HOME_S4_2; s4_2_rate_v := 300; s4_2_enable_v := TRUE;
    rot_ok := ABS(D1024 - D600) <= POS_TOL AND ABS(D1025) <= VEL_TOL;
    IF rot_ok THEN r0_phase := 20; END_IF;

20:
    Y75 := TRUE; Y76 := TRUE;
    s4_0_target_v := D600; s4_0_rate_v := 300; s4_0_enable_v := TRUE;
    s4_1_target_v := D601; s4_1_rate_v := 300; s4_1_enable_v := TRUE;
    s4_2_target_v := HOME_S4_2; s4_2_rate_v := 300; s4_2_enable_v := TRUE;
    IF X75 THEN r0_phase := 21; END_IF;

21:
    s4_1_target_v := HOME_S4_1; s4_1_rate_v := 300; s4_1_enable_v := TRUE;
    s4_0_target_v := D600; s4_0_rate_v := 300; s4_0_enable_v := TRUE;
    s4_2_target_v := HOME_S4_2; s4_2_rate_v := 300; s4_2_enable_v := TRUE;
    pin_ok := ABS(D1028 - HOME_S4_1) <= POS_TOL AND ABS(D1029) <= VEL_TOL;
    IF pin_ok THEN r0_phase := 22; END_IF;

22:
    s4_0_target_v := HOME_S4_0; s4_0_rate_v := 300; s4_0_enable_v := TRUE;
    s4_1_target_v := HOME_S4_1; s4_1_rate_v := 300; s4_1_enable_v := TRUE;
    s4_2_target_v := HOME_S4_2; s4_2_rate_v := 300; s4_2_enable_v := TRUE;
    rot_ok := ABS(D1024 - HOME_S4_0) <= POS_TOL AND ABS(D1025) <= VEL_TOL;
    IF rot_ok THEN r0_phase := 23; END_IF;

23:
    IF shuttle_owner = 1 THEN r0_phase := 24; END_IF;

24:
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_ok := ABS(D1000 - DOCK4) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok THEN r0_phase := 25; r0_couple_new := TRUE; END_IF;

25:
    IF r0_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 1; D81 := 4;
        r0_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r0_phase := 26; END_IF;

26:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN cell4_occupied_by := 0; r0_phase := 27; END_IF;

27:
    r0_dock_x := SEL(D101 = 2, DOCK1, DOCK2);
    a_target_v := r0_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    IF D101 = 2 THEN
        d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
        lift_ok := ABS(D1012 - LIFT_DOCK_HEIGHT) <= POS_TOL AND ABS(D1013) <= VEL_TOL;
    ELSE
        c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE;
        lift_ok := ABS(D1008 - LIFT_DOCK_HEIGHT) <= POS_TOL AND ABS(D1009) <= VEL_TOL;
    END_IF;
    a_ok := ABS(D1000 - r0_dock_x) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok AND lift_ok THEN r0_phase := 28; r0_couple_new := TRUE; END_IF;

28:
    IF r0_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 2; D81 := SEL(D101 = 2, 1, 2);
        r0_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := r0_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    IF D101 = 2 THEN d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
    ELSE c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE; END_IF;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r0_phase := 29; END_IF;

29:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := r0_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    IF D101 = 2 THEN d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
    ELSE c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE; END_IF;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN shuttle_owner := 0; r0_phase := 30; END_IF;

30:
    IF D101 = 2 THEN
        d_target_v := HOME_D; d_rate_v := 300; d_enable_v := TRUE;
        lift_ok := ABS(D1012 - HOME_D) <= POS_TOL AND ABS(D1013) <= VEL_TOL;
    ELSE
        c_target_v := HOME_C; c_rate_v := 300; c_enable_v := TRUE;
        lift_ok := ABS(D1008 - HOME_C) <= POS_TOL AND ABS(D1009) <= VEL_TOL;
    END_IF;
    IF lift_ok THEN r0_phase := 31; END_IF;

31:
    IF X30 AND NOT r0_acked THEN
        D300 := D100; D301 := 1; r0_acked := TRUE; r0_phase := 99;
    END_IF;

99:
    ;
ELSE
    r0_phase := 99;
END_CASE;

(* ============ request 1 sequence (mirrored) ============ *)
CASE r1_phase OF

0:
    IF D120 <> 0 AND X35 AND NOT r1_acked THEN
        D302 := D120; D303 := 2; r1_acked := TRUE; r1_phase := 99;
    ELSIF shuttle_owner = 2 THEN
        r1_phase := 1;
    END_IF;

1:
    r1_dock_x := SEL(D121 = 2, DOCK1, DOCK2);
    a_target_v := r1_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    IF D121 = 2 THEN
        d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
        lift_ok := ABS(D1012 - LIFT_DOCK_HEIGHT) <= POS_TOL AND ABS(D1013) <= VEL_TOL;
    ELSE
        c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE;
        lift_ok := ABS(D1008 - LIFT_DOCK_HEIGHT) <= POS_TOL AND ABS(D1009) <= VEL_TOL;
    END_IF;
    a_ok := ABS(D1000 - r1_dock_x) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok AND lift_ok THEN r1_phase := 2; r1_couple_new := TRUE; END_IF;

2:
    IF r1_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 1; D81 := SEL(D121 = 2, 1, 2);
        r1_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := r1_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    IF D121 = 2 THEN d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
    ELSE c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE; END_IF;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r1_phase := 3; END_IF;

3:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := r1_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    IF D121 = 2 THEN d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
    ELSE c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE; END_IF;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r1_phase := 4; END_IF;

4:
    a_target_v := r1_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    IF D121 = 2 THEN
        d_target_v := HOME_D; d_rate_v := 300; d_enable_v := TRUE;
        lift_ok := ABS(D1012 - HOME_D) <= POS_TOL AND ABS(D1013) <= VEL_TOL;
    ELSE
        c_target_v := HOME_C; c_rate_v := 300; c_enable_v := TRUE;
        lift_ok := ABS(D1008 - HOME_C) <= POS_TOL AND ABS(D1009) <= VEL_TOL;
    END_IF;
    IF lift_ok THEN r1_phase := 5; END_IF;

5:
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_ok := ABS(D1000 - DOCK3) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok AND (cell3_occupied_by = 0 OR cell3_occupied_by = 2) THEN
        cell3_occupied_by := 2; r1_phase := 6; r1_couple_new := TRUE;
    END_IF;

6:
    IF r1_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 2; D81 := 3;
        r1_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r1_phase := 7; END_IF;

7:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN shuttle_owner := 0; r1_phase := 8; END_IF;

8:
    Y70 := TRUE; D700 := D120; D701 := D526; D702 := 500;
    s3_0_target_v := D500; s3_0_rate_v := 300; s3_0_enable_v := TRUE;
    s3_1_target_v := HOME_S3_1; s3_1_rate_v := 300; s3_1_enable_v := TRUE;
    rot_ok := ABS(D1016 - D500) <= POS_TOL AND ABS(D1017) <= VEL_TOL;
    IF rot_ok THEN r1_phase := 9; END_IF;

9:
    Y70 := TRUE; Y71 := TRUE;
    s3_0_target_v := D500; s3_0_rate_v := 300; s3_0_enable_v := TRUE;
    s3_1_target_v := D501; s3_1_rate_v := 300; s3_1_enable_v := TRUE;
    IF X70 THEN r1_phase := 10; END_IF;

10:
    s3_1_target_v := HOME_S3_1; s3_1_rate_v := 300; s3_1_enable_v := TRUE;
    s3_0_target_v := D500; s3_0_rate_v := 300; s3_0_enable_v := TRUE;
    slide_ok := ABS(D1020 - HOME_S3_1) <= POS_TOL AND ABS(D1021) <= VEL_TOL;
    IF slide_ok THEN r1_phase := 11; END_IF;

11:
    s3_0_target_v := HOME_S3_0; s3_0_rate_v := 300; s3_0_enable_v := TRUE;
    s3_1_target_v := HOME_S3_1; s3_1_rate_v := 300; s3_1_enable_v := TRUE;
    rot_ok := ABS(D1016 - HOME_S3_0) <= POS_TOL AND ABS(D1017) <= VEL_TOL;
    IF rot_ok THEN r1_phase := 12; END_IF;

12:
    IF shuttle_owner = 2 THEN r1_phase := 13; END_IF;

13:
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_ok := ABS(D1000 - DOCK3) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok THEN r1_phase := 14; r1_couple_new := TRUE; END_IF;

14:
    IF r1_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 1; D81 := 3;
        r1_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r1_phase := 15; END_IF;

15:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK3; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN cell3_occupied_by := 0; r1_phase := 16; END_IF;

16:
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_ok := ABS(D1000 - DOCK4) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok AND (cell4_occupied_by = 0 OR cell4_occupied_by = 2) THEN
        cell4_occupied_by := 2; r1_phase := 17; r1_couple_new := TRUE;
    END_IF;

17:
    IF r1_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 2; D81 := 4;
        r1_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r1_phase := 18; END_IF;

18:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN shuttle_owner := 0; r1_phase := 19; END_IF;

19:
    Y75 := TRUE; D710 := 2; D711 := D626; D712 := 500;
    s4_0_target_v := D600; s4_0_rate_v := 300; s4_0_enable_v := TRUE;
    s4_1_target_v := HOME_S4_1; s4_1_rate_v := 300; s4_1_enable_v := TRUE;
    s4_2_target_v := HOME_S4_2; s4_2_rate_v := 300; s4_2_enable_v := TRUE;
    rot_ok := ABS(D1024 - D600) <= POS_TOL AND ABS(D1025) <= VEL_TOL;
    IF rot_ok THEN r1_phase := 20; END_IF;

20:
    Y75 := TRUE; Y76 := TRUE;
    s4_0_target_v := D600; s4_0_rate_v := 300; s4_0_enable_v := TRUE;
    s4_1_target_v := HOME_S4_1; s4_1_rate_v := 300; s4_1_enable_v := TRUE;
    s4_2_target_v := D602; s4_2_rate_v := 300; s4_2_enable_v := TRUE;
    IF X75 THEN r1_phase := 21; END_IF;

21:
    s4_2_target_v := HOME_S4_2; s4_2_rate_v := 300; s4_2_enable_v := TRUE;
    s4_0_target_v := D600; s4_0_rate_v := 300; s4_0_enable_v := TRUE;
    s4_1_target_v := HOME_S4_1; s4_1_rate_v := 300; s4_1_enable_v := TRUE;
    pin_ok := ABS(D1032 - HOME_S4_2) <= POS_TOL AND ABS(D1033) <= VEL_TOL;
    IF pin_ok THEN r1_phase := 22; END_IF;

22:
    s4_0_target_v := HOME_S4_0; s4_0_rate_v := 300; s4_0_enable_v := TRUE;
    s4_1_target_v := HOME_S4_1; s4_1_rate_v := 300; s4_1_enable_v := TRUE;
    s4_2_target_v := HOME_S4_2; s4_2_rate_v := 300; s4_2_enable_v := TRUE;
    rot_ok := ABS(D1024 - HOME_S4_0) <= POS_TOL AND ABS(D1025) <= VEL_TOL;
    IF rot_ok THEN r1_phase := 23; END_IF;

23:
    IF shuttle_owner = 2 THEN r1_phase := 24; END_IF;

24:
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_ok := ABS(D1000 - DOCK4) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok THEN r1_phase := 25; r1_couple_new := TRUE; END_IF;

25:
    IF r1_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 1; D81 := 4;
        r1_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r1_phase := 26; END_IF;

26:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := DOCK4; a_rate_v := 300; a_enable_v := TRUE;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN cell4_occupied_by := 0; r1_phase := 27; END_IF;

27:
    r1_dock_x := SEL(D121 = 2, DOCK1, DOCK2);
    a_target_v := r1_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    IF D121 = 2 THEN
        d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
        lift_ok := ABS(D1012 - LIFT_DOCK_HEIGHT) <= POS_TOL AND ABS(D1013) <= VEL_TOL;
    ELSE
        c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE;
        lift_ok := ABS(D1008 - LIFT_DOCK_HEIGHT) <= POS_TOL AND ABS(D1009) <= VEL_TOL;
    END_IF;
    a_ok := ABS(D1000 - r1_dock_x) <= POS_TOL AND ABS(D1001) <= VEL_TOL;
    IF a_ok AND lift_ok THEN r1_phase := 28; r1_couple_new := TRUE; END_IF;

28:
    IF r1_couple_new THEN
        couple_seq_ctr := couple_seq_ctr + 1;
        D82 := couple_seq_ctr; D80 := 2; D81 := SEL(D121 = 2, 1, 2);
        r1_couple_new := FALSE;
    END_IF;
    b_target_v := FORK_CONNECT; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := r1_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    IF D121 = 2 THEN d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
    ELSE c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE; END_IF;
    b_ok := ABS(D1004 - FORK_CONNECT) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN r1_phase := 29; END_IF;

29:
    b_target_v := FORK_RETRIEVE; b_rate_v := 300; b_enable_v := TRUE;
    a_target_v := r1_dock_x; a_rate_v := 300; a_enable_v := TRUE;
    IF D121 = 2 THEN d_target_v := LIFT_DOCK_HEIGHT; d_rate_v := 300; d_enable_v := TRUE;
    ELSE c_target_v := LIFT_DOCK_HEIGHT; c_rate_v := 300; c_enable_v := TRUE; END_IF;
    b_ok := ABS(D1004 - FORK_RETRIEVE) <= POS_TOL AND ABS(D1005) <= VEL_TOL;
    IF b_ok THEN shuttle_owner := 0; r1_phase := 30; END_IF;

30:
    IF D121 = 2 THEN
        d_target_v := HOME_D; d_rate_v := 300; d_enable_v := TRUE;
        lift_ok := ABS(D1012 - HOME_D) <= POS_TOL AND ABS(D1013) <= VEL_TOL;
    ELSE
        c_target_v := HOME_C; c_rate_v := 300; c_enable_v := TRUE;
        lift_ok := ABS(D1008 - HOME_C) <= POS_TOL AND ABS(D1009) <= VEL_TOL;
    END_IF;
    IF lift_ok THEN r1_phase := 31; END_IF;

31:
    IF X34 AND NOT r1_acked THEN
        D302 := D120; D303 := 1; r1_acked := TRUE; r1_phase := 99;
    END_IF;

99:
    ;
ELSE
    r1_phase := 99;
END_CASE;

(* ============ final homing when both slots clear ============ *)
r0_all_clear := (r0_phase = 99) OR (D100 = 0);
r1_all_clear := (r1_phase = 99) OR (D120 = 0);

IF r0_all_clear AND r1_all_clear AND shuttle_owner = 0 THEN
    a_target_v := HOME_A; a_rate_v := 300; a_enable_v := TRUE;
    b_target_v := HOME_B; b_rate_v := 300; b_enable_v := TRUE;
END_IF;

(* ============ write staged values to actual outputs ============ *)
D2000 := a_target_v; D2001 := a_rate_v; D2002 := 0; Y40 := a_enable_v;
D2004 := b_target_v; D2005 := b_rate_v; D2006 := 0; Y41 := b_enable_v;
D2008 := c_target_v; D2009 := c_rate_v; D2010 := 0; Y42 := c_enable_v;
D2012 := d_target_v; D2013 := d_rate_v; D2014 := 0; Y43 := d_enable_v;
D2016 := s3_0_target_v; D2017 := s3_0_rate_v; D2018 := 0; Y44 := s3_0_enable_v;
D2020 := s3_1_target_v; D2021 := s3_1_rate_v; D2022 := 0; Y45 := s3_1_enable_v;
D2024 := s4_0_target_v; D2025 := s4_0_rate_v; D2026 := 0; Y46 := s4_0_enable_v;
D2028 := s4_1_target_v; D2029 := s4_1_rate_v; D2030 := 0; Y47 := s4_1_enable_v;
D2032 := s4_2_target_v; D2033 := s4_2_rate_v; D2034 := 0; Y48 := s4_2_enable_v;

(* ============ brake handling ============ *)
Y30 := (shuttle_owner = 0);

(* ============ overall completion ============ *)
home_ok := ABS(D1000 - HOME_A) <= POS_TOL AND ABS(D1001) <= VEL_TOL
    AND ABS(D1004 - HOME_B) <= POS_TOL AND ABS(D1005) <= VEL_TOL
    AND ABS(D1008 - HOME_C) <= POS_TOL AND ABS(D1009) <= VEL_TOL
    AND ABS(D1012 - HOME_D) <= POS_TOL AND ABS(D1013) <= VEL_TOL
    AND ABS(D1016 - HOME_S3_0) <= POS_TOL AND ABS(D1017) <= VEL_TOL
    AND ABS(D1020 - HOME_S3_1) <= POS_TOL AND ABS(D1021) <= VEL_TOL
    AND ABS(D1024 - HOME_S4_0) <= POS_TOL AND ABS(D1025) <= VEL_TOL
    AND ABS(D1028 - HOME_S4_1) <= POS_TOL AND ABS(D1029) <= VEL_TOL
    AND ABS(D1032 - HOME_S4_2) <= POS_TOL AND ABS(D1033) <= VEL_TOL;

stable_timer(IN := (X51 AND home_ok AND r0_all_clear AND r1_all_clear), PT := T#100ms);

IF stable_timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM