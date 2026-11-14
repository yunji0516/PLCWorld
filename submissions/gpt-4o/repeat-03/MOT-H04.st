PROGRAM Main
VAR
    D1000 : DINT; // a_position; Actual position of shared shuttle X ×0.01 mm.
    D1001 : DINT; // a_velocity; Actual speed of shared shuttle X ×0.01 mm/s.
    D1004 : DINT; // b_position; Actual position of connection fork ×0.01 mm.
    D1005 : DINT; // b_velocity; Actual speed of connection fork ×0.01 mm/s.
    D1008 : DINT; // c_position; Actual position of lift A ×0.01 mm.
    D1009 : DINT; // c_velocity; Actual speed of lift A ×0.01 mm/s.
    D1012 : DINT; // d_position; Actual position of lift B ×0.01 mm.
    D1013 : DINT; // d_velocity; Actual speed of lift B ×0.01 mm/s.
    D1016 : DINT; // s3_0_position; Actual position of s3_0 ×0.01 mm.
    D1017 : DINT; // s3_0_velocity; Actual speed of s3_0 ×0.01 mm/s.
    D1020 : DINT; // s3_1_position; Actual position of s3_1 ×0.01 mm.
    D1021 : DINT; // s3_1_velocity; Actual speed of s3_1 ×0.01 mm/s.
    D1024 : DINT; // s3_2_position; s3_2 actual position ×0.01 deg.
    D1025 : DINT; // s3_2_velocity; s3_2 actual speed ×0.01 deg/s.
    D1028 : DINT; // s4_0_position; s4_0 actual position ×0.01 deg.
    D1029 : DINT; // s4_0_velocity; s4_0 actual speed ×0.01 deg/s.
    D1032 : DINT; // s4_1_position; s4_1 actual position ×0.01 mm.
    D1033 : DINT; // s4_1_velocity; s4_1 actual speed ×0.01 mm/s.
    D100 : DINT;  // r0_id; request 1 id.
    D101 : DINT;  // r0_location; request 1 location.
    D102 : DINT;  // r0_progress; request 1 progress.
    D103 : DINT;  // r0_due; request 1 due.
    D104 : DINT;  // r0_record; request 1 record.
    X30 : BOOL;   // r0_returned; request 1 returned.
    X31 : BOOL;   // r0_cancelled; request 1 cancelled.
    D120 : DINT;  // r1_id; request 2 id.
    D121 : DINT;  // r1_location; request 2 location.
    D122 : DINT;  // r1_progress; request 2 progress.
    D123 : DINT;  // r1_due; request 2 due.
    D124 : DINT;  // r1_record; request 2 record.
    X34 : BOOL;   // r1_returned; request 2 returned.
    X35 : BOOL;   // r1_cancelled; request 2 cancelled.
    X51 : BOOL;   // all_done; all requests through future requests completed.
    D90 : DINT;   // holding; Shuttle fixture request ID.
    D91 : DINT;   // epoch; common reference generation.
    D92 : DINT;   // source_dock; lift connection height ×0.01 mm.
    X52 : BOOL;   // brake_closed; common brake closed.
    X53 : BOOL;   // brake_open; common brake open.
    D403 : DINT;  // port1_x; connection position ×0.01 mm.
    D404 : DINT;  // port1_id; relevant equipment usage request ID.
    X61 : BOOL;   // port1_ready; actual connection posture·stop.
    D406 : DINT;  // port2_x; connection position ×0.01 mm.
    D407 : DINT;  // port2_id; relevant equipment usage request ID.
    X62 : BOOL;   // port2_ready; actual connection posture·stop.
    D409 : DINT;  // port3_x; connection position ×0.01 mm.
    D410 : DINT;  // port3_id; relevant equipment usage request ID.
    X63 : BOOL;   // port3_ready; actual connection posture·stop.
    D412 : DINT;  // port4_x; connection position ×0.01 mm.
    D413 : DINT;  // port4_id; relevant equipment usage request ID.
    X64 : BOOL;   // port4_ready; actual connection posture·stop.
    D500 : DINT;  // m3_goal0; request's physical target ×0.01.
    D501 : DINT;  // m3_goal1; request's physical target ×0.01.
    D502 : DINT;  // m3_goal2; Physical target of request ×0.01.
    D520 : DINT;  // m3_lane; hoist lane.
    D521 : DINT;  // m3_origin; hoist origin.
    D522 : DINT;  // m3_capture_owner; hoist capture_owner.
    D523 : DINT;  // m3_capture; hoist capture.
    D524 : DINT;  // m3_capture_epoch; hoist capture_epoch.
    D525 : DINT;  // m3_span; hoist span.
    D526 : DINT;  // m3_route; hoist route.
    D527 : DINT;  // m3_angle; hoist angle.
    X70 : BOOL;   // m3_served; hoist served.
    X71 : BOOL;   // m3_cancelled; hoist cancelled.
    X72 : BOOL;   // m3_synced; hoist synced.
    D600 : DINT;  // m4_goal0; request's physical target ×0.01.
    D601 : DINT;  // m4_goal1; request's physical target ×0.01.
    D620 : DINT;  // m4_lane; balanced inclined head lane.
    D621 : DINT;  // m4_origin; balanced inclined head origin.
    D622 : DINT;  // m4_capture_owner; balanced inclined head capture_owner.
    D623 : DINT;  // m4_capture; balanced inclined head capture.
    D624 : DINT;  // m4_capture_epoch; balanced inclined head capture_epoch.
    D625 : DINT;  // m4_span; balanced inclined head span.
    D626 : DINT;  // m4_route; balanced inclined head route.
    D627 : DINT;  // m4_angle; balanced inclined head angle.
    X75 : BOOL;   // m4_served; balanced inclined head served.
    X76 : BOOL;   // m4_cancelled; balanced inclined head cancelled.
    X77 : BOOL;   // m4_synced; balanced inclined head synced.
    D2000 : DINT; // a_target; Target of shared shuttle X ×0.01.
    D2001 : DINT; // a_rate; Drive ratio of shared shuttle X ×0.001.
    D2002 : DINT; // a_ff; Speed feedforward input of shared shuttle X ×0.01.
    Y40 : BOOL;   // a_enable; Torque and drive activation of shared shuttle X.
    D2004 : DINT; // b_target; Target of connection fork ×0.01.
    D2005 : DINT; // b_rate; Drive ratio of connection fork ×0.001.
    D2006 : DINT; // b_ff; Speed feedforward input of connection fork ×0.01.
    Y41 : BOOL;   // b_enable; Torque and drive activation of connection fork.
    D2008 : DINT; // c_target; Target of lift A ×0.01.
    D2009 : DINT; // c_rate; Drive ratio of lift A ×0.001.
    D2010 : DINT; // c_ff; Speed feedforward input of lift A ×0.01.
    Y42 : BOOL;   // c_enable; Torque and drive activation of lift A.
    D2012 : DINT; // d_target; Target of lift B ×0.01.
    D2013 : DINT; // d_rate; Drive ratio of lift B ×0.001.
    D2014 : DINT; // d_ff; Speed feedforward input of lift B ×0.01.
    Y43 : BOOL;   // d_enable; Torque and drive activation of lift B.
    D2016 : DINT; // s3_0_target; Target of s3_0 ×0.01.
    D2017 : DINT; // s3_0_rate; Drive ratio of s3_0 ×0.001.
    D2018 : DINT; // s3_0_ff; Speed feedforward input of s3_0 ×0.01.
    Y44 : BOOL;   // s3_0_enable; Torque and drive activation of s3_0.
    D2020 : DINT; // s3_1_target; Target of s3_1 ×0.01.
    D2021 : DINT; // s3_1_rate; Drive ratio of s3_1 ×0.001.
    D2022 : DINT; // s3_1_ff; s3_1 speed lead input ×0.01.
    Y45 : BOOL;   // s3_1_enable; s3_1 torque·drive active.
    D2024 : DINT; // s3_2_target; s3_2 target ×0.01.
    D2025 : DINT; // s3_2_rate; s3_2 drive ratio ×0.001.
    D2026 : DINT; // s3_2_ff; s3_2 speed feedforward input ×0.01.
    Y46 : BOOL;   // s3_2_enable; s3_2 torque/drive active.
    D2028 : DINT; // s4_0_target; s4_0 target ×0.01.
    D2029 : DINT; // s4_0_rate; s4_0 drive ratio ×0.001.
    D2030 : DINT; // s4_0_ff; s4_0 speed feedforward input ×0.01.
    Y47 : BOOL;   // s4_0_enable; s4_0 torque/drive active.
    D2032 : DINT; // s4_1_target; s4_1 target ×0.01.
    D2033 : DINT; // s4_1_rate; s4_1 drive ratio ×0.001.
    D2034 : DINT; // s4_1_ff; s4_1 speed feedforward input ×0.01.
    Y48 : BOOL;   // s4_1_enable; s4_1 torque/drive active.
    D300 : DINT;  // ack0; completion ID per request.
    D301 : DINT;  // status0; completion 1 / cancellation retrieval 2.
    D302 : DINT;  // ack1; completion ID per request.
    D303 : DINT;  // status1; completion 1 / cancellation retrieval 2.
    Y70 : BOOL;   // m3_configure; hoist configure.
    Y71 : BOOL;   // m3_retain; hoist retain.
    D700 : DINT;  // m3_select; hoist select.
    D701 : DINT;  // m3_route; hoist route.
    D702 : DINT;  // m3_accel; hoist accel.
    Y75 : BOOL;   // m4_configure; balanced inclined head configure.
    Y76 : BOOL;   // m4_retain; balanced inclined head retain.
    D710 : DINT;  // m4_select; balanced inclined head select.
    D711 : DINT;  // m4_route; balanced inclined head route.
    D712 : DINT;  // m4_accel; balanced inclined head accel.
    D80 : DINT;   // action; connection 1 extraction / 2 placement.
    D81 : DINT;   // station; connection target 1/2 lift A/B, 3/4 subsequent cell.
    D82 : DINT;   // couple_seq; new connection sequence number.
    Y30 : BOOL;   // brake; common brake engaged.
    Y2 : BOOL;    // completion; Completion of actual alignment and return for all requests.
    // Internal Variables
    current_request : DINT := 0;
    request_completed : BOOL := FALSE;
    request_sequence : DINT := 1;
    settle_timer : TON;
    brake_management_timer : TON;
    all_requests_completed : BOOL := FALSE;
    // Add more as needed
