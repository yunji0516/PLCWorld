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

    sh_state : DINT := 0;
    sh_target_port : DINT := 0;
    sh_action : DINT := 0;
    sh_req : DINT := 0;
    sh_pocket : DINT := 0;
    
    r0_state : DINT := 0;
    r1_state : DINT := 0;
    
    cell3_state : DINT := 0;
    cell3_req : DINT := 0;
    
    cell4_state : DINT := 0;
    cell4_req : DINT := 0;
    cell4_active_pocket : DINT := 0;
    
    a_target_val : DINT := 0;
    b_target_val : DINT := 0;
    lift_target : DINT := 40000;
    
    s3_0_t : DINT := 0;
    s3_1_t : DINT := 0;
    s3_2_t : DINT := 0;
    
    s4_0_t : DINT := 0;
    s4_1_t : DINT := 0;
    s4_2_t : DINT := 0;

    is_cancelled : BOOL;
    X_ready : BOOL;
    Lift_ready : BOOL;
    pocket_ready : BOOL;
    b_ready : BOOL;
    pocket_retracted : BOOL;
    ready : BOOL;
    BOOL_dest_ready : BOOL;
    val : REAL;
END_VAR

IF D100 > 0 AND r0_state = 0 THEN r0_state := 1; END_IF
IF D100 = 0 THEN r0_state := 0; END_IF
IF D120 > 0 AND r1_state = 0 THEN r1_state := 1; END_IF
IF D120 = 0 THEN r1_state := 0; END_IF

IF sh_state = 0 THEN
    IF D90 > 0 THEN
        sh_req := D90;
        sh_action := 2; 
        IF D90 = D100 THEN
            IF X31 THEN sh_target_port := 1;
            ELSIF r0_state = 2 THEN sh_target_port := 3;
            ELSIF r0_state = 4 THEN
                sh_target_port := 4;
                IF D104 < 0 THEN sh_pocket := 0; ELSE sh_pocket := 1; END_IF
            ELSIF r0_state = 6 THEN sh_target_port := 1;
            END_IF
            sh_state := 1;
        ELSIF D90 = D120 THEN
            IF X35 THEN sh_target_port := 2;
            ELSIF r1_state = 2 THEN sh_target_port := 3;
            ELSIF r1_state = 4 THEN
                sh_target_port := 4;
                IF D124 < 0 THEN sh_pocket := 0; ELSE sh_pocket := 1; END_IF
            ELSIF r1_state = 6 THEN sh_target_port := 2;
            END_IF
            sh_state := 1;
        END_IF
    ELSE
        IF cell4_state = 4 THEN
            sh_target_port := 4;
            sh_action := 1;
            sh_req := cell4_req;
            sh_pocket := cell4_active_pocket;
            sh_state := 1;
        ELSIF cell3_state = 4 THEN
            BOOL_dest_ready := FALSE;
            IF cell3_req = D100 THEN
                IF X31 OR cell4_state = 0 THEN BOOL_dest_ready := TRUE; END_IF
            ELSIF cell3_req = D120 THEN
                IF X35 OR cell4_state = 0 THEN BOOL_dest_ready := TRUE; END_IF
            END_IF
            IF BOOL_dest_ready THEN
                sh_target_port := 3;
                sh_action := 1;
                sh_req := cell3_req;
                sh_state := 1;
            END_IF
        ELSIF r0_state = 1 AND cell3_state = 0 THEN
            sh_target_port := 1;
            sh_action := 1;
            sh_req := D100;
            sh_state := 1;
        ELSIF r1_state = 1 AND cell3_state = 0 THEN
            sh_target_port := 2;
            sh_action := 1;
            sh_req := D120;
            sh_state := 1;
        END_IF
    END_IF
END_IF

a_target_val := 0;
IF sh_state > 0 THEN
    IF sh_target_port = 1 THEN a_target_val := -405000;
    ELSIF sh_target_port = 2 THEN a_target_val := -185000;
    ELSIF sh_target_port = 3 THEN a_target_val := 0;
    ELSIF sh_target_port = 4 THEN a_target_val := 375000;
    END_IF
END_IF

IF sh_state >= 2 AND sh_state <= 4 AND (sh_target_port = 1 OR sh_target_port = 2) THEN
    lift_target := 95000;
