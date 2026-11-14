PROGRAM Main
VAR
    ST_IDLE : INT := 0;
    ST_LIFT_DOCK : INT := 1;
    ST_WAIT_CONNECT : INT := 2;
    ST_TO_CELL3 : INT := 3;
    ST_CELL3_CONF : INT := 4;
    ST_TO_CELL4 : INT := 5;
    ST_CELL4_CAP : INT := 6;
    ST_TO_LIFT : INT := 7;
    ST_WAIT_DISCONN : INT := 8;
    ST_LIFT_HOME : INT := 9;
    ST_REQ_DONE : INT := 10;

    req0_state : INT := ST_IDLE;
    req1_state : INT := ST_IDLE;

    req0_id : DINT := -1;
    req1_id : DINT := -1;
    req0_active : BOOL := FALSE;
    req1_active : BOOL := FALSE;
    req0_cancel : BOOL := FALSE;
    req1_cancel : BOOL := FALSE;

    req0_ack : BOOL := FALSE;
    req1_ack : BOOL := FALSE;

    active_req : DINT := -1;

    seq_num : DINT := 1;
    stored_epoch : DINT := 0;

    r0_edge : R_TRIG;
    r1_edge : R_TRIG;
    cancel_r0_edge : R_TRIG;
    cancel_r1_edge : R_TRIG;

    settle_timer : TON;
    observe_timer : TON;
    y2_hold : TON;

    req0_done : BOOL := FALSE;
    req1_done : BOOL := FALSE;
    all_complete : BOOL := FALSE;

    cell3_done : BOOL := FALSE;
    capture_valid : BOOL := FALSE;
    fork_out : BOOL := FALSE;

    DOCK_HT : DINT := 73250;
    HOME_LT : DINT := 15000;
    HOME_SH : DINT := 0;
    HOME_FK : DINT := 0;
    EXT_FK : DINT := 18000;
    HOME_S3 : DINT := -60000;
    HOME_S4 : DINT := -60000;

    PT1 : DINT := -360000;
    PT2 : DINT := -230000;
    PT3 : DINT := 0;
    PT4 : DINT := 360000;

    SPD : DINT := 800;
    SPD_S : DINT := 300;
    SPD_F : DINT := 100;

    ARR_TOL : DINT := 20;
    SPD_TOL : DINT := 100;
END_VAR

Y30 := FALSE;
Y2 := FALSE;

r0_edge(CLK := X30);
r1_edge(CLK := X34);
cancel_r0_edge(CLK := X31);
cancel_r1_edge(CLK := X35);

IF req0_active AND NOT req0_done AND NOT req0_ack THEN
    IF req0_cancel THEN
        req0_state := ST_TO_LIFT;
    END_IF;
END_IF;

IF req1_active AND NOT req1_done AND NOT req1_ack THEN
    IF req1_cancel THEN
        req1_state := ST_TO_LIFT;
    END_IF;
END_IF;

IF req0_state = ST_IDLE AND D102 > 0 AND NOT req0_done THEN
    req0_active := TRUE;
    req0_id := D100;
    req0_state := ST_LIFT_DOCK;
    req0_cancel := FALSE;
END_IF;

IF req1_state = ST_IDLE AND D122 > 0 AND NOT req1_done THEN
    req1_active := TRUE;
    req1_id := D120;
    req1_state := ST_LIFT_DOCK;
    req1_cancel := FALSE;
END_IF;

IF req0_state = ST_LIFT_DOCK THEN
    D2008 := DOCK_HT;
    D2009 := SPD;
    Y42 := TRUE;
    IF ABS(D1008 - DOCK_HT) <= ARR_TOL AND ABS(D1009) <= SPD_TOL THEN
        Y42 := FALSE;
        req0_state := ST_WAIT_CONNECT;
        active_req := 0;
    END_IF;
END_IF;

IF req1_state = ST_LIFT_DOCK THEN
    D2012 := DOCK_HT;
    D2013 := SPD;
    Y43 := TRUE;
    IF ABS(D1012 - DOCK_HT) <= ARR_TOL AND ABS(D1013) <= SPD_TOL THEN
        Y43 := FALSE;
        req1_state := ST_WAIT_CONNECT;
        active_req := 1;
    END_IF;
END_IF;

IF req0_state = ST_WAIT_CONNECT AND active_req = 0 THEN
    IF D101 = 1 THEN
        D2000 := PT1;
        D2001 := SPD;
        Y40 := TRUE;
    END_IF;
    IF ABS(D1000 - PT1) <= ARR_TOL AND ABS(D1001) <= SPD_TOL THEN
        Y40 := FALSE;
        D2004 := EXT_FK;
        D2005 := SPD;
        Y41 := TRUE;
        req0_state := ST_TO_CELL3;
        fork_out := TRUE;
    END_IF;
END_IF;

