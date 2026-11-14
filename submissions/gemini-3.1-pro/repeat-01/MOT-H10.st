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

    r0_state : INT := 0;
    r1_state : INT := 0;
    r0_cancel_flag : INT := 0;
    r1_cancel_flag : INT := 0;
    r0_cell3_req : DINT := 0;
    r1_cell3_req : DINT := 0;
    r0_cell4_req : DINT := 0;
    r1_cell4_req : DINT := 0;
    cell3_req : DINT := 0;
    cell4_req : DINT := 0;
    shuttle_state : INT := 0;
    shuttle_active : INT := 0;
    r0_shuttle_req_valid : BOOL;
    r1_shuttle_req_valid : BOOL;
    cell3_free : BOOL;
    cell4_free : BOOL;
    r0_shuttle_done : BOOL;
    r1_shuttle_done : BOOL;
    r0_shuttle_done_ack : BOOL;
    r1_shuttle_done_ack : BOOL;
    target_station : DINT;
    target_action : DINT;
    target_id : DINT;
    r0_st, r0_act : DINT;
    r1_st, r1_act : DINT;
    r0_id_req, r1_id_req : DINT;
    a_m_s2, x_err_m, v_x_m, theta_rad, theta_dot_rad : REAL;
    m4_goal_active : BOOL;
    target_s4_1 : DINT;
    ready_flag : BOOL;
    target_pos : DINT;
    v_a_target : DINT;
    cell3_done : BOOL;
    cell4_done : BOOL;
END_VAR

D2001 := 1000; Y40 := TRUE;
D2005 := 1000; Y41 := TRUE;
D2009 := 1000; Y42 := TRUE;
D2013 := 1000; Y43 := TRUE;
D2017 := 1000; Y44 := TRUE;
D2021 := 1000; Y45 := TRUE;
D2025 := 1000; Y46 := TRUE;
D2029 := 1000; Y47 := TRUE;
D2033 := 1000; Y48 := TRUE;

IF r0_state = 0 AND D100 <> 0 THEN
    IF D90 = D100 THEN
        r0_state := 8;
    ELSIF D101 = 3 THEN
        IF X31 THEN r0_cancel_flag := 1; ELSE r0_cancel_flag := 0; END_IF;
        r0_state := 4;
    ELSIF D101 = 4 THEN
        IF X31 THEN r0_cancel_flag := 1; ELSE r0_cancel_flag := 0; END_IF;
        r0_state := 7;
    ELSE
        IF X31 THEN
            r0_state := 9;
        ELSE
            r0_cancel_flag := 0;
            r0_state := 1;
        END_IF;
    END_IF;
END_IF;

IF r1_state = 0 AND D120 <> 0 THEN
    IF D90 = D120 THEN
        r1_state := 8;
    ELSIF D121 = 3 THEN
        IF X35 THEN r1_cancel_flag := 1; ELSE r1_cancel_flag := 0; END_IF;
        r1_state := 4;
    ELSIF D121 = 4 THEN
        IF X35 THEN r1_cancel_flag := 1; ELSE r1_cancel_flag := 0; END_IF;
        r1_state := 7;
    ELSE
        IF X35 THEN
            r1_state := 9;
        ELSE
            r1_cancel_flag := 0;
            r1_state := 1;
        END_IF;
    END_IF;
END_IF;

cell3_free := NOT (r0_state = 2 OR r0_state = 3 OR r0_state = 4) AND NOT (r1_state = 2 OR r1_state = 3 OR r1_state = 4);
cell4_free := NOT (r0_state = 5 OR r0_state = 6 OR r0_state = 7) AND NOT (r1_state = 5 OR r1_state = 6 OR r1_state = 7);

r0_shuttle_req_valid := FALSE;
IF r0_state = 1 AND cell3_free THEN r0_shuttle_req_valid := TRUE; END_IF;
IF r0_state = 2 THEN r0_shuttle_req_valid := TRUE; END_IF;
IF r0_state = 4 AND (cell4_free OR r0_cancel_flag = 1) THEN r0_shuttle_req_valid := TRUE; END_IF;
IF r0_state = 5 THEN r0_shuttle_req_valid := TRUE; END_IF;
IF r0_state = 7 THEN r0_shuttle_req_valid := TRUE; END_IF;
IF r0_state = 8 THEN r0_shuttle_req_valid := TRUE; END_IF;

