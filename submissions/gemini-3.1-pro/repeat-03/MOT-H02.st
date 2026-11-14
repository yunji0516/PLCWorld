```iecst
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

    r_state : ARRAY[0..1] OF INT;
    r_id : ARRAY[0..1] OF DINT;
    r_loc : ARRAY[0..1] OF DINT;
    r_cancel_flag : ARRAY[0..1] OF BOOL;
    r_status : ARRAY[0..1] OF DINT;
    r_ack : ARRAY[0..1] OF DINT;
    r_lift_tgt : ARRAY[0..1] OF DINT;
    r_a_tgt : ARRAY[0..1] OF DINT;
    r_b_tgt : ARRAY[0..1] OF DINT;
    r_action : ARRAY[0..1] OF DINT;
    r_station : ARRAY[0..1] OF DINT;
    r_m3_sel : ARRAY[0..1] OF DINT;
    r_m3_ret : ARRAY[0..1] OF BOOL;
    r_m3_conf : ARRAY[0..1] OF BOOL;
    r_s3_0_tgt : ARRAY[0..1] OF DINT;
    r_s3_1_tgt : ARRAY[0..1] OF DINT;
    r_m4_sel : ARRAY[0..1] OF DINT;
    r_m4_ret : ARRAY[0..1] OF BOOL;
    r_m4_conf : ARRAY[0..1] OF BOOL;
    r_s4_0_tgt : ARRAY[0..1] OF DINT;
    r_s4_1_tgt : ARRAY[0..1] OF DINT;

    shuttle_owner : INT;
    cell3_owner : INT;
    cell4_owner : INT;
    global_couple_seq : DINT;

    i : INT;
    idx : INT;
    id_in : DINT;
    loc_in : DINT;
    cancel_in : BOOL;
    y2_timer : TON;
END_VAR

FOR i := 0 TO 1 DO
    id_in := SEL(i = 0, D120, D100);
    loc_in := SEL(i = 0, D121, D101);
    cancel_in := SEL(i = 0, X35, X31);

    IF r_state[i] = 0 THEN
        IF id_in <> 0 AND loc_in > 0 THEN
            r_id[i] := id_in;
            r_loc[i] := loc_in;
            r_cancel_flag[i] := FALSE;
            r_status[i] := 0;
            r_ack[i] := 0;
            r_lift_tgt[i] := 40000;
            r_state[i] := 1;
        END_IF;
    END_IF;

    IF cancel_in THEN
        r_cancel_flag[i] := TRUE;
    END_IF;

    CASE r_state[i] OF
    1:
        r_lift_tgt[i] := 95000;
        IF (r_loc[i] = 1 AND ABS(D1008 - 95000) <= 20 AND ABS(D1009) <= 100) OR
           (r_loc[i] = 2 AND ABS(D1012 - 95000) <= 20 AND ABS(D1013) <= 100) THEN
            r_state[i] := 2;
        END_IF;

    2:
        IF r_cancel_flag[i] THEN
            r_state[i] := 45;
        ELSIF shuttle_owner = 0 OR shuttle_owner = i + 1 THEN
            shuttle_owner := i + 1;
            r_state[i] := 3;
        END_IF;

    3:
        r_a_tgt[i] := SEL(r_loc[i] = 1, D406, D403);
        IF r_cancel_flag[i] THEN
            shuttle_owner := 0;
            r_state[i] := 45;
        ELSIF (r_loc[i] = 1 AND X61) OR (r_loc[i] = 2 AND X62) THEN
            r_state[i] := 4;
        END_IF;

    4:
        r_b_tgt[i] := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 5;
        END_IF;

    5:
        r_action[i] := 1;
        r_station[i] := r_loc[i];
        global_couple_seq := global_couple_seq + 1;
        r_state[i] := 6;

    6:
        IF D90 = r_id[i] THEN
            r_state[i] := 7;
        END_IF;

    7:
        r_b_tgt[i] := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 8;
        END_IF;

    8:
        IF r_cancel_flag[i] THEN
            r_state[i] := 40;
        ELSE
            r_state[i] := 81;
        END_IF;

    81:
        r_a_tgt[i] := D409;
        IF X63 THEN
            r_state[i] := 9;
        END_IF;

    9:
        r_b_tgt[i] := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 10;
        END_IF;

    10:
        IF cell3_owner = 0 OR cell3_owner = i + 1 THEN
            cell3_owner := i + 1;
            r_action[i] := 2;
            r_station[i] := 3;
            global_couple_seq := global_couple_seq + 1;
            r_state[i] := 11;
        END_IF;

    11:
        IF D90 = 0 THEN
            r_state[i] := 12;
        END_IF;

    12:
        r_b_tgt[i] := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            shuttle_owner := 0;
            r_state[i] := 13;
        END_IF;

    13:
        IF r_cancel_flag[i] THEN
            r_state[i] := 16;
        ELSIF ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
            r_m3_sel[i] := r_id[i];
            r_m3_ret[i] := TRUE;
            r_m3_conf[i] := TRUE;
            r_state[i] := 14;
        END_IF;

    14:
        r_m3_conf[i] := FALSE;
        r_s3_0_tgt[i] := D500 + 60000;
        r_s3_1_tgt[i] := D501 + 60000;
        r_state[i] := 15;

    15:
        IF X70 OR X71 OR r_cancel_flag[i] THEN
            r_state[i] := 16;
        END_IF;

    16:
        r_s3_0_tgt[i] := 0;
        r_s3_1_tgt[i] := 0;
        IF ABS(D1016) <= 20 AND ABS(D1020) <= 20 AND ABS(D1017) <= 100 AND ABS(D1021) <= 100 THEN
            r_state[i] := 17;
        END_IF;

    17:
        IF shuttle_owner = 0 OR shuttle_owner = i + 1 THEN
            shuttle_owner := i + 1;
            r_state[i] := 18;
        END_IF;

    18:
        r_a_tgt[i] := D409;
        IF X63 THEN
            r_state[i] := 19;
        END_IF;

    19:
        r_b_tgt[i] := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 20;
        END_IF;

    20:
        r_action[i] := 1;
        r_station[i] := 3;
        global_couple_seq := global_couple_seq + 1;
        r_state[i] := 21;

    21:
        IF D90 = r_id[i] THEN
            cell3_owner := 0;
            r_state[i] := 22;
        END_IF;

    22:
        r_b_tgt[i] := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 23;
        END_IF;

    23:
        IF r_cancel_flag[i] THEN
            r_state[i] := 40;
        ELSE
            r_state[i] := 231;
        END_IF;

    231:
        r_a_tgt[i] := D412;
        IF X64 THEN
            r_state[i] := 24;
        END_IF;

    24:
        r_b_tgt[i] := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 25;
        END_IF;

    25:
        IF cell4_owner = 0 OR cell4_owner = i + 1 THEN
            cell4_owner := i + 1;
            r_action[i] := 2;
            r_station[i] := 4;
            global_couple_seq := global_couple_seq + 1;
            r_state[i] := 26;
        END_IF;

    26:
        IF D90 = 0 THEN
            r_state[i] := 27;
        END_IF;

    27:
        r_b_tgt[i] := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            shuttle_owner := 0;
            r_state[i] := 28;
        END_IF;

    28:
        IF r_cancel_flag[i] THEN
            r_state[i] := 30;
        ELSIF ABS(D1025) <= 100 AND ABS(D1029) <= 100 THEN
            r_m4_sel[i] := r_id[i];
            r_m4_ret[i] := TRUE;
            r_m4_conf[i] := TRUE;
            r_state[i] := 29;
        END_IF;

    29:
        r_m4_conf[i] := FALSE;
        r_s4_0_tgt[i] := D600 + 60000;
        r_s4_1_tgt[i] := D601 + 60000;
        r_state[i] := 291;

    291:
        IF X75 OR X76 OR r_cancel_flag[i] THEN
            r_state[i] := 30;
        END_IF;

    30:
        r_s4_0_tgt[i] := 0;
        r_s4_1_tgt[i] := 0;
        IF ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1025) <= 100 AND ABS(D1029) <= 100 THEN
            r_state[i] := 31;
        END_IF;

    31:
        IF shuttle_owner = 0 OR shuttle_owner = i + 1 THEN
            shuttle_owner := i + 1;
            r_state[i] := 32;
        END_IF;

    32:
        r_a_tgt[i] := D412;
        IF X64 THEN
            r_state[i] := 33;
        END_IF;

    33:
        r_b_tgt[i] := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 34;
        END_IF;

    34:
        r_action[i] := 1;
        r_station[i] := 4;
        global_couple_seq := global_couple_seq + 1;
        r_state[i] := 35;

    35:
        IF D90 = r_id[i] THEN
            cell4_owner := 0;
            r_state[i] := 36;
        END_IF;

    36:
        r_b_tgt[i] := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 40;
        END_IF;

    40:
        r_a_tgt[i] := SEL(r_loc[i] = 1, D406, D403);
        IF (r_loc[i] = 1 AND X61) OR (r_loc[i] = 2 AND X62) THEN
            r_state[i] := 41;
        END_IF;

    41:
        r_b_tgt[i] := 18000;
        IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN
            r_state[i] := 42;
        END_IF;

    42:
        r_action[i] := 2;
        r_station[i] := r_loc[i];
        global_couple_seq := global_couple_seq + 1;
        r_state[i] := 43;

    43:
        IF D90 = 0 THEN
            r_state[i] := 44;
        END_IF;

    44:
        r_b_tgt[i] := 0;
        IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN
            shuttle_owner := 0;
            r_state[i] := 45;
        END_IF;

    45:
        r_lift_tgt[i] := 40000;
        IF (r_loc[i] = 1 AND ABS(D1008 - 40000) <= 20 AND ABS(D1009) <= 100) OR
           (r_loc[i] = 2 AND ABS(D1012 - 40000) <= 20 AND ABS(D1013) <= 100) THEN
            r_state[i] := 46;
        END_IF;

    46:
        r_ack[i] := r_id[i];
        r_status[i] := SEL(r_cancel_flag[i], 1, 2);
        IF id_in <> r_id[i] THEN
            r_state[i] := 0;
            r_ack[i] := 0;
            r_status[i] := 0;
        END_IF;
    END_CASE;
END_FOR;

IF shuttle_owner > 0 THEN
    idx := shuttle_owner - 1;
    D2000 := r_a_tgt[idx];
    D2004 := r_b_tgt[idx];
    D80 := r_action[idx];
    D81 := r_station[idx];
ELSE
    D2000 := 0;
    D2004 := 0;
    D80 := 0;
    D81 := 0;
END_IF;
D82 := global_couple_seq;

IF r_loc[0] = 1 AND r_state[0] > 0 THEN D2008 := r_lift_tgt[0];
ELSIF r_loc[1] = 1 AND r_state[1] > 0 THEN D2008 := r_lift_tgt[1];
ELSE D2008 := 40000; END_IF;

IF r_loc[0] = 2 AND r_state[0] > 0 THEN D2012 := r_lift_tgt[0];
ELSIF r_loc[1] = 2 AND r_state[1] > 0 THEN D2012 := r_lift_tgt[1];
ELSE D2012 := 40000; END_IF;

IF cell3_owner > 0 THEN
    idx := cell3_owner - 1;
    D2016 := r_s3_0_tgt[idx];
    D2020 := r_s3_1_tgt[idx];
    D700 := r_m3_sel[idx];
    Y71 := r_m3_ret[idx];
    Y70 := r_m3_conf[idx];
ELSE
    D2016 := 0;
    D2020 := 0;
    D700 := 0;
    Y71 := FALSE;
    Y70 := FALSE;
END_IF;

IF cell4_owner > 0 THEN
    idx := cell4_owner - 1;
    D2024 := r_s4_0_tgt[idx];
    D2028 := r_s4_1_tgt[idx];
    D710 := r_m4_sel[idx];
    Y76 := r_m4_ret[idx];
    Y75 := r_m4_conf[idx];
ELSE
    D2024 := 0;
    D2028 := 0;
    D710 := 0;
    Y76 := FALSE;
    Y75 := FALSE;
END_IF;

D300 := r_ack[0];
D301 := r_status[0];
D302 := r_ack[1];
D303 := r_status[1];

D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2009 := 1000; D2010 := 0; Y42 := TRUE;
D2013 := 1000; D2014 := 0; Y43 := TRUE;
D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2025 := 1000; D2026 := 0; Y46 := TRUE;
D2029 := 1000; D2030 := 0; Y47 := TRUE;
Y30 := FALSE;

IF X51 AND r_state[0] = 0 AND r_state[1] = 0 AND
   ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND
   (ABS(D1016) <= 20 OR ABS(D1016 + 60000) <= 20) AND (ABS(D1020) <= 20 OR ABS(D1020 + 60000) <= 20) AND
   (ABS(D1024) <= 20 OR ABS(D1024 + 60000) <= 20) AND (ABS(D1028) <= 20 OR ABS(D1028 + 60000) <= 20) AND
   ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND
   ABS(D1001) <= 100 AND ABS(D1005) <= 100 AND
   ABS(D1017) <= 100 AND ABS(D1021) <= 100 AND
   ABS(D1025) <= 100 AND ABS(D1029) <= 100 AND
   ABS(D1009) <= 100 AND ABS(D1013) <= 100 THEN
    y2_timer(IN := TRUE, PT := T#100ms);
ELSE
    y2_timer(IN := FALSE, PT := T#100ms);
END_IF;
Y2 := y2_timer.Q;

END_PROGRAM
```