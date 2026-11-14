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

    (* internal *)
    POS_TOL : DINT := 20;
    VEL_TOL : DINT := 100;

    HOME_A   : DINT := 0;
    HOME_B   : DINT := 0;
    HOME_C   : DINT := 15000;
    HOME_D   : DINT := 15000;
    HOME_S3_0: DINT := 0;
    HOME_S3_1: DINT := 0;
    HOME_S3_2: DINT := 0;
    HOME_S4_0: DINT := 0;
    HOME_S4_1: DINT := 5000;
    FORK_CONN: DINT := 18000;
    FORK_RETR: DINT := 0;

    A_MIN : DINT := -450000;  A_MAX : DINT := 1461300;
    B_MIN : DINT := 0;        B_MAX : DINT := 18000;
    C_MIN : DINT := 0;        C_MAX : DINT := 120000;
    D_MIN : DINT := 0;        D_MAX : DINT := 120000;
    S3_MIN: DINT := 0;        S3_MAX: DINT := 100000;
    S4_0_MIN: DINT := 0;      S4_0_MAX: DINT := 27000;
    S4_1_MIN: DINT := 0;      S4_1_MAX: DINT := 74000;

    phase       : INT := 0;
    prev_phase  : INT := -1;
    active_req  : INT := 0;
    r0_done     : BOOL := FALSE;
    r1_done     : BOOL := FALSE;
    seq_counter : DINT := 0;

    cur_id       : DINT;
    cur_loc      : DINT;
    cur_cancel   : BOOL;
    cur_use_c    : BOOL;
    lift_port_x  : DINT;
    lift_port_rdy: BOOL;
    cell3_port_x : DINT;
    cell4_port_x : DINT;
    station_num  : DINT;

    sel3_is0     : BOOL;
    sel3_target  : DINT;

    final_phase_done : BOOL := FALSE;
    y2_latched       : BOOL := FALSE;
END_VAR

(* ---------- default hold: keep all axes at current feedback, disabled ---------- *)
D2000 := D1000; D2001 := 0; D2002 := 0; Y40 := FALSE;
D2004 := D1004; D2005 := 0; D2006 := 0; Y41 := FALSE;
D2008 := D1008; D2009 := 0; D2010 := 0; Y42 := FALSE;
D2012 := D1012; D2013 := 0; D2014 := 0; Y43 := FALSE;
D2016 := D1016; D2017 := 0; D2018 := 0; Y44 := FALSE;
D2020 := D1020; D2021 := 0; D2022 := 0; Y45 := FALSE;
D2024 := D1024; D2025 := 0; D2026 := 0; Y46 := FALSE;
D2028 := D1028; D2029 := 0; D2030 := 0; Y47 := FALSE;
D2032 := D1032; D2033 := 0; D2034 := 0; Y48 := FALSE;
Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;

CASE phase OF

0: (* IDLE / dispatch *)
    IF NOT r0_done AND D100 <> 0 THEN
        active_req := 0;
        phase := 1;
    ELSIF NOT r1_done AND D120 <> 0 THEN
        active_req := 1;
        phase := 1;
    ELSIF r0_done AND r1_done AND NOT final_phase_done THEN
        phase := 100;
    END_IF

1: (* SETUP *)
    IF active_req = 0 THEN
        cur_id := D100; cur_loc := D101; cur_cancel := X31;
    ELSE
        cur_id := D120; cur_loc := D121; cur_cancel := X35;
    END_IF
    cur_use_c := (cur_loc = 1);
    IF cur_use_c THEN
        lift_port_x := D403; lift_port_rdy := X61; station_num := 1;
    ELSE
        lift_port_x := D406; lift_port_rdy := X62; station_num := 2;
    END_IF
    cell3_port_x := D409;
    cell4_port_x := D412;
    phase := 2;

2: (* LIFT_PREP *)
    IF cur_use_c THEN
        D2008 := LIMIT(C_MIN, D92, C_MAX); D2009 := 1000; Y42 := TRUE;
        IF ABS(D1008 - D92) <= POS_TOL AND ABS(D1009) <= VEL_TOL THEN
            phase := 3;
        END_IF
    ELSE
        D2012 := LIMIT(D_MIN, D92, D_MAX); D2013 := 1000; Y43 := TRUE;
        IF ABS(D1012 - D92) <= POS_TOL AND ABS(D1013) <= VEL_TOL THEN
            phase := 3;
        END_IF
    END_IF

3: (* SHUTTLE_TO_LIFT *)
    D2004 := LIMIT(B_MIN, FORK_RETR, B_MAX); D2005 := 1000; Y41 := TRUE;
    D2000 := LIMIT(A_MIN, lift_port_x, A_MAX); D2001 := 1000; Y40 := TRUE;
    IF cur_use_c THEN
        D2008 := LIMIT(C_MIN, D92, C_MAX); D2009 := 1000; Y42 := TRUE;
    ELSE
        D2012 := LIMIT(D_MIN, D92, D_MAX); D2013 := 1000; Y43 := TRUE;
    END_IF
    IF ABS(D1000 - lift_port_x) <= POS_TOL AND ABS(D1001) <= VEL_TOL
       AND ABS(D1004 - FORK_RETR) <= POS_TOL AND ABS(D1005) <= VEL_TOL
       AND lift_port_rdy THEN
        phase := 4;
    END_IF

4: (* FORK_CONNECT - extract jig from lift onto shuttle *)
    D2004 := LIMIT(B_MIN, FORK_CONN, B_MAX); D2005 := 1000; Y41 := TRUE;
    IF cur_use_c THEN
        D2008 := LIMIT(C_MIN, D92, C_MAX); D2009 := 1000; Y42 := TRUE;
    ELSE
        D2012 := LIMIT(D_MIN, D92, D_MAX); D2013 := 1000; Y43 := TRUE;
    END_IF
    IF phase <> prev_phase THEN
        seq_counter := seq_counter + 1; D82 := seq_counter; D80 := 1; D81 := station_num;
    END_IF
    IF ABS(D1004 - FORK_CONN) <= POS_TOL AND ABS(D1005) <= VEL_TOL AND lift_port_rdy THEN
        phase := 6;
    END_IF

6: (* FORK_RETREAT *)
    D2004 := LIMIT(B_MIN, FORK_RETR, B_MAX); D2005 := 1000; Y41 := TRUE;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL AND ABS(D1005) <= VEL_TOL THEN
        IF cur_cancel THEN
            phase := 18;
        ELSE
            phase := 7;
        END_IF
    END_IF

7: (* SHUTTLE_TO_CELL3 *)
    sel3_is0 := (D520 = 0);
    IF sel3_is0 THEN sel3_target := D500; ELSE sel3_target := D501; END_IF
    D2000 := LIMIT(A_MIN, cell3_port_x, A_MAX); D2001 := 1000; Y40 := TRUE;
    D2004 := LIMIT(B_MIN, FORK_RETR, B_MAX); D2005 := 1000; Y41 := TRUE;
    IF ABS(D1000 - cell3_port_x) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND X63 THEN
        phase := 8;
    END_IF

8: (* CELL3_APPROACH - single selected axis *)
    IF sel3_is0 THEN
        D2016 := LIMIT(S3_MIN, sel3_target, S3_MAX); D2017 := 1000; Y44 := TRUE;
    ELSE
        D2020 := LIMIT(S3_MIN, sel3_target, S3_MAX); D2021 := 1000; Y45 := TRUE;
    END_IF
    Y70 := TRUE; Y71 := TRUE;
    IF phase <> prev_phase THEN
        D700 := station_num; D701 := D526; D702 := 500;
        seq_counter := seq_counter + 1; D82 := seq_counter; D80 := 2; D81 := 3;
    END_IF
    IF sel3_is0 THEN
        IF ABS(D1016 - sel3_target) <= POS_TOL AND ABS(D1017) <= VEL_TOL THEN
            phase := 9;
        END_IF
    ELSE
        IF ABS(D1020 - sel3_target) <= POS_TOL AND ABS(D1021) <= VEL_TOL THEN
            phase := 9;
        END_IF
    END_IF

9: (* CELL3_WAIT_RESULT *)
    IF sel3_is0 THEN
        D2016 := LIMIT(S3_MIN, sel3_target, S3_MAX); D2017 := 1000; Y44 := TRUE;
    ELSE
        D2020 := LIMIT(S3_MIN, sel3_target, S3_MAX); D2021 := 1000; Y45 := TRUE;
    END_IF
    Y70 := TRUE; Y71 := TRUE;
    IF X70 THEN
        phase := 10;
    END_IF

10: (* CELL3_RETREAT *)
    IF sel3_is0 THEN
        D2016 := LIMIT(S3_MIN, HOME_S3_0, S3_MAX); D2017 := 1000; Y44 := TRUE;
    ELSE
        D2020 := LIMIT(S3_MIN, HOME_S3_1, S3_MAX); D2021 := 1000; Y45 := TRUE;
    END_IF
    IF phase <> prev_phase THEN
        seq_counter := seq_counter + 1; D82 := seq_counter; D80 := 1; D81 := 3;
    END_IF
    IF sel3_is0 THEN
        IF ABS(D1016 - HOME_S3_0) <= POS_TOL AND ABS(D1017) <= VEL_TOL THEN
            Y70 := FALSE; Y71 := FALSE; phase := 12;
        END_IF
    ELSE
        IF ABS(D1020 - HOME_S3_1) <= POS_TOL AND ABS(D1021) <= VEL_TOL THEN
            Y70 := FALSE; Y71 := FALSE; phase := 12;
        END_IF
    END_IF

12: (* SHUTTLE_TO_CELL4 *)
    D2000 := LIMIT(A_MIN, cell4_port_x, A_MAX); D2001 := 1000; Y40 := TRUE;
    D2004 := LIMIT(B_MIN, FORK_RETR, B_MAX); D2005 := 1000; Y41 := TRUE;
    IF ABS(D1000 - cell4_port_x) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND X64 THEN
        phase := 13;
    END_IF

13: (* CELL4_ROTATE - slide stays at home ( <=500mm ) *)
    D2028 := LIMIT(S4_0_MIN, D600, S4_0_MAX); D2029 := 1000; Y47 := TRUE;
    D2032 := LIMIT(S4_1_MIN, HOME_S4_1, S4_1_MAX); D2033 := 1000; Y48 := TRUE;
    Y75 := TRUE; Y76 := TRUE;
    IF phase <> prev_phase THEN
        D710 := station_num; D711 := D626; D712 := 500;
        seq_counter := seq_counter + 1; D82 := seq_counter; D80 := 2; D81 := 4;
    END_IF
    IF ABS(D1028 - D600) <= POS_TOL AND ABS(D1029) <= VEL_TOL
       AND ABS(D1032 - HOME_S4_1) <= POS_TOL AND ABS(D1033) <= VEL_TOL THEN
        phase := 14;
    END_IF

14: (* CELL4_APPROACH - slide out to 700mm target *)
    D2028 := LIMIT(S4_0_MIN, D600, S4_0_MAX); D2029 := 1000; Y47 := TRUE;
    D2032 := LIMIT(S4_1_MIN, D601, S4_1_MAX); D2033 := 1000; Y48 := TRUE;
    Y75 := TRUE; Y76 := TRUE;
    IF ABS(D1032 - D601) <= POS_TOL AND ABS(D1033) <= VEL_TOL THEN
        phase := 15;
    END_IF

15: (* CELL4_WAIT_RESULT *)
    D2028 := LIMIT(S4_0_MIN, D600, S4_0_MAX); D2029 := 1000; Y47 := TRUE;
    D2032 := LIMIT(S4_1_MIN, D601, S4_1_MAX); D2033 := 1000; Y48 := TRUE;
    Y75 := TRUE; Y76 := TRUE;
    IF X75 THEN
        phase := 16;
    END_IF

16: (* CELL4_RETREAT_SLIDE *)
    D2032 := LIMIT(S4_1_MIN, HOME_S4_1, S4_1_MAX); D2033 := 1000; Y48 := TRUE;
    IF phase <> prev_phase THEN
        seq_counter := seq_counter + 1; D82 := seq_counter; D80 := 1; D81 := 4;
    END_IF
    IF ABS(D1032 - HOME_S4_1) <= POS_TOL AND ABS(D1033) <= VEL_TOL THEN
        Y75 := FALSE; Y76 := FALSE;
        phase := 17;
    END_IF

17: (* CELL4_RETREAT_ROT *)
    D2028 := LIMIT(S4_0_MIN, HOME_S4_0, S4_0_MAX); D2029 := 1000; Y47 := TRUE;
    IF ABS(D1028 - HOME_S4_0) <= POS_TOL AND ABS(D1029) <= VEL_TOL THEN
        phase := 18;
    END_IF

18: (* SHUTTLE_TO_LIFT_RETURN *)
    D2000 := LIMIT(A_MIN, lift_port_x, A_MAX); D2001 := 1000; Y40 := TRUE;
    D2004 := LIMIT(B_MIN, FORK_RETR, B_MAX); D2005 := 1000; Y41 := TRUE;
    IF cur_use_c THEN
        D2008 := LIMIT(C_MIN, D92, C_MAX); D2009 := 1000; Y42 := TRUE;
    ELSE
        D2012 := LIMIT(D_MIN, D92, D_MAX); D2013 := 1000; Y43 := TRUE;
    END_IF
    IF ABS(D1000 - lift_port_x) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND lift_port_rdy THEN
        phase := 19;
    END_IF

19: (* FORK_CONNECT_RETURN - place jig back into lift *)
    D2004 := LIMIT(B_MIN, FORK_CONN, B_MAX); D2005 := 1000; Y41 := TRUE;
    IF cur_use_c THEN
        D2008 := LIMIT(C_MIN, D92, C_MAX); D2009 := 1000; Y42 := TRUE;
    ELSE
        D2012 := LIMIT(D_MIN, D92, D_MAX); D2013 := 1000; Y43 := TRUE;
    END_IF
    IF phase <> prev_phase THEN
        seq_counter := seq_counter + 1; D82 := seq_counter; D80 := 2; D81 := station_num;
    END_IF
    IF ABS(D1004 - FORK_CONN) <= POS_TOL AND ABS(D1005) <= VEL_TOL AND lift_port_rdy THEN
        phase := 20;
    END_IF

20: (* FORK_RETREAT_RETURN *)
    D2004 := LIMIT(B_MIN, FORK_RETR, B_MAX); D2005 := 1000; Y41 := TRUE;
    IF ABS(D1004 - FORK_RETR) <= POS_TOL AND ABS(D1005) <= VEL_TOL THEN
        phase := 21;
    END_IF

21: (* LIFT_DESCEND to home *)
    IF cur_use_c THEN
        D2008 := LIMIT(C_MIN, HOME_C, C_MAX); D2009 := 1000; Y42 := TRUE;
        IF ABS(D1008 - HOME_C) <= POS_TOL AND ABS(D1009) <= VEL_TOL THEN
            IF active_req = 0 THEN
                IF X30 THEN phase := 22; END_IF
            ELSE
                IF X34 THEN phase := 22; END_IF
            END_IF
        END_IF
    ELSE
        D2012 := LIMIT(D_MIN, HOME_D, D_MAX); D2013 := 1000; Y43 := TRUE;
        IF ABS(D1012 - HOME_D) <= POS_TOL AND ABS(D1013) <= VEL_TOL THEN
            IF active_req = 0 THEN
                IF X30 THEN phase := 22; END_IF
            ELSE
                IF X34 THEN phase := 22; END_IF
            END_IF
        END_IF
    END_IF

22: (* ACK *)
    IF active_req = 0 THEN
        D300 := cur_id;
        IF cur_cancel THEN D301 := 2; ELSE D301 := 1; END_IF
        r0_done := TRUE;
    ELSE
        D302 := cur_id;
        IF cur_cancel THEN D303 := 2; ELSE D303 := 1; END_IF
        r1_done := TRUE;
    END_IF
    phase := 0;

100: (* FINAL_HOME - all axes to initial connection posture *)
    D2000 := LIMIT(A_MIN, HOME_A, A_MAX); D2001 := 1000; Y40 := TRUE;
    D2004 := LIMIT(B_MIN, HOME_B, B_MAX); D2005 := 1000; Y41 := TRUE;
    D2008 := LIMIT(C_MIN, HOME_C, C_MAX); D2009 := 1000; Y42 := TRUE;
    D2012 := LIMIT(D_MIN, HOME_D, D_MAX); D2013 := 1000; Y43 := TRUE;
    D2016 := LIMIT(S3_MIN, HOME_S3_0, S3_MAX); D2017 := 1000; Y44 := TRUE;
    D2020 := LIMIT(S3_MIN, HOME_S3_1, S3_MAX); D2021 := 1000; Y45 := TRUE;
    D2024 := LIMIT(S3_MIN, HOME_S3_2, S3_MAX); D2025 := 1000; Y46 := TRUE;
    D2028 := LIMIT(S4_0_MIN, HOME_S4_0, S4_0_MAX); D2029 := 1000; Y47 := TRUE;
    D2032 := LIMIT(S4_1_MIN, HOME_S4_1, S4_1_MAX); D2033 := 1000; Y48 := TRUE;
    IF ABS(D1000 - HOME_A) <= POS_TOL AND ABS(D1001) <= VEL_TOL
       AND ABS(D1004 - HOME_B) <= POS_TOL AND ABS(D1005) <= VEL_TOL
       AND ABS(D1008 - HOME_C) <= POS_TOL AND ABS(D1009) <= VEL_TOL
       AND ABS(D1012 - HOME_D) <= POS_TOL AND ABS(D1013) <= VEL_TOL
       AND ABS(D1016 - HOME_S3_0) <= POS_TOL AND ABS(D1017) <= VEL_TOL
       AND ABS(D1020 - HOME_S3_1) <= POS_TOL AND ABS(D1021) <= VEL_TOL
       AND ABS(D1024 - HOME_S3_2) <= POS_TOL AND ABS(D1025) <= VEL_TOL
       AND ABS(D1028 - HOME_S4_0) <= POS_TOL AND ABS(D1029) <= VEL_TOL
       AND ABS(D1032 - HOME_S4_1) <= POS_TOL AND ABS(D1033) <= VEL_TOL
       AND X51 THEN
        final_phase_done := TRUE;
        y2_latched := TRUE;
        phase := 101;
    END_IF

101: (* FINAL_HOLD - maintain home posture, completion asserted *)
    D2000 := LIMIT(A_MIN, HOME_A, A_MAX); D2001 := 0; Y40 := FALSE;
    D2004 := LIMIT(B_MIN, HOME_B, B_MAX); D2005 := 0; Y41 := FALSE;
    D2008 := LIMIT(C_MIN, HOME_C, C_MAX); D2009 := 0; Y42 := FALSE;
    D2012 := LIMIT(D_MIN, HOME_D, D_MAX); D2013 := 0; Y43 := FALSE;
    D2016 := LIMIT(S3_MIN, HOME_S3_0, S3_MAX); D2017 := 0; Y44 := FALSE;
    D2020 := LIMIT(S3_MIN, HOME_S3_1, S3_MAX); D2021 := 0; Y45 := FALSE;
    D2024 := LIMIT(S3_MIN, HOME_S3_2, S3_MAX); D2025 := 0; Y46 := FALSE;
    D2028 := LIMIT(S4_0_MIN, HOME_S4_0, S4_0_MAX); D2029 := 0; Y47 := FALSE;
    D2032 := LIMIT(S4_1_MIN, HOME_S4_1, S4_1_MAX); D2033 := 0; Y48 := FALSE;

ELSE
    phase := 0;

END_CASE

prev_phase := phase;

IF Y40 THEN
    Y30 := FALSE;
ELSE
    Y30 := TRUE;
END_IF

Y2 := y2_latched;

END_PROGRAM