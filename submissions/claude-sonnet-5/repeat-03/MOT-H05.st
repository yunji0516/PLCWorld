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

    (* Internal variables *)
    active_idx      : INT := -1;
    state           : DINT := 0;
    seq_counter     : DINT := 0;
    cur_station     : DINT := 0;
    port_ok         : BOOL := FALSE;
    act_id          : DINT := 0;
    act_location    : DINT := 0;
    act_due         : DINT := 0;
    act_cancelled   : BOOL := FALSE;
    act_lane        : DINT := 0;
    c3_final_target : DINT := 0;
    c3_captured     : BOOL := FALSE;
    goal_axis       : DINT := 0;
    req0_done       : BOOL := FALSE;
    req1_done       : BOOL := FALSE;

    a_arr, b_arr, c_arr, d_arr : BOOL;
    s30_arr, s31_arr, s40_arr, s41_arr, s42_arr : BOOL;
    home_ok         : BOOL := FALSE;
    completion_ready: BOOL := FALSE;
    fin_timer       : TON;
    y2_latch        : BOOL := FALSE;
    scan_count      : DINT := 0;

    POS_TOL      : DINT := 20;
    VEL_TOL      : DINT := 100;
    STATION1_X   : DINT := -360000;
    STATION2_X   : DINT := -230000;
    STATION3_X   : DINT := 230000;
    STATION4_X   : DINT := 990000;
    FORK_RETRIEVE: DINT := 0;
    FORK_CONNECT : DINT := 18000;
    LIFT_HOME    : DINT := 15000;
    S3_HOME      : DINT := -60000;
    S4_HOME      : DINT := 0;
    FIN_OFFSET   : DINT := 25000;
    PIN_INSERT   : DINT := 4000;
    DRV_RATE     : DINT := 300;

    station_src_x : DINT := 0;
    lift_is_c     : BOOL := TRUE;
END_VAR

scan_count := scan_count + 1;

(* ---- arrival flags based on previously commanded targets ---- *)
a_arr  := (ABS(D1000 - D2000) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL);
b_arr  := (ABS(D1004 - D2004) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
c_arr  := (ABS(D1008 - D2008) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL);
d_arr  := (ABS(D1012 - D2012) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);
s30_arr:= (ABS(D1016 - D2016) <= POS_TOL) AND (ABS(D1017) <= VEL_TOL);
s31_arr:= (ABS(D1020 - D2020) <= POS_TOL) AND (ABS(D1021) <= VEL_TOL);
s40_arr:= (ABS(D1024 - D2024) <= POS_TOL) AND (ABS(D1025) <= VEL_TOL);
s41_arr:= (ABS(D1028 - D2028) <= POS_TOL) AND (ABS(D1029) <= VEL_TOL);
s42_arr:= (ABS(D1032 - D2032) <= POS_TOL) AND (ABS(D1033) <= VEL_TOL);

(* ---- default: all axes commanded to home, enabled ---- *)
D2000:=0;            D2001:=DRV_RATE; D2002:=0; Y40:=TRUE;
D2004:=FORK_RETRIEVE; D2005:=DRV_RATE; D2006:=0; Y41:=TRUE;
D2008:=LIFT_HOME;    D2009:=DRV_RATE; D2010:=0; Y42:=TRUE;
D2012:=LIFT_HOME;    D2013:=DRV_RATE; D2014:=0; Y43:=TRUE;
D2016:=S3_HOME;      D2017:=DRV_RATE; D2018:=0; Y44:=TRUE;
D2020:=S3_HOME;      D2021:=DRV_RATE; D2022:=0; Y45:=TRUE;
D2024:=S4_HOME;      D2025:=DRV_RATE; D2026:=0; Y46:=TRUE;
D2028:=S4_HOME;      D2029:=DRV_RATE; D2030:=0; Y47:=TRUE;
D2032:=S4_HOME;      D2033:=DRV_RATE; D2034:=0; Y48:=TRUE;

Y70:=FALSE; Y71:=FALSE; Y75:=FALSE; Y76:=FALSE;

(* ---- arbitration: pick a pending request ---- *)
IF active_idx = -1 THEN
    IF (D100 <> 0) AND (NOT req0_done) THEN
        active_idx := 0;
        act_id := D100; act_location := D101; act_due := D103; act_lane := 0;
        act_cancelled := X31;
        c3_captured := FALSE;
        state := 1;
    ELSIF (D120 <> 0) AND (NOT req1_done) THEN
        active_idx := 1;
        act_id := D120; act_location := D121; act_due := D123; act_lane := 1;
        act_cancelled := X35;
        c3_captured := FALSE;
        state := 1;
    END_IF;
END_IF;

IF active_idx = 0 THEN
    act_cancelled := X31 OR X71 OR X76;
ELSIF active_idx = 1 THEN
    act_cancelled := X35 OR X71 OR X76;
END_IF;

IF act_location = 1 THEN
    station_src_x := STATION1_X; lift_is_c := TRUE;
ELSE
    station_src_x := STATION2_X; lift_is_c := FALSE;
END_IF;

(* ---- cancellation: expedite return ---- *)
IF (active_idx <> -1) AND act_cancelled AND (state >= 1) AND (state <= 17) THEN
    state := 18;
END_IF;

IF active_idx <> -1 THEN
    CASE state OF
    1:
        D2000 := station_src_x;
        IF lift_is_c THEN D2008 := D92; ELSE D2012 := D92; END_IF;
        IF a_arr AND ((lift_is_c AND c_arr) OR ((NOT lift_is_c) AND d_arr)) THEN
            state := 2;
        END_IF;

    2:
        D2004 := FORK_CONNECT;
        IF act_location = 1 THEN cur_station := 1; ELSE cur_station := 2; END_IF;
        IF (D80 <> 2) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := cur_station; D82 := seq_counter;
        END_IF;
        IF cur_station = 1 THEN port_ok := X61 AND (D404 = act_id);
        ELSE port_ok := X62 AND (D407 = act_id);
        END_IF;
        IF b_arr AND port_ok THEN state := 3; END_IF;

    3:
        D2004 := FORK_RETRIEVE;
        IF act_location = 1 THEN cur_station := 1; ELSE cur_station := 2; END_IF;
        IF (D80 <> 1) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := cur_station; D82 := seq_counter;
        END_IF;
        IF cur_station = 1 THEN port_ok := X61 AND (D404 = act_id);
        ELSE port_ok := X62 AND (D407 = act_id);
        END_IF;
        IF b_arr AND port_ok THEN state := 4; END_IF;

    4:
        D2000 := STATION3_X;
        IF a_arr THEN state := 5; END_IF;

    5:
        D2004 := FORK_CONNECT;
        cur_station := 3;
        IF (D80 <> 2) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := cur_station; D82 := seq_counter;
        END_IF;
        port_ok := X63 AND (D410 = act_id);
        IF b_arr AND port_ok THEN state := 6; END_IF;

    6:
        D700 := act_id; D701 := 1; D702 := 500;
        c3_captured := FALSE;
        state := 7;

    7:
        IF act_lane = 0 THEN goal_axis := D500; ELSE goal_axis := D501; END_IF;
        IF NOT c3_captured THEN
            IF act_lane = 0 THEN D2016 := goal_axis; ELSE D2020 := goal_axis; END_IF;
            IF (D522 = act_id) AND (D524 = D91) THEN
                c3_final_target := D523 + FIN_OFFSET;
                c3_captured := TRUE;
            END_IF;
        ELSE
            IF act_lane = 0 THEN
                D2016 := c3_final_target;
                IF s30_arr AND X70 THEN state := 8; END_IF;
            ELSE
                D2020 := c3_final_target;
                IF s31_arr AND X70 THEN state := 8; END_IF;
            END_IF;
        END_IF;

    8:
        D2004 := FORK_CONNECT;
        cur_station := 3;
        IF (D80 <> 2) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := cur_station; D82 := seq_counter;
        END_IF;
        port_ok := X63 AND (D410 = act_id);
        IF b_arr AND port_ok THEN state := 9; END_IF;

    9:
        D2004 := FORK_RETRIEVE;
        cur_station := 3;
        IF (D80 <> 1) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := cur_station; D82 := seq_counter;
        END_IF;
        port_ok := X63 AND (D410 = act_id);
        IF b_arr AND port_ok THEN state := 10; END_IF;

    10:
        D2000 := STATION4_X;
        IF a_arr THEN state := 11; END_IF;

    11:
        D2004 := FORK_CONNECT;
        cur_station := 4;
        IF (D80 <> 2) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := cur_station; D82 := seq_counter;
        END_IF;
        port_ok := X64 AND (D413 = act_id);
        IF b_arr AND port_ok THEN state := 12; END_IF;

    12:
        D710 := act_id; D711 := 1; D712 := 500;
        state := 13;

    13:
        D2024 := D600;
        IF s40_arr THEN state := 14; END_IF;

    14:
        IF act_lane = 0 THEN
            D2028 := PIN_INSERT;
            IF s41_arr AND X75 AND (D622 = act_id) AND (D624 = D91) THEN state := 15; END_IF;
        ELSE
            D2032 := PIN_INSERT;
            IF s42_arr AND X75 AND (D622 = act_id) AND (D624 = D91) THEN state := 15; END_IF;
        END_IF;

    15:
        IF act_lane = 0 THEN
            D2028 := S4_HOME;
            IF s41_arr THEN state := 16; END_IF;
        ELSE
            D2032 := S4_HOME;
            IF s42_arr THEN state := 16; END_IF;
        END_IF;

    16:
        D2004 := FORK_CONNECT;
        cur_station := 4;
        IF (D80 <> 2) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := cur_station; D82 := seq_counter;
        END_IF;
        port_ok := X64 AND (D413 = act_id);
        IF b_arr AND port_ok THEN state := 17; END_IF;

    17:
        D2004 := FORK_RETRIEVE;
        cur_station := 4;
        IF (D80 <> 1) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := cur_station; D82 := seq_counter;
        END_IF;
        port_ok := X64 AND (D413 = act_id);
        IF b_arr AND port_ok THEN state := 18; END_IF;

    18:
        D2000 := station_src_x;
        IF a_arr THEN state := 19; END_IF;

    19:
        D2004 := FORK_CONNECT;
        IF act_location = 1 THEN cur_station := 1; ELSE cur_station := 2; END_IF;
        IF (D80 <> 2) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 2; D81 := cur_station; D82 := seq_counter;
        END_IF;
        IF cur_station = 1 THEN port_ok := X61 AND (D404 = act_id);
        ELSE port_ok := X62 AND (D407 = act_id);
        END_IF;
        IF b_arr AND port_ok THEN state := 20; END_IF;

    20:
        D2004 := FORK_RETRIEVE;
        IF lift_is_c THEN D2008 := LIFT_HOME; ELSE D2012 := LIFT_HOME; END_IF;
        IF act_location = 1 THEN cur_station := 1; ELSE cur_station := 2; END_IF;
        IF (D80 <> 1) OR (D81 <> cur_station) THEN
            seq_counter := seq_counter + 1;
            D80 := 1; D81 := cur_station; D82 := seq_counter;
        END_IF;
        IF cur_station = 1 THEN port_ok := X61 AND (D404 = act_id);
        ELSE port_ok := X62 AND (D407 = act_id);
        END_IF;
        IF b_arr AND port_ok THEN state := 21; END_IF;

    21:
        IF lift_is_c THEN D2008 := LIFT_HOME; ELSE D2012 := LIFT_HOME; END_IF;
        IF (lift_is_c AND c_arr) OR ((NOT lift_is_c) AND d_arr) THEN
            IF (active_idx = 0 AND X30) OR (active_idx = 1 AND X34) THEN
                state := 22;
            END_IF;
        END_IF;

    22:
        IF active_idx = 0 THEN
            D300 := act_id;
            IF act_cancelled THEN D301 := 2; ELSE D301 := 1; END_IF;
            req0_done := TRUE;
        ELSE
            D302 := act_id;
            IF act_cancelled THEN D303 := 2; ELSE D303 := 1; END_IF;
            req1_done := TRUE;
        END_IF;
        state := 23;

    23:
        active_idx := -1;
        state := 0;

    ELSE
        ;
    END_CASE;
END_IF;

(* ---- ownership retain / configure flag windows ---- *)
IF (active_idx <> -1) AND (state >= 6) AND (state <= 7) THEN
    Y70 := TRUE;
END_IF;
IF (active_idx <> -1) AND (state >= 6) AND (state <= 13) THEN
    Y71 := TRUE;
END_IF;
IF (active_idx <> -1) AND (state >= 12) AND (state <= 14) THEN
    Y75 := TRUE;
END_IF;
IF (active_idx <> -1) AND (state >= 12) AND (state <= 15) THEN
    Y76 := TRUE;
END_IF;

(* ---- brake: engaged only while parked with no active request ---- *)
Y30 := (active_idx = -1);

(* ---- final completion check ---- *)
home_ok := (ABS(D1000 - 0) <= POS_TOL)
       AND (ABS(D1004 - FORK_RETRIEVE) <= POS_TOL)
       AND (ABS(D1008 - LIFT_HOME) <= POS_TOL)
       AND (ABS(D1012 - LIFT_HOME) <= POS_TOL)
       AND (ABS(D1016 - S3_HOME) <= POS_TOL)
       AND (ABS(D1020 - S3_HOME) <= POS_TOL)
       AND (ABS(D1024 - S4_HOME) <= POS_TOL)
       AND (ABS(D1028 - S4_HOME) <= POS_TOL)
       AND (ABS(D1032 - S4_HOME) <= POS_TOL)
       AND (ABS(D1001) <= VEL_TOL)
       AND (ABS(D1005) <= VEL_TOL)
       AND (ABS(D1009) <= VEL_TOL)
       AND (ABS(D1013) <= VEL_TOL);

completion_ready := X51 AND home_ok AND (active_idx = -1);

fin_timer(IN := completion_ready, PT := T#100ms);

IF fin_timer.Q THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM