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

    (* Internal control state *)
    phase          : INT := 0;
    active_req     : INT := 0;
    req0_done      : BOOL := FALSE;
    req1_done      : BOOL := FALSE;
    cancel_flag    : BOOL := FALSE;
    active_cancelled : BOOL := FALSE;
    cur_axis_is_c  : BOOL := TRUE;
    cur_station    : DINT := 1;
    last_station   : DINT := 0;
    couple_seq     : DINT := 0;
    lift_active    : BOOL := FALSE;
    y2_latched     : BOOL := FALSE;

    a_tgt    : DINT := 0;
    b_tgt    : DINT := 0;
    s3_0_tgt : DINT := -60000;
    s3_1_tgt : DINT := -60000;
    s4_0_tgt : DINT := -60000;
    s4_1_tgt : DINT := -60000;

    arrive_tmr : TON;
    cfg_tmr    : TON;
    hold_timer : TON;

    cond11 : BOOL := FALSE;
    cond100 : BOOL := FALSE;

    pos_tol : DINT := 20;
    vel_tol : DINT := 100;

    HOME_A   : DINT := 0;
    HOME_B   : DINT := 0;
    HOME_C   : DINT := 40000;
    HOME_D   : DINT := 40000;
    HOME_S3_0 : DINT := -60000;
    HOME_S3_1 : DINT := -60000;
    HOME_S4_0 : DINT := -60000;
    HOME_S4_1 : DINT := -60000;

    STATION1 : DINT := -405000;
    STATION2 : DINT := -185000;
    STATION3 : DINT := 0;
    STATION4 : DINT := 470000;

    DOCK_HEIGHT : DINT := 95000;
    FORK_OPEN   : DINT := 0;
    FORK_CLOSED : DINT := 18000;
END_VAR

(* ---- cancellation preemption ---- *)
active_cancelled := (active_req = 0 AND X31) OR (active_req = 1 AND X35);
IF active_cancelled AND (NOT cancel_flag) AND phase >= 1 AND phase <= 14 THEN
    cancel_flag := TRUE;
    phase := 90;
END_IF

CASE phase OF

0: (* select next request *)
    IF NOT req0_done THEN
        active_req := 0;
        IF D101 = 1 THEN
            cur_axis_is_c := TRUE; cur_station := 1;
        ELSE
            cur_axis_is_c := FALSE; cur_station := 2;
        END_IF
        cancel_flag := FALSE;
        phase := 1;
    ELSIF NOT req1_done THEN
        active_req := 1;
        IF D121 = 1 THEN
            cur_axis_is_c := TRUE; cur_station := 1;
        ELSE
            cur_axis_is_c := FALSE; cur_station := 2;
        END_IF
        cancel_flag := FALSE;
        phase := 1;
    ELSE
        phase := 100;
    END_IF

