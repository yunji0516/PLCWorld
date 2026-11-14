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

    init : INT := 0;
    
    state_1 : INT := 0;
    id_1 : DINT := 0;
    loc_1 : DINT := 0;
    jig_1_loc : INT := 0; 
    cancel_1 : BOOL := FALSE;
    status_1 : DINT := 1;
    c3_1_done : BOOL := FALSE;
    c4_1_rotated : BOOL := FALSE;
    c4_1_served : BOOL := FALSE;
    
    state_2 : INT := 0;
    id_2 : DINT := 0;
    loc_2 : DINT := 0;
    jig_2_loc : INT := 0;
    cancel_2 : BOOL := FALSE;
    status_2 : DINT := 1;
    c3_2_done : BOOL := FALSE;
    c4_2_rotated : BOOL := FALSE;
    c4_2_served : BOOL := FALSE;
    
    sh_owner : INT := 0;
    sh_state : INT := 0;
    sh_cmd_start : BOOL := FALSE;
    sh_cmd_action : DINT := 0;
    sh_cmd_station : DINT := 0;
    sh_done : BOOL := FALSE;
    port_rdy : BOOL := FALSE;
    expected_holding : DINT := 0;
    couple_seq_int : DINT := 0;
    
    m3_select_owner : INT := 0;
END_VAR

IF init == 0 THEN
    D2008 := 15000;
    D2012 := 15000;
    D2032 := 5000;
    D2000 := 0; D2004 := 0; D2016 := 0; D2020 := 0; D2024 := 0; D2028 := 0;
    D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
    D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000; D2033 := 1000;
    Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE; 
    Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE; Y48 := TRUE;
    init := 1;
END_IF;

IF sh_owner == 1 AND sh_done THEN
    IF sh_cmd_action == 1 THEN
        jig_1_loc := 1;
    ELSIF sh_cmd_action == 2 THEN
        IF sh_cmd_station == 3 THEN jig_1_loc := 2;
        ELSIF sh_cmd_station == 4 THEN jig_1_loc := 3;
        ELSE jig_1_loc := 0;
        END_IF;
    END_IF;
    sh_owner := 0;
    sh_done := FALSE;
    IF NOT cancel_1 AND state_1 > 0 AND state_1 < 10 THEN
        state_1 := state_1 + 1;
    END_IF;
END_IF;

IF sh_owner == 2 AND sh_done THEN
    IF sh_cmd_action == 1 THEN
        jig_2_loc := 1;
    ELSIF sh_cmd_action == 2 THEN
        IF sh_cmd_station == 3 THEN jig_2_loc := 2;
        ELSIF sh_cmd_station == 4 THEN jig_2_loc := 3;
        ELSE jig_2_loc := 0;
        END_IF;
    END_IF;
    sh_owner := 0;
    sh_done := FALSE;
    IF NOT cancel_2 AND state_2 > 0 AND state_2 < 10 THEN
        state_2 := state_2 + 1;
    END_IF;
END_IF;

IF X31 AND state_1 > 0 AND state_1 < 11 AND NOT cancel_1 THEN
    cancel_1 := TRUE;
END_IF;

IF X35 AND state_2 > 0 AND state_2 < 11 AND NOT cancel_2 THEN
    cancel_2 := TRUE;
END_IF;

