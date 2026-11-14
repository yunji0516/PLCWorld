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

    r0_id : DINT;
    r0_step : DINT;
    r1_id : DINT;
    r1_step : DINT;
    
    shuttle_state : DINT;
    shuttle_target_port : DINT;
    shuttle_target_action : DINT;
    shuttle_target_station : DINT;
    shuttle_expected_d90 : DINT;
    held_id : DINT;
    
    target_m3_select : DINT := 1;
    current_m3_select : DINT := 1;
    
    c3_state : DINT;
    c3_r0_done : BOOL;
    c3_r1_done : BOOL;
    
    c4_state : DINT;
    c4_req : DINT;
    c4_r0_done : BOOL;
    c4_r1_done : BOOL;
    
    cell3_free : BOOL;
    cell4_free : BOOL;
END_VAR

Y40 := TRUE; D2001 := 1000;
Y41 := TRUE; D2005 := 1000;
Y42 := TRUE; D2009 := 1000;
Y43 := TRUE; D2013 := 1000;
Y44 := TRUE; D2017 := 1000;
Y45 := TRUE; D2021 := 1000;
Y46 := TRUE; D2025 := 1000;
Y47 := TRUE; D2029 := 1000;
Y48 := TRUE; D2033 := 1000;
Y30 := FALSE; 

IF D100 > 0 AND r0_step == 0 AND D300 == 0 THEN
    r0_id := D100;
    r0_step := 1;
END_IF;

IF D120 > 0 AND r1_step == 0 AND D302 == 0 THEN
    r1_id := D120;
    r1_step := 1;
END_IF;

cell3_free := (r0_step <> 3) AND (r1_step <> 3);
cell4_free := (r0_step <> 5) AND (r1_step <> 5);

IF shuttle_state == 0 THEN
    held_id := D90;
    IF D90 == 0 THEN
        IF r0_step == 5 AND c4_r0_done THEN
            shuttle_target_port := D412;
            shuttle_target_action := 1;
            shuttle_target_station := 4;
            shuttle_expected_d90 := r0_id;
            shuttle_state := 1;
        ELSIF r1_step == 5 AND c4_r1_done THEN
            shuttle_target_port := D412;
            shuttle_target_action := 1;
            shuttle_target_station := 4;
            shuttle_expected_d90 := r1_id;
            shuttle_state := 1;
        ELSIF r0_step == 3 AND c3_r0_done AND (X31 OR cell4_free) THEN
            shuttle_target_port := D409;
            shuttle_target_action := 1;
            shuttle_target_station := 3;
            shuttle_expected_d90 := r0_id;
            target_m3_select := 1;
            shuttle_state := 1;
        ELSIF r1_step == 3 AND c3_r1_done AND (X35 OR cell4_free) THEN
            shuttle_target_port := D409;
            shuttle_target_action := 1;
            shuttle_target_station := 3;
            shuttle_expected_d90 := r1_id;
            target_m3_select := 2;
            shuttle_state := 1;
        ELSIF r0_step == 1 AND ABS(D1008 - D92) <= 20 AND D1009 == 0 AND cell3_free THEN
            shuttle_target_port := D403;
            shuttle_target_action := 1;
            shuttle_target_station := 1;
            shuttle_expected_d90 := r0_id;
            shuttle_state := 1;
        ELSIF r1_step == 1 AND ABS(D1012 - D92) <= 20 AND D1013 == 0 AND cell3_free THEN
            shuttle_target_port := D406;
            shuttle_target_action := 1;
            shuttle_target_station := 2;
            shuttle_expected_d90 := r1_id;
            shuttle_state := 1;
        END_IF;
    ELSE
        IF D90 == r0_id THEN
            IF r0_step == 2 THEN
                IF X31 THEN
                    shuttle_target_port := D403;
                    shuttle_target_action := 2;
                    shuttle_target_station := 1;
                ELSE
                    shuttle_target_port := D409;
                    shuttle_target_action := 2;
                    shuttle_target_station := 3;
                    target_m3_select := 1;
                END_IF;
            ELSIF r0_step == 4 THEN
                IF X31 THEN
                    shuttle_target_port := D403;
                    shuttle_target_action := 2;
                    shuttle_target_station := 1;
                ELSE
                    shuttle_target_port := D412;
                    shuttle_target_action := 2;
                    shuttle_target_station := 4;
                END_IF;
            ELSIF r0_step == 6 THEN
                shuttle_target_port := D403;
                shuttle_target_action := 2;
                shuttle_target_station := 1;
            END_IF;
            shuttle_expected_d90 := 0;
            shuttle_state := 1;
        ELSIF D90 == r1_id THEN
            IF r1_step == 2 THEN
                IF X35 THEN
                    shuttle_target_port := D406;
                    shuttle_target_action := 2;
                    shuttle_target_station := 2;
                ELSE
                    shuttle_target_port := D409;
                    shuttle_target_action := 2;
                    shuttle_target_station := 3;
                    target_m3_select := 2;
                END_IF;
            ELSIF r1_step == 4 THEN
                IF X35 THEN
                    shuttle_target_port := D406;
                    shuttle_target_action := 2;
                    shuttle_target_station := 2;
                ELSE
                    shuttle_target_port := D412;
                    shuttle_target_action := 2;
                    shuttle_target_station := 4;
                END_IF;
            ELSIF r1_step == 6 THEN
                shuttle_target_port := D406;
                shuttle_target_action := 2;
                shuttle_target_station := 2;
            END_IF;
            shuttle_expected_d90 := 0;
            shuttle_state := 1;
        END_IF;
    END_IF;
