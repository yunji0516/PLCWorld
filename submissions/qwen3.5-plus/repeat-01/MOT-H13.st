```
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

    scan_cnt : DINT := 0;
    seq_num : DINT := 0;

    r0_active : BOOL := FALSE;
    r0_phase : INT := 0;
    r0_ack : DINT := 0;
    r0_status : DINT := 0;
    r0_lane : INT := 0;
    r0_target : DINT := 0;
    r0_cell3_done : BOOL := FALSE;
    r0_cell4_done : BOOL := FALSE;
    r0_sync_established : BOOL := FALSE;
    r0_sync_time : DINT := 0;
    r0_ended : BOOL := FALSE;

    r1_active : BOOL := FALSE;
    r1_phase : INT := 0;
    r1_ack : DINT := 0;
    r1_status : DINT := 0;
    r1_lane : INT := 0;
    r1_target : DINT := 0;
    r1_cell3_done : BOOL := FALSE;
    r1_cell4_done : BOOL := FALSE;
    r1_sync_established : BOOL := FALSE;
    r1_sync_time : DINT := 0;
    r1_ended : BOOL := FALSE;

    shuttle_target : DINT := 0;
    fork_target : DINT := 0;
    lift_target : DINT := 0;
    motor_running : BOOL := FALSE;
    motor_stable_time : DINT := 0;

    cfg_m3 : BOOL := FALSE;
    ret_m3 : BOOL := FALSE;
    sel_m3 : DINT := 0;
    route_m3 : DINT := 0;
    accel_m3 : DINT := 0;

    cfg_m4 : BOOL := FALSE;
    ret_m4 : BOOL := FALSE;
    sel_m4 : DINT := 0;
    route_m4 : DINT := 0;
    accel_m4 : DINT := 0;

    act_station : DINT := 0;
    act_action : DINT := 0;

    all_done_flag : BOOL := FALSE;
    done_hold_time : DINT := 0;

    s3_home_pos : DINT := 0;
    s4_0_home_pos : DINT := 0;
    s4_1_home_pos : DINT := 0;
    c_home_pos : DINT := 40000;
    d_home_pos : DINT := 40000;
    a_home_pos : DINT := 0;
    b_home_pos : DINT := 0;

    timer_sync : TON;
    timer_done : TON;
    timer_stable : TON;
    timer_motor : TON;
    timer_scan : TON;

    prev_r0_loc : DINT := -1;
    prev_r1_loc : DINT := -1;
    prev_r0_prog : DINT := -1;
    prev_r1_prog : DINT := -1;

    prev_s3_0_vel : REAL := 0.0;
    prev_s3_1_vel : REAL := 0.0;
    prev_s3_2_vel : REAL := 0.0;
    prev_s4_0_vel : REAL := 0.0;
    prev_s4_1_vel : REAL := 0.0;

    current_request_id : DINT := 0;
    is_r0_active : BOOL := FALSE;
END_VAR

VAR CONSTANT
    SCAN_MS : DINT := 20;
    DOCK_HEIGHT : DINT := 95000;
    HOME_A : DINT := 0;
    HOME_B : DINT := 0;
    HOME_C : DINT := 40000;
    HOME_D : DINT := 40000;
    HOME_S3 : DINT := 0;
    HOME_S4 : DINT := 0;
    PORT1_X : DINT := -405000;
    PORT2_X : DINT := -185000;
    PORT3_X : DINT := 65000;
    PORT4_X : DINT := 3600000;
    FORK_RETRACT : DINT := 0;
    FORK_EXTEND : DINT := 18000;
    SPEED_RATE : DINT := 200;
    MIN_RATE : DINT := 20;
    AXIS_RATE : DINT := 500;
    MAX_ANGLE_ERR : DINT := 20;
    MAX_SPEED_ERR : DINT := 100;
    ESTABLISH_ANGLE_ERR : DINT := 20;
    ESTABLISH_SPEED_ERR : DINT := 100;
    SYNC_HOLD_MS : DINT := 50;
    RESULT_HOLD_MS : DINT := 80;
    BRAKE_RELEASE : BOOL := FALSE;
    BRAKE_ENGAGE : BOOL := TRUE;
END_VAR

scan_cnt := scan_cnt + 1;

timer_sync(IN := FALSE, PT := T#50ms);
timer_done(IN := FALSE, PT := T#100ms);
timer_stable(IN := FALSE, PT := T#100ms);
timer_motor(IN := FALSE, PT := T#30ms);

D80 := 0;
D81 := 0;
D82 := seq_num;

D700 := sel_m3;
D701 := route_m3;
D702 := accel_m3;
Y70 := cfg_m3;
Y71 := ret_m3;

D710 := sel_m4;
D711 := route_m4;
D712 := accel_m4;
Y75 := cfg_m4;
Y76 := ret_m4;

D300 := r0_ack;
D301 := r0_status;
D302 := r1_ack;
D303 := r1_status;

Y2 := FALSE;

IF NOT all_done_flag THEN
    IF r0_ended AND r1_ended THEN
        timer_done(IN := TRUE, PT := T#100ms);
        IF timer_done.Q THEN
            Y2 := TRUE;
            all_done_flag := TRUE;
        END_IF;
    END_IF;
END_IF;

IF (prev_r0_loc = 0 OR prev_r0_loc = -1) AND D101 <> 0 AND NOT r0_ended THEN
    IF D101 <> prev_r0_loc OR prev_r0_loc = -1 THEN
        IF D101 = 1 OR D101 = 2 OR D101 = 3 OR D101 = 4 THEN
            r0_active := TRUE;
            r0_phase := 0;
            r0_lane := INT_TO_INT(D100 MOD 2);
            r0_target := D500;
            r0_cell3_done := FALSE;
            r0_cell4_done := FALSE;
            r0_sync_established := FALSE;
            r0_sync_time := 0;
            r0_ended := FALSE;
            r0_ack := D100;
            r0_status := 0;
        END_IF;
    END_IF;
END_IF;

IF (prev_r1_loc = 0 OR prev_r1_loc = -1) AND D121 <> 0 AND NOT r1_ended THEN
    IF D121 <> prev_r1_loc OR prev_r1_loc = -1 THEN
        IF D121 = 1 OR D121 = 2 OR D121 = 3 OR D121 = 4 THEN
            r1_active := TRUE;
            r1_phase := 0;
            r1_lane := INT_TO_INT(D120 MOD 2);
            r1_target := D600;
            r1_cell3_done := FALSE;
            r1_cell4_done := FALSE;
            r1_sync_established := FALSE;
            r1_sync_time := 0;
            r1_ended := FALSE;
            r1_ack := D120;
            r1_status := 0;
        END_IF;
    END_IF;
END_IF;

IF X31 AND r0_active AND NOT r0_ended THEN
    r0_status := 2;
    r0_ended := TRUE;
END_IF;

IF X35 AND r1_active AND NOT r1_ended THEN
    r1_status := 2;
    r1_ended := TRUE;
END_IF;

prev_r0_loc := D101;
prev_r1_loc := D121;
prev_r0_prog := D102;
prev_r1_prog := D122;

END_PROGRAM
```