r1_shuttle_req_valid := FALSE;
IF r1_state = 1 AND cell3_free THEN r1_shuttle_req_valid := TRUE; END_IF;
IF r1_state = 2 THEN r1_shuttle_req_valid := TRUE; END_IF;
IF r1_state = 4 AND (cell4_free OR r1_cancel_flag = 1) THEN r1_shuttle_req_valid := TRUE; END_IF;
IF r1_state = 5 THEN r1_shuttle_req_valid := TRUE; END_IF;
IF r1_state = 7 THEN r1_shuttle_req_valid := TRUE; END_IF;
IF r1_state = 8 THEN r1_shuttle_req_valid := TRUE; END_IF;

IF r0_state = 1 THEN r0_st := 1; r0_act := 1; r0_id_req := D100; END_IF;
IF r0_state = 2 THEN r0_st := 3; r0_act := 2; r0_id_req := 0; END_IF;
IF r0_state = 4 THEN r0_st := 3; r0_act := 1; r0_id_req := D100; END_IF;
IF r0_state = 5 THEN r0_st := 4; r0_act := 2; r0_id_req := 0; END_IF;
IF r0_state = 7 THEN r0_st := 4; r0_act := 1; r0_id_req := D100; END_IF;
IF r0_state = 8 THEN r0_st := 1; r0_act := 2; r0_id_req := 0; END_IF;

IF r1_state = 1 THEN r1_st := 2; r1_act := 1; r1_id_req := D120; END_IF;
IF r1_state = 2 THEN r1_st := 3; r1_act := 2; r1_id_req := 0; END_IF;
IF r1_state = 4 THEN r1_st := 3; r1_act := 1; r1_id_req := D120; END_IF;
IF r1_state = 5 THEN r1_st := 4; r1_act := 2; r1_id_req := 0; END_IF;
IF r1_state = 7 THEN r1_st := 4; r1_act := 1; r1_id_req := D120; END_IF;
IF r1_state = 8 THEN r1_st := 2; r1_act := 2; r1_id_req := 0; END_IF;

IF shuttle_state = 0 THEN
    IF r0_shuttle_req_valid THEN
        shuttle_active := 1;
        target_station := r0_st;
        target_action := r0_act;
        target_id := r0_id_req;
        shuttle_state := 1;
    ELSIF r1_shuttle_req_valid THEN
        shuttle_active := 2;
        target_station := r1_st;
        target_action := r1_act;
        target_id := r1_id_req;
        shuttle_state := 1;
    END_IF;
END_IF;

IF shuttle_state = 1 THEN
    target_pos := 0;
    ready_flag := FALSE;
    IF target_station = 1 THEN
        target_pos := D403;
        ready_flag := X61 AND (ABS(D1008 - D92) <= 20) AND (ABS(D1009) <= 100);
    ELSIF target_station = 2 THEN
        target_pos := D406;
        ready_flag := X62 AND (ABS(D1012 - D92) <= 20) AND (ABS(D1013) <= 100);
    ELSIF target_station = 3 THEN
        target_pos := D409;
        ready_flag := X63;
    ELSIF target_station = 4 THEN
        target_pos := D412;
        ready_flag := X64;
    END_IF;
    
    v_a_target := target_pos;
    
    IF ABS(D1000 - target_pos) <= 20 AND ABS(D1001) <= 100 AND ready_flag THEN
        shuttle_state := 2;
    END_IF;
ELSIF shuttle_state = 2 THEN
    D2004 := 18000;
    IF D1004 >= 17980 AND ABS(D1005) <= 100 THEN
        shuttle_state := 3;
        D82 := D82 + 1;
    END_IF;
ELSIF shuttle_state = 3 THEN
    D80 := target_action;
    D81 := target_station;
    IF D90 = target_id THEN
        shuttle_state := 4;
    END_IF;
ELSIF shuttle_state = 4 THEN
    D2004 := 0;
    IF D1004 <= 20 AND ABS(D1005) <= 100 THEN
        shuttle_state := 5;
    END_IF;
