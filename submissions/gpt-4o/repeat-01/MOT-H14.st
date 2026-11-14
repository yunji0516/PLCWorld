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
    D1024 : DINT; // s4_0_position
    D1025 : DINT; // s4_0_velocity
    D1028 : DINT; // s4_1_position
    D1029 : DINT; // s4_1_velocity
    D100 : DINT; // r0_id
    D101 : DINT; // r0_location
    D102 : DINT; // r0_progress
    D103 : DINT; // r0_due
    D104 : DINT; // r0_record
    X30 : BOOL;  // r0_returned
    X31 : BOOL;  // r0_cancelled
    D120 : DINT; // r1_id
    D121 : DINT; // r1_location
    D122 : DINT; // r1_progress
    D123 : DINT; // r1_due
    D124 : DINT; // r1_record
    X34 : BOOL;  // r1_returned
    X35 : BOOL;  // r1_cancelled
    X51 : BOOL;  // all_done
    D90 : DINT;  // holding
    D91 : DINT;  // epoch
    D92 : DINT;  // source_dock
    X52 : BOOL;  // brake_closed
    X53 : BOOL;  // brake_open
    D403 : DINT; // port1_x
    D404 : DINT; // port1_id
    X61 : BOOL;  // port1_ready
    D406 : DINT; // port2_x
    D407 : DINT; // port2_id
    X62 : BOOL;  // port2_ready
    D409 : DINT; // port3_x
    D410 : DINT; // port3_id
    X63 : BOOL;  // port3_ready
    D412 : DINT; // port4_x
    D413 : DINT; // port4_id
    X64 : BOOL;  // port4_ready
    D500 : DINT; // m3_goal0
    D501 : DINT; // m3_goal1
    D520 : DINT; // m3_lane
    D521 : DINT; // m3_origin
    D522 : DINT; // m3_capture_owner
    D523 : DINT; // m3_capture
    D524 : DINT; // m3_capture_epoch
    D525 : DINT; // m3_span
    D526 : DINT; // m3_route
    D527 : DINT; // m3_angle
    X70 : BOOL;  // m3_served
    X71 : BOOL;  // m3_cancelled
    X72 : BOOL;  // m3_synced
    D600 : DINT; // m4_goal0
    D601 : DINT; // m4_goal1
    D620 : DINT; // m4_lane
    D621 : DINT; // m4_origin
    D622 : DINT; // m4_capture_owner
    D623 : DINT; // m4_capture
    D624 : DINT; // m4_capture_epoch
    D625 : DINT; // m4_span
    D626 : DINT; // m4_route
    D627 : DINT; // m4_angle
    X75 : BOOL;  // m4_served
    X76 : BOOL;  // m4_cancelled
    X77 : BOOL;  // m4_synced
    D2000 : DINT; // a_target
    D2001 : DINT; // a_rate
    D2002 : DINT; // a_ff
    Y40 : BOOL;   // a_enable
    D2004 : DINT; // b_target
    D2005 : DINT; // b_rate
    D2006 : DINT; // b_ff
    Y41 : BOOL;   // b_enable
    D2008 : DINT; // c_target
    D2009 : DINT; // c_rate
    D2010 : DINT; // c_ff
    Y42 : BOOL;   // c_enable
    D2012 : DINT; // d_target
    D2013 : DINT; // d_rate
    D2014 : DINT; // d_ff
    Y43 : BOOL;   // d_enable
    D2016 : DINT; // s3_0_target
    D2017 : DINT; // s3_0_rate
    D2018 : DINT; // s3_0_ff
    Y44 : BOOL;   // s3_0_enable
    D2020 : DINT; // s3_1_target
    D2021 : DINT; // s3_1_rate
    D2022 : DINT; // s3_1_ff
    Y45 : BOOL;   // s3_1_enable
    D2024 : DINT; // s4_0_target
    D2025 : DINT; // s4_0_rate
    D2026 : DINT; // s4_0_ff
    Y46 : BOOL;   // s4_0_enable
    D2028 : DINT; // s4_1_target
    D2029 : DINT; // s4_1_rate
    D2030 : DINT; // s4_1_ff
    Y47 : BOOL;   // s4_1_enable
    D300 : DINT;  // ack0
    D301 : DINT;  // status0
    D302 : DINT;  // ack1
    D303 : DINT;  // status1
    Y70 : BOOL;   // m3_configure
    Y71 : BOOL;   // m3_retain
    D700 : DINT;  // m3_select
    D701 : DINT;  // m3_route
    D702 : DINT;  // m3_accel
    Y75 : BOOL;   // m4_configure
    Y76 : BOOL;   // m4_retain
    D710 : DINT;  // m4_select
    D711 : DINT;  // m4_route
    D712 : DINT;  // m4_accel
    D80 : DINT;   // action
    D81 : DINT;   // station
    D82 : DINT;   // couple_seq
    Y30 : BOOL;   // brake
    Y2 : BOOL;    // completion
    reference_changed : BOOL; // Internal flag
    current_reference : DINT; // Current reference
    new_reference : DINT;     // New reference
    previous_epoch : DINT;
    completion_timer : TON;
    epoch_change_edge : R_TRIG;
    request_in_progress : BOOL;
    target_set : BOOL;
