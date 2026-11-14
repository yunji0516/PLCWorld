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

    (* internal state *)
    r0_state : INT := 0;
    r0_port  : DINT := 0;
    r0_cancel_flag : BOOL := FALSE;
    r0_move_timer : TON;

    r1_state : INT := 0;
    r1_port  : DINT := 0;
    r1_cancel_flag : BOOL := FALSE;
    r1_move_timer : TON;

    shuttle_owner : INT := 0;
    cell3_owner   : INT := 0;
    cell4_owner   : INT := 0;
    seq_num       : DINT := 0;

    DEG2RAD : REAL := 0.0174532925;
    thetaA_rad : REAL := 0.0;
    thetaB_rad : REAL := 0.0;
    xcw : REAL := 0.0;
    moment3 : REAL := 0.0;
    cell3_ok : BOOL := FALSE;
    cell4_ok : BOOL := FALSE;

    pocket_sel0 : DINT := 1;
    pocket_sel1 : DINT := 1;

    tA0 : REAL := 0.0;
    tB0 : REAL := 0.0;
    calc_x0 : REAL := 0.0;
    s3_2_tgt0 : DINT := 0;

    tA1 : REAL := 0.0;
    tB1 : REAL := 0.0;
    calc_x1 : REAL := 0.0;
    s3_2_tgt1 : DINT := 0;

    home_c : DINT := 40000;
    home_d : DINT := 40000;

    at_home : BOOL := FALSE;
    hold_timer : TON;
    y2_latched : BOOL := FALSE;
END_VAR

(* ---- Safety / balance monitoring ---- *)
thetaA_rad := INT_TO_REAL(D1016) * 0.01 * DEG2RAD;
thetaB_rad := INT_TO_REAL(D1020) * 0.01 * DEG2RAD;
xcw := INT_TO_REAL(D1024) * 0.01;
moment3 := 20.0 * 9.81 / 1000.0 * (225.0 * (SIN(thetaA_rad) + SIN(thetaB_rad)) + xcw);
cell3_ok := X70 AND (ABS(moment3) <= 1.0);
cell4_ok := X75;

Y30 := TRUE; (* default brake engaged; released during shuttle motion *)

(* ================= Request 0 ================= *)
IF X31 THEN
    r0_cancel_flag := TRUE;
END_IF;
IF r0_cancel_flag AND r0_state >= 1 AND r0_state <= 10 THEN
    r0_state := 11;
END_IF;

CASE r0_state OF

0:
    IF D100 <> 0 AND NOT r0_cancel_flag THEN
        r0_port := D101;
        r0_state := 1;
    END_IF;

1:
    IF (shuttle_owner = 0 OR shuttle_owner = 1) AND (cell3_owner = 0 OR cell3_owner = 1) THEN
        shuttle_owner := 1;
        cell3_owner := 1;
        seq_num := seq_num + 1;
        D82 := seq_num;
        D80 := 1;
        D81 := r0_port;
        r0_state := 2;
    END_IF;

