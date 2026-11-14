```iec
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
    D100 : DINT;  // r0_id
    D101 : DINT;  // r0_location
    D102 : DINT;  // r0_progress
    D103 : DINT;  // r0_due
    D104 : DINT;  // r0_record
    X30 : BOOL;   // r0_returned
    X31 : BOOL;   // r0_cancelled
    D120 : DINT;  // r1_id
    D121 : DINT;  // r1_location
    D122 : DINT;  // r1_progress
    D123 : DINT;  // r1_due
    D124 : DINT;  // r1_record
    X34 : BOOL;   // r1_returned
    X35 : BOOL;   // r1_cancelled
    X51 : BOOL;   // all_done
    D90 : DINT;   // holding
    D91 : DINT;   // epoch
    D92 : DINT;   // source_dock
    X52 : BOOL;   // brake_closed
    X53 : BOOL;   // brake_open
    D403 : DINT;  // port1_x
    D404 : DINT;  // port1_id
    X61 : BOOL;   // port1_ready
    D406 : DINT;  // port2_x
    D407 : DINT;  // port2_id
    X62 : BOOL;   // port2_ready
    D409 : DINT;  // port3_x
    D410 : DINT;  // port3_id
    X63 : BOOL;   // port3_ready
    D412 : DINT;  // port4_x
    D413 : DINT;  // port4_id
    X64 : BOOL;   // port4_ready
    D500 : DINT;  // m3_goal0
    D501 : DINT;  // m3_goal1
    D520 : DINT;  // m3_lane
    D521 : DINT;  // m3_origin
    D522 : DINT;  // m3_capture_owner
    D523 : DINT;  // m3_capture
    D524 : DINT;  // m3_capture_epoch
    D525 : DINT;  // m3_span
    D526 : DINT;  // m3_route
    D527 : DINT;  // m3_angle
    X70 : BOOL;   // m3_served
    X71 : BOOL;   // m3_cancelled
    X72 : BOOL;   // m3_synced
    D600 : DINT;  // m4_goal0
    D601 : DINT;  // m4_goal1
    D602 : DINT;  // m4_goal2
    D620 : DINT;  // m4_lane
    D621 : DINT;  // m4_origin
    D622 : DINT;  // m4_capture_owner
    D623 : DINT;  // m4_capture
    D624 : DINT;  // m4_capture_epoch
    D625 : DINT;  // m4_span
    D626 : DINT;  // m4_route
    D627 : DINT;  // m4_angle
    X75 : BOOL;   // m4_served
    X76 : BOOL;   // m4_cancelled
    X77 : BOOL;   // m4_synced

    // Outputs
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
    D2032 : DINT; // s4_2_target
    D2033 : DINT; // s4_2_rate
    D2034 : DINT; // s4_2_ff
    Y48 : BOOL;   // s4_2_enable
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

    // Internal variables
    request_handling : BOOL := FALSE;
    request_id : DINT := 0;
    request_location : DINT := 0;
    request_due : DINT := 0;
    request_served : BOOL := FALSE;
    request_cancelled : BOOL := FALSE;
    timer : TON;
    completion_timer : TON;
END_VAR

(* Implement the control logic here. *)

(* Check for new requests *)
IF NOT request_handling THEN
    IF D100 <> 0 THEN
        request_handling := TRUE;
        request_id := D100;
        request_location := D101;
        request_due := D103;
        request_served := FALSE;
        request_cancelled := X31;
    ELSIF D120 <> 0 THEN
        request_handling := TRUE;
        request_id := D120;
        request_location := D121;
        request_due := D123;
        request_served := FALSE;
        request_cancelled := X35;
    END_IF
END_IF

(* Handle request if processing *)
IF request_handling THEN
    IF request_cancelled THEN
        D302 := request_id;
        D303 := 2; // Status: cancellation
        request_handling := FALSE;
    ELSE
        // Connect to the shared shuttle based on the location
        CASE request_location OF
            1: 
                // Logic for location 1
            2: 
                // Logic for location 2
            3:
                // Logic for Cell 3
            4:
                // Logic for Cell 4
        END_CASE

        // Check completion
        IF X51 THEN
            request_served := TRUE;
        END_IF

        // Handle completion
        IF request_served THEN
            D302 := request_id;
            D303 := 1; // Status: completion
            request_handling := FALSE;
        END_IF
    END_IF
END_IF

(* Brake management *)
Y30 := request_handling; // Engage brake while handling a request

(* Completion signal management *)
timer(IN := all_done, PT := T#100ms);
Y2 := timer.Q; // Maintain Y2 at completion for 100 ms

END_PROGRAM
```