IF NOT cancel_1 THEN
    CASE state_1 OF
        0: 
            IF D100 <> 0 THEN
                id_1 := D100; loc_1 := D101; state_1 := 1; jig_1_loc := 0; status_1 := 1;
            END_IF;
        1:
            IF loc_1 == 1 THEN
                D2008 := D92;
                IF ABS(D1008 - D92) <= 20 THEN state_1 := 2; END_IF;
            ELSE
                D2012 := D92;
                IF ABS(D1012 - D92) <= 20 THEN state_1 := 2; END_IF;
            END_IF;
        2:
            IF sh_owner == 0 THEN
                sh_owner := 1; sh_cmd_action := 1; sh_cmd_station := loc_1; sh_cmd_start := TRUE;
            END_IF;
        3:
            IF sh_owner == 0 THEN
                sh_owner := 1; sh_cmd_action := 2; sh_cmd_station := 3; sh_cmd_start := TRUE;
            END_IF;
        4:
            IF m3_select_owner == 0 OR m3_select_owner == 1 THEN
                m3_select_owner := 1;
                D700 := loc_1;
                IF loc_1 == 1 THEN
                    D2020 := D501;
                    IF ABS(D1020 - D501) <= 20 AND X70 THEN c3_1_done := TRUE; END_IF;
                    IF c3_1_done THEN
                        D2020 := 0;
                        IF ABS(D1020) <= 20 THEN
                            c3_1_done := FALSE; m3_select_owner := 0; state_1 := 5;
                        END_IF;
                    END_IF;
                ELSE
                    D2024 := D502;
                    IF ABS(D1024 - D502) <= 20 AND X70 THEN c3_1_done := TRUE; END_IF;
                    IF c3_1_done THEN
                        D2024 := 0;
                        IF ABS(D1024) <= 20 THEN
                            c3_1_done := FALSE; m3_select_owner := 0; state_1 := 5;
                        END_IF;
                    END_IF;
                END_IF;
            END_IF;
        5:
            IF sh_owner == 0 THEN
                sh_owner := 1; sh_cmd_action := 1; sh_cmd_station := 3; sh_cmd_start := TRUE;
            END_IF;
        6:
            IF sh_owner == 0 THEN
                sh_owner := 1; sh_cmd_action := 2; sh_cmd_station := 4; sh_cmd_start := TRUE;
            END_IF;
        7:
            IF NOT c4_1_rotated THEN
                D2032 := 5000;
                IF ABS(D1032 - 5000) <= 20 THEN
                    D2028 := D600;
                    IF ABS(D1028 - D600) <= 20 THEN c4_1_rotated := TRUE; END_IF;
                END_IF;
            ELSIF NOT c4_1_served THEN
                D2032 := 70000;
                IF ABS(D1032 - 70000) <= 20 AND X75 THEN c4_1_served := TRUE; END_IF;
            ELSE
                D2032 := 5000;
                IF ABS(D1032 - 5000) <= 20 THEN
                    D2028 := 0;
                    IF ABS(D1028) <= 20 THEN
                        c4_1_rotated := FALSE; c4_1_served := FALSE; state_1 := 8;
                    END_IF;
                END_IF;
            END_IF;
        8:
            IF sh_owner == 0 THEN
                sh_owner := 1; sh_cmd_action := 1; sh_cmd_station := 4; sh_cmd_start := TRUE;
            END_IF;
        9:
            IF sh_owner == 0 THEN
                sh_owner := 1; sh_cmd_action := 2; sh_cmd_station := loc_1; sh_cmd_start := TRUE;
            END_IF;
        10:
            IF loc_1 == 1 THEN
                D2008 := 15000;
                IF ABS(D1008 - 15000) <= 20 THEN state_1 := 11; END_IF;
            ELSE
                D2012 := 15000;
                IF ABS(D1012 - 15000) <= 20 THEN state_1 := 11; END_IF;
            END_IF;
        11:
            D300 := id_1; D301 := status_1;
            IF X30 THEN D300 := 0; state_1 := 12; END_IF;
        12:
            IF D100 == 0 OR D100 <> id_1 THEN state_1 := 0; END_IF;
    END_CASE;
ELSE
    CASE jig_1_loc OF
        3:
            IF ABS(D1032 - 5000) > 20 OR ABS(D1028) > 20 THEN
                D2032 := 5000;
                IF ABS(D1032 - 5000) <= 20 THEN D2028 := 0; END_IF;
            ELSE
                IF sh_owner == 0 THEN sh_owner := 1; sh_cmd_action := 1; sh_cmd_station := 4; sh_cmd_start := TRUE; END_IF;
            END_IF;
        2:
            IF m3_select_owner == 0 OR m3_select_owner == 1 THEN
                m3_select_owner := 1; D700 := loc_1;
                IF loc_1 == 1 THEN
                    D2020 := 0;
                    IF ABS(D1020) <= 20 THEN
                        m3_select_owner := 0;
                        IF sh_owner == 0 THEN sh_owner := 1; sh_cmd_action := 1; sh_cmd_station := 3; sh_cmd_start := TRUE; END_IF;
                    END_IF;
                ELSE
                    D2024 := 0;
                    IF ABS(D1024) <= 20 THEN
                        m3_select_owner := 0;
                        IF sh_owner == 0 THEN sh_owner := 1; sh_cmd_action := 1; sh_cmd_station := 3; sh_cmd_start := TRUE; END_IF;
                    END_IF;
                END_IF;
            END_IF;
        1:
            IF sh_owner == 0 THEN sh_owner := 1; sh_cmd_action := 2; sh_cmd_station := loc_1; sh_cmd_start := TRUE; END_IF;
        0:
            cancel_1 := FALSE; state_1 := 10; status_1 := 2;
    END_CASE;
END_IF;

IF NOT cancel_2 THEN
    CASE state_2 OF
        0: 
            IF D120 <> 0 THEN
                id_2 := D120; loc_2 := D121; state_2 := 1; jig_2_loc := 0; status_2 := 1;
            END_IF;
        1:
            IF loc_2 == 1 THEN
                D2008 := D92;
                IF ABS(D1008 - D92) <= 20 THEN state_2 := 2; END_IF;
            ELSE
                D2012 := D92;
                IF ABS(D1012 - D92) <= 20 THEN state_2 := 2; END_IF;
            END_IF;
        2:
            IF sh_owner == 0 THEN
                sh_owner := 2; sh_cmd_action := 1; sh_cmd_station := loc_2; sh_cmd_start := TRUE;
            END_IF;
        3:
            IF sh_owner == 0 THEN
                sh_owner := 2; sh_cmd_action := 2; sh_cmd_station := 3; sh_cmd_start := TRUE;
            END_IF;
        4:
            IF m3_select_owner == 0 OR m3_select_owner == 2 THEN
                m3_select_owner := 2;
                D700 := loc_2;
                IF loc_2 == 1 THEN
                    D2020 := D501;
                    IF ABS(D1020 - D501) <= 20 AND X70 THEN c3_2_done := TRUE; END_IF;
                    IF c3_2_done THEN
                        D2020 := 0;
                        IF ABS(D1020) <= 20 THEN
                            c3_2_done := FALSE; m3_select_owner := 0; state_2 := 5;
                        END_IF;
                    END_IF;
                ELSE
                    D2024 := D502;
                    IF ABS(D1024 - D502) <= 20 AND X70 THEN c3_2_done := TRUE; END_IF;
                    IF c3_2_done THEN
                        D2024 := 0;
                        IF ABS(D1024) <= 20 THEN
                            c3_2_done := FALSE; m3_select_owner := 0; state_2 := 5;
                        END_IF;
                    END_IF;
                END_IF;
            END_IF;
        5:
            IF sh_owner == 0 THEN
                sh_owner := 2; sh_cmd_action := 1; sh_cmd_station := 3; sh_cmd_start := TRUE;
            END_IF;
        6:
            IF sh_owner == 0 THEN
                sh_owner := 2; sh_cmd_action := 2; sh_cmd_station := 4; sh_cmd_start := TRUE;
            END_IF;
        7:
            IF NOT c4_2_rotated THEN
                D2032 := 5000;
                IF ABS(D1032 - 5000) <= 20 THEN
                    D2028 := D600;
                    IF ABS(D1028 - D600) <= 20 THEN c4_2_rotated := TRUE; END_IF;
                END_IF;
            ELSIF NOT c4_2_served THEN
                D2032 := 70000;
                IF ABS(D1032 - 70000) <= 20 AND X75 THEN c4_2_served := TRUE; END_IF;
            ELSE
                D2032 := 5000;
                IF ABS(D1032 - 5000) <= 20 THEN
                    D2028 := 0;
                    IF ABS(D1028) <= 20 THEN
                        c4_2_rotated := FALSE; c4_2_served := FALSE; state_2 := 8;
                    END_IF;
                END_IF;
            END_IF;
        8:
            IF sh_owner == 0 THEN
                sh_owner := 2; sh_cmd_action := 1; sh_cmd_station := 4; sh_cmd_start := TRUE;
            END_IF;
        9:
            IF sh_owner == 0 THEN
                sh_owner := 2; sh_cmd_action := 2; sh_cmd_station := loc_2; sh_cmd_start := TRUE;
            END_IF;
        10:
            IF loc_2 == 1 THEN
                D2008 := 15000;
                IF ABS(D1008 - 15000) <= 20 THEN state_2 := 11; END_IF;
            ELSE
                D2012 := 15000;
                IF ABS(D1012 - 15000) <= 20 THEN state_2 := 11; END_IF;
            END_IF;
        11:
            D302 := id_2; D303 := status_2;
            IF X34 THEN D302 := 0; state_2 := 12; END_IF;
        12:
            IF D120 == 0 OR D120 <> id_2 THEN state_2 := 0; END_IF;
    END_CASE;