ELSIF (D100 > 0 AND r0_state = 7) OR (D120 > 0 AND r1_state = 7) THEN
    lift_target := 40000;
ELSIF (D100 > 0 AND (r0_state = 1 OR r0_state = 6)) OR
      (D120 > 0 AND (r1_state = 1 OR r1_state = 6)) OR
      (sh_state > 0 AND (sh_target_port = 1 OR sh_target_port = 2)) THEN
    lift_target := 95000;
ELSE
    lift_target := 40000;
END_IF

IF sh_state = 1 THEN
    X_ready := ABS(D1000 - a_target_val) <= 20 AND ABS(D1001) <= 100;
    Lift_ready := TRUE;
    IF sh_target_port = 1 OR sh_target_port = 2 THEN
        Lift_ready := ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100;
    END_IF
    pocket_ready := TRUE;
    IF sh_target_port = 4 THEN
        IF sh_pocket = 0 THEN
            pocket_ready := ABS(D1028 - 18000) <= 20 AND ABS(D1029) <= 100;
        ELSE
            pocket_ready := ABS(D1032 - 18000) <= 20 AND ABS(D1033) <= 100;
        END_IF
    END_IF
    IF X_ready AND Lift_ready AND pocket_ready THEN
        sh_state := 2;
    END_IF
ELSIF sh_state = 2 THEN
    D81 := sh_target_port;
    D80 := sh_action;
    D82 := D82 + 1;
    sh_state := 3;
ELSIF sh_state = 3 THEN
    ready := FALSE;
    IF sh_target_port = 1 THEN ready := X61; END_IF
    IF sh_target_port = 2 THEN ready := X62; END_IF
    IF sh_target_port = 3 THEN ready := X63; END_IF
    IF sh_target_port = 4 THEN ready := X64; END_IF

    IF ready THEN
        b_target_val := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            IF (sh_action = 1 AND D90 = sh_req) OR (sh_action = 2 AND D90 = 0) THEN
                sh_state := 4;
            END_IF
        END_IF
    END_IF
ELSIF sh_state = 4 THEN
    b_target_val := 0;
    b_ready := ABS(D1004) <= 20 AND ABS(D1005) <= 100;
    pocket_retracted := TRUE;
    IF sh_target_port = 4 THEN
        IF sh_pocket = 0 THEN
            pocket_retracted := ABS(D1028) <= 20 AND ABS(D1029) <= 100;
        ELSE
            pocket_retracted := ABS(D1032) <= 20 AND ABS(D1033) <= 100;
        END_IF
    END_IF
    IF b_ready AND pocket_retracted THEN
        sh_state := 5;
    END_IF
ELSIF sh_state = 5 THEN
    IF sh_action = 1 THEN
        IF sh_target_port = 1 THEN r0_state := 2;
        ELSIF sh_target_port = 2 THEN r1_state := 2;
        ELSIF sh_target_port = 3 THEN
            IF cell3_req = D100 THEN
                IF X31 THEN r0_state := 6; ELSE r0_state := 4; END_IF
            ELSIF cell3_req = D120 THEN
                IF X35 THEN r1_state := 6; ELSE r1_state := 4; END_IF
            END_IF
            cell3_state := 0;
            cell3_req := 0;
        ELSIF sh_target_port = 4 THEN
            IF cell4_req = D100 THEN r0_state := 6;
            ELSIF cell4_req = D120 THEN r1_state := 6;
            END_IF
            cell4_state := 0;
            cell4_req := 0;
        END_IF
    ELSIF sh_action = 2 THEN
        IF sh_target_port = 1 THEN r0_state := 7;
        ELSIF sh_target_port = 2 THEN r1_state := 7;
        ELSIF sh_target_port = 3 THEN
            cell3_req := sh_req;
            cell3_state := 1;
            IF sh_req = D100 THEN r0_state := 3;
            ELSIF sh_req = D120 THEN r1_state := 3;
            END_IF
        ELSIF sh_target_port = 4 THEN
            cell4_req := sh_req;
            cell4_state := 1;
            cell4_active_pocket := sh_pocket;
            IF sh_req = D100 THEN r0_state := 5;
            ELSIF sh_req = D120 THEN r1_state := 5;
            END_IF
        END_IF
    END_IF
    sh_state := 0;
END_IF

IF cell3_state = 1 THEN
    D700 := cell3_req;
    Y70 := TRUE;
    Y71 := FALSE;
    cell3_state := 2;
ELSIF cell3_state = 2 THEN
    is_cancelled := FALSE;
    IF cell3_req = D100 AND X31 THEN is_cancelled := TRUE; END_IF
    IF cell3_req = D120 AND X35 THEN is_cancelled := TRUE; END_IF
    IF is_cancelled THEN
        Y70 := FALSE;
        cell3_state := 3;
    ELSIF X70 THEN
        Y70 := FALSE;
        Y71 := TRUE;
        cell3_state := 3;
    END_IF
ELSIF cell3_state = 3 THEN
    IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 THEN
        cell3_state := 4;
    END_IF
END_IF
IF cell3_state = 0 THEN
    Y70 := FALSE;
    Y71 := FALSE;
    D700 := 0;
END_IF

IF cell3_state = 2 THEN
    s3_0_t := D500;
    s3_1_t := D501;
ELSE
    s3_0_t := 0;
    s3_1_t := 0;
END_IF

val := SIN( REAL(D1016) * 0.00017453292 ) + SIN( REAL(D1020) * 0.00017453292 );
s3_2_t := DINT( -22500.0 * val );

IF cell4_state = 1 THEN
    D710 := cell4_req;
    Y75 := TRUE;
    Y76 := FALSE;
    cell4_state := 2;
ELSIF cell4_state = 2 THEN
    is_cancelled := FALSE;
    IF cell4_req = D100 AND X31 THEN is_cancelled := TRUE; END_IF
    IF cell4_req = D120 AND X35 THEN is_cancelled := TRUE; END_IF
    IF is_cancelled THEN
        Y75 := FALSE;
        cell4_state := 3;
    ELSIF X75 THEN
        Y75 := FALSE;
        Y76 := TRUE;
        cell4_state := 3;
    END_IF
ELSIF cell4_state = 3 THEN
    IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1036) <= 20 THEN
        cell4_state := 4;
    END_IF
END_IF
IF cell4_state = 0 THEN
    Y75 := FALSE;
    Y76 := FALSE;
    D710 := 0;
END_IF

s4_0_t := 0; s4_1_t := 0; s4_2_t := 0;
IF cell4_state = 2 THEN
    s4_0_t := D600;
    s4_1_t := D601;
    s4_2_t := D602;
ELSIF (sh_state = 1 OR sh_state = 2 OR sh_state = 3) AND sh_target_port = 4 THEN
    IF sh_pocket = 0 THEN
        s4_0_t := 18000;
    ELSIF sh_pocket = 1 THEN
        s4_1_t := 18000;
    END_IF
END_IF

IF r0_state = 7 THEN
    IF ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100 THEN
        r0_state := 8;
    END_IF
END_IF
IF r0_state = 8 THEN
    D300 := D100;
    IF X31 THEN D301 := 2; ELSE D301 := 1; END_IF
ELSE
    D300 := 0; D301 := 0;
END_IF

IF r1_state = 7 THEN
    IF ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100 THEN
        r1_state := 8;
    END_IF
END_IF
IF r1_state = 8 THEN
    D302 := D120;
    IF X35 THEN D303 := 2; ELSE D303 := 1; END_IF
ELSE
    D302 := 0; D303 := 0;
END_IF

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000;
D2029 := 1000; D2033 := 1000; D2037 := 1000;

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0;
D2030 := 0; D2034 := 0; D2038 := 0;

Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE;
Y47 := TRUE; Y48 := TRUE; Y49 := TRUE;
Y30 := FALSE;

D2000 := a_target_val;
D2004 := b_target_val;
D2008 := lift_target;
D2012 := lift_target;
D2016 := s3_0_t;
D2020 := s3_1_t;
D2024 := s3_2_t;
D2028 := s4_0_t;
D2032 := s4_1_t;
D2036 := s4_2_t;

Y2 := X51 AND D100 = 0 AND D120 = 0 AND
      ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND
      ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND
      ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND
      ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1036) <= 20;

END_PROGRAM