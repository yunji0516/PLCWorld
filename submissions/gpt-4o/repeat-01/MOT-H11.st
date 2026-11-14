PROGRAM Main
VAR
    // Inputs
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
    D1032 : DINT; // s4_2_position
    D1033 : DINT; // s4_2_velocity
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

    // Outputs
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
    D2024 : DINT; // s4_0_target
    D2025 : DINT; // s4_0_rate
    D2026 : DINT; // s4_0_ff
    Y46 : BOOL; // s4_0_enable
    D2028 : DINT; // s4_1_target
    D2029 : DINT; // s4_1_rate
    D2030 : DINT; // s4_1_ff
    Y47 : BOOL; // s4_1_enable
    D2032 : DINT; // s4_2_target
    D2033 : DINT; // s4_2_rate
    D2034 : DINT; // s4_2_ff
    Y48 : BOOL; // s4_2_enable
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

    // Internal Variables
    currentRequestID : DINT := 0;
    currentStage : INT := 0;
    requestProcessed : BOOL := FALSE;
    completeObservation : BOOL := FALSE;
    completionTimer : TIME := T#0ms;
    req0InProgress : BOOL := FALSE;
    req1InProgress : BOOL := FALSE;
    edge_all_done : R_TRIG;
    edge_completion : R_TRIG;
END_VAR

// Edge detection for all_done and completion
edge_all_done(CLK := X51);
edge_completion(CLK := Y2);

IF NOT requestProcessed THEN
    // Handle Request 0
    IF NOT req0InProgress AND NOT X31 THEN
        IF D1003 <= D103 THEN // Check if the request's due time allows starting
            currentRequestID := D100;
            req0InProgress := TRUE;
            currentStage := 1; // Start with the lift
        END_IF
    END_IF

    // Handle Request 1
    IF NOT req1InProgress AND NOT X35 THEN
        IF D1203 <= D123 THEN // Check if the request's due time allows starting
            currentRequestID := D120;
            req1InProgress := TRUE;
            currentStage := 1; // Start with the lift
        END_IF
    END_IF

    // Process the currently active request
    CASE currentStage OF
        1: 
            // Process lift A/B depending on location
            IF currentRequestID = D100 THEN // Request 0 active
                IF D101 = 1 THEN // Lift A
                    D2008 := 9500; // Move lift A to connection height
                    D2009 := 1000; // Set lift A speed
                    Y42 := TRUE; // Enable drive
                ELSIF D101 = 2 THEN // Lift B
                    D2012 := 9500; // Move lift B to connection height
                    D2013 := 1000; // Set lift B speed
                    Y43 := TRUE; // Enable drive
                END_IF
            ELSIF currentRequestID = D120 THEN // Request 1 active
                IF D121 = 1 THEN // Lift A
                    D2008 := 9500; // Move lift A to connection height
                    D2009 := 1000; // Set lift A speed
                    Y42 := TRUE; // Enable drive
                ELSIF D121 = 2 THEN // Lift B
                    D2012 := 9500; // Move lift B to connection height
                    D2013 := 1000; // Set lift B speed
                    Y43 := TRUE; // Enable drive
                END_IF
            END_IF

            // Advance to next stage when either lift reaches target
            IF (D1008 = 950 AND D1012 = 400) OR (D1012 = 950 AND D1008 = 400) THEN
                currentStage := 2;
            END_IF

        2:
            // Cell 3 and Cell 4 processing
            Y70 := TRUE; // Start processing in Cell 3
            Y75 := TRUE; // Start processing in Cell 4
            currentStage := 3;

        3:
            // Wait for cell processes to complete
            IF X70 AND X75 THEN
                currentStage := 4; 
            END_IF

        4:
            // Return the jig to the original lift section
            IF currentRequestID = D100 THEN // Request 0 active
                IF D101 = 1 THEN // Lift A
                    D2008 := 4000; // Return lift A to initial height
                    D2009 := 1000; // Set lift A speed
                    Y42 := TRUE; // Enable drive
                ELSIF D101 = 2 THEN // Lift B
                    D2012 := 4000; // Return lift B to initial height
                    D2013 := 1000; // Set lift B speed
                    Y43 := TRUE; // Enable drive
                END_IF
            ELSIF currentRequestID = D120 THEN // Request 1 active
                IF D121 = 1 THEN // Lift A
                    D2008 := 4000; // Return lift A to initial height
                    D2009 := 1000; // Set lift A speed
                    Y42 := TRUE; // Enable drive
                ELSIF D121 = 2 THEN // Lift B
                    D2012 := 4000; // Return lift B to initial height
                    D2013 := 1000; // Set lift B speed
                    Y43 := TRUE; // Enable drive
                END_IF
            END_IF

            // Complete request processing when lift is at initial height
            IF (D1008 = 400 AND D1012 = 400) OR (D1012 = 400 AND D1008 = 400) THEN
                requestProcessed := TRUE;
                // Complete or cancel request
                IF currentRequestID = D100 THEN
                    D300 := D100;
                    IF X31 THEN
                        D301 := 2;
                    ELSE
                        D301 := 1;
                    END_IF
                    req0InProgress := FALSE;
                ELSIF currentRequestID = D120 THEN
                    D302 := D120;
                    IF X35 THEN
                        D303 := 2;
                    ELSE
                        D303 := 1;
                    END_IF
                    req1InProgress := FALSE;
                END_IF
            END_IF
    END_CASE
END_IF

// Set brakes when not processing requests
IF NOT req0InProgress AND NOT req1InProgress THEN
    Y30 := TRUE; // Engage the brake
ELSE
    Y30 := FALSE; // Disengage the brake
END_IF

// Completion observation logic
IF X51 THEN
    IF edge_all_done.Q THEN
        completeObservation := TRUE;
        completionTimer := T#0ms;
    END_IF
    IF completeObservation THEN
        completionTimer := completionTimer + T#20ms;
        IF completionTimer >= T#100ms THEN
            Y2 := TRUE;
            IF edge_completion.Q THEN
                completeObservation := FALSE; // Reset after observation
            END_IF
        ELSE
            Y2 := FALSE;
        END_IF
    END_IF
ELSE
    Y2 := FALSE;
END_IF

END_PROGRAM