ELSE
    CASE jig_2_loc OF
        3:
            IF ABS(D1032 - 5000) > 20 OR ABS(D1028) > 20 THEN
                D2032 := 5000;
                IF ABS(D1032 - 5000) <= 20 THEN D2028 := 0; END_IF;
            ELSE
                IF sh_owner == 0 THEN sh_owner := 2; sh_cmd_action := 1; sh_cmd_station := 4; sh_cmd_start := TRUE; END_IF;
            END_IF;
        2:
            IF m3_select_owner == 0 OR m3_select_owner == 2 THEN
                m3_select_owner := 2; D700 := loc_2;
                IF loc_2 == 1 THEN
                    D2020 := 0;
                    IF ABS(D1020) <= 20 THEN
                        m3_select_owner := 0;
                        IF sh_owner == 0 THEN sh_owner := 2; sh_cmd_action := 1; sh_cmd_station := 3; sh_cmd_start := TRUE; END_IF;
                    END_IF;
                ELSE
                    D2024 := 0;
                    IF ABS(D1024) <= 20 THEN
                        m3_select_owner := 0;
                        IF sh_owner == 0 THEN sh_owner := 2; sh_cmd_action := 1; sh_cmd_station := 3; sh_cmd_start := TRUE; END_IF;
                    END_IF;
                END_IF;
            END_IF;
        1:
            IF sh_owner == 0 THEN sh_owner := 2; sh_cmd_action := 2; sh_cmd_station := loc_2; sh_cmd_start := TRUE; END_IF;
        0:
            cancel_2 := FALSE; state_2 := 10; status_2 := 2;
    END_CASE;
END_IF;

IF sh_state == 0 AND sh_cmd_start THEN
    sh_state := 1;
    sh_cmd_start := FALSE;
END_IF;

IF sh_state == 1 THEN
    IF sh_cmd_station == 1 THEN D2000 := D403; port_rdy := X61;
    ELSIF sh_cmd_station == 2 THEN D2000 := D406; port_rdy := X62;
    ELSIF sh_cmd_station == 3 THEN D2000 := D409; port_rdy := X63;
    ELSIF sh_cmd_station == 4 THEN D2000 := D412; port_rdy := X64;
    END_IF;
    
    IF ABS(D1000 - D2000) <= 20 AND ABS(D1001) <= 100 THEN
        IF sh_cmd_station == 3 THEN
            IF m3_select_owner == 0 OR m3_select_owner == sh_owner THEN
                m3_select_owner := sh_owner;
                IF sh_owner == 1 THEN D700 := loc_1; ELSE D700 := loc_2; END_IF;
            END_IF;
        END_IF;
        IF port_rdy THEN
            IF sh_cmd_station <> 3 OR (m3_select_owner == sh_owner AND ABS(D1020) <= 20 AND ABS(D1024) <= 20) THEN
                sh_state := 2;
            END_IF;
        END_IF;
    END_IF;
END_IF;

IF sh_state == 2 THEN
    D2004 := 18000;
    IF D1004 >= 17980 THEN
        D80 := sh_cmd_action;
        D81 := sh_cmd_station;
        couple_seq_int := couple_seq_int + 1;
        D82 := couple_seq_int;
        sh_state := 3;
    END_IF;
END_IF;

IF sh_state == 3 THEN
    expected_holding := 0;
    IF sh_cmd_action == 1 THEN
        IF sh_owner == 1 THEN expected_holding := id_1; ELSE expected_holding := id_2; END_IF;
    END_IF;
    
    IF D90 == expected_holding THEN
        sh_state := 4;
    END_IF;
END_IF;

IF sh_state == 4 THEN
    D2004 := 0;
    IF D1004 <= 20 THEN
        IF sh_cmd_station == 3 THEN m3_select_owner := 0; END_IF;
        sh_state := 5;
    END_IF;
END_IF;

IF sh_state == 5 THEN
    sh_done := TRUE;
END_IF;

IF jig_1_loc == 2 OR jig_2_loc == 2 THEN
    Y70 := TRUE; Y71 := TRUE;
ELSE
    Y70 := FALSE; Y71 := FALSE;
END_IF;

IF jig_1_loc == 3 OR jig_2_loc == 3 THEN
    Y75 := TRUE; Y76 := TRUE;
ELSE
    Y75 := FALSE; Y76 := FALSE;
END_IF;

IF X51 AND state_1 == 0 AND state_2 == 0 AND sh_state == 0 THEN
    D2000 := 0; D2004 := 0; D2008 := 15000; D2012 := 15000;
    D2016 := 0; D2020 := 0; D2024 := 0; D2028 := 0; D2032 := 5000;
    
    IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032 - 5000) <= 20 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM