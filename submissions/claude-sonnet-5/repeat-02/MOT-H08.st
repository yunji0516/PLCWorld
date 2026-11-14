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

    (* -------- internal -------- *)
    STATION1_X : DINT := -405000;
    STATION2_X : DINT := -185000;
    STATION3_X : DINT := 490000;
    STATION4_X : DINT := 1140000;
    LIFT_HOME  : DINT := 40000;
    LIFT_DOCK  : DINT := 95000;
    FORK_CONNECT_V : DINT := 18000;
    FORK_RELEASE_V : DINT := 0;
    HOME_S3    : DINT := -60000;
    HOME_S4A   : DINT := 0;
    HOME_S4C   : DINT := 0;
    HOME_A     : DINT := 0;
    HOME_B     : DINT := 0;
    POS_TOL    : DINT := 20;
    VEL_TOL    : DINT := 100;

    req_state0 : INT := 0;
    req_state1 : INT := 0;
    own_station0 : INT := 0;
    own_station1 : INT := 0;
    axis_is_c0 : BOOL := TRUE;
    axis_is_c1 : BOOL := FALSE;
    pending_status0 : INT := 0;
    pending_status1 : INT := 0;
    last_id0 : DINT := 0;
    last_id1 : DINT := 0;
    settle0 : INT := 0;
    settle1 : INT := 0;
    shuttle_owner : INT := -1;
    seq : DINT := 0;

    a_target_v : DINT := 0;
    b_target_v : DINT := 0;
    c_target_v : DINT := 40000;
    d_target_v : DINT := 40000;
    s3_0_target_v : DINT := -60000;
    s3_1_target_v : DINT := -60000;
    s4_0_target_v : DINT := 0;
    s4_1_target_v : DINT := 0;
    s4_2_target_v : DINT := 0;

    pi_const : REAL := 3.1415926535;
    theta_a_rad : REAL;
    theta_b_rad : REAL;
    cw_mm : REAL;
    moment_real : REAL;
    abs_moment : REAL;

    home_ok : BOOL := FALSE;
    home_settle : TON;
    y2_latched : BOOL := FALSE;
    elapsed_ms : DINT := 0;
END_VAR

(* ================= REQUEST 0 ================= *)

IF (X31) AND (req_state0>=1) AND (req_state0<=11) THEN
    pending_status0 := 2;
    IF req_state0 = 1 THEN
        req_state0 := 14;
    ELSE
        req_state0 := 51;
    END_IF;
END_IF;

CASE req_state0 OF

0:
    IF (D100<>0) AND (D100<>last_id0) AND (NOT X30) THEN
        last_id0 := D100;
        pending_status0 := 1;
        IF D101 = 1 THEN
            own_station0 := 1; axis_is_c0 := TRUE;
        ELSE
            own_station0 := 2; axis_is_c0 := FALSE;
        END_IF;
        req_state0 := 1;
        settle0 := 0;
    END_IF;

