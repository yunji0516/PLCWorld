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

    Last_R0_ID : DINT := 0;
    Last_R1_ID : DINT := 0;
    R_ID : ARRAY[0..1] OF DINT;
    R_Active : ARRAY[0..1] OF BOOL;
    R_Loc : ARRAY[0..1] OF DINT;
    R_Prog : ARRAY[0..1] OF DINT;
    R_Cancel : ARRAY[0..1] OF BOOL;

    Occ : ARRAY[1..4] OF DINT; 

    C3_State : DINT := 0;
    C4_State : DINT := 0;
    C3_Req : DINT := 0;
    C4_Req : DINT := 0;

    S_State : DINT := 0;
    S_Req : DINT := 0;
    S_Src : DINT := 0;
    S_Dst : DINT := 0;

    can_move_0 : BOOL;
    can_move_1 : BOOL;
    src_0, dst_0, src_1, dst_1 : DINT;
    selected : DINT;
    px : DINT;

    Lift_Target : DINT := 95000;
    Lift_Need_Down : BOOL;
    Shuttle_Using_Lift : BOOL;
    Pickup_Ready, Dropoff_Ready : BOOL;

    All_Done_State : BOOL;
    timer : TON;

    a_target_val : DINT := 0;
    b_target_val : DINT := 0;
    c_target_val : DINT := 40000;
    d_target_val : DINT := 40000;
    s3_0_target_val : DINT := 0;
    s3_1_target_val : DINT := 5000;
    s4_0_target_val : DINT := 0;
    s4_1_target_val : DINT := 0;
    s4_2_target_val : DINT := 0;
END_VAR

IF D100 > 0 AND D100 <> Last_R0_ID THEN
    Last_R0_ID := D100; R_ID[0] := D100; R_Active[0] := TRUE; R_Loc[0] := D101; R_Prog[0] := 0; R_Cancel[0] := FALSE; Occ[D101] := D100;
END_IF
IF D120 > 0 AND D120 <> Last_R1_ID THEN
    Last_R1_ID := D120; R_ID[1] := D120; R_Active[1] := TRUE; R_Loc[1] := D121; R_Prog[1] := 0; R_Cancel[1] := FALSE; Occ[D121] := D120;
END_IF
IF R_Active[0] AND X31 THEN R_Cancel[0] := TRUE; R_Prog[0] := 2; END_IF
IF R_Active[1] AND X35 THEN R_Cancel[1] := TRUE; R_Prog[1] := 2; END_IF

IF Occ[3] > 0 THEN
    IF R_ID[0] = Occ[3] THEN C3_Req := 0; ELSE C3_Req := 1; END_IF
    IF R_Cancel[C3_Req] AND C3_State < 6 THEN C3_State := 6; END_IF
    CASE C3_State OF
        0: C3_State := 1;
        1:
            s3_0_target_val := D500; s3_1_target_val := 5000;
            IF ABS(D1016 - D500) <= 20 AND ABS(D1017) <= 100 THEN C3_State := 3; END_IF
        3:
            s3_1_target_val := D501;
            IF ABS(D1020 - D501) <= 20 AND ABS(D1021) <= 100 THEN C3_State := 5; END_IF
        5:
            IF X70 THEN R_Prog[C3_Req] := 1; C3_State := 6; END_IF
        6:
            s3_1_target_val := 5000;
            IF ABS(D1020 - 5000) <= 20 AND ABS(D1021) <= 100 THEN C3_State := 8; END_IF
        8:
            s3_0_target_val := 0;
            IF ABS(D1016) <= 20 AND ABS(D1017) <= 100 THEN C3_State := 10; END_IF
    END_CASE
ELSE
    C3_State := 0; s3_0_target_val := 0; s3_1_target_val := 5000;
END_IF

IF Occ[4] > 0 THEN
    IF R_ID[0] = Occ[4] THEN C4_Req := 0; ELSE C4_Req := 1; END_IF
    IF R_Cancel[C4_Req] AND C4_State < 8 THEN C4_State := 8; END_IF
    CASE C4_State OF
        0: C4_State := 1;
        1:
            s4_1_target_val := 0; s4_2_target_val := 0;
            IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN C4_State := 3; END_IF
        3:
            s4_0_target_val := D600;
            IF ABS(D1024 - D600) <= 20 AND ABS(D1025) <= 100 THEN C4_State := 5; END_IF
        5:
            IF D620 = 0 THEN s4_1_target_val := 4000; ELSE s4_2_target_val := 4000; END_IF
            C4_State := 6;
        6:
            IF D620 = 0 THEN
                IF ABS(D1028 - 4000) <= 20 AND ABS(D1029) <= 100 THEN C4_State := 7; END_IF
            ELSE
                IF ABS(D1032 - 4000) <= 20 AND ABS(D1033) <= 100 THEN C4_State := 7; END_IF
            END_IF
        7:
            IF X75 THEN R_Prog[C4_Req] := 2; C4_State := 8; END_IF
        8:
            s4_1_target_val := 0; s4_2_target_val := 0;
            IF ABS(D1028) <= 20 AND ABS(D1032) <= 20 THEN C4_State := 10; END_IF
        10:
            s4_0_target_val := 0;
            IF ABS(D1024) <= 20 AND ABS(D1025) <= 100 THEN C4_State := 12; END_IF
    END_CASE
ELSE
    C4_State := 0; s4_0_target_val := 0; s4_1_target_val := 0; s4_2_target_val := 0;
END_IF

can_move_0 := FALSE; src_0 := 0; dst_0 := 0;
IF R_Active[0] THEN
    IF R_Prog[0] = 0 AND Occ[R_Loc[0]] = R_ID[0] AND Occ[3] = 0 THEN 
        can_move_0 := TRUE; src_0 := R_Loc[0]; dst_0 := 3;
    ELSIF R_Prog[0] = 1 AND Occ[3] = R_ID[0] AND C3_State >= 10 AND Occ[4] = 0 THEN 
        can_move_0 := TRUE; src_0 := 3; dst_0 := 4;
    ELSIF R_Prog[0] = 2 THEN
        IF Occ[3] = R_ID[0] AND C3_State >= 10 THEN 
            can_move_0 := TRUE; src_0 := 3; dst_0 := R_Loc[0];
        ELSIF Occ[4] = R_ID[0] AND C4_State >= 12 THEN 
            can_move_0 := TRUE; src_0 := 4; dst_0 := R_Loc[0];
        END_IF
    END_IF
END_IF

can_move_1 := FALSE; src_1 := 0; dst_1 := 0;
IF R_Active[1] THEN
    IF R_Prog[1] = 0 AND Occ[R_Loc[1]] = R_ID[1] AND Occ[3] = 0 THEN 
        can_move_1 := TRUE; src_1 := R_Loc[1]; dst_1 := 3;
    ELSIF R_Prog[1] = 1 AND Occ[3] = R_ID[1] AND C3_State >= 10 AND Occ[4] = 0 THEN 
        can_move_1 := TRUE; src_1 := 3; dst_1 := 4;
    ELSIF R_Prog[1] = 2 THEN
        IF Occ[3] = R_ID[1] AND C3_State >= 10 THEN 
            can_move_1 := TRUE; src_1 := 3; dst_1 := R_Loc[1];
        ELSIF Occ[4] = R_ID[1] AND C4_State >= 12 THEN 
            can_move_1 := TRUE; src_1 := 4; dst_1 := R_Loc[1];
        END_IF
    END_IF
END_IF

IF S_State = 0 THEN
    selected := -1;
    IF can_move_0 AND can_move_1 THEN
        IF D103 <= D123 THEN selected := 0; ELSE selected := 1; END_IF
    ELSIF can_move_0 THEN selected := 0;
    ELSIF can_move_1 THEN selected := 1;
    END_IF
    
    IF selected = 0 THEN S_Req := 0; S_Src := src_0; S_Dst := dst_0; S_State := 10;
    ELSIF selected = 1 THEN S_Req := 1; S_Src := src_1; S_Dst := dst_1; S_State := 10;
    END_IF
END_IF

IF S_State > 0 THEN
    IF S_State = 15 AND R_Cancel[S_Req] THEN S_Dst := R_Loc[S_Req]; END_IF
    CASE S_State OF
        10:
            IF S_Src = 1 THEN px := D403; ELSIF S_Src = 2 THEN px := D406; ELSIF S_Src = 3 THEN px := D409; ELSE px := D412; END_IF
            a_target_val := px;
            Pickup_Ready := FALSE;
            IF S_Src <= 2 THEN
                IF ABS(D1008 - D92) <= 20 AND ABS(D1012 - D92) <= 20 AND ABS(D1009) <= 100 THEN Pickup_Ready := TRUE; END_IF
            ELSIF S_Src = 3 THEN
                IF ABS(D1016) <= 20 AND ABS(D1020 - 5000) <= 20 AND C3_State >= 10 THEN Pickup_Ready := TRUE; END_IF
            ELSIF S_Src = 4 THEN
                IF ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND C4_State >= 12 THEN Pickup_Ready := TRUE; END_IF
            END_IF
            IF Pickup_Ready AND ABS(D1000 - px) <= 20 AND ABS(D1001) <= 100 THEN S_State := 12; END_IF
        12:
            b_target_val := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN D80 := 1; D81 := S_Src; D82 := D82 + 1; S_State := 14; END_IF
        14:
            IF D90 = R_ID[S_Req] THEN Occ[S_Src] := 0; S_State := 15; END_IF
        15:
            b_target_val := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN S_State := 16; END_IF
        16:
            IF S_Dst = 1 THEN px := D403; ELSIF S_Dst = 2 THEN px := D406; ELSIF S_Dst = 3 THEN px := D409; ELSE px := D412; END_IF
            a_target_val := px;
            Dropoff_Ready := FALSE;
            IF S_Dst <= 2 THEN
                IF ABS(D1008 - D92) <= 20 AND ABS(D1012 - D92) <= 20 AND ABS(D1009) <= 100 THEN Dropoff_Ready := TRUE; END_IF
            ELSIF S_Dst = 3 THEN
                IF ABS(D1016) <= 20 AND ABS(D1020 - 5000) <= 20 AND C3_State = 0 THEN Dropoff_Ready := TRUE; END_IF
            ELSIF S_Dst = 4 THEN
                IF ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20 AND C4_State = 0 THEN Dropoff_Ready := TRUE; END_IF
            END_IF
            IF Dropoff_Ready AND ABS(D1000 - px) <= 20 AND ABS(D1001) <= 100 THEN S_State := 18; END_IF
        18:
            b_target_val := 18000;
            IF ABS(D1004 - 18000) <= 20 AND ABS(D1005) <= 100 THEN D80 := 2; D81 := S_Dst; D82 := D82 + 1; S_State := 20; END_IF
        20:
            IF D90 = 0 THEN Occ[S_Dst] := R_ID[S_Req]; S_State := 21; END_IF
        21:
            b_target_val := 0;
            IF ABS(D1004) <= 20 AND ABS(D1005) <= 100 THEN S_State := 0; END_IF
    END_CASE
END_IF

Lift_Target := 95000; 
Lift_Need_Down := FALSE;
IF R_Active[0] AND R_Prog[0] = 2 AND Occ[R_Loc[0]] = R_ID[0] THEN Lift_Need_Down := TRUE; END_IF
IF R_Active[1] AND R_Prog[1] = 2 AND Occ[R_Loc[1]] = R_ID[1] THEN Lift_Need_Down := TRUE; END_IF

Shuttle_Using_Lift := FALSE;
IF S_State >= 10 THEN
    IF S_State <= 15 AND S_Src <= 2 THEN Shuttle_Using_Lift := TRUE; END_IF
    IF S_State >= 16 AND S_Dst <= 2 THEN Shuttle_Using_Lift := TRUE; END_IF
END_IF
IF Lift_Need_Down AND NOT Shuttle_Using_Lift THEN Lift_Target := 40000; END_IF

c_target_val := Lift_Target; 
d_target_val := Lift_Target;

IF ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND ABS(D1009) <= 100 THEN
    IF R_Active[0] AND R_Prog[0] = 2 AND Occ[R_Loc[0]] = R_ID[0] THEN
        D300 := R_ID[0]; 
        IF R_Cancel[0] THEN D301 := 2; ELSE D301 := 1; END_IF
        R_Active[0] := FALSE; Occ[R_Loc[0]] := 0;
    END_IF
    IF R_Active[1] AND R_Prog[1] = 2 AND Occ[R_Loc[1]] = R_ID[1] THEN
        D302 := R_ID[1]; 
        IF R_Cancel[1] THEN D303 := 2; ELSE D303 := 1; END_IF
        R_Active[1] := FALSE; Occ[R_Loc[1]] := 0;
    END_IF
END_IF

IF X51 AND NOT R_Active[0] AND NOT R_Active[1] AND S_State = 0 THEN
    a_target_val := 0;
END_IF

All_Done_State := X51 AND NOT R_Active[0] AND NOT R_Active[1] AND
                  ABS(D1000) <= 20 AND ABS(D1004) <= 20 AND
                  ABS(D1008 - 40000) <= 20 AND ABS(D1012 - 40000) <= 20 AND
                  ABS(D1016) <= 20 AND ABS(D1020 - 5000) <= 20 AND
                  ABS(D1024) <= 20 AND ABS(D1028) <= 20 AND ABS(D1032) <= 20;

timer(IN := All_Done_State, PT := T#100ms);
Y2 := timer.Q;

D2000 := a_target_val; D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2004 := b_target_val; D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2008 := c_target_val; D2009 := 1000; D2010 := 0; Y42 := TRUE;
D2012 := d_target_val; D2013 := 1000; D2014 := 0; Y43 := TRUE;

D2016 := s3_0_target_val; D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2020 := s3_1_target_val; D2021 := 1000; D2022 := 0; Y45 := TRUE;

D2024 := s4_0_target_val; D2025 := 1000; D2026 := 0; Y46 := TRUE;
D2028 := s4_1_target_val; D2029 := 1000; D2030 := 0; Y47 := TRUE;
D2032 := s4_2_target_val; D2033 := 1000; D2034 := 0; Y48 := TRUE;

Y30 := FALSE;
END_PROGRAM