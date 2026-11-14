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

    (* Internal control variables *)
    state       : INT := 0;
    req_idx     : INT := 0;
    req0_done   : BOOL := FALSE;
    req1_done   : BOOL := FALSE;
    cancel_flag : BOOL := FALSE;
    y2_latched  : BOOL := FALSE;

    cur_id       : DINT;
    cur_location : DINT;
    cur_cancelled: BOOL;
    cur_returned : BOOL;

    couple_seq     : DINT := 0;
    accompany_start: DINT := 0;
    accompanied_ok : BOOL := FALSE;
    sync_ok_cond   : BOOL := FALSE;

    err_pos : DINT;
    err_vel : DINT;

    pos_tol         : DINT := 20;
    vel_tol         : DINT := 100;
    ang_tol         : DINT := 20;
    angvel_tol      : DINT := 100;
    ang_maintain_tol: DINT := 60;
    accompany_dist  : DINT := 20000;
    master_std_tol  : DINT := 100;

    home_a   : DINT := 0;
    home_b   : DINT := 0;
    home_c   : DINT := 15000;
    home_d   : DINT := 15000;
    home_s3_0: DINT := -50000;
    home_s3_1: DINT := -50000;
    home_s3_2: DINT := 0;
    home_s4_0: DINT := 0;
    home_s4_1: DINT := 0;

    sync3_timer      : TON;
    sync4_timer      : TON;
    completion_timer : TON;
END_VAR

(* fetch current active request data *)
IF req_idx = 0 THEN
    cur_id        := D100;
    cur_location  := D101;
    cur_cancelled := X31;
    cur_returned  := X30;
ELSE
    cur_id        := D120;
    cur_location  := D121;
    cur_cancelled := X35;
    cur_returned  := X34;
END_IF;

CASE state OF

0: (* SELECT NEXT REQUEST *)
    Y30 := TRUE;
    IF req0_done AND req1_done THEN
        state := 200;
    ELSE
        IF NOT req0_done THEN
            req_idx := 0;
        ELSE
            req_idx := 1;
        END_IF;

        IF req_idx = 0 THEN
            IF D100 <> 0 THEN
                IF X31 THEN
                    cancel_flag := TRUE;
                    state := 900;
                ELSE
                    cancel_flag := FALSE;
                    sync3_timer(IN := FALSE);
                    sync4_timer(IN := FALSE);
                    state := 10;
                END_IF;
            END_IF;
        ELSE
            IF D120 <> 0 THEN
                IF X35 THEN
                    cancel_flag := TRUE;
                    state := 900;
                ELSE
                    cancel_flag := FALSE;
                    sync3_timer(IN := FALSE);
                    sync4_timer(IN := FALSE);
                    state := 10;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

10: (* LIFT_UP : raise correct lift to source dock height *)
    Y30 := TRUE;
    IF cur_location = 1 THEN
        D2008 := D92; D2009 := 1000; D2010 := 0; Y42 := TRUE;
        err_pos := ABS(D1008 - D92);
        err_vel := ABS(D1009);
    ELSE
        D2012 := D92; D2013 := 1000; D2014 := 0; Y43 := TRUE;
        err_pos := ABS(D1012 - D92);
        err_vel := ABS(D1013);
    END_IF;
    IF err_pos <= pos_tol AND err_vel <= vel_tol THEN
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 1;
        D81 := cur_location;
        state := 20;
    END_IF;

20: (* TO_LIFT_PORT : align shuttle, engage fork to grab jig *)
    Y30 := FALSE;
    Y40 := TRUE; Y41 := TRUE;
    D2001 := 1000; D2002 := 0;
    D2005 := 1000; D2006 := 0;
    IF cur_location = 1 THEN
        D2000 := D403;
        err_pos := ABS(D1000 - D403);
    ELSE
        D2000 := D406;
        err_pos := ABS(D1000 - D406);
    END_IF;
    D2004 := 18000;
    err_vel := ABS(D1001);
    IF err_pos <= pos_tol AND err_vel <= vel_tol
       AND ABS(D1004 - 18000) <= pos_tol AND ABS(D1005) <= vel_tol
       AND ((cur_location = 1 AND X61) OR (cur_location = 2 AND X62)) THEN
        accompany_start := D1000;
        state := 30;
    END_IF;