1:
    IF axis_is_c0 THEN
        c_target_v := LIMIT(D1012-8000, LIFT_DOCK, D1012+8000);
        IF (ABS(D1008-c_target_v)<=POS_TOL) AND (ABS(D1009)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    ELSE
        d_target_v := LIMIT(D1008-8000, LIFT_DOCK, D1008+8000);
        IF (ABS(D1012-d_target_v)<=POS_TOL) AND (ABS(D1013)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    END_IF;
    IF settle0>=30 THEN
        IF (shuttle_owner=-1) OR (shuttle_owner=0) THEN
            shuttle_owner := 0;
            seq := seq+1; D82:=seq; D80:=1; D81:=own_station0;
            b_target_v := FORK_CONNECT_V;
            req_state0 := 2; settle0:=0;
        END_IF;
    END_IF;

2:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        a_target_v := STATION3_X;
        req_state0 := 3; settle0:=0;
    END_IF;

3:
    IF (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        D80:=2; D81:=3;
        b_target_v := FORK_RELEASE_V;
        req_state0 := 4; settle0:=0;
    END_IF;

4:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        s3_0_target_v := LIMIT(-95000,D500,95000);
        s3_1_target_v := LIMIT(-95000,D501,95000);
        req_state0 := 5; settle0:=0;
    END_IF;

5:
    IF ABS(D1016-D1020) > 300 THEN
        s3_0_target_v := D1016;
        s3_1_target_v := D1020;
    END_IF;
    IF X70 THEN
        D80:=1; D81:=3; seq:=seq+1; D82:=seq;
        b_target_v := FORK_CONNECT_V;
        req_state0 := 6;
    END_IF;

6:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        a_target_v := STATION4_X;
        req_state0 := 7; settle0:=0;
    END_IF;

7:
    IF (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        D80:=2; D81:=4;
        b_target_v := FORK_RELEASE_V;
        req_state0 := 8; settle0:=0;
    END_IF;

8:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        s4_0_target_v := LIMIT(-5000,D600,5000);
        s4_1_target_v := LIMIT(-5000,D601,5000);
        s4_2_target_v := LIMIT(-45000,D602,45000);
        req_state0 := 9; settle0:=0;
    END_IF;

9:
    IF X75 AND (abs_moment<=1.0) THEN
        D80:=1; D81:=4; seq:=seq+1; D82:=seq;
        b_target_v := FORK_CONNECT_V;
        req_state0 := 10;
    END_IF;

10:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        IF own_station0=1 THEN a_target_v:=STATION1_X; ELSE a_target_v:=STATION2_X; END_IF;
        req_state0 := 11; settle0:=0;
    END_IF;

11:
    IF (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        D80:=2; D81:=own_station0;
        b_target_v := FORK_RELEASE_V;
        req_state0 := 12; settle0:=0;
    END_IF;

12:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    IF settle0>=30 THEN
        IF shuttle_owner=0 THEN shuttle_owner:=-1; END_IF;
        req_state0 := 14; settle0:=0;
    END_IF;

13:
    req_state0 := 14;

14:
    IF axis_is_c0 THEN
        c_target_v := LIMIT(D1012-8000, LIFT_HOME, D1012+8000);
        IF (ABS(D1008-c_target_v)<=POS_TOL) AND (ABS(D1009)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    ELSE
        d_target_v := LIMIT(D1008-8000, LIFT_HOME, D1008+8000);
        IF (ABS(D1012-d_target_v)<=POS_TOL) AND (ABS(D1013)<=VEL_TOL) THEN settle0:=settle0+20; ELSE settle0:=0; END_IF;
    END_IF;
    IF settle0>=30 THEN
        req_state0 := 15; settle0:=0;
    END_IF;

15:
    D300 := last_id0; D301 := pending_status0;
    req_state0 := 0;

51:
    b_target_v := FORK_CONNECT_V;
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN
        IF own_station0=1 THEN a_target_v:=STATION1_X; ELSE a_target_v:=STATION2_X; END_IF;
        IF (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL) THEN
            settle0 := settle0+20;
        ELSE
            settle0 := 0;
        END_IF;
    ELSE
        settle0 := 0;
    END_IF;
    IF settle0>=30 THEN
        D80:=2; D81:=own_station0;
        b_target_v := FORK_RELEASE_V;
        req_state0 := 12; settle0:=0;
    END_IF;

ELSE
    req_state0 := 0;
END_CASE;

(* ================= REQUEST 1 ================= *)

IF (X35) AND (req_state1>=1) AND (req_state1<=11) THEN
    pending_status1 := 2;
    IF req_state1 = 1 THEN
        req_state1 := 14;
    ELSE
        req_state1 := 51;
    END_IF;
END_IF;

CASE req_state1 OF

0:
    IF (D120<>0) AND (D120<>last_id1) AND (NOT X34) THEN
        last_id1 := D120;
        pending_status1 := 1;
        IF D121 = 1 THEN
            own_station1 := 1; axis_is_c1 := TRUE;
        ELSE
            own_station1 := 2; axis_is_c1 := FALSE;
        END_IF;
        req_state1 := 1;
        settle1 := 0;
    END_IF;

1:
    IF axis_is_c1 THEN
        c_target_v := LIMIT(D1012-8000, LIFT_DOCK, D1012+8000);
        IF (ABS(D1008-c_target_v)<=POS_TOL) AND (ABS(D1009)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    ELSE
        d_target_v := LIMIT(D1008-8000, LIFT_DOCK, D1008+8000);
        IF (ABS(D1012-d_target_v)<=POS_TOL) AND (ABS(D1013)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    END_IF;
    IF settle1>=30 THEN
        IF (shuttle_owner=-1) OR (shuttle_owner=1) THEN
            shuttle_owner := 1;
            seq := seq+1; D82:=seq; D80:=1; D81:=own_station1;
            b_target_v := FORK_CONNECT_V;
            req_state1 := 2; settle1:=0;
        END_IF;
    END_IF;

2:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        a_target_v := STATION3_X;
        req_state1 := 3; settle1:=0;
    END_IF;

3:
    IF (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        D80:=2; D81:=3;
        b_target_v := FORK_RELEASE_V;
        req_state1 := 4; settle1:=0;
    END_IF;

4:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        s3_0_target_v := LIMIT(-95000,D500,95000);
        s3_1_target_v := LIMIT(-95000,D501,95000);
        req_state1 := 5; settle1:=0;
    END_IF;

5:
    IF ABS(D1016-D1020) > 300 THEN
        s3_0_target_v := D1016;
        s3_1_target_v := D1020;
    END_IF;
    IF X70 THEN
        D80:=1; D81:=3; seq:=seq+1; D82:=seq;
        b_target_v := FORK_CONNECT_V;
        req_state1 := 6;
    END_IF;

6:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        a_target_v := STATION4_X;
        req_state1 := 7; settle1:=0;
    END_IF;

7:
    IF (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        D80:=2; D81:=4;
        b_target_v := FORK_RELEASE_V;
        req_state1 := 8; settle1:=0;
    END_IF;

8:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        s4_0_target_v := LIMIT(-5000,D600,5000);
        s4_1_target_v := LIMIT(-5000,D601,5000);
        s4_2_target_v := LIMIT(-45000,D602,45000);
        req_state1 := 9; settle1:=0;
    END_IF;

9:
    IF X75 AND (abs_moment<=1.0) THEN
        D80:=1; D81:=4; seq:=seq+1; D82:=seq;
        b_target_v := FORK_CONNECT_V;
        req_state1 := 10;
    END_IF;

10:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        IF own_station1=1 THEN a_target_v:=STATION1_X; ELSE a_target_v:=STATION2_X; END_IF;
        req_state1 := 11; settle1:=0;
    END_IF;

11:
    IF (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        D80:=2; D81:=own_station1;
        b_target_v := FORK_RELEASE_V;
        req_state1 := 12; settle1:=0;
    END_IF;

12:
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    IF settle1>=30 THEN
        IF shuttle_owner=1 THEN shuttle_owner:=-1; END_IF;
        req_state1 := 14; settle1:=0;
    END_IF;

13:
    req_state1 := 14;

14:
    IF axis_is_c1 THEN
        c_target_v := LIMIT(D1012-8000, LIFT_HOME, D1012+8000);
        IF (ABS(D1008-c_target_v)<=POS_TOL) AND (ABS(D1009)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    ELSE
        d_target_v := LIMIT(D1008-8000, LIFT_HOME, D1008+8000);
        IF (ABS(D1012-d_target_v)<=POS_TOL) AND (ABS(D1013)<=VEL_TOL) THEN settle1:=settle1+20; ELSE settle1:=0; END_IF;
    END_IF;
    IF settle1>=30 THEN
        req_state1 := 15; settle1:=0;
    END_IF;

15:
    D302 := last_id1; D303 := pending_status1;
    req_state1 := 0;

51:
    b_target_v := FORK_CONNECT_V;
    IF (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL) THEN
        IF own_station1=1 THEN a_target_v:=STATION1_X; ELSE a_target_v:=STATION2_X; END_IF;
        IF (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL) THEN
            settle1 := settle1+20;
        ELSE
            settle1 := 0;
        END_IF;
    ELSE
        settle1 := 0;
    END_IF;
    IF settle1>=30 THEN
        D80:=2; D81:=own_station1;
        b_target_v := FORK_RELEASE_V;
        req_state1 := 12; settle1:=0;
    END_IF;

ELSE
    req_state1 := 0;
END_CASE;

(* ================= SAFETY: BALANCE MOMENT ================= *)

theta_a_rad := REAL(D1024)/100.0 * pi_const/180.0;
theta_b_rad := REAL(D1028)/100.0 * pi_const/180.0;
cw_mm := REAL(D1032)/100.0;
moment_real := 20.0*9.81/1000.0*(225.0*(SIN(theta_a_rad)+SIN(theta_b_rad)) + cw_mm);
abs_moment := ABS(moment_real);

IF abs_moment > 25.0 THEN
    s4_0_target_v := D1024;
    s4_1_target_v := D1028;
    s4_2_target_v := D1032;
END_IF;

(* ================= FINAL HOMING / COMPLETION ================= *)

elapsed_ms := elapsed_ms + 20;

IF X51 THEN
    a_target_v := HOME_A;
    b_target_v := HOME_B;
    c_target_v := LIFT_HOME;
    d_target_v := LIFT_HOME;
    s3_0_target_v := HOME_S3;
    s3_1_target_v := HOME_S3;
    s4_0_target_v := HOME_S4A;
    s4_1_target_v := HOME_S4A;
    s4_2_target_v := HOME_S4C;

    home_ok := (ABS(D1000-a_target_v)<=POS_TOL) AND (ABS(D1001)<=VEL_TOL)
           AND (ABS(D1004-b_target_v)<=POS_TOL) AND (ABS(D1005)<=VEL_TOL)
           AND (ABS(D1008-c_target_v)<=POS_TOL) AND (ABS(D1009)<=VEL_TOL)
           AND (ABS(D1012-d_target_v)<=POS_TOL) AND (ABS(D1013)<=VEL_TOL)
           AND (ABS(D1016-s3_0_target_v)<=POS_TOL) AND (ABS(D1017)<=VEL_TOL)
           AND (ABS(D1020-s3_1_target_v)<=POS_TOL) AND (ABS(D1021)<=VEL_TOL)
           AND (ABS(D1024-s4_0_target_v)<=POS_TOL) AND (ABS(D1025)<=VEL_TOL)
           AND (ABS(D1028-s4_1_target_v)<=POS_TOL) AND (ABS(D1029)<=VEL_TOL)
           AND (ABS(D1032-s4_2_target_v)<=POS_TOL) AND (ABS(D1033)<=VEL_TOL);

    home_settle(IN:=home_ok, PT:=T#100ms);
    IF home_settle.Q THEN
        y2_latched := TRUE;
    END_IF;
ELSE
    home_settle(IN:=FALSE, PT:=T#100ms);
END_IF;

Y2 := y2_latched;

(* ================= BRAKE ================= *)

Y30 := (req_state0=0) AND (req_state1=0) AND (shuttle_owner=-1);

(* ================= ENABLES ================= *)

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;

(* ================= CELL CONFIG DEFAULTS ================= *)

Y70 := FALSE; Y71 := TRUE;
D700 := 0; D701 := 0; D702 := 1000;
Y75 := FALSE; Y76 := TRUE;
D710 := 0; D711 := 0; D712 := 1000;

(* ================= FINAL AXIS OUTPUTS ================= *)

D2000 := LIMIT(-450000, a_target_v, 1461300);
D2001 := 1000; D2002 := 0;

D2004 := LIMIT(0, b_target_v, 18000);
D2005 := 1000; D2006 := 0;

D2008 := LIMIT(0, c_target_v, 120000);
D2009 := 1000; D2010 := 0;

D2012 := LIMIT(0, d_target_v, 120000);
D2013 := 1000; D2014 := 0;

D2016 := LIMIT(-95000, s3_0_target_v, 95000);
D2017 := 1000; D2018 := 0;

D2020 := LIMIT(-95000, s3_1_target_v, 95000);
D2021 := 1000; D2022 := 0;

D2024 := LIMIT(-5000, s4_0_target_v, 5000);
D2025 := 1000; D2026 := 0;

D2028 := LIMIT(-5000, s4_1_target_v, 5000);
D2029 := 1000; D2030 := 0;

D2032 := LIMIT(-45000, s4_2_target_v, 45000);
D2033 := 1000; D2034 := 0;

END_PROGRAM