ELSIF shuttle_state = 5 THEN
    IF shuttle_active = 1 THEN r0_shuttle_done := TRUE; END_IF;
    IF shuttle_active = 2 THEN r1_shuttle_done := TRUE; END_IF;
    shuttle_state := 6;
ELSIF shuttle_state = 6 THEN
    IF shuttle_active = 1 AND r0_shuttle_done_ack THEN
        shuttle_state := 0;
        shuttle_active := 0;
        r0_shuttle_done := FALSE;
    ELSIF shuttle_active = 2 AND r1_shuttle_done_ack THEN
        shuttle_state := 0;
        shuttle_active := 0;
        r1_shuttle_done := FALSE;
    END_IF;
END_IF;

IF shuttle_state = 0 AND X51 THEN
    v_a_target := 0;
END_IF;
D2000 := v_a_target;
IF shuttle_state = 0 THEN D2004 := 0; END_IF;

IF r0_shuttle_done AND NOT r0_shuttle_done_ack THEN
    IF r0_state = 1 THEN
        IF X31 THEN r0_cancel_flag := 1; r0_state := 8; ELSE r0_state := 2; END_IF;
    ELSIF r0_state = 2 THEN
        r0_state := 3;
    ELSIF r0_state = 4 THEN
        IF r0_cancel_flag = 1 OR X31 THEN r0_state := 8; ELSE r0_state := 5; END_IF;
    ELSIF r0_state = 5 THEN
        r0_state := 6;
    ELSIF r0_state = 7 THEN
        r0_state := 8;
    ELSIF r0_state = 8 THEN
        r0_state := 9;
    END_IF;
    r0_shuttle_done_ack := TRUE;
ELSE
    r0_shuttle_done_ack := FALSE;
END_IF;

IF r1_shuttle_done AND NOT r1_shuttle_done_ack THEN
    IF r1_state = 1 THEN
        IF X35 THEN r1_cancel_flag := 1; r1_state := 8; ELSE r1_state := 2; END_IF;
    ELSIF r1_state = 2 THEN
        r1_state := 3;
    ELSIF r1_state = 4 THEN
        IF r1_cancel_flag = 1 OR X35 THEN r1_state := 8; ELSE r1_state := 5; END_IF;
    ELSIF r1_state = 5 THEN
        r1_state := 6;
    ELSIF r1_state = 7 THEN
        r1_state := 8;
    ELSIF r1_state = 8 THEN
        r1_state := 9;
    END_IF;
    r1_shuttle_done_ack := TRUE;
ELSE
    r1_shuttle_done_ack := FALSE;
END_IF;

IF r0_state = 3 THEN
    IF X31 THEN
        r0_cell3_req := 0;
        IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
            r0_cancel_flag := 1;
            r0_state := 4;
        END_IF;
    ELSE
        r0_cell3_req := D100;
        IF cell3_done THEN r0_state := 4; END_IF;
    END_IF;
ELSE
    r0_cell3_req := 0;
END_IF;

IF r1_state = 3 THEN
    IF X35 THEN
        r1_cell3_req := 0;
        IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN
            r1_cancel_flag := 1;
            r1_state := 4;
        END_IF;
    ELSE
        r1_cell3_req := D120;
        IF cell3_done THEN r1_state := 4; END_IF;
    END_IF;
ELSE
    r1_cell3_req := 0;
END_IF;

cell3_req := r0_cell3_req;
IF r1_cell3_req <> 0 THEN cell3_req := r1_cell3_req; END_IF;

IF cell3_req <> 0 THEN
    D700 := cell3_req;
    Y71 := TRUE;
    Y70 := TRUE;
    IF D522 = cell3_req THEN
        D2016 := D500;
        IF X70 THEN cell3_done := TRUE; END_IF;
    END_IF;
ELSE
    D700 := 0;
    Y71 := FALSE;
    Y70 := FALSE;
    D2016 := 0;
    cell3_done := FALSE;
END_IF;

IF D501 = 0 THEN
    D2020 := DINT(-45000.0 * SIN(REAL(D1016) * 0.0001745329));
ELSE
    D2020 := D501;
END_IF;