END_IF;

CASE shuttle_state OF
    1: 
        D2000 := shuttle_target_port;
        IF ABS(D1000 - shuttle_target_port) <= 20 AND D1001 == 0 THEN
            IF shuttle_target_station == 1 THEN
                IF ABS(D1008 - D92) <= 20 AND D1009 == 0 THEN shuttle_state := 2; END_IF;
            ELSIF shuttle_target_station == 2 THEN
                IF ABS(D1012 - D92) <= 20 AND D1013 == 0 THEN shuttle_state := 2; END_IF;
            ELSIF shuttle_target_station == 3 THEN
                IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND current_m3_select == target_m3_select THEN
                    shuttle_state := 2;
                END_IF;
            ELSIF shuttle_target_station == 4 THEN
                IF ABS(D1028) <= 20 AND ABS(D1032 - 5000) <= 20 THEN
                    shuttle_state := 2;
                END_IF;
            END_IF;
        END_IF;
    2: 
        D2004 := 18000;
        IF ABS(D1004 - 18000) <= 20 AND D1005 == 0 THEN
            shuttle_state := 3;
        END_IF;
    3: 
        D80 := shuttle_target_action;
        D81 := shuttle_target_station;
        D82 := D82 + 1;
        shuttle_state := 4;
    4: 
        IF D90 == shuttle_expected_d90 THEN
            shuttle_state := 5;
        END_IF;
    5: 
        D2004 := 0;
        IF ABS(D1004) <= 20 AND D1005 == 0 THEN
            shuttle_state := 6;
        END_IF;
    6: 
        IF shuttle_target_action == 1 THEN
            IF shuttle_expected_d90 == r0_id THEN r0_step := r0_step + 1;
            ELSIF shuttle_expected_d90 == r1_id THEN r1_step := r1_step + 1; END_IF;
        ELSE
            IF held_id == r0_id THEN
                IF shuttle_target_station == 3 THEN r0_step := 3;
                ELSIF shuttle_target_station == 4 THEN r0_step := 5;
                ELSIF shuttle_target_station == 1 THEN r0_step := 7; END_IF;
            ELSIF held_id == r1_id THEN
                IF shuttle_target_station == 3 THEN r1_step := 3;
                ELSIF shuttle_target_station == 4 THEN r1_step := 5;
                ELSIF shuttle_target_station == 2 THEN r1_step := 7; END_IF;
            END_IF;
        END_IF;
        shuttle_state := 0;
END_CASE;

IF r0_step == 1 OR r0_step == 6 OR ((r0_step == 2 OR r0_step == 4) AND X31) THEN
    D2008 := D92;
ELSIF r0_step == 7 THEN
    D2008 := 15000;
ELSE
    D2008 := 15000;
END_IF;

IF r1_step == 1 OR r1_step == 6 OR ((r1_step == 2 OR r1_step == 4) AND X35) THEN
    D2012 := D92;
ELSIF r1_step == 7 THEN
    D2012 := 15000;
ELSE
    D2012 := 15000;
END_IF;

IF target_m3_select <> current_m3_select THEN
    IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 THEN
        current_m3_select := target_m3_select;
    END_IF;
END_IF;
D700 := current_m3_select;