2:
    D2004 := 0; D2005 := 300; D2006 := 0; Y41 := TRUE;
    IF r0_port = 1 THEN
        D2008 := D92; D2009 := 300; D2010 := 0; Y42 := TRUE;
    ELSIF r0_port = 2 THEN
        D2012 := D92; D2013 := 300; D2014 := 0; Y43 := TRUE;
    END_IF;
    D2000 := 0; D2001 := 300; D2002 := 0; Y40 := TRUE;
    Y30 := FALSE;
    r0_move_timer(IN := TRUE, PT := T#200ms);
    IF ABS(D1000 - 0) <= 20 AND ABS(D1001) <= 100 AND r0_move_timer.Q THEN
        Y30 := TRUE;
        r0_move_timer(IN := FALSE, PT := T#200ms);
        D80 := 2; D81 := 3;
        r0_state := 3;
    END_IF;

3:
    IF X63 THEN
        shuttle_owner := 0;
        r0_state := 4;
    END_IF;

4:
    tA0 := INT_TO_REAL(D500) * 0.01 * DEG2RAD;
    tB0 := INT_TO_REAL(D501) * 0.01 * DEG2RAD;
    IF D502 = 0 THEN
        calc_x0 := -225.0 * (SIN(tA0) + SIN(tB0));
        s3_2_tgt0 := DINT(ROUND(calc_x0 * 100.0));
    ELSE
        s3_2_tgt0 := D502;
    END_IF;
    D2016 := D500; D2017 := 300; D2018 := 0; Y44 := TRUE;
    D2020 := D501; D2021 := 300; D2022 := 0; Y45 := TRUE;
    D2024 := s3_2_tgt0; D2025 := 300; D2026 := 0; Y46 := TRUE;
    D700 := D520;
    D701 := D526;
    D702 := 300;
    Y70 := TRUE;
    r0_state := 5;

5:
    IF cell3_ok THEN
        Y70 := FALSE;
        Y71 := TRUE;
        r0_state := 6;
    END_IF;

6:
    Y71 := FALSE;
    IF (shuttle_owner = 0 OR shuttle_owner = 1) AND (cell4_owner = 0 OR cell4_owner = 1) THEN
        shuttle_owner := 1;
        cell4_owner := 1;
        cell3_owner := 0;
        seq_num := seq_num + 1;
        D82 := seq_num;
        D80 := 1; D81 := 3;
        r0_state := 7;
    END_IF;

7:
    D2000 := 375000; D2001 := 300; D2002 := 0; Y40 := TRUE;
    Y30 := FALSE;
    r0_move_timer(IN := TRUE, PT := T#200ms);
    IF ABS(D1000 - 375000) <= 20 AND ABS(D1001) <= 100 AND r0_move_timer.Q THEN
        Y30 := TRUE;
        r0_move_timer(IN := FALSE, PT := T#200ms);
        D80 := 2; D81 := 4;
        r0_state := 8;
    END_IF;

8:
    IF X64 THEN
        shuttle_owner := 0;
        r0_state := 9;
    END_IF;

9:
    pocket_sel0 := SEL(D104 < 0, 2, 1);
    D2028 := D600; D2029 := 300; D2030 := 0; Y47 := TRUE;
    D2032 := D601; D2033 := 300; D2034 := 0; Y48 := TRUE;
    D2036 := D602; D2037 := 300; D2038 := 0; Y49 := TRUE;
    D710 := pocket_sel0;
    D711 := D626;
    D712 := 300;
    Y75 := TRUE;
    r0_state := 10;

10:
    IF cell4_ok THEN
        Y75 := FALSE;
        Y76 := TRUE;
        r0_state := 11;
    END_IF;

11:
    Y76 := FALSE;
    IF (shuttle_owner = 0 OR shuttle_owner = 1) THEN
        shuttle_owner := 1;
        cell4_owner := 0;
        seq_num := seq_num + 1;
        D82 := seq_num;
        D80 := 1; D81 := 4;
        r0_state := 12;
    END_IF;

12:
    IF r0_port = 1 THEN
        D2000 := -405000;
    ELSE
        D2000 := -185000;
    END_IF;
    D2001 := 300; D2002 := 0; Y40 := TRUE;
    Y30 := FALSE;
    r0_move_timer(IN := TRUE, PT := T#200ms);
    IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 AND r0_move_timer.Q THEN
        Y30 := TRUE;
        r0_move_timer(IN := FALSE, PT := T#200ms);
        D80 := 2; D81 := r0_port;
        IF r0_port = 1 THEN
            D2008 := D92; D2009 := 300; Y42 := TRUE;
        ELSE
            D2012 := D92; D2013 := 300; Y43 := TRUE;
        END_IF;
        r0_state := 13;
    END_IF;

13:
    D2004 := 18000; D2005 := 300; Y41 := TRUE;
    IF (r0_port = 1 AND X61) OR (r0_port = 2 AND X62) THEN
        shuttle_owner := 0;
        D2004 := 0; D2005 := 300;
        r0_state := 14;
    END_IF;

14:
    IF r0_port = 1 THEN
        D2008 := home_c; D2009 := 300; Y42 := TRUE;
    ELSE
        D2012 := home_d; D2013 := 300; Y43 := TRUE;
    END_IF;
    IF X30 THEN
        r0_state := 15;
    END_IF;

15:
    D300 := D100;
    D301 := SEL(r0_cancel_flag, 1, 2);
    r0_state := 16;

16:
    ;

ELSE
    r0_state := 0;
END_CASE;

(* ================= Request 1 ================= *)
IF X35 THEN
    r1_cancel_flag := TRUE;
END_IF;
IF r1_cancel_flag AND r1_state >= 1 AND r1_state <= 10 THEN
    r1_state := 11;
END_IF;

CASE r1_state OF

0:
    IF D120 <> 0 AND NOT r1_cancel_flag THEN
        r1_port := D121;
        r1_state := 1;
    END_IF;

1:
    IF (shuttle_owner = 0 OR shuttle_owner = 2) AND (cell3_owner = 0 OR cell3_owner = 2) THEN
        shuttle_owner := 2;
        cell3_owner := 2;
        seq_num := seq_num + 1;
        D82 := seq_num;
        D80 := 1;
        D81 := r1_port;
        r1_state := 2;
    END_IF;

2:
    D2004 := 0; D2005 := 300; D2006 := 0; Y41 := TRUE;
    IF r1_port = 1 THEN
        D2008 := D92; D2009 := 300; D2010 := 0; Y42 := TRUE;
    ELSIF r1_port = 2 THEN
        D2012 := D92; D2013 := 300; D2014 := 0; Y43 := TRUE;
    END_IF;
    D2000 := 0; D2001 := 300; D2002 := 0; Y40 := TRUE;
    Y30 := FALSE;
    r1_move_timer(IN := TRUE, PT := T#200ms);
    IF ABS(D1000 - 0) <= 20 AND ABS(D1001) <= 100 AND r1_move_timer.Q THEN
        Y30 := TRUE;
        r1_move_timer(IN := FALSE, PT := T#200ms);
        D80 := 2; D81 := 3;
        r1_state := 3;
    END_IF;

3:
    IF X63 THEN
        shuttle_owner := 0;
        r1_state := 4;
    END_IF;

4:
    tA1 := INT_TO_REAL(D500) * 0.01 * DEG2RAD;
    tB1 := INT_TO_REAL(D501) * 0.01 * DEG2RAD;
    IF D502 = 0 THEN
        calc_x1 := -225.0 * (SIN(tA1) + SIN(tB1));
        s3_2_tgt1 := DINT(ROUND(calc_x1 * 100.0));
    ELSE
        s3_2_tgt1 := D502;
    END_IF;
    D2016 := D500; D2017 := 300; D2018 := 0; Y44 := TRUE;
    D2020 := D501; D2021 := 300; D2022 := 0; Y45 := TRUE;
    D2024 := s3_2_tgt1; D2025 := 300; D2026 := 0; Y46 := TRUE;
    D700 := D520;
    D701 := D526;
    D702 := 300;
    Y70 := TRUE;
    r1_state := 5;

5:
    IF cell3_ok THEN
        Y70 := FALSE;
        Y71 := TRUE;
        r1_state := 6;
    END_IF;

6:
    Y71 := FALSE;
    IF (shuttle_owner = 0 OR shuttle_owner = 2) AND (cell4_owner = 0 OR cell4_owner = 2) THEN
        shuttle_owner := 2;
        cell4_owner := 2;
        cell3_owner := 0;
        seq_num := seq_num + 1;
        D82 := seq_num;
        D80 := 1; D81 := 3;
        r1_state := 7;
    END_IF;

7:
    D2000 := 375000; D2001 := 300; D2002 := 0; Y40 := TRUE;
    Y30 := FALSE;
    r1_move_timer(IN := TRUE, PT := T#200ms);
    IF ABS(D1000 - 375000) <= 20 AND ABS(D1001) <= 100 AND r1_move_timer.Q THEN
        Y30 := TRUE;
        r1_move_timer(IN := FALSE, PT := T#200ms);
        D80 := 2; D81 := 4;
        r1_state := 8;
    END_IF;

8:
    IF X64 THEN
        shuttle_owner := 0;
        r1_state := 9;
    END_IF;

9:
    pocket_sel1 := SEL(D124 < 0, 2, 1);
    D2028 := D600; D2029 := 300; D2030 := 0; Y47 := TRUE;
    D2032 := D601; D2033 := 300; D2034 := 0; Y48 := TRUE;
    D2036 := D602; D2037 := 300; D2038 := 0; Y49 := TRUE;
    D710 := pocket_sel1;
    D711 := D626;
    D712 := 300;
    Y75 := TRUE;
    r1_state := 10;

10:
    IF cell4_ok THEN
        Y75 := FALSE;
        Y76 := TRUE;
        r1_state := 11;
    END_IF;

11:
    Y76 := FALSE;
    IF (shuttle_owner = 0 OR shuttle_owner = 2) THEN
        shuttle_owner := 2;
        cell4_owner := 0;
        seq_num := seq_num + 1;
        D82 := seq_num;
        D80 := 1; D81 := 4;
        r1_state := 12;
    END_IF;

12:
    IF r1_port = 1 THEN
        D2000 := -405000;
    ELSE
        D2000 := -185000;
    END_IF;
    D2001 := 300; D2002 := 0; Y40 := TRUE;
    Y30 := FALSE;
    r1_move_timer(IN := TRUE, PT := T#200ms);
    IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 AND r1_move_timer.Q THEN
        Y30 := TRUE;
        r1_move_timer(IN := FALSE, PT := T#200ms);
        D80 := 2; D81 := r1_port;
        IF r1_port = 1 THEN
            D2008 := D92; D2009 := 300; Y42 := TRUE;
        ELSE
            D2012 := D92; D2013 := 300; Y43 := TRUE;
        END_IF;
        r1_state := 13;
    END_IF;

13:
    D2004 := 18000; D2005 := 300; Y41 := TRUE;
    IF (r1_port = 1 AND X61) OR (r1_port = 2 AND X62) THEN
        shuttle_owner := 0;
        D2004 := 0; D2005 := 300;
        r1_state := 14;
    END_IF;

14:
    IF r1_port = 1 THEN
        D2008 := home_c; D2009 := 300; Y42 := TRUE;
    ELSE
        D2012 := home_d; D2013 := 300; Y43 := TRUE;
    END_IF;
    IF X34 THEN
        r1_state := 15;
    END_IF;

15:
    D302 := D120;
    D303 := SEL(r1_cancel_flag, 1, 2);
    r1_state := 16;

16:
    ;

ELSE
    r1_state := 0;
END_CASE;

(* ================= Final completion ================= *)
at_home := (ABS(D1000 - 0) <= 20) AND (ABS(D1004 - 0) <= 20) AND
           (ABS(D1008 - home_c) <= 20) AND (ABS(D1012 - home_d) <= 20) AND
           (ABS(D1016 - 0) <= 20) AND (ABS(D1020 - 0) <= 20) AND (ABS(D1024 - 0) <= 20) AND
           (ABS(D1028 - 0) <= 20) AND (ABS(D1032 - 0) <= 20) AND (ABS(D1036 - 0) <= 20);

hold_timer(IN := X51 AND at_home, PT := T#100ms);
IF hold_timer.Q THEN
    y2_latched := TRUE;
END_IF;
Y2 := y2_latched;

END_PROGRAM