IF r0_state = 6 THEN
    IF X31 THEN
        r0_cell4_req := 0;
        IF ABS(D1024 - 100000) <= 20 AND ABS(D1025) <= 100 AND ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1032) <= 3 AND ABS(D1033) <= 15 THEN
            r0_cancel_flag := 1;
            r0_state := 7;
        END_IF;
    ELSE
        r0_cell4_req := D100;
        IF cell4_done THEN r0_state := 7; END_IF;
    END_IF;
ELSE
    r0_cell4_req := 0;
END_IF;

IF r1_state = 6 THEN
    IF X35 THEN
        r1_cell4_req := 0;
        IF ABS(D1024 - 100000) <= 20 AND ABS(D1025) <= 100 AND ABS(D1028) <= 20 AND ABS(D1029) <= 100 AND ABS(D1032) <= 3 AND ABS(D1033) <= 15 THEN
            r1_cancel_flag := 1;
            r1_state := 7;
        END_IF;
    ELSE
        r1_cell4_req := D120;
        IF cell4_done THEN r1_state := 7; END_IF;
    END_IF;
ELSE
    r1_cell4_req := 0;
END_IF;

cell4_req := r0_cell4_req;
IF r1_cell4_req <> 0 THEN cell4_req := r1_cell4_req; END_IF;

IF cell4_req <> 0 THEN
    D710 := cell4_req;
    Y76 := TRUE;
    Y75 := TRUE;
    IF D622 = cell4_req THEN
        D2024 := D600;
        m4_goal_active := TRUE;
        IF X75 THEN cell4_done := TRUE; END_IF;
    END_IF;
ELSE
    D710 := 0;
    Y76 := FALSE;
    Y75 := FALSE;
    D2024 := 100000;
    m4_goal_active := FALSE;
    cell4_done := FALSE;
END_IF;

IF m4_goal_active THEN
    target_s4_1 := D601;
ELSE
    target_s4_1 := 0;
END_IF;

x_err_m := REAL(target_s4_1 - D1028) / 100000.0;
v_x_m := REAL(D1029) / 100000.0;
theta_rad := REAL(D1032) * 0.000174533;
theta_dot_rad := REAL(D1033) * 0.000174533;
a_m_s2 := 2.0 * x_err_m - 3.0 * v_x_m + 15.0 * theta_rad + 6.0 * theta_dot_rad;
a_m_s2 := LIMIT(-2.0, a_m_s2, 2.0);
D712 := DINT(a_m_s2 * 100000.0);
D2028 := target_s4_1;
D2032 := 0;

IF r0_state = 0 OR r0_state = 9 THEN D2008 := 15000; ELSE D2008 := D92; END_IF;
IF r1_state = 0 OR r1_state = 9 THEN D2012 := 15000; ELSE D2012 := D92; END_IF;

IF r0_state = 9 THEN
    IF ABS(D1008 - 15000) <= 20 AND ABS(D1009) <= 100 THEN
        D300 := D100;
        IF X31 OR r0_cancel_flag = 1 THEN D301 := 2; ELSE D301 := 1; END_IF;
        IF D100 = 0 THEN
            r0_state := 0;
            D300 := 0;
            D301 := 0;
            r0_cancel_flag := 0;
        END_IF;
    END_IF;
END_IF;

IF r1_state = 9 THEN
    IF ABS(D1012 - 15000) <= 20 AND ABS(D1013) <= 100 THEN
        D302 := D120;
        IF X35 OR r1_cancel_flag = 1 THEN D303 := 2; ELSE D303 := 1; END_IF;
        IF D120 = 0 THEN
            r1_state := 0;
            D302 := 0;
            D303 := 0;
            r1_cancel_flag := 0;
        END_IF;
    END_IF;
END_IF;

Y30 := X51 AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1009) <= 100) AND (ABS(D1013) <= 100) AND (D2008 = 15000) AND (D2012 = 15000);

Y2 := X51 AND (ABS(D1000) <= 20) AND (ABS(D1004) <= 20) AND (ABS(D1008 - 15000) <= 20) AND (ABS(D1012 - 15000) <= 20) AND (ABS(D1016) <= 20) AND (ABS(D1020) <= 20) AND (ABS(D1024 - 100000) <= 20) AND (ABS(D1028) <= 20) AND (ABS(D1032) <= 3) AND Y30;

END_PROGRAM