END_VAR

(* Implement the control logic here. *)

// Initialize the settle timer
settle_timer(IN := FALSE, PT := T#100ms);

// Initialize the brake management timer
brake_management_timer(IN := FALSE, PT := T#100ms);

// Sequence number increment logic
IF NOT all_requests_completed THEN
    IF current_request < 2 THEN
        current_request := current_request + 1;
        request_sequence := request_sequence + 1;
    ELSE
        all_requests_completed := TRUE;
    END_IF
END_IF

// Start handling requests
CASE current_request OF 
    0: // Request 1
        
        // Move the shuttle to connection point A
        D2000 := DINT(-4050 * 100); // Convert mm to 0.01 unit
        D2001 := DINT(1 * 1000); // Drive full speed
        Y40 := TRUE; // Enable shuttle drive
        
        // Check connection and request completion
        IF X61 THEN
            D300 := r0_id; // Confirm request 1 completion
            D301 := 1; // Set status to completion
            
            // Manage brake
            IF NOT X52 THEN
                Y30 := TRUE; // Engage brake
            END_IF
            
            // Start settle timer
            settle_timer(IN := TRUE);
            
            // Disable shuttle once position is reached
            Y40 := FALSE;
            
            // Check for completion
            IF settle_timer.Q THEN
                request_completed := TRUE;
            END_IF
        END_IF
        
    1: // Request 2

        // Move the shuttle to connection point B
        D2000 := DINT(-1850 * 100); // Convert mm to 0.01 unit
        D2001 := DINT(1 * 1000); // Drive full speed
        Y41 := TRUE; // Enable shuttle drive
        
        // Check connection and request completion
        IF X62 THEN
            D302 := r1_id; // Confirm request 2 completion
            D303 := 1; // Set status to completion
            
            // Manage brake
            IF NOT X52 THEN
                Y30 := TRUE; // Engage brake
            END_IF
            
            // Start settle timer
            settle_timer(IN := TRUE);
            
            // Disable shuttle once position is reached
            Y41 := FALSE;

            // Check for completion
            IF settle_timer.Q THEN
                request_completed := TRUE;
            END_IF
        END_IF
END_CASE

// Final completion signal
IF all_requests_completed AND request_completed THEN
    Y2 := TRUE;
    brake_management_timer(IN := TRUE);
    
    IF brake_management_timer.Q THEN
        // Reset brakes and timers
        Y2 := FALSE;
        Y30 := FALSE;
        brake_management_timer(IN := FALSE);
        settle_timer(IN := FALSE);
    END_IF
END_IF

END_PROGRAM