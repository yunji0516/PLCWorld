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

    (* ---- internal ---- *)
    POS_TOL_L : DINT := 20;
    VEL_TOL_L : DINT := 100;
    POS_TOL_A : DINT := 20;
    VEL_TOL_A : DINT := 100;
    SWAY_POS_TOL : DINT := 3;
    SWAY_VEL_TOL : DINT := 15;

    ORIGIN1_X : DINT := -360000;
    ORIGIN2_X : DINT := -230000;
    CELL3_X   : DINT := 230000;
    CELL4_X   : DINT := 990000;
    FORK_RETR : DINT := 0;
    FORK_CONN : DINT := 18000;
    LIFT_HOME : DINT := 15000;
    S3_0_HOME : DINT := 0;
    S3_1_HOME : DINT := 0;
    S4_0_HOME : DINT := 100000;
    S4_1_HOME : DINT := 0;
    A_HOME    : DINT := 0;

    A_MIN : DINT := -450000; A_MAX : DINT := 1130000;
    B_MIN : DINT := 0;       B_MAX : DINT := 18000;
    CD_MIN: DINT := 0;       CD_MAX: DINT := 120000;
    S3_0_MIN: DINT := -5000; S3_0_MAX: DINT := 5000;
    S3_1_MIN: DINT := -45000;S3_1_MAX: DINT := 45000;
    S4_0_MIN: DINT := 50000; S4_0_MAX: DINT := 150000;
    S4_1_MIN: DINT := -100000;S4_1_MAX: DINT := 100000;

    PI_CONST : REAL := 3.14159265358979;

    st0 : DINT := 0;
    st1 : DINT := 0;
    last_id0 : DINT := -1;
    last_id1 : DINT := -1;
    result_status0 : DINT := 1;
    result_status1 : DINT := 1;
    skip_cell4_0 : BOOL := FALSE;
    skip_cell4_1 : BOOL := FALSE;

    r0_a_tgt : DINT;
    r0_b_tgt : DINT;
    r1_a_tgt : DINT;
    r1_b_tgt : DINT;
    r0_lift_tgt : DINT := 15000;
    r1_lift_tgt : DINT := 15000;

    shuttle_owner : DINT := 0;
    couple_seq : DINT := 0;

    a_cmd : DINT;
    b_cmd : DINT;
    s3_0_cmd : DINT;
    s4_0_cmd : DINT;
    s4_1_cmd : DINT;

    theta_rad : REAL;
    x_bal : REAL;
    s3_1_target_raw : DINT;

    parked : BOOL;
    lift_speed_ok : BOOL;
    gen_enable : BOOL := TRUE;
    c_enable : BOOL;
    d_enable : BOOL;
    y2_latch : BOOL := FALSE;
    cond_all : BOOL;

    compl_hold : TON;
END_VAR

(* ---------- reset pulse outputs ---------- *)
D80 := 0;
D81 := 0;

(* ---------- Request 0 (lift A / axis c / origin station 1) ---------- *)
IF X31 AND st0 >= 2 AND st0 <= 21 THEN
    result_status0 := 2;
END_IF;

CASE st0 OF
0:
    r0_lift_tgt := D92;
    IF (D100 <> last_id0) AND (D100 <> 0) THEN
        IF (ABS(D1008 - D92) <= POS_TOL_L) AND (shuttle_owner = 0) THEN
            last_id0 := D100;
            result_status0 := 1;
            skip_cell4_0 := FALSE;
            shuttle_owner := 1;
            st0 := 2;
        END_IF;
    END_IF;

2:
    r0_a_tgt := ORIGIN1_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1000 - ORIGIN1_X) <= POS_TOL_L AND ABS(D1001) <= VEL_TOL_L
       AND ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 3;
    END_IF;

3:
    r0_a_tgt := ORIGIN1_X;
    r0_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 4;
    END_IF;

4:
    couple_seq := couple_seq + 1;
    D80 := 1; D81 := 1; D82 := couple_seq;
    st0 := 5;

5:
    r0_a_tgt := ORIGIN1_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 6;
    END_IF;

6:
    r0_a_tgt := CELL3_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1000 - CELL3_X) <= POS_TOL_L AND ABS(D1001) <= VEL_TOL_L THEN
        st0 := 7;
    END_IF;

7:
    r0_a_tgt := CELL3_X;
    r0_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 8;
    END_IF;