CASE c3_state OF
    0:
        D2016 := 0;
        D2020 := 0;
        D2024 := 0;
        Y70 := FALSE;
        Y71 := FALSE;
        IF r0_step == 3 AND NOT c3_r0_done THEN
            c3_state := 1;
        ELSIF r1_step == 3 AND NOT c3_r1_done THEN
            c3_state := 2;
        END_IF;
    1:
        Y70 := TRUE;
        Y71 := TRUE;
        D2020 := D501;
        IF X31 OR X70 THEN c3_state := 3; END_IF;
    2:
        Y70 := TRUE;
        Y71 := TRUE;
        D2024 := D502;
        IF X35 OR X70 THEN c3_state := 4; END_IF;
    3:
        Y70 := TRUE;
        Y71 := TRUE;
        D2020 := 0;
        IF ABS(D1020) <= 20 THEN
            c3_r0_done := TRUE;
            c3_state := 0;
        END_IF;
    4:
        Y70 := TRUE;
        Y71 := TRUE;
        D2024 := 0;
        IF ABS(D1024) <= 20 THEN
            c3_r1_done := TRUE;
            c3_state := 0;
        END_IF;
END_CASE;

IF r0_step == 4 THEN c3_r0_done := FALSE; END_IF;
IF r1_step == 4 THEN c3_r1_done := FALSE; END_IF;

CASE c4_state OF
    0:
        D2028 := 0;
        D2032 := 5000;
        Y75 := FALSE;
        Y76 := FALSE;
        IF r0_step == 5 AND NOT c4_r0_done THEN
            c4_req := 0;
            c4_state := 1;
        ELSIF r1_step == 5 AND NOT c4_r1_done THEN
            c4_req := 1;
            c4_state := 1;
        END_IF;
    1:
        Y75 := TRUE;
        Y76 := TRUE;
        D2028 := D600;
        D2032 := 5000;
        IF ABS(D1028 - D600) <= 20 AND ABS(D1032 - 5000) <= 20 THEN
            IF (c4_req == 0 AND X31) OR (c4_req == 1 AND X35) THEN
                c4_state := 3;
            ELSE
                c4_state := 2;
            END_IF;
        END_IF;
    2:
        Y75 := TRUE;
        Y76 := TRUE;
        D2032 := 70000;
        IF X75 OR (c4_req == 0 AND X31) OR (c4_req == 1 AND X35) THEN
            c4_state := 3;
        END_IF;
    3:
        Y75 := TRUE;
        Y76 := TRUE;
        D2032 := 5000;
        IF ABS(D1032 - 5000) <= 20 THEN
            c4_state := 4;
        END_IF;
    4:
        Y75 := TRUE;
        Y76 := TRUE;
        D2028 := 0;
        IF ABS(D1028) <= 20 THEN
            IF c4_req == 0 THEN c4_r0_done := TRUE; ELSE c4_r1_done := TRUE; END_IF;
            c4_state := 0;
        END_IF;
END_CASE;

IF r0_step == 6 THEN c4_r0_done := FALSE; END_IF;
IF r1_step == 6 THEN c4_r1_done := FALSE; END_IF;

IF r0_step == 7 THEN
    IF ABS(D1008 - 15000) <= 20 AND D1009 == 0 THEN
        r0_step := 8;
    END_IF;
END_IF;

IF r0_step == 8 THEN
    D300 := r0_id;
    IF X31 THEN D301 := 2; ELSE D301 := 1; END_IF;
    IF D100 == 0 THEN
        r0_step := 0;
        D300 := 0;
        D301 := 0;
    END_IF;
END_IF;

IF r1_step == 7 THEN
    IF ABS(D1012 - 15000) <= 20 AND D1013 == 0 THEN
        r1_step := 8;
    END_IF;
END_IF;

IF r1_step == 8 THEN
    D302 := r1_id;
    IF X35 THEN D303 := 2; ELSE D303 := 1; END_IF;
    IF D120 == 0 THEN
        r1_step := 0;
        D302 := 0;
        D303 := 0;
    END_IF;
END_IF;

IF X51 THEN
    IF shuttle_state == 0 THEN
        D2000 := 0;
        D2004 := 0;
    END_IF;
    
    IF ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND 
       ABS(D1008 - 15000) <= 20 AND ABS(D1012 - 15000) <= 20 AND
       ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND
       ABS(D1028) <= 20 AND ABS(D1032 - 5000) <= 20 THEN
       Y2 := TRUE;
    ELSE
       Y2 := FALSE;
    END_IF;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM