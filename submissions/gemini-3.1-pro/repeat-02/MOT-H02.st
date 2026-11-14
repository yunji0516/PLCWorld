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

    st : ARRAY[0..1] OF INT;
    loc : ARRAY[0..1] OF DINT;
    id : ARRAY[0..1] OF DINT;
    canc : ARRAY[0..1] OF BOOL;
    lift_need_up : ARRAY[0..1] OF BOOL;
    
    shuttle_owner : INT := -1;
    cell3_owner : INT := -1;
    cell4_owner : INT := -1;
    
    global_lift_target : DINT := 40000;
    shuttle_target : DINT := 0;
    fork_target : DINT := 0;
    s3_0_tgt : DINT := -60000;
    s3_1_tgt : DINT := -60000;
    s4_0_tgt : DINT := -60000;
    s4_1_tgt : DINT := -60000;
    
    cell3_active : BOOL;
    cell3_cfg : BOOL;
    cell4_active : BOOL;
    cell4_cfg : BOOL;
    
    conn_trigger : BOOL;
    conn_action : DINT;
    conn_station : DINT;
    
    i : INT;
    all_home : BOOL;
    all_done_timer : TON;
END_VAR

cell3_active := FALSE;
cell3_cfg := FALSE;
cell4_active := FALSE;
cell4_cfg := FALSE;
conn_trigger := FALSE;

canc[0] := X31;
canc[1] := X35;

IF st[0] = 0 AND D100 > 0 AND NOT X31 AND NOT X30 THEN
    id[0] := D100;
    loc[0] := D101;
    st[0] := 1;
END_IF

IF st[1] = 0 AND D120 > 0 AND NOT X35 AND NOT X34 THEN
    id[1] := D120;
    loc[1] := D121;
    st[1] := 1;
END_IF

FOR i := 0 TO 1 DO
    CASE st[i] OF
    1:
        lift_need_up[i] := TRUE;
        IF ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
            IF canc[i] THEN st[i] := 36; ELSE st[i] := 2; END_IF
        END_IF
        
    2:
        IF canc[i] THEN
            st[i] := 36;
        ELSIF shuttle_owner = -1 AND cell3_owner = -1 THEN
            shuttle_owner := i;
            st[i] := 3;
        END_IF
        
    3:
        shuttle_target := SEL(loc[i] = 1, D406, D403);
        IF canc[i] THEN
            st[i] := 35;
        ELSIF ABS(D1000 - shuttle_target) <= 20 AND ABS(D1001) <= 100 THEN
            st[i] := 4;
        END_IF
        
    4:
        IF canc[i] THEN
            st[i] := 35;
        ELSIF (loc[i] = 1 AND X61) OR (loc[i] = 2 AND X62) THEN
            fork_target := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                st[i] := 5;
                conn_trigger := TRUE;
                conn_action := 1;
                conn_station := loc[i];
            END_IF
        END_IF
        
    5:
        IF D90 = id[i] THEN
            st[i] := 6;
        END_IF
        
    6:
        fork_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            lift_need_up[i] := FALSE;
            IF canc[i] THEN
                st[i] := 32;
            ELSE
                st[i] := 7;
            END_IF
        END_IF
        
    7:
        IF canc[i] THEN
            IF cell3_owner = i THEN cell3_owner := -1; END_IF
            st[i] := 32;
        ELSIF cell3_owner = -1 OR cell3_owner = i THEN
            cell3_owner := i;
            shuttle_target := D409;
            IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
                st[i] := 8;
            END_IF
        END_IF
        
    8:
        IF X63 THEN
            fork_target := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                st[i] := 9;
                conn_trigger := TRUE;
                conn_action := 2;
                conn_station := 3;
            END_IF
        END_IF
        
    9:
        IF D90 = 0 THEN
            st[i] := 10;
        END_IF
        
    10:
        fork_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF shuttle_owner = i THEN shuttle_owner := -1; END_IF
            st[i] := 11;
        END_IF
        
    11:
        cell3_active := TRUE;
        IF canc[i] THEN
            st[i] := 15;
        ELSE
            s3_0_tgt := D500;
            s3_1_tgt := D501;
            IF ABS(D1016 - D500) <= 20 AND ABS(D1020 - D501) <= 20 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
                st[i] := 12;
            END_IF
        END_IF
        
    12:
        cell3_active := TRUE;
        cell3_cfg := TRUE;
        IF canc[i] THEN
            st[i] := 15;
        ELSIF X72 THEN
            st[i] := 13;
        END_IF
        
    13:
        cell3_active := TRUE;
        cell3_cfg := FALSE;
        IF canc[i] THEN
            st[i] := 15;
        ELSE
            s3_0_tgt := D500;
            s3_1_tgt := D501;
            IF ABS(D1016 - D500) <= 20 AND ABS(D1020 - D501) <= 20 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
                st[i] := 14;
            END_IF
        END_IF
        
    14:
        cell3_active := TRUE;
        IF canc[i] THEN
            st[i] := 15;
        ELSIF X70 THEN
            st[i] := 15;
        END_IF
        
    15:
        cell3_active := TRUE;
        s3_0_tgt := -60000;
        s3_1_tgt := -60000;
        IF ABS(D1016 - (-60000)) <= 20 AND ABS(D1020 - (-60000)) <= 20 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
            st[i] := 16;
        END_IF
        
    16:
        cell3_active := TRUE;
        IF shuttle_owner = -1 AND (cell4_owner = -1 OR canc[i]) THEN
            shuttle_owner := i;
        END_IF
        IF shuttle_owner = i THEN
            shuttle_target := D409;
            IF ABS(D1000 - D409) <= 20 AND ABS(D1001) <= 100 THEN
                st[i] := 17;
            END_IF
        END_IF
        
    17:
        cell3_active := TRUE;
        IF X63 THEN
            fork_target := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                st[i] := 18;
                conn_trigger := TRUE;
                conn_action := 1;
                conn_station := 3;
            END_IF
        END_IF
        
    18:
        cell3_active := TRUE;
        IF D90 = id[i] THEN
            IF cell3_owner = i THEN cell3_owner := -1; END_IF
            st[i] := 19;
        END_IF
        
    19:
        fork_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF canc[i] THEN
                st[i] := 32;
            ELSE
                st[i] := 20;
            END_IF
        END_IF
        
    20:
        IF canc[i] THEN
            IF cell4_owner = i THEN cell4_owner := -1; END_IF
            st[i] := 32;
        ELSIF cell4_owner = -1 OR cell4_owner = i THEN
            cell4_owner := i;
            shuttle_target := D412;
            IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
                st[i] := 21;
            END_IF
        END_IF
        
    21:
        IF X64 THEN
            fork_target := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                st[i] := 22;
                conn_trigger := TRUE;
                conn_action := 2;
                conn_station := 4;
            END_IF
        END_IF
        
    22:
        IF D90 = 0 THEN
            st[i] := 23;
        END_IF
        
    23:
        fork_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF shuttle_owner = i THEN shuttle_owner := -1; END_IF
            st[i] := 24;
        END_IF
        
    24:
        cell4_active := TRUE;
        IF canc[i] THEN
            st[i] := 28;
        ELSE
            s4_0_tgt := D600;
            s4_1_tgt := D601;
            IF ABS(D1024 - D600) <= 20 AND ABS(D1028 - D601) <= 20 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100 THEN
                st[i] := 25;
            END_IF
        END_IF
        
    25:
        cell4_active := TRUE;
        cell4_cfg := TRUE;
        IF canc[i] THEN
            st[i] := 28;
        ELSIF X77 THEN
            st[i] := 26;
        END_IF
        
    26:
        cell4_active := TRUE;
        cell4_cfg := FALSE;
        IF canc[i] THEN
            st[i] := 28;
        ELSE
            s4_0_tgt := D600;
            s4_1_tgt := D601;
            IF ABS(D1024 - D600) <= 20 AND ABS(D1028 - D601) <= 20 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100 THEN
                st[i] := 27;
            END_IF
        END_IF
        
    27:
        cell4_active := TRUE;
        IF canc[i] THEN
            st[i] := 28;
        ELSIF X75 THEN
            st[i] := 28;
        END_IF
        
    28:
        cell4_active := TRUE;
        s4_0_tgt := -60000;
        s4_1_tgt := -60000;
        IF ABS(D1024 - (-60000)) <= 20 AND ABS(D1028 - (-60000)) <= 20 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100 THEN
            st[i] := 29;
        END_IF
        
    29:
        cell4_active := TRUE;
        IF shuttle_owner = -1 THEN
            shuttle_owner := i;
        END_IF
        IF shuttle_owner = i THEN
            shuttle_target := D412;
            IF ABS(D1000 - D412) <= 20 AND ABS(D1001) <= 100 THEN
                st[i] := 30;
            END_IF
        END_IF
        
    30:
        cell4_active := TRUE;
        IF X64 THEN
            fork_target := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                st[i] := 31;
                conn_trigger := TRUE;
                conn_action := 1;
                conn_station := 4;
            END_IF
        END_IF
        
    31:
        cell4_active := TRUE;
        IF D90 = id[i] THEN
            IF cell4_owner = i THEN cell4_owner := -1; END_IF
            st[i] := 32;
        END_IF
        
    32:
        lift_need_up[i] := TRUE;
        shuttle_target := SEL(loc[i] = 1, D406, D403);
        IF ABS(D1000 - shuttle_target) <= 20 AND ABS(D1001) <= 100 AND ABS(D1008 - 95000) <= 20 AND ABS(D1012 - 95000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
            st[i] := 33;
        END_IF
        
    33:
        IF (loc[i] = 1 AND X61) OR (loc[i] = 2 AND X62) THEN
            fork_target := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
                st[i] := 34;
                conn_trigger := TRUE;
                conn_action := 2;
                conn_station := loc[i];
            END_IF
        END_IF
        
    34:
        IF D90 = 0 THEN
            st[i] := 35;
        END_IF
        
    35:
        fork_target := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            IF shuttle_owner = i THEN shuttle_owner := -1; END_IF
            st[i] := 36;
        END_IF
        
    36:
        lift_need_up[i] := FALSE;
        IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
            st[i] := 37;
        END_IF
        
    END_CASE;
END_FOR;

IF lift_need_up[0] OR lift_need_up[1] THEN
    global_lift_target := 95000;
ELSE
    global_lift_target := 40000;
END_IF

IF cell3_owner = -1 THEN
    s3_0_tgt := -60000;
    s3_1_tgt := -60000;
END_IF

IF cell4_owner = -1 THEN
    s4_0_tgt := -60000;
    s4_1_tgt := -60000;
END_IF

IF shuttle_owner = -1 THEN
    IF st[0] = 0 AND st[1] = 0 AND X51 THEN
        shuttle_target := 0;
    END_IF
END_IF

IF conn_trigger THEN
    D80 := conn_action;
    D81 := conn_station;
    D82 := D82 + 1;
END_IF

IF st[0] = 37 THEN
    D300 := id[0];
    D301 := SEL(canc[0], DINT(1), DINT(2));
    IF D100 <> id[0] OR X30 OR X31 THEN
        st[0] := 0;
        D300 := 0;
        D301 := 0;
    END_IF
ELSE
    D300 := 0;
    D301 := 0;
END_IF

IF st[1] = 37 THEN
    D302 := id[1];
    D303 := SEL(canc[1], DINT(1), DINT(2));
    IF D120 <> id[1] OR X34 OR X35 THEN
        st[1] := 0;
        D302 := 0;
        D303 := 0;
    END_IF
ELSE
    D302 := 0;
    D303 := 0;
END_IF

all_home := (ABS(D1000) <= 20) AND (ABS(D1004) <= 20) AND
            (ABS(D1008 - 40000) <= 20) AND (ABS(D1012 - 40000) <= 20) AND
            (ABS(D1016 - (-60000)) <= 20) AND (ABS(D1020 - (-60000)) <= 20) AND
            (ABS(D1024 - (-60000)) <= 20) AND (ABS(D1028 - (-60000)) <= 20);

all_done_timer(IN := (st[0] = 0 AND st[1] = 0 AND X51 AND all_home), PT := T#100ms);
Y2 := all_done_timer.Q;

Y30 := FALSE;
Y40 := TRUE; Y41 := TRUE; Y42 := TRUE; Y43 := TRUE;
Y44 := TRUE; Y45 := TRUE; Y46 := TRUE; Y47 := TRUE;

D2001 := 1000; D2005 := 1000; D2009 := 1000; D2013 := 1000;
D2017 := 1000; D2021 := 1000; D2025 := 1000; D2029 := 1000;

D2000 := shuttle_target;
D2004 := fork_target;
D2008 := global_lift_target;
D2012 := global_lift_target;
D2016 := s3_0_tgt;
D2020 := s3_1_tgt;
D2024 := s4_0_tgt;
D2028 := s4_1_tgt;

D2002 := 0; D2006 := 0; D2010 := 0; D2014 := 0;
D2018 := 0; D2022 := 0; D2026 := 0; D2030 := 0;

Y71 := cell3_active;
Y70 := cell3_cfg;
Y76 := cell4_active;
Y75 := cell4_cfg;

END_PROGRAM