1: (* raise lift, approach lift station *)
    lift_active := TRUE;
    b_tgt := FORK_OPEN;
    IF cur_axis_is_c THEN a_tgt := STATION1; ELSE a_tgt := STATION2; END_IF
    arrive_tmr(IN := (ABS(D1000 - a_tgt) <= pos_tol AND ABS(D1001) <= vel_tol AND
                       ABS(D1008 - DOCK_HEIGHT) <= pos_tol AND ABS(D1009) <= vel_tol AND
                       ABS(D1012 - DOCK_HEIGHT) <= pos_tol AND ABS(D1013) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN phase := 2; END_IF

2: (* connect fork at lift *)
    b_tgt := FORK_CLOSED;
    arrive_tmr(IN := (ABS(D1004 - FORK_CLOSED) <= pos_tol AND ABS(D1005) <= vel_tol AND
                       ((cur_station = 1 AND X61) OR (cur_station = 2 AND X62))),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 2; D81 := cur_station; D82 := couple_seq;
        last_station := cur_station;
        phase := 3;
    END_IF

3: (* release from lift, retract fork, lower lift home *)
    b_tgt := FORK_OPEN;
    lift_active := FALSE;
    arrive_tmr(IN := (ABS(D1004 - FORK_OPEN) <= pos_tol AND ABS(D1005) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 1; D81 := cur_station; D82 := couple_seq;
        phase := 4;
    END_IF

4: (* move to cell 3 *)
    a_tgt := STATION3;
    arrive_tmr(IN := (ABS(D1000 - a_tgt) <= pos_tol AND ABS(D1001) <= vel_tol AND
                       ABS(D1008 - HOME_C) <= pos_tol AND ABS(D1012 - HOME_D) <= pos_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN phase := 5; END_IF

5: (* connect fork cell3 *)
    b_tgt := FORK_CLOSED;
    arrive_tmr(IN := (ABS(D1004 - FORK_CLOSED) <= pos_tol AND ABS(D1005) <= vel_tol AND X63),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 2; D81 := 3; D82 := couple_seq;
        last_station := 3;
        D700 := D520; D701 := D526; D702 := 500;
        Y71 := TRUE;
        phase := 6;
    END_IF

6: (* cell3 process *)
    Y70 := TRUE;
    s3_0_tgt := D500;
    s3_1_tgt := D501;
    IF X70 THEN
        Y70 := FALSE;
        phase := 7;
    END_IF

7: (* retract cell3 axes home *)
    s3_0_tgt := HOME_S3_0;
    s3_1_tgt := HOME_S3_1;
    Y71 := FALSE;
    arrive_tmr(IN := (ABS(D1016 - HOME_S3_0) <= pos_tol AND ABS(D1017) <= vel_tol AND
                       ABS(D1020 - HOME_S3_1) <= pos_tol AND ABS(D1021) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN phase := 8; END_IF

8: (* disconnect fork cell3 *)
    b_tgt := FORK_OPEN;
    arrive_tmr(IN := (ABS(D1004 - FORK_OPEN) <= pos_tol AND ABS(D1005) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 1; D81 := 3; D82 := couple_seq;
        phase := 9;
    END_IF

9: (* move to cell4 *)
    a_tgt := STATION4;
    arrive_tmr(IN := (ABS(D1000 - a_tgt) <= pos_tol AND ABS(D1001) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN phase := 10; END_IF

10: (* connect fork cell4 *)
    b_tgt := FORK_CLOSED;
    arrive_tmr(IN := (ABS(D1004 - FORK_CLOSED) <= pos_tol AND ABS(D1005) <= vel_tol AND X64),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 2; D81 := 4; D82 := couple_seq;
        last_station := 4;
        phase := 11;
    END_IF

11: (* establish reference frame while cell4 axes stopped at home *)
    s4_0_tgt := HOME_S4_0;
    s4_1_tgt := HOME_S4_1;
    cond11 := (ABS(D1024 - HOME_S4_0) <= pos_tol AND ABS(D1025) <= 100 AND
               ABS(D1028 - HOME_S4_1) <= pos_tol AND ABS(D1029) <= 100);
    cfg_tmr(IN := cond11, PT := T#40ms);
    Y75 := cond11;
    IF cfg_tmr.Q THEN
        Y75 := FALSE;
        D710 := D620; D711 := D626; D712 := 500;
        Y76 := TRUE;
        phase := 12;
    END_IF

12: (* move cell4 axes to published final goal *)
    s4_0_tgt := D600;
    s4_1_tgt := D601;
    IF X75 THEN
        phase := 13;
    END_IF

13: (* retract cell4 axes home *)
    s4_0_tgt := HOME_S4_0;
    s4_1_tgt := HOME_S4_1;
    Y76 := FALSE;
    arrive_tmr(IN := (ABS(D1024 - HOME_S4_0) <= pos_tol AND ABS(D1025) <= vel_tol AND
                       ABS(D1028 - HOME_S4_1) <= pos_tol AND ABS(D1029) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN phase := 14; END_IF

14: (* disconnect fork cell4 *)
    b_tgt := FORK_OPEN;
    arrive_tmr(IN := (ABS(D1004 - FORK_OPEN) <= pos_tol AND ABS(D1005) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 1; D81 := 4; D82 := couple_seq;
        phase := 15;
    END_IF

15: (* return to originating lift station *)
    IF cur_axis_is_c THEN a_tgt := STATION1; ELSE a_tgt := STATION2; END_IF
    arrive_tmr(IN := (ABS(D1000 - a_tgt) <= pos_tol AND ABS(D1001) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN phase := 16; END_IF

16: (* raise lift and connect fork for return *)
    lift_active := TRUE;
    b_tgt := FORK_CLOSED;
    arrive_tmr(IN := (ABS(D1008 - DOCK_HEIGHT) <= pos_tol AND ABS(D1009) <= vel_tol AND
                       ABS(D1012 - DOCK_HEIGHT) <= pos_tol AND ABS(D1013) <= vel_tol AND
                       ABS(D1004 - FORK_CLOSED) <= pos_tol AND ABS(D1005) <= vel_tol AND
                       ((cur_station = 1 AND X61) OR (cur_station = 2 AND X62))),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 2; D81 := cur_station; D82 := couple_seq;
        last_station := cur_station;
        phase := 17;
    END_IF

17: (* lower lift to initial height and release fork *)
    lift_active := FALSE;
    b_tgt := FORK_OPEN;
    arrive_tmr(IN := (ABS(D1008 - HOME_C) <= pos_tol AND ABS(D1009) <= vel_tol AND
                       ABS(D1012 - HOME_D) <= pos_tol AND ABS(D1013) <= vel_tol AND
                       ABS(D1004 - FORK_OPEN) <= pos_tol AND ABS(D1005) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 1; D81 := cur_station; D82 := couple_seq;
        phase := 18;
    END_IF

18: (* finalize: respond id and status *)
    IF active_req = 0 THEN
        D300 := D100;
        IF cancel_flag THEN D301 := 2; ELSE D301 := 1; END_IF
        req0_done := TRUE;
    ELSE
        D302 := D120;
        IF cancel_flag THEN D303 := 2; ELSE D303 := 1; END_IF
        req1_done := TRUE;
    END_IF
    phase := 0;

90: (* cancellation: disconnect wherever currently coupled, then head to lift *)
    b_tgt := FORK_OPEN;
    arrive_tmr(IN := (ABS(D1004 - FORK_OPEN) <= pos_tol AND ABS(D1005) <= vel_tol),
                PT := T#30ms);
    IF arrive_tmr.Q THEN
        couple_seq := couple_seq + 1;
        D80 := 1; D81 := last_station; D82 := couple_seq;
        s3_0_tgt := HOME_S3_0; s3_1_tgt := HOME_S3_1;
        s4_0_tgt := HOME_S4_0; s4_1_tgt := HOME_S4_1;
        Y70 := FALSE; Y71 := FALSE; Y75 := FALSE; Y76 := FALSE;
        phase := 15;
    END_IF

100: (* return everything to initial connection posture and observe completion *)
    lift_active := FALSE;
    a_tgt := HOME_A;
    b_tgt := HOME_B;
    s3_0_tgt := HOME_S3_0; s3_1_tgt := HOME_S3_1;
    s4_0_tgt := HOME_S4_0; s4_1_tgt := HOME_S4_1;
    cond100 := (ABS(D1000 - HOME_A) <= pos_tol AND ABS(D1001) <= vel_tol AND
                ABS(D1004 - HOME_B) <= pos_tol AND ABS(D1005) <= vel_tol AND
                ABS(D1008 - HOME_C) <= pos_tol AND ABS(D1009) <= vel_tol AND
                ABS(D1012 - HOME_D) <= pos_tol AND ABS(D1013) <= vel_tol AND
                ABS(D1016 - HOME_S3_0) <= pos_tol AND ABS(D1017) <= vel_tol AND
                ABS(D1020 - HOME_S3_1) <= pos_tol AND ABS(D1021) <= vel_tol AND
                ABS(D1024 - HOME_S4_0) <= pos_tol AND ABS(D1025) <= vel_tol AND
                ABS(D1028 - HOME_S4_1) <= pos_tol AND ABS(D1029) <= vel_tol AND
                X51);
    IF cond100 THEN
        y2_latched := TRUE;
    END_IF

ELSE
    phase := 0;

END_CASE

(* ---- output mapping ---- *)
D2000 := a_tgt;
D2001 := 1000;
D2002 := 0;
Y40 := TRUE;

D2004 := b_tgt;
D2005 := 1000;
D2006 := 0;
Y41 := TRUE;

IF lift_active THEN
    D2008 := DOCK_HEIGHT;
    D2012 := DOCK_HEIGHT;
ELSE
    D2008 := HOME_C;
    D2012 := HOME_D;
END_IF
D2009 := 1000;
D2010 := 0;
Y42 := TRUE;
D2013 := 1000;
D2014 := 0;
Y43 := TRUE;

D2016 := s3_0_tgt;
D2017 := 1000;
D2018 := 0;
Y44 := TRUE;

D2020 := s3_1_tgt;
D2021 := 1000;
D2022 := 0;
Y45 := TRUE;

D2024 := s4_0_tgt;
D2025 := 1000;
D2026 := 0;
Y46 := TRUE;

D2028 := s4_1_tgt;
D2029 := 1000;
D2030 := 0;
Y47 := TRUE;

Y2 := y2_latched;
Y30 := y2_latched;

END_PROGRAM