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

    (* Internal state *)
    active_req      : INT := 0;
    r0_stage        : INT := 0;
    r1_stage        : INT := 0;
    cur_stage       : INT := 0;
    cur_location    : DINT := 0;
    cur_cancelled   : BOOL := FALSE;
    cur_id          : DINT := 0;
    station_num     : DINT := 0;
    a_tgt           : DINT := 0;
    b_tgt           : DINT := 0;
    lift_tgt        : DINT := 0;
    lift_needed     : BOOL := FALSE;
    a_ok            : BOOL := FALSE;
    b_ok            : BOOL := FALSE;
    lift_ok         : BOOL := FALSE;
    c_target        : DINT := 40000;
    d_target        : DINT := 40000;
    status_val      : DINT := 0;
    seq             : DINT := 0;
    last_conn_stage : INT := 0;
    final_latch     : BOOL := FALSE;
    postures_ok     : BOOL := FALSE;
    motor_run       : BOOL := FALSE;
    gear_run        : BOOL := FALSE;
    POS_TOL         : DINT := 20;
    VEL_TOL         : DINT := 100;
    HOME_LIFT       : DINT := 40000;
    FORK_CONNECT    : DINT := 18000;
    FORK_HOME       : DINT := 0;
END_VAR

(* ---- select which request currently owns the shared shuttle ---- *)
IF active_req = 0 THEN
    IF r0_stage < 13 THEN
        active_req := 1;
        IF r0_stage = 0 THEN r0_stage := 1; END_IF;
    ELSIF r1_stage < 13 THEN
        active_req := 2;
        IF r1_stage = 0 THEN r1_stage := 1; END_IF;
    END_IF;
ELSIF active_req = 1 THEN
    IF r0_stage >= 13 THEN
        active_req := 0;
    END_IF;
ELSIF active_req = 2 THEN
    IF r1_stage >= 13 THEN
        active_req := 0;
    END_IF;
END_IF;

(* ---- load context for active request ---- *)
IF active_req = 1 THEN
    cur_stage := r0_stage;
    cur_location := D101;
    cur_cancelled := X31;
    cur_id := D100;
ELSIF active_req = 2 THEN
    cur_stage := r1_stage;
    cur_location := D121;
    cur_cancelled := X35;
    cur_id := D120;
ELSE
    cur_stage := 0;
    cur_location := 0;
    cur_cancelled := FALSE;
    cur_id := 0;
END_IF;

(* ---- defaults : everything idle at home ---- *)
a_tgt := 0;
b_tgt := 0;
c_target := HOME_LIFT;
d_target := HOME_LIFT;
station_num := 0;
lift_needed := FALSE;

IF active_req <> 0 THEN

    (* cancellation: skip remaining cell processing, go retrieve & return *)
    IF cur_cancelled AND cur_stage >= 3 AND cur_stage <= 8 THEN
        cur_stage := 9;
    END_IF;

    CASE cur_stage OF
        1:  station_num := cur_location; b_tgt := FORK_CONNECT; lift_needed := TRUE;
        2:  station_num := cur_location; b_tgt := FORK_HOME;    lift_needed := FALSE;
        3:  station_num := 3;            b_tgt := FORK_HOME;    lift_needed := FALSE;
        4:  station_num := 3;            b_tgt := FORK_CONNECT; lift_needed := FALSE;
        5:  station_num := 3;            b_tgt := FORK_HOME;    lift_needed := FALSE;
        6:  station_num := 4;            b_tgt := FORK_HOME;    lift_needed := FALSE;
        7:  station_num := 4;            b_tgt := FORK_CONNECT; lift_needed := FALSE;
        8:  station_num := 4;            b_tgt := FORK_HOME;    lift_needed := FALSE;
        9:  station_num := cur_location; b_tgt := FORK_HOME;    lift_needed := FALSE;
        10: station_num := cur_location; b_tgt := FORK_CONNECT; lift_needed := TRUE;
        11: station_num := cur_location; b_tgt := FORK_HOME;    lift_needed := TRUE;
        12: station_num := cur_location; b_tgt := FORK_HOME;    lift_needed := FALSE;
        ELSE
            station_num := cur_location; b_tgt := FORK_HOME; lift_needed := FALSE;
    END_CASE;

    CASE station_num OF
        1: a_tgt := -405000;
        2: a_tgt := -185000;
        3: a_tgt := 65000;
        4: a_tgt := 360000;
        ELSE
            a_tgt := 0;
    END_CASE;

    IF lift_needed THEN
        lift_tgt := D92;
    ELSE
        lift_tgt := HOME_LIFT;
    END_IF;

    IF cur_location = 1 THEN
        c_target := lift_tgt;
    ELSIF cur_location = 2 THEN
        d_target := lift_tgt;
    END_IF;

    (* arrival tolerance checks *)
    a_ok := (ABS(D1000 - a_tgt) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL);
    b_ok := (ABS(D1004 - b_tgt) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL);
    IF cur_location = 1 THEN
        lift_ok := (ABS(D1008 - lift_tgt) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL);
    ELSE
        lift_ok := (ABS(D1012 - lift_tgt) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);
    END_IF;

    (* new connection sequence number when a fresh coupling engagement begins *)
    IF (cur_stage = 1 OR cur_stage = 4 OR cur_stage = 7 OR cur_stage = 10) AND (cur_stage <> last_conn_stage) THEN
        seq := seq + 1;
        D82 := seq;
        D81 := station_num;
        IF cur_stage = 1 THEN
            D80 := 1;
        ELSE
            D80 := 2;
        END_IF;
    END_IF;
    last_conn_stage := cur_stage;

    (* stage progression *)
    CASE cur_stage OF
        1:  IF a_ok AND b_ok AND lift_ok THEN cur_stage := 2; END_IF;
        2:  IF b_ok THEN cur_stage := 3; END_IF;
        3:  IF a_ok THEN cur_stage := 4; END_IF;
        4:  IF a_ok AND b_ok AND X70 THEN cur_stage := 5; END_IF;
        5:  IF b_ok THEN cur_stage := 6; END_IF;
        6:  IF a_ok THEN cur_stage := 7; END_IF;
        7:  IF a_ok AND b_ok AND X77 AND X75 THEN cur_stage := 8; END_IF;
        8:  IF b_ok THEN cur_stage := 9; END_IF;
        9:  IF a_ok THEN cur_stage := 10; END_IF;
        10: IF a_ok AND b_ok AND lift_ok THEN cur_stage := 11; END_IF;
        11: IF b_ok THEN cur_stage := 12; END_IF;
        12:
            IF lift_ok AND ((active_req = 1 AND X30) OR (active_req = 2 AND X34)) THEN
                status_val := 1;
                IF cur_cancelled THEN
                    status_val := 2;
                END_IF;
                IF active_req = 1 THEN
                    D300 := cur_id;
                    D301 := status_val;
                ELSE
                    D302 := cur_id;
                    D303 := status_val;
                END_IF;
                cur_stage := 13;
            END_IF;
    END_CASE;

    IF active_req = 1 THEN
        r0_stage := cur_stage;
    ELSE
        r1_stage := cur_stage;
    END_IF;
END_IF;

(* ---- cell 4 gear active only while a jig is docked at cell 4 ---- *)
gear_run := (r0_stage = 7) OR (r1_stage = 7);

(* ---- final completion posture check ---- *)
postures_ok :=
    (ABS(D1000) <= POS_TOL) AND (ABS(D1001) <= VEL_TOL) AND
    (ABS(D1004) <= POS_TOL) AND (ABS(D1005) <= VEL_TOL) AND
    (ABS(D1017) <= VEL_TOL) AND
    (ABS(D1020) <= POS_TOL) AND (ABS(D1021) <= VEL_TOL) AND
    (ABS(D1024) <= POS_TOL) AND (ABS(D1025) <= VEL_TOL) AND
    (ABS(D1028) <= POS_TOL) AND (ABS(D1029) <= VEL_TOL) AND
    (ABS(D1032) <= POS_TOL) AND (ABS(D1033) <= VEL_TOL) AND
    (ABS(D1008 - HOME_LIFT) <= POS_TOL) AND (ABS(D1009) <= VEL_TOL) AND
    (ABS(D1012 - HOME_LIFT) <= POS_TOL) AND (ABS(D1013) <= VEL_TOL);

IF X51 AND postures_ok THEN
    final_latch := TRUE;
END_IF;

motor_run := NOT final_latch;

(* ---- shuttle / fork / lift outputs ---- *)
D2000 := a_tgt; D2001 := 1000; D2002 := 0; Y40 := NOT final_latch;
D2004 := b_tgt; D2005 := 1000; D2006 := 0; Y41 := NOT final_latch;
D2008 := c_target; D2009 := 1000; D2010 := 0; Y42 := NOT final_latch;
D2012 := d_target; D2013 := 1000; D2014 := 0; Y43 := NOT final_latch;

(* ---- cell 3 (master, common motor + home-held axes) ---- *)
D2016 := 0; D2017 := 0; D2018 := 0; Y44 := motor_run;
D2020 := 0; D2021 := 1000; D2022 := 0; Y45 := NOT final_latch;
D2024 := 0; D2025 := 1000; D2026 := 0; Y46 := NOT final_latch;

Y70 := FALSE;
Y71 := motor_run;
D700 := 0;
D701 := 0;
D702 := 200;

(* ---- cell 4 (gear, home-held axes with gear following master when engaged) ---- *)
D2028 := 0; D2029 := 1000; D2030 := 0; Y47 := NOT final_latch;
D2032 := 0; D2033 := 1000; D2034 := 0; Y48 := NOT final_latch;

Y75 := gear_run;
Y76 := FALSE;
IF gear_run THEN
    D710 := 1000;
ELSE
    D710 := 0;
END_IF;
D711 := 0;
D712 := 0;

(* ---- brake and final completion ---- *)
Y30 := final_latch;
Y2 := final_latch;

END_PROGRAM