8:
    couple_seq := couple_seq + 1;
    D80 := 2; D81 := 3; D82 := couple_seq;
    st0 := 9;

9:
    r0_a_tgt := CELL3_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 10;
    END_IF;

10:
    IF X70 OR result_status0 = 2 THEN
        IF result_status0 = 2 THEN
            skip_cell4_0 := TRUE;
        END_IF;
        st0 := 11;
    END_IF;

11:
    r0_a_tgt := CELL3_X;
    r0_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 12;
    END_IF;

12:
    couple_seq := couple_seq + 1;
    D80 := 1; D81 := 3; D82 := couple_seq;
    st0 := 13;

13:
    r0_a_tgt := CELL3_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        IF skip_cell4_0 THEN
            st0 := 22;
        ELSE
            st0 := 14;
        END_IF;
    END_IF;

14:
    r0_a_tgt := CELL4_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1000 - CELL4_X) <= POS_TOL_L AND ABS(D1001) <= VEL_TOL_L THEN
        st0 := 15;
    END_IF;

15:
    r0_a_tgt := CELL4_X;
    r0_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 16;
    END_IF;

16:
    couple_seq := couple_seq + 1;
    D80 := 2; D81 := 4; D82 := couple_seq;
    st0 := 17;

17:
    r0_a_tgt := CELL4_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 18;
    END_IF;

18:
    IF X75 OR result_status0 = 2 THEN
        st0 := 19;
    END_IF;

19:
    r0_a_tgt := CELL4_X;
    r0_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 20;
    END_IF;

20:
    couple_seq := couple_seq + 1;
    D80 := 1; D81 := 4; D82 := couple_seq;
    st0 := 21;

21:
    r0_a_tgt := CELL4_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 22;
    END_IF;

22:
    r0_a_tgt := ORIGIN1_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1000 - ORIGIN1_X) <= POS_TOL_L AND ABS(D1001) <= VEL_TOL_L THEN
        st0 := 23;
    END_IF;

23:
    r0_a_tgt := ORIGIN1_X;
    r0_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st0 := 24;
    END_IF;

24:
    couple_seq := couple_seq + 1;
    D80 := 2; D81 := 1; D82 := couple_seq;
    st0 := 25;

25:
    r0_a_tgt := ORIGIN1_X;
    r0_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        shuttle_owner := 0;
        st0 := 26;
    END_IF;

26:
    r0_lift_tgt := LIFT_HOME;
    IF ABS(D1008 - LIFT_HOME) <= POS_TOL_L AND ABS(D1009) <= VEL_TOL_L THEN
        st0 := 27;
    END_IF;

27:
    D300 := last_id0;
    D301 := result_status0;
    st0 := 0;

ELSE
    st0 := 0;
END_CASE;

(* ---------- Request 1 (lift B / axis d / origin station 2) ---------- *)
IF X35 AND st1 >= 2 AND st1 <= 21 THEN
    result_status1 := 2;
END_IF;

CASE st1 OF
0:
    r1_lift_tgt := D92;
    IF (D120 <> last_id1) AND (D120 <> 0) THEN
        IF (ABS(D1012 - D92) <= POS_TOL_L) AND (shuttle_owner = 0) THEN
            last_id1 := D120;
            result_status1 := 1;
            skip_cell4_1 := FALSE;
            shuttle_owner := 2;
            st1 := 2;
        END_IF;
    END_IF;

2:
    r1_a_tgt := ORIGIN2_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1000 - ORIGIN2_X) <= POS_TOL_L AND ABS(D1001) <= VEL_TOL_L
       AND ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 3;
    END_IF;

3:
    r1_a_tgt := ORIGIN2_X;
    r1_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 4;
    END_IF;

4:
    couple_seq := couple_seq + 1;
    D80 := 1; D81 := 2; D82 := couple_seq;
    st1 := 5;

5:
    r1_a_tgt := ORIGIN2_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 6;
    END_IF;

6:
    r1_a_tgt := CELL3_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1000 - CELL3_X) <= POS_TOL_L AND ABS(D1001) <= VEL_TOL_L THEN
        st1 := 7;
    END_IF;

7:
    r1_a_tgt := CELL3_X;
    r1_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 8;
    END_IF;

8:
    couple_seq := couple_seq + 1;
    D80 := 2; D81 := 3; D82 := couple_seq;
    st1 := 9;

9:
    r1_a_tgt := CELL3_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 10;
    END_IF;

10:
    IF X70 OR result_status1 = 2 THEN
        IF result_status1 = 2 THEN
            skip_cell4_1 := TRUE;
        END_IF;
        st1 := 11;
    END_IF;

11:
    r1_a_tgt := CELL3_X;
    r1_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 12;
    END_IF;

12:
    couple_seq := couple_seq + 1;
    D80 := 1; D81 := 3; D82 := couple_seq;
    st1 := 13;

13:
    r1_a_tgt := CELL3_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        IF skip_cell4_1 THEN
            st1 := 22;
        ELSE
            st1 := 14;
        END_IF;
    END_IF;

14:
    r1_a_tgt := CELL4_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1000 - CELL4_X) <= POS_TOL_L AND ABS(D1001) <= VEL_TOL_L THEN
        st1 := 15;
    END_IF;

15:
    r1_a_tgt := CELL4_X;
    r1_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 16;
    END_IF;

16:
    couple_seq := couple_seq + 1;
    D80 := 2; D81 := 4; D82 := couple_seq;
    st1 := 17;

17:
    r1_a_tgt := CELL4_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 18;
    END_IF;

18:
    IF X75 OR result_status1 = 2 THEN
        st1 := 19;
    END_IF;

19:
    r1_a_tgt := CELL4_X;
    r1_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 20;
    END_IF;

20:
    couple_seq := couple_seq + 1;
    D80 := 1; D81 := 4; D82 := couple_seq;
    st1 := 21;

21:
    r1_a_tgt := CELL4_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 22;
    END_IF;

22:
    r1_a_tgt := ORIGIN2_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1000 - ORIGIN2_X) <= POS_TOL_L AND ABS(D1001) <= VEL_TOL_L THEN
        st1 := 23;
    END_IF;

23:
    r1_a_tgt := ORIGIN2_X;
    r1_b_tgt := FORK_CONN;
    IF ABS(D1004 - FORK_CONN) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        st1 := 24;
    END_IF;

24:
    couple_seq := couple_seq + 1;
    D80 := 2; D81 := 2; D82 := couple_seq;
    st1 := 25;

25:
    r1_a_tgt := ORIGIN2_X;
    r1_b_tgt := FORK_RETR;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL_L AND ABS(D1005) <= VEL_TOL_L THEN
        shuttle_owner := 0;
        st1 := 26;
    END_IF;

26:
    r1_lift_tgt := LIFT_HOME;
    IF ABS(D1012 - LIFT_HOME) <= POS_TOL_L AND ABS(D1013) <= VEL_TOL_L THEN
        st1 := 27;
    END_IF;

27:
    D302 := last_id1;
    D303 := result_status1;
    st1 := 0;

ELSE
    st1 := 0;
END_CASE;

(* ---------- Shared shuttle / fork command arbitration ---------- *)
IF shuttle_owner = 1 THEN
    a_cmd := r0_a_tgt;
    b_cmd := r0_b_tgt;
ELSIF shuttle_owner = 2 THEN
    a_cmd := r1_a_tgt;
    b_cmd := r1_b_tgt;
ELSE
    a_cmd := A_HOME;
    b_cmd := FORK_RETR;
END_IF;

(* ---------- Cell 3 balance / interlocking drive ---------- *)
theta_rad := (REAL(D1016) / 100.0) * (PI_CONST / 180.0);
x_bal := -450.0 * SIN(theta_rad);
s3_1_target_raw := DINT(ROUND(x_bal * 100.0));

s3_0_cmd := S3_0_HOME;
IF (st0 >= 9 AND st0 <= 12) OR (st1 >= 9 AND st1 <= 12) THEN
    s3_0_cmd := D500;
END_IF;

D701 := D526;
IF (st0 = 8) OR (st1 = 8) THEN
    Y70 := TRUE;
ELSE
    Y70 := FALSE;
END_IF;
IF (st0 >= 8 AND st0 <= 12) OR (st1 >= 8 AND st1 <= 12) THEN
    Y71 := TRUE;
    D702 := 50;
    IF (st0 >= 8 AND st0 <= 12) THEN
        D700 := D100;
    ELSE
        D700 := D120;
    END_IF;
ELSE
    Y71 := FALSE;
    D702 := 0;
END_IF;

(* ---------- Cell 4 hoist targets ---------- *)
s4_0_cmd := S4_0_HOME;
s4_1_cmd := S4_1_HOME;
IF (st0 >= 17 AND st0 <= 20) OR (st1 >= 17 AND st1 <= 20) THEN
    s4_0_cmd := D600;
    s4_1_cmd := D601;
END_IF;

D711 := D626;
IF (st0 = 16) OR (st1 = 16) THEN
    Y75 := TRUE;
ELSE
    Y75 := FALSE;
END_IF;
IF (st0 >= 16 AND st0 <= 20) OR (st1 >= 16 AND st1 <= 20) THEN
    Y76 := TRUE;
    D712 := 100;
    IF (st0 >= 16 AND st0 <= 20) THEN
        D710 := D100;
    ELSE
        D710 := D120;
    END_IF;
ELSE
    Y76 := FALSE;
    D712 := 0;
END_IF;

(* ---------- Parked / brake / safety ---------- *)
parked := (ABS(D1000 - A_HOME) <= POS_TOL_L) AND (ABS(D1001) <= VEL_TOL_L)
      AND (ABS(D1004 - FORK_RETR) <= POS_TOL_L) AND (ABS(D1005) <= VEL_TOL_L)
      AND (ABS(D1008 - LIFT_HOME) <= POS_TOL_L) AND (ABS(D1009) <= VEL_TOL_L)
      AND (ABS(D1012 - LIFT_HOME) <= POS_TOL_L) AND (ABS(D1013) <= VEL_TOL_L)
      AND (ABS(D1016 - S3_0_HOME) <= POS_TOL_A) AND (ABS(D1017) <= VEL_TOL_A)
      AND (ABS(D1020 - S3_1_HOME) <= POS_TOL_L) AND (ABS(D1021) <= VEL_TOL_L)
      AND (ABS(D1024 - S4_0_HOME) <= POS_TOL_L) AND (ABS(D1025) <= VEL_TOL_L)
      AND (ABS(D1028 - S4_1_HOME) <= POS_TOL_L) AND (ABS(D1029) <= VEL_TOL_L)
      AND (ABS(D1032) <= SWAY_POS_TOL) AND (ABS(D1033) <= SWAY_VEL_TOL);

lift_speed_ok := (ABS(D1009) <= VEL_TOL_L) AND (ABS(D1013) <= VEL_TOL_L);

Y30 := parked AND lift_speed_ok;
c_enable := NOT Y30;
d_enable := NOT Y30;

gen_enable := NOT y2_latch;

cond_all := parked AND X51 AND (st0 = 0) AND (st1 = 0);
compl_hold(IN := cond_all, PT := T#100ms);
IF compl_hold.Q THEN
    y2_latch := TRUE;
END_IF;
Y2 := y2_latch;

(* ---------- Output writes with range clipping ---------- *)
D2000 := LIMIT(A_MIN, a_cmd, A_MAX);
D2001 := 700;
D2002 := 0;
Y40 := gen_enable;

D2004 := LIMIT(B_MIN, b_cmd, B_MAX);
D2005 := 700;
D2006 := 0;
Y41 := gen_enable;

D2008 := LIMIT(CD_MIN, r0_lift_tgt, CD_MAX);
D2009 := 700;
D2010 := 0;
Y42 := c_enable;

D2012 := LIMIT(CD_MIN, r1_lift_tgt, CD_MAX);
D2013 := 700;
D2014 := 0;
Y43 := d_enable;

D2016 := LIMIT(S3_0_MIN, s3_0_cmd, S3_0_MAX);
D2017 := 700;
D2018 := 0;
Y44 := gen_enable;

D2020 := LIMIT(S3_1_MIN, s3_1_target_raw, S3_1_MAX);
D2021 := 700;
D2022 := 0;
Y45 := gen_enable;

D2024 := LIMIT(S4_0_MIN, s4_0_cmd, S4_0_MAX);
D2025 := 700;
D2026 := 0;
Y46 := gen_enable;

D2028 := LIMIT(S4_1_MIN, s4_1_cmd, S4_1_MAX);
D2029 := 700;
D2030 := 0;
Y47 := gen_enable;

D2032 := D1032;
D2033 := 0;
D2034 := 0;
Y48 := FALSE;

END_PROGRAM