30: (* TRANSIT TO CELL3 : moving connection sync + 200mm accompaniment *)
    Y30 := FALSE;
    Y40 := TRUE; Y41 := TRUE;
    D2000 := D409; D2001 := 1000; D2002 := 0;
    D2004 := 18000; D2005 := 1000; D2006 := 0;
    Y70 := TRUE; Y71 := TRUE;
    D700 := 1000; D701 := D526; D702 := 1000;
    Y44 := TRUE; Y45 := TRUE; Y46 := TRUE;
    D2016 := D500; D2017 := 1000; D2018 := 0;
    D2020 := D501; D2021 := 1000; D2022 := 0;
    D2024 := D502; D2025 := 1000; D2026 := 0;

    err_pos := ABS(D1000 - D1016);
    err_vel := ABS(D1001 - D1017);
    sync_ok_cond := (err_pos <= pos_tol) AND (err_vel <= vel_tol);
    sync3_timer(IN := sync_ok_cond, PT := T#50ms);
    accompanied_ok := (ABS(D1000 - accompany_start) >= accompany_dist);

    IF sync3_timer.Q AND accompanied_ok AND X63
       AND ABS(D1000 - D409) <= pos_tol AND ABS(D1001) <= vel_tol THEN
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 2; D81 := 3;
        state := 35;
    END_IF;

35: (* handoff to cell3 : retrieve fork *)
    Y30 := FALSE;
    D2004 := 0; D2005 := 1000; D2006 := 0; Y41 := TRUE;
    IF ABS(D1004 - 0) <= pos_tol AND ABS(D1005) <= vel_tol THEN
        state := 40;
    END_IF;

40: (* CELL3_HOLD : wait for cell3 result *)
    Y30 := TRUE;
    IF X70 THEN
        state := 50;
    END_IF;

50: (* LEAVE_CELL3 : re-engage fork to grab jig back *)
    Y30 := FALSE;
    D2004 := 18000; D2005 := 1000; D2006 := 0; Y41 := TRUE;
    IF ABS(D1004 - 18000) <= pos_tol AND ABS(D1005) <= vel_tol THEN
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 1; D81 := 3;
        state := 60;
    END_IF;

60: (* TRANSIT TO CELL4 : electronic gear rotation sync *)
    Y30 := FALSE;
    Y40 := TRUE; Y41 := TRUE;
    D2000 := D412; D2001 := 1000; D2002 := 0;
    D2004 := 18000; D2005 := 1000; D2006 := 0;
    Y75 := TRUE; Y76 := TRUE;
    D710 := 1000; D711 := D626; D712 := 1000;
    Y47 := TRUE; Y48 := TRUE;
    D2028 := D600; D2029 := 1000; D2030 := 0;
    D2032 := D601; D2033 := 1000; D2034 := 0;

    err_pos := ABS(D1028 - D600);
    err_vel := ABS(D1029);
    sync_ok_cond := (err_pos <= ang_tol) AND (err_vel <= angvel_tol) AND (ABS(D1001) > master_std_tol);
    sync4_timer(IN := sync_ok_cond, PT := T#50ms);

    IF sync4_timer.Q AND X64
       AND ABS(D1000 - D412) <= pos_tol AND ABS(D1001) <= vel_tol THEN
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 2; D81 := 4;
        state := 65;
    END_IF;

65: (* handoff to cell4 : retrieve fork *)
    D2004 := 0; D2005 := 1000; D2006 := 0; Y41 := TRUE;
    IF ABS(D1004 - 0) <= pos_tol AND ABS(D1005) <= vel_tol THEN
        state := 70;
    END_IF;

70: (* CELL4_HOLD : maintain angle within 0.6deg until result, wait served *)
    Y30 := TRUE;
    IF X75 THEN
        state := 80;
    END_IF;

80: (* LEAVE_CELL4 : re-engage fork *)
    Y30 := FALSE;
    D2004 := 18000; D2005 := 1000; D2006 := 0; Y41 := TRUE;
    IF ABS(D1004 - 18000) <= pos_tol AND ABS(D1005) <= vel_tol THEN
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 1; D81 := 4;
        state := 90;
    END_IF;

90: (* RETURN_TO_LIFT *)
    Y30 := FALSE;
    Y40 := TRUE; Y41 := TRUE;
    IF cur_location = 1 THEN
        D2000 := D403;
        err_pos := ABS(D1000 - D403);
    ELSE
        D2000 := D406;
        err_pos := ABS(D1000 - D406);
    END_IF;
    D2001 := 1000; D2002 := 0;
    D2004 := 18000; D2005 := 1000; D2006 := 0;
    err_vel := ABS(D1001);
    IF err_pos <= pos_tol AND err_vel <= vel_tol THEN
        couple_seq := couple_seq + 1;
        D82 := couple_seq;
        D80 := 2; D81 := cur_location;
        state := 95;
    END_IF;

95: (* place jig back on lift : retrieve fork *)
    D2004 := 0; D2005 := 1000; D2006 := 0; Y41 := TRUE;
    IF ABS(D1004 - 0) <= pos_tol AND ABS(D1005) <= vel_tol THEN
        state := 100;
    END_IF;

100: (* LIFT_DOWN : lower lift to initial height *)
    Y30 := TRUE;
    IF cur_location = 1 THEN
        D2008 := home_c; D2009 := 1000; D2010 := 0; Y42 := TRUE;
        err_pos := ABS(D1008 - home_c); err_vel := ABS(D1009);
    ELSE
        D2012 := home_d; D2013 := 1000; D2014 := 0; Y43 := TRUE;
        err_pos := ABS(D1012 - home_d); err_vel := ABS(D1013);
    END_IF;
    IF err_pos <= pos_tol AND err_vel <= vel_tol THEN
        state := 110;
    END_IF;

110: (* RESPOND with ack/status, wait for physical return confirmation *)
    IF req_idx = 0 THEN
        D300 := cur_id;
        D301 := SEL(cancel_flag, 1, 2);
    ELSE
        D302 := cur_id;
        D303 := SEL(cancel_flag, 1, 2);
    END_IF;

    IF cur_returned THEN
        IF req_idx = 0 THEN
            req0_done := TRUE;
        ELSE
            req1_done := TRUE;
        END_IF;
        state := 0;
    END_IF;

900: (* CANCEL RETRIEVAL : return jig to lift without processing cells *)
    Y30 := FALSE;
    Y40 := TRUE; Y41 := TRUE;
    IF cur_location = 1 THEN
        D2000 := D403;
        err_pos := ABS(D1000 - D403);
    ELSE
        D2000 := D406;
        err_pos := ABS(D1000 - D406);
    END_IF;
    D2001 := 1000; D2002 := 0;
    D2004 := 0; D2005 := 1000; D2006 := 0;
    err_vel := ABS(D1001);
    IF err_pos <= pos_tol AND err_vel <= vel_tol
       AND ABS(D1004 - 0) <= pos_tol AND ABS(D1005) <= vel_tol THEN
        state := 100;
    END_IF;

200: (* COMPLETION CHECK : all axes to initial connection posture, hold 100ms then declare *)
    Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
    Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
    Y30 := TRUE;

    D2000 := home_a;   D2001 := 1000; D2002 := 0;
    D2004 := home_b;   D2005 := 1000; D2006 := 0;
    D2008 := home_c;   D2009 := 1000; D2010 := 0;
    D2012 := home_d;   D2013 := 1000; D2014 := 0;
    D2016 := home_s3_0; D2017 := 1000; D2018 := 0;
    D2020 := home_s3_1; D2021 := 1000; D2022 := 0;
    D2024 := home_s3_2; D2025 := 1000; D2026 := 0;
    D2028 := home_s4_0; D2029 := 1000; D2030 := 0;
    D2032 := home_s4_1; D2033 := 1000; D2034 := 0;

    sync_ok_cond := X51
        AND ABS(D1000 - home_a) <= pos_tol AND ABS(D1001) <= vel_tol
        AND ABS(D1004 - home_b) <= pos_tol AND ABS(D1005) <= vel_tol
        AND ABS(D1008 - home_c) <= pos_tol AND ABS(D1009) <= vel_tol
        AND ABS(D1012 - home_d) <= pos_tol AND ABS(D1013) <= vel_tol
        AND ABS(D1016 - home_s3_0) <= pos_tol AND ABS(D1017) <= vel_tol
        AND ABS(D1020 - home_s3_1) <= pos_tol AND ABS(D1021) <= vel_tol
        AND ABS(D1024 - home_s3_2) <= pos_tol AND ABS(D1025) <= vel_tol
        AND ABS(D1028 - home_s4_0) <= ang_tol AND ABS(D1029) <= angvel_tol
        AND ABS(D1032 - home_s4_1) <= ang_tol AND ABS(D1033) <= angvel_tol;

    completion_timer(IN := sync_ok_cond, PT := T#100ms);

    IF completion_timer.Q THEN
        y2_latched := TRUE;
    END_IF;

    IF y2_latched THEN
        Y2 := TRUE;
    END_IF;

ELSE
    state := 0;

END_CASE;

END_PROGRAM