IF req1_state = ST_WAIT_CONNECT AND active_req = 1 THEN
    IF D121 = 2 THEN
        D2000 := PT2;
        D2001 := SPD;
        Y40 := TRUE;
    END_IF;
    IF ABS(D1000 - PT2) <= ARR_TOL AND ABS(D1001) <= SPD_TOL THEN
        Y40 := FALSE;
        D2004 := EXT_FK;
        D2005 := SPD;
        Y41 := TRUE;
        req1_state := ST_TO_CELL3;
        fork_out := TRUE;
    END_IF;
END_IF;

IF req0_state = ST_TO_CELL3 AND active_req = 0 THEN
    D2000 := PT3;
    D2001 := SPD;
    Y40 := TRUE;
    IF ABS(D1000 - PT3) <= ARR_TOL AND ABS(D1001) <= SPD_TOL THEN
        Y40 := FALSE;
        req0_state := ST_CELL3_CONF;
        cell3_done := FALSE;
        stored_epoch := D91;
    END_IF;
END_IF;

IF req1_state = ST_TO_CELL3 AND active_req = 1 THEN
    D2000 := PT3;
    D2001 := SPD;
    Y40 := TRUE;
    IF ABS(D1000 - PT3) <= ARR_TOL AND ABS(D1001) <= SPD_TOL THEN
        Y40 := FALSE;
        req1_state := ST_CELL3_CONF;
        cell3_done := FALSE;
        stored_epoch := D91;
    END_IF;
END_IF;

IF req0_state = ST_CELL3_CONF AND active_req = 0 THEN
    IF ABS(D1016) <= SPD_TOL AND ABS(D1017) <= SPD_TOL AND ABS(D1020) <= SPD_TOL AND ABS(D1021) <= SPD_TOL THEN
        Y70 := TRUE;
        D700 := req0_id;
        D710 := req0_id;
    ELSE
        Y70 := FALSE;
    END_IF;
    IF X72 AND NOT cell3_done THEN
        Y70 := FALSE;
        cell3_done := TRUE;
        req0_state := ST_TO_CELL4;
    END_IF;
    IF NOT cell3_done THEN
        D2016 := HOME_S3;
        D2017 := SPD_S;
        Y44 := TRUE;
        D2020 := HOME_S3;
        D2021 := SPD_S;
        Y45 := TRUE;
    ELSE
        Y44 := FALSE;
        Y45 := FALSE;
    END_IF;
END_IF;

IF req1_state = ST_CELL3_CONF AND active_req = 1 THEN
    IF ABS(D1016) <= SPD_TOL AND ABS(D1017) <= SPD_TOL AND ABS(D1020) <= SPD_TOL AND ABS(D1021) <= SPD_TOL THEN
        Y70 := TRUE;
        D700 := req1_id;
        D710 := req1_id;
    ELSE
        Y70 := FALSE;
    END_IF;
    IF X72 AND NOT cell3_done THEN
        Y70 := FALSE;
        cell3_done := TRUE;
        req1_state := ST_TO_CELL4;
    END_IF;
    IF NOT cell3_done THEN
        D2016 := HOME_S3;
        D2017 := SPD_S;
        Y44 := TRUE;
        D2020 := HOME_S3;
        D2021 := SPD_S;
        Y45 := TRUE;
    ELSE
        Y44 := FALSE;
        Y45 := FALSE;
    END_IF;
END_IF;

IF req0_state = ST_TO_CELL4 AND active_req = 0 THEN
    D710 := req0_id;
    D2000 := PT4;
    D2001 := SPD;
    Y40 := TRUE;
    IF ABS(D1000 - PT4) <= ARR_TOL AND ABS(D1001) <= SPD_TOL THEN
        Y40 := FALSE;
        req0_state := ST_CELL4_CAP;
        capture_valid := FALSE;
    END_IF;
END_IF;

IF req1_state = ST_TO_CELL4 AND active_req = 1 THEN
    D710 := req1_id;
    D2000 := PT4;
    D2001 := SPD;
    Y40 := TRUE;
    IF ABS(D1000 - PT4) <= ARR_TOL AND ABS(D1001) <= SPD_TOL THEN
        Y40 := FALSE;
        req1_state := ST_CELL4_CAP;
        capture_valid := FALSE;
    ENDIF;
END_IF;

IF req0_state = ST_CELL4_CAP AND active_req = 0 THEN
    D710 := req0_id;
    IF D623 >= 0 AND D624 = stored_epoch AND D622 = req0_id THEN
        capture_valid := TRUE;
        req0_state := ST_TO_LIFT;
    END_IF;
END_IF;

IF req1_state = ST_CELL4_CAP AND active_req = 1 THEN
    D710 := req1_id;
    IF D623 >= 0 AND D624 = stored_epoch AND D622 = req1_id THEN
        capture_valid := TRUE;
        req1_state := ST_TO_LIFT;
    END_IF;
END_IF;

IF req0_state = ST_TO_LIFT AND active_req = 0 THEN
    IF D101 = 1 THEN
        D2000 := PT1;
        D2001 := SPD;
        Y40 := TRUE;
    ELSIF D101 = 2 THEN
        D2000 := PT2;
        D2001 := SPD;
        Y40 := TRUE;
    END_IF;
    IF ABS(D1000 - PT1) <= ARR_TOL AND ABS(D1001) <= SPD_TOL OR ABS(D1000 - PT2) <= ARR_TOL AND ABS(D1001) <= SPD_TOL THEN
        Y40 := FALSE;
        req0_state := ST_WAIT_DISCONN;
    END_IF;
END_IF;

IF req1_state = ST_TO_LIFT AND active_req = 1 THEN
    IF D121 = 1 THEN
        D2000 := PT1;
        D2001 := SPD;
        Y40 := TRUE;
    ELSIF D121 = 2 THEN
        D2000 := PT2;
        D2001 := SPD;
        Y40 := TRUE;
    END_IF;
    IF ABS(D1000 - PT1) <= ARR_TOL AND ABS(D1001) <= SPD_TOL OR ABS(D1000 - PT2) <= ARR_TOL AND ABS(D1001) <= SPD_TOL THEN
        Y40 := FALSE;
        req1_state := ST_WAIT_DISCONN;
    END_IF;
END_IF;

IF req0_state = ST_WAIT_DISCONN AND active_req = 0 THEN
    D2004 := HOME_FK;
    D2005 := SPD;
    Y41 := TRUE;
    IF ABS(D1004 - HOME_FK) <= ARR_TOL AND ABS(D1005) <= SPD_TOL THEN
        Y41 := FALSE;
        fork_out := FALSE;
        req0_state := ST_LIFT_HOME;
        active_req := -1;
    END_IF;
END_IF;

IF req1_state = ST_WAIT_DISCONN AND active_req = 1 THEN
    D2004 := HOME_FK;
    D2005 := SPD;
    Y41 := TRUE;
    IF ABS(D1004 - HOME_FK) <= ARR_TOL AND ABS(D1005) <= SPD_TOL THEN
        Y41 := FALSE;
        fork_out := FALSE;
        req1_state := ST_LIFT_HOME;
        active_req := -1;
    END_IF;
END_IF;

IF req0_state = ST_LIFT_HOME THEN
    D2008 := HOME_LT;
    D2009 := SPD;
    Y42 := TRUE;
    IF ABS(D1008 - HOME_LT) <= ARR_TOL AND ABS(D1009) <= SPD_TOL THEN
        Y42 := FALSE;
        req0_state := ST_REQ_DONE;
        req0_done := TRUE;
    END_IF;
END_IF;

IF req1_state = ST_LIFT_HOME THEN
    D2012 := HOME_LT;
    D2013 := SPD;
    Y43 := TRUE;
    IF ABS(D1012 - HOME_LT) <= ARR_TOL AND ABS(D1013) <= SPD_TOL THEN
        Y43 := FALSE;
        req1_state := ST_REQ_DONE;
        req1_done := TRUE;
    END_IF;
END_IF;

IF req0_done AND NOT req0_ack THEN
    D300 := req0_id;
    IF req0_cancel THEN
        D301 := 2;
    ELSE
        D301 := 1;
    END_IF;
    req0_ack := TRUE;
END_IF;

IF req1_done AND NOT req1_ack THEN
    D302 := req1_id;
    IF req1_cancel THEN
        D303 := 2;
    ELSE
        D303 := 1;
    END_IF;
    req1_ack := TRUE;
END_IF;

IF req0_done AND req1_done AND X51 THEN
    Y2 := TRUE;
END_IF;

IF Y2 THEN
    observe_timer(IN := TRUE, PT := T#100ms);
    IF observe_timer.Q THEN
        all_complete := TRUE;
    END_IF;
ELSE
    observe_timer(IN := FALSE);
END_IF;

IF NOT req0_done THEN
    IF D100 >= 0 AND req0_active THEN
        D300 := req0_id;
        D301 := 2;
        req0_done := TRUE;
        req0_ack := TRUE;
    END_IF;
END_IF;

IF NOT req1_done THEN
    IF D120 >= 0 AND req1_active THEN
        D302 := req1_id;
        D303 := 2;
        req1_done := TRUE;
        req1_ack := TRUE;
    END_IF;
END_IF;

D2002 := 0;
D2006 := 0;
D2010 := 0;
D2014 := 0;
D2018 := 0;
D2022 := 0;
D2026 := 0;
D2030 := 0;

D80 := 0;
D81 := 0;
D82 := seq_num;

IF req0_active OR req1_active THEN
    seq_num := seq_num + 1;
END_IF;

Y71 := FALSE;
Y76 := FALSE;
D701 := 0;
D702 := 0;
D711 := 0;
D712 := 0;

END_PROGRAM