PROGRAM Main
VAR
    D1000 : DINT; // a_position
    D1001 : DINT; // a_velocity
    D1004 : DINT; // b_position
    D1005 : DINT; // b_velocity
    D1008 : DINT; // c_position
    D1009 : DINT; // c_velocity
    D1012 : DINT; // d_position
    D1013 : DINT; // d_velocity
    D1016 : DINT; // s3_0_position
    D1017 : DINT; // s3_0_velocity
    D1020 : DINT; // s3_1_position
    D1021 : DINT; // s3_1_velocity
    D1024 : DINT; // s3_2_position
    D1025 : DINT; // s3_2_velocity
    D1028 : DINT; // s3_3_position
    D1029 : DINT; // s3_3_velocity
    D1032 : DINT; // s4_0_position
    D1033 : DINT; // s4_0_velocity
    D1036 : DINT; // s4_1_position
    D1037 : DINT; // s4_1_velocity
    D1040 : DINT; // s4_2_position
    D1041 : DINT; // s4_2_velocity
    D100 : DINT; // r0_id
    D101 : DINT; // r0_location
    D102 : DINT; // r0_progress
    D103 : DINT; // r0_due
    D104 : DINT; // r0_record
    X30 : BOOL; // r0_returned
    X31 : BOOL; // r0_cancelled
    D120 : DINT; // r1_id
    D121 : DINT; // r1_location
    D122 : DINT; // r1_progress
    D123 : DINT; // r1_due
    D124 : DINT; // r1_record
    X34 : BOOL; // r1_returned
    X35 : BOOL; // r1_cancelled
    X51 : BOOL; // all_done
    D90 : DINT; // holding
    D91 : DINT; // epoch
    D92 : DINT; // source_dock
    X52 : BOOL; // brake_closed
    X53 : BOOL; // brake_open
    D403 : DINT; // port1_x
    D404 : DINT; // port1_id
    X61 : BOOL; // port1_ready
    D406 : DINT; // port2_x
    D407 : DINT; // port2_id
    X62 : BOOL; // port2_ready
    D409 : DINT; // port3_x
    D410 : DINT; // port3_id
    X63 : BOOL; // port3_ready
    D412 : DINT; // port4_x
    D413 : DINT; // port4_id
    X64 : BOOL; // port4_ready
    D500 : DINT; // m3_goal0
    D501 : DINT; // m3_goal1
    D502 : DINT; // m3_goal2
    D503 : DINT; // m3_goal3
    D520 : DINT; // m3_lane
    D521 : DINT; // m3_origin
    D522 : DINT; // m3_capture_owner
    D523 : DINT; // m3_capture
    D524 : DINT; // m3_capture_epoch
    D525 : DINT; // m3_span
    D526 : DINT; // m3_route
    D527 : DINT; // m3_angle
    X70 : BOOL; // m3_served
    X71 : BOOL; // m3_cancelled
    X72 : BOOL; // m3_synced
    D600 : DINT; // m4_goal0
    D601 : DINT; // m4_goal1
    D602 : DINT; // m4_goal2
    D620 : DINT; // m4_lane
    D621 : DINT; // m4_origin
    D622 : DINT; // m4_capture_owner
    D623 : DINT; // m4_capture
    D624 : DINT; // m4_capture_epoch
    D625 : DINT; // m4_span
    D626 : DINT; // m4_route
    D627 : DINT; // m4_angle
    X75 : BOOL; // m4_served
    X76 : BOOL; // m4_cancelled
    X77 : BOOL; // m4_synced
    D2000 : DINT; // a_target
    D2001 : DINT; // a_rate
    D2002 : DINT; // a_ff
    Y40 : BOOL; // a_enable
    D2004 : DINT; // b_target
    D2005 : DINT; // b_rate
    D2006 : DINT; // b_ff
    Y41 : BOOL; // b_enable
    D2008 : DINT; // c_target
    D2009 : DINT; // c_rate
    D2010 : DINT; // c_ff
    Y42 : BOOL; // c_enable
    D2012 : DINT; // d_target
    D2013 : DINT; // d_rate
    D2014 : DINT; // d_ff
    Y43 : BOOL; // d_enable
    D2016 : DINT; // s3_0_target
    D2017 : DINT; // s3_0_rate
    D2018 : DINT; // s3_0_ff
    Y44 : BOOL; // s3_0_enable
    D2020 : DINT; // s3_1_target
    D2021 : DINT; // s3_1_rate
    D2022 : DINT; // s3_1_ff
    Y45 : BOOL; // s3_1_enable
    D2024 : DINT; // s3_2_target
    D2025 : DINT; // s3_2_rate
    D2026 : DINT; // s3_2_ff
    Y46 : BOOL; // s3_2_enable
    D2028 : DINT; // s3_3_target
    D2029 : DINT; // s3_3_rate
    D2030 : DINT; // s3_3_ff
    Y47 : BOOL; // s3_3_enable
    D2032 : DINT; // s4_0_target
    D2033 : DINT; // s4_0_rate
    D2034 : DINT; // s4_0_ff
    Y48 : BOOL; // s4_0_enable
    D2036 : DINT; // s4_1_target
    D2037 : DINT; // s4_1_rate
    D2038 : DINT; // s4_1_ff
    Y49 : BOOL; // s4_1_enable
    D2040 : DINT; // s4_2_target
    D2041 : DINT; // s4_2_rate
    D2042 : DINT; // s4_2_ff
    Y50 : BOOL; // s4_2_enable
    D300 : DINT; // ack0
    D301 : DINT; // status0
    D302 : DINT; // ack1
    D303 : DINT; // status1
    Y70 : BOOL; // m3_configure
    Y71 : BOOL; // m3_retain
    D700 : DINT; // m3_select
    D701 : DINT; // m3_route
    D702 : DINT; // m3_accel
    Y75 : BOOL; // m4_configure
    Y76 : BOOL; // m4_retain
    D710 : DINT; // m4_select
    D711 : DINT; // m4_route
    D712 : DINT; // m4_accel
    D80 : DINT; // action
    D81 : DINT; // station
    D82 : DINT; // couple_seq
    Y30 : BOOL; // brake
    Y2 : BOOL; // completion

    request0_done : BOOL := FALSE;
    request1_done : BOOL := FALSE;
    current_sequence : DINT := 0;
    ton_timer : TON;
    start_completion : BOOL := FALSE;
END_VAR

// Move request processing logic
IF NOT request0_done THEN
    // Handle Request 0
    ton_timer(IN := X70 AND NOT X71, PT := T#80ms);
    IF ton_timer.Q THEN
        request0_done := TRUE;
        D300 := D100; // ack0: respond with request 1 ID
        D301 := 1; // status0: completion
        current_sequence := current_sequence + 1;
    END_IF;
END_IF;

IF request0_done AND NOT request1_done THEN
    // Handle Request 1
    ton_timer(IN := X75 AND NOT X76, PT := T#80ms);
    IF ton_timer.Q THEN
        request1_done := TRUE;
        D302 := D120; // ack1: respond with request 2 ID
        D303 := 1; // status1: completion
    END_IF;
END_IF;

// Completion output logic
IF (request0_done AND request1_done AND NOT start_completion) THEN
    ton_timer(IN := NOT ton_timer.Q AND request0_done AND request1_done, PT := T#100ms);
    IF ton_timer.Q THEN
        Y2 := TRUE;
        start_completion := TRUE;
        ton_timer.IN := FALSE;
    END_IF;
ELSIF start_completion THEN
    Y2 := FALSE;
END_IF;

END_PROGRAM