END_VAR

// Initialize current reference from initial epoch
current_reference := D91;
new_reference := D91;

// Detect reference change
epoch_change_edge(CLK := (previous_epoch <> D91));
IF epoch_change_edge.Q THEN
    reference_changed := TRUE;
    new_reference := D91;
END_IF
previous_epoch := D91;

// Evaluate the position settings for requests
IF request_in_progress = FALSE THEN
    // Process requests if not in progress
    IF D102 = 0 THEN // Request 1 not in progress
        D2000 := 0; // Set target for shuttle X
        D2001 := 1000; // Set rate for shuttle X
        D2002 := 0; // No feedforward
        Y40 := TRUE; // Enable shuttle X
        request_in_progress := TRUE;
        target_set := FALSE;
    ELSIF D122 = 0 THEN // Request 2 not in progress
        D2000 := 0; // Set target for shuttle X
        D2001 := 1000; // Set rate for shuttle X
        D2002 := 0; // No feedforward
        Y40 := TRUE; // Enable shuttle X
        request_in_progress := TRUE;
        target_set := FALSE;
    END_IF
ELSE
    // Check request progress and update targets
    IF D102 > 0 AND target_set = FALSE THEN
        // Set the target for cell 3 processing
        D2016 := m3_goal0;
        D2017 := 1000; // Full rate
        D2018 := 0;    // Feedforward
        Y44 := TRUE;   // Enable s3_0
        D2020 := m3_goal1;
        D2021 := 1000;
        D2022 := 0;
        Y45 := TRUE;
        target_set := TRUE;
        
    ELSIF D122 > 0 AND target_set = FALSE THEN
        // Set the target for cell 4 processing
        D2024 := m4_goal0;
        D2025 := 1000; // Full rate
        D2026 := 0;    // Feedforward
        Y46 := TRUE;   // Enable s4_0
        D2028 := m4_goal1;
        D2029 := 1000;
        D2030 := 0;
        Y47 := TRUE;
        target_set := TRUE;
    END_IF
END_IF

// Completion logic
IF request_in_progress THEN
    IF X51 THEN // Check if all_done input
        Y2 := TRUE; // Set completion flag
        completion_timer(IN := TRUE, PT := T#100ms);
        IF completion_timer.Q THEN
            request_in_progress := FALSE; // Reset request in progress flag
            Y2 := FALSE; // Reset completion flag
        END_IF
    ELSE
        Y2 := FALSE;
        completion_timer(IN := FALSE);
    END_IF
END_IF

END_PROGRAM