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
    
    state : ARRAY[0..1] OF DINT;
    is_canc : ARRAY[0..1] OF BOOL;
    shuttle_owner : DINT := 0;
    cell3_owner : DINT := 0;
    cell4_owner : DINT := 0;
    couple_seq : DINT := 1;
    active_action : DINT := 0;
    active_station : DINT := 0;
    shuttle_target : DINT := 0;
    b_target_val : DINT := 0;
    s3_1_target_val : DINT := 0;
    s3_2_target_val : DINT := 0;
    s4_0_target_val : DINT := 0;
    s4_1_target_val : DINT := 0;
    cell4_sync : BOOL := FALSE;
    i : DINT;
    id : DINT;
    loc : DINT;
    canc : BOOL;
    target_x : DINT;
    p1_x : DINT;
    p2_x : DINT;
    p3_x : DINT;
    p4_x : DINT;
END_VAR

p1_x := D403;
p2_x := D406;
p3_x := D409;
p4_x := D412;

cell4_sync := FALSE;
s3_1_target_val := 0;
s3_2_target_val := 0;

FOR i := 0 TO 1 DO
    IF i = 0 THEN
        id := D100;
        loc := D101;
        canc := X31;
    ELSE
        id := D120;
        loc := D121;
        canc := X35;
    END_IF
    
    IF id = 0 THEN
        state[i] := 0;
        is_canc[i] := FALSE;
        IF i = 0 THEN 
            D300 := 0; D301 := 0; 
        ELSE 
            D302 := 0; D303 := 0; 
        END_IF
        CONTINUE;
    END_IF
    
    IF canc THEN
        is_canc[i] := TRUE;
    END_IF
    
    IF is_canc[i] THEN
        IF state[i] = 3 THEN state[i] := 15; END_IF
        IF state[i] = 5 THEN state[i] := 6; END_IF
        IF state[i] = 9 THEN state[i] := 15; END_IF
        IF state[i] = 11 THEN state[i] := 12; END_IF
    END_IF
    
    CASE state[i] OF
        0:
            IF id > 0 THEN
                state[i] := 1;
            END_IF
            
        1:
            IF shuttle_owner = 0 OR shuttle_owner = (i+1) THEN
                shuttle_owner := i+1;
                IF loc = 1 THEN target_x := p1_x; ELSIF loc = 2 THEN target_x := p2_x; ELSE target_x := 0; END_IF
                shuttle_target := target_x;
                IF ABS(D1000 - target_x) <= 20 AND ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 THEN
                    b_target_val := 18000;
                    IF D1004 >= 17980 THEN
                        state[i] := 2;
                        active_action := 1;
                        active_station := loc;
                        couple_seq := couple_seq + 1;
                    END_IF
                ELSE
                    b_target_val := 0;
                END_IF
            END_IF
            
        2:
            IF D90 = id THEN
                b_target_val := 0;
                IF D1004 <= 20 THEN
                    IF is_canc[i] THEN state[i] := 15; ELSE state[i] := 3; END_IF
                END_IF
            ELSE
                b_target_val := 18000;
            END_IF
            
        3:
            IF (cell3_owner = 0 OR cell3_owner = (i+1)) AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 THEN
                shuttle_target := p3_x;
                IF ABS(D1000 - p3_x) <= 20 THEN
                    b_target_val := 18000;
                    IF D1004 >= 17980 THEN
                        state[i] := 4;
                        active_action := 2; 
                        active_station := 3;
                        couple_seq := couple_seq + 1;
                    END_IF
                ELSE
                    b_target_val := 0;
                END_IF
            END_IF
            
        4:
            IF D90 = 0 THEN
                b_target_val := 0;
                IF D1004 <= 20 THEN
                    cell3_owner := i+1;
                    shuttle_owner := 0;
                    state[i] := 5;
                END_IF
            ELSE
                b_target_val := 18000;
            END_IF
            
        5:
            s3_1_target_val := D501;
            s3_2_target_val := D502;
            IF X70 THEN
                state[i] := 6;
            END_IF
            
        6:
            s3_1_target_val := 0;
            s3_2_target_val := 0;
            IF ABS(D1020) <= 20 AND ABS(D1024) <= 20 THEN
                state[i] := 7;
            END_IF
            
        7:
            IF shuttle_owner = 0 OR shuttle_owner = (i+1) THEN
                shuttle_owner := i+1;
                shuttle_target := p3_x;
                IF ABS(D1000 - p3_x) <= 20 THEN
                    b_target_val := 18000;
                    IF D1004 >= 17980 THEN
                        state[i] := 8;
                        active_action := 1; 
                        active_station := 3;
                        couple_seq := couple_seq + 1;
                    END_IF
                ELSE
                    b_target_val := 0;
                END_IF
            END_IF
            
        8:
            IF D90 = id THEN
                b_target_val := 0;
                IF D1004 <= 20 THEN
                    cell3_owner := 0;
                    IF is_canc[i] THEN state[i] := 15; ELSE state[i] := 9; END_IF
                END_IF
            ELSE
                b_target_val := 18000;
            END_IF
            
        9:
            IF (cell4_owner = 0 OR cell4_owner = (i+1)) AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
                shuttle_target := p4_x;
                IF ABS(D1000 - p4_x) <= 20 THEN
                    b_target_val := 18000;
                    IF D1004 >= 17980 THEN
                        state[i] := 10;
                        active_action := 2; 
                        active_station := 4;
                        couple_seq := couple_seq + 1;
                    END_IF
                ELSE
                    b_target_val := 0;
                END_IF
            END_IF
            
        10:
            IF D90 = 0 THEN
                b_target_val := 0;
                IF D1004 <= 20 THEN
                    cell4_owner := i+1;
                    shuttle_owner := 0;
                    state[i] := 11;
                END_IF
            ELSE
                b_target_val := 18000;
            END_IF
            
        11:
            cell4_sync := TRUE;
            IF X75 THEN
                state[i] := 12;
            END_IF
            
        12:
            s4_0_target_val := 0;
            s4_1_target_val := 0;
            IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN
                state[i] := 13;
            END_IF
            
        13:
            IF shuttle_owner = 0 OR shuttle_owner = (i+1) THEN
                shuttle_owner := i+1;
                shuttle_target := p4_x;
                IF ABS(D1000 - p4_x) <= 20 THEN
                    b_target_val := 18000;
                    IF D1004 >= 17980 THEN
                        state[i] := 14;
                        active_action := 1; 
                        active_station := 4;
                        couple_seq := couple_seq + 1;
                    END_IF
                ELSE
                    b_target_val := 0;
                END_IF
            END_IF
            
        14:
            IF D90 = id THEN
                b_target_val := 0;
                IF D1004 <= 20 THEN
                    cell4_owner := 0;
                    state[i] := 15;
                END_IF
            ELSE
                b_target_val := 18000;
            END_IF
            
        15:
            IF loc = 1 THEN target_x := p1_x; ELSIF loc = 2 THEN target_x := p2_x; ELSE target_x := 0; END_IF
            shuttle_target := target_x;
            IF ABS(D1000 - target_x) <= 20 THEN
                b_target_val := 18000;
                IF D1004 >= 17980 THEN
                    state[i] := 16;
                    active_action := 2; 
                    active_station := loc;
                    couple_seq := couple_seq + 1;
                END_IF
            ELSE
                b_target_val := 0;
            END_IF
            
        16:
            IF D90 = 0 THEN
                b_target_val := 0;
                IF D1004 <= 20 THEN
                    shuttle_owner := 0;
                    state[i] := 17;
                END_IF
            ELSE
                b_target_val := 18000;
            END_IF
            
        17:
            IF i = 0 THEN
                D300 := id;
                D301 := SEL(is_canc[i], 1, 2);
            ELSE
                D302 := id;
                D303 := SEL(is_canc[i], 1, 2);
            END_IF
            IF id = 0 THEN
                state[i] := 0;
                is_canc[i] := FALSE;
                IF i = 0 THEN 
                    D300 := 0; D301 := 0; 
                ELSE 
                    D302 := 0; D303 := 0; 
                END_IF
            END_IF
    END_CASE
END_FOR

IF X51 THEN
    shuttle_target := 0;
    b_target_val := 0;
    D2008 := 40000;
    D2012 := 40000;
ELSE
    D2008 := 95000;
    D2012 := 95000;
END_IF

D80 := active_action;
D81 := active_station;
D82 := couple_seq;

D2000 := shuttle_target;
D2001 := 1000;
Y40 := TRUE;

D2004 := b_target_val;
D2005 := 1000;
Y41 := TRUE;

D2009 := 1000;
Y42 := TRUE;
D2013 := 1000;
Y43 := TRUE;

D2016 := 0;
D2017 := 1000;
Y44 := TRUE;

D2020 := s3_1_target_val;
D2021 := 1000;
Y45 := TRUE;

D2024 := s3_2_target_val;
D2025 := 1000;
Y46 := TRUE;

D2028 := s4_0_target_val;
D2029 := 1000;
Y47 := TRUE;

D2032 := s4_1_target_val;
D2033 := 1000;
Y48 := TRUE;

Y71 := NOT X51;
Y75 := cell4_sync;
D710 := 700;

Y30 := FALSE;

Y2 := X51 AND ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 
      AND ABS(D1020) <= 20 AND ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND ABS(D1017) <= 100;

END_PROGRAM