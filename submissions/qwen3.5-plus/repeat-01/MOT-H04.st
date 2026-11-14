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
    
    // Internal state variables
    main_state : INT := 0;
    
    // Request tracking
    req0_id : DINT := 0;
    req0_state : INT := 0;
    req0_location : DINT := 0;
    req1_id : DINT := 0;
    req1_state : INT := 0;
    req1_location : DINT := 0;
    active_req : INT := -1;
    prev_r0_id : DINT := -1;
    prev_r1_id : DINT := -1;
    
    // Cell operation states
    cell3_state : INT := 0;
    cell4_state : INT := 0;
    configure_pulsing : BOOL := FALSE;
    cfg_timer_elapsed : BOOL := FALSE;
    
    // Connection sequence
    seq_counter : DINT := 0;
    
    // Completion tracking
    completion_timer : TON;
    completion_active : BOOL := FALSE;
    completion_start_scan : DINT := 0;
    
    // Position targets (x0.01 mm)
    STN1_POS : DINT := -405000;
    STN2_POS : DINT := -185000;
    STN3_POS : DINT := 90000;
    STN4_POS : DINT := 470000;
    
    // Constants
    LIFT_HOME : DINT := 40000;
    LIFT_DOCK : DINT := 95000;
    FORK_HOME : DINT := 0;
    FORK_CONNECT : DINT := 18000;
    DRIVE_RATE : DINT := 500;
    ZERO_TARGET : DINT := 0;
    
    // Balance calc temp
    balance_angle_deg : REAL;
    balance_sin_val : REAL;
    balance_counter_x : REAL;
    balance_pos_raw : DINT;
    
    // Handshake helpers
    station_pending : DINT := 0;
    action_pending : DINT := 0;
    handshake_done : BOOL := FALSE;
    
    // Arrival check helpers
    shuttle_pos : REAL;
    shuttle_vel : REAL;
    fork_pos : REAL;
    fork_vel : REAL;
    liftA_pos : REAL;
    liftA_vel : REAL;
    liftB_pos : REAL;
    liftB_vel : REAL;
    s3_0_pos : REAL;
    s3_0_vel : REAL;
    s3_1_pos : REAL;
    s3_1_vel : REAL;
    s4_0_pos : REAL;
    s4_0_vel : REAL;
    s4_1_pos : REAL;
    s4_1_vel : REAL;
    
    // Edge triggers
    req0_trig : R_TRIG;
    req1_trig : R_TRIG;
    
END_VAR

// Convert raw inputs to physical units (x0.01 -> actual)
shuttle_pos := DINT_TO_REAL(D1000) / 100.0;
shuttle_vel := DINT_TO_REAL(D1001) / 100.0;
fork_pos := DINT_TO_REAL(D1004) / 100.0;
fork_vel := DINT_TO_REAL(D1005) / 100.0;
liftA_pos := DINT_TO_REAL(D1008) / 100.0;
liftA_vel := DINT_TO_REAL(D1009) / 100.0;
liftB_pos := DINT_TO_REAL(D1012) / 100.0;
liftB_vel := DINT_TO_REAL(D1013) / 100.0;
s3_0_pos := DINT_TO_REAL(D1016) / 100.0;
s3_0_vel := DINT_TO_REAL(D1017) / 100.0;
s3_1_pos := DINT_TO_REAL(D1020) / 100.0;
s3_1_vel := DINT_TO_REAL(D1021) / 100.0;
s4_0_pos := DINT_TO_REAL(D1028) / 100.0;
s4_0_vel := DINT_TO_REAL(D1029) / 100.0;
s4_1_pos := DINT_TO_REAL(D1032) / 100.0;
s4_1_vel := DINT_TO_REAL(D1033) / 100.0;

// Default all outputs to safe/disabled
Y40 := FALSE;
Y41 := FALSE;
Y42 := FALSE;
Y43 := FALSE;
Y44 := FALSE;
Y45 := FALSE;
Y46 := FALSE;
Y47 := FALSE;
Y48 := FALSE;
Y70 := FALSE;
Y71 := FALSE;
Y75 := FALSE;
Y76 := FALSE;
Y30 := TRUE;
Y2 := FALSE;
D2000 := 0;
D2001 := DRIVE_RATE;
D2002 := 0;
D2004 := 0;
D2005 := DRIVE_RATE;
D2006 := 0;
D2008 := 0;
D2009 := DRIVE_RATE;
D2010 := 0;
D2012 := 0;
D2013 := DRIVE_RATE;
D2014 := 0;
D2016 := 0;
D2017 := DRIVE_RATE;
D2018 := 0;
D2020 := 0;
D2021 := DRIVE_RATE;
D2022 := 0;
D2024 := 0;
D2025 := DRIVE_RATE;
D2026 := 0;
D2028 := 0;
D2029 := DRIVE_RATE;
D2030 := 0;
D2032 := 0;
D2033 := DRIVE_RATE;
D2034 := 0;
D300 := 0;
D301 := 0;
D302 := 0;
D303 := 0;
D700 := 0;
D701 := 0;
D702 := 0;
D710 := 0;
D711 := 0;
D712 := 0;
D80 := 0;
D81 := 0;
D82 := 0;

// Detect new requests
req0_trig(CLK := (D100 <> prev_r0_id) AND (D100 <> 0));
req1_trig(CLK := (D120 <> prev_r1_id) AND (D120 <> 0));
prev_r0_id := D100;
prev_r1_id := D120;

// Record request info when first seen
IF req0_trig.Q AND (req0_state = 0) AND (D100 <> 0) THEN
    req0_id := D100;
    req0_location := D101;
    req0_state := 1; (* waiting for pickup *)
END_IF;

IF req1_trig.Q AND (req1_state = 0) AND (D120 <> 0) THEN
    req1_id := D120;
    req1_location := D121;
    req1_state := 1;
END_IF;

// Cancel handling
IF X31 AND (req0_state >= 1) AND (req0_state <= 5) THEN
    req0_state := 10;
END_IF;
IF X35 AND (req1_state >= 1) AND (req1_state <= 5) THEN
    req1_state := 10;
END_IF;

// Select active request
IF active_req = -1 THEN
    IF req0_state = 1 THEN
        active_req := 0;
    ELSIF req1_state = 1 THEN
        active_req := 1;
    END_IF;
END_IF;

// Helper: get active request location
IF active_req = 0 THEN
    station_pending := 1;
ELSIF active_req = 1 THEN
    station_pending := 2;
END_IF;

// Main state machine
CASE main_state OF
0: (* IDLE - wait for request *)
    IF active_req >= 0 THEN
        main_state := 1;
    END_IF;
    
1: (* MOVE TO LIFT STATION *)
    Y40 := TRUE;
    D2000 := STN1_POS;
    D2001 := DRIVE_RATE;
    D81 := station_pending;
    D700 := 0;
    D710 := 0;
    
    // Check shuttle arrived at station position
    IF ABS(shuttle_pos - DINT_TO_REAL(D2000) / 100.0) < 0.5 THEN
        IF ABS(shuttle_vel) < 5.0 THEN
            main_state := 2;
        END_IF;
    END_IF;
    
2: (* LIFT UP - raise lift to docking height *)
    Y40 := TRUE;
    Y42 := TRUE;
    Y43 := TRUE;
    
    IF station_pending = 1 THEN
        D2008 := LIFT_DOCK;
        D2012 := LIFT_HOME;
        D2009 := DRIVE_RATE;
        D2013 := DRIVE_RATE;
    ELSE
        D2012 := LIFT_DOCK;
        D2008 := LIFT_HOME;
        D2009 := DRIVE_RATE;
        D2013 := DRIVE_RATE;
    END_IF;
    
    // Both lifts within tolerance of target
    IF (ABS(liftA_pos - DINT_TO_REAL(D2008) / 100.0) < 1.0) AND 
       (ABS(liftB_pos - DINT_TO_REAL(D2012) / 100.0) < 1.0) AND
       (ABS(liftA_vel) < 10.0) AND
       (ABS(liftB_vel) < 10.0) THEN
        main_state := 3;
    END_IF;
    
3: (* EXTEND FORK - connect to workpiece *)
    Y40 := TRUE;
    Y41 := TRUE;
    IF station_pending = 1 THEN
        Y42 := TRUE;
    ELSE
        Y43 := TRUE;
    END_IF;
    
    D2004 := FORK_CONNECT;
    D2005 := DRIVE_RATE;
    
    // Fork at position and stopped
    IF (ABS(fork_pos - 180.0) < 0.5) AND (ABS(fork_vel) < 5.0) THEN
        // Increment sequence and signal connection
        seq_counter := seq_counter + 1;
        D82 := seq_counter;
        D81 := station_pending;
        D80 := 2; (* placement action *)
        
        IF station_pending = 1 THEN
            D700 := req0_id;
        ELSE
            D710 := req0_id;
        END_IF;
        
        handshake_done := FALSE;
        configure_pulsing := TRUE;
        cfg_timer(IN := TRUE, PT := T#100ms);
        main_state := 4;
    END_IF;
    
4: (* WAIT FOR CONNECTION CONFIRM *)
    Y40 := TRUE;
    Y41 := TRUE;
    IF station_pending = 1 THEN
        Y42 := TRUE;
    ELSE
        Y43 := TRUE;
    END_IF;
    
    // Keep configure pulsing
    cfg_timer(IN := configure_pulsing, PT := T#100ms);
    IF configure_pulsing AND cfg_timer.Q THEN
        configure_pulsing := FALSE;
    END_IF;
    
    // Check if port is ready (connection established)
    IF station_pending = 1 THEN
        IF X61 THEN
            main_state := 5;
        END_IF;
    ELSE
        IF X62 THEN
            main_state := 5;
        END_IF;
    END_IF;
    
5: (* TRANSIT TO CELL 3 (hoist) *)
    Y40 := TRUE;
    D2000 := STN3_POS;
    D2001 := DRIVE_RATE;
    D81 := 3;
    
    IF station_pending = 1 THEN
        D700 := req0_id;
    ELSE
        D700 := req1_id;
    END_IF;
    
    // Shuttle arrived at Cell 3
    IF ABS(shuttle_pos - 900.0) < 1.0 THEN
        IF ABS(shuttle_vel) < 5.0 THEN
            main_state := 6;
        END_IF;
    END_IF;
    
6: (* CELL 3 OPERATION - hoist *)
    Y40 := TRUE;
    
    // Configure Cell 3
    D700 := 0;
    IF station_pending = 1 THEN
        D700 := req0_id;
    ELSE
        D700 := req1_id;
    END_IF;
    D701 := D526; (* route from request *)
    D702 := 100; (* accel *)
    Y70 := TRUE;
    Y71 := TRUE;
    
    // Move hoist axes to targets
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    
    IF D500 <> 0 THEN
        D2016 := D500;
    ELSE
        D2016 := 100000; (* home s3_0 *)
    END_IF;
    
    IF D501 <> 0 THEN
        D2020 := D501;
    ELSE
        D2020 := 0; (* home s3_1 *)
    END_IF;
    
    IF D502 <> 0 THEN
        D2024 := D502;
    ELSE
        D2024 := 0; (* home s3_2 *)
    END_IF;
    
    D2017 := DRIVE_RATE;
    D2021 := DRIVE_RATE;
    D2025 := DRIVE_RATE;
    
    // Check Cell 3 axes settled
    cell3_state := 1;
    IF (ABS(s3_0_pos - DINT_TO_REAL(D2016) / 100.0) < 0.5) AND
       (ABS(s3_1_pos - DINT_TO_REAL(D2020) / 100.0) < 0.5) AND
       (ABS(s3_2_pos - DINT_TO_REAL(D2024) / 100.0) < 0.5) AND
       (ABS(s3_0_vel) < 5.0) AND
       (ABS(s3_1_vel) < 5.0) AND
       (ABS(s3_2_vel) < 5.0) AND
       X72 THEN (* synced *)
        cell3_state := 2;
        main_state := 7;
    END_IF;
    
7: (* TRANSIT TO CELL 4 (counterbalance) *)
    Y40 := TRUE;
    Y44 := FALSE;
    Y45 := FALSE;
    Y46 := FALSE;
    
    D2000 := STN4_POS;
    D2001 := DRIVE_RATE;
    D81 := 4;
    
    IF station_pending = 1 THEN
        D710 := req0_id;
    ELSE
        D710 := req1_id;
    END_IF;
    
    // Shuttle arrived at Cell 4
    IF ABS(shuttle_pos - 4700.0) < 1.0 THEN
        IF ABS(shuttle_vel) < 5.0 THEN
            main_state := 8;
        END_IF;
    END_IF;
    
8: (* CELL 4 OPERATION - balanced inclined head *)
    Y40 := TRUE;
    
    // Configure Cell 4
    D710 := 0;
    IF station_pending = 1 THEN
        D710 := req0_id;
    ELSE
        D710 := req1_id;
    END_IF;
    D711 := D626;
    D712 := 100;
    Y75 := TRUE;
    Y76 := TRUE;
    
    // Move counterbalance axes
    Y47 := TRUE;
    Y48 := TRUE;
    
    // Target angle and position
    IF D600 <> 0 THEN
        D2028 := D600;
    ELSE
        D2028 := 0;
    END_IF;
    
    // Calculate counterweight for balance moment ~1 Nm
    // M = (20*9.81/1000) * (450*sin(theta) + x)
    // x = M*1000/(20*9.81) - 450*sin(theta)
    // M = 1 Nm target
    balance_angle_deg := DINT_TO_REAL(D627) / 100.0;
    balance_sin_val := SIN(balance_angle_deg);
    balance_counter_x := (1.0 * 1000.0 / (20.0 * 9.81)) - (450.0 * balance_sin_val);
    
    // Clamp to permitted range [-450, 450] mm -> x0.01
    IF balance_counter_x > 450.0 THEN
        balance_counter_x := 450.0;
    ELSIF balance_counter_x < -450.0 THEN
        balance_counter_x := -450.0;
    END_IF;
    
    balance_pos_raw := DINT(balance_counter_x * 100.0);
    
    IF D601 <> 0 THEN
        D2032 := D601;
    ELSE
        D2032 := balance_pos_raw;
    END_IF;
    
    D2029 := DRIVE_RATE;
    D2033 := DRIVE_RATE;
    
    // Check Cell 4 settled
    cell4_state := 1;
    IF (ABS(s4_0_pos - DINT_TO_REAL(D2028) / 100.0) < 0.5) AND
       (ABS(s4_1_pos - DINT_TO_REAL(D2032) / 100.0) < 0.5) AND
       (ABS(s4_0_vel) < 5.0) AND
       (ABS(s4_1_vel) < 5.0) AND
       X77 THEN (* synced *)
        cell4_state := 2;
        main_state := 9;
    END_IF;
    
9: (* RETURN TO LIFT STATION *)
    Y40 := TRUE;
    Y47 := FALSE;
    Y48 := FALSE;
    
    D2000 := STN1_POS;
    D2001 := DRIVE_RATE;
    D81 := station_pending;
    
    // Shuttle arrived back at lift station
    IF ABS(shuttle_pos - DINT_TO_REAL(STN1_POS) / 100.0) < 1.0 THEN
        IF ABS(shuttle_vel) < 5.0 THEN
            main_state := 10;
        END_IF;
    END_IF;
    
10: (* RETRACT FORK - release workpiece *)
    Y40 := TRUE;
    Y41 := TRUE;
    IF station_pending = 1 THEN
        Y42 := TRUE;
    ELSE
        Y43 := TRUE;
    END_IF;
    
    D2004 := FORK_HOME;
    D2005 := DRIVE_RATE;
    D80 := 1; (* extraction action *)
    
    // Fork retracted
    IF (ABS(fork_pos - 0.0) < 0.5) AND (ABS(fork_vel) < 5.0) THEN
        main_state := 11;
    END_IF;
    
11: (* LOWER LIFT *)
    Y40 := TRUE;
    IF station_pending = 1 THEN
        Y42 := TRUE;
        D2008 := LIFT_HOME;
        D2009 := DRIVE_RATE;
    ELSE
        Y43 := TRUE;
        D2012 := LIFT_HOME;
        D2013 := DRIVE_RATE;
    END_IF;
    D2012 := LIFT_HOME;
    D2013 := DRIVE_RATE;
    D2008 := LIFT_HOME;
    D2009 := DRIVE_RATE;
    
    // Lift lowered to home
    IF (ABS(liftA_pos - 400.0) < 1.0) AND
       (ABS(liftB_pos - 400.0) < 1.0) AND
       (ABS(liftA_vel) < 5.0) AND
       (ABS(liftB_vel) < 5.0) THEN
        // Acknowledge completion
        IF station_pending = 1 THEN
            D300 := req0_id;
            D301 := 1; (* completion *)
            req0_state := 5; (* completed *)
        ELSE
            D302 := req0_id;
            D303 := 1;
            req1_state := 5;
        END_IF;
        main_state := 12;
    END_IF;
    
12: (* CHECK FOR MORE REQUESTS OR COMPLETION *)
    // Clear active request
    active_req := -1;
    
    // Check if there's another request
    IF (req0_state = 1) OR (req1_state = 1) THEN
        IF req0_state = 1 THEN
            active_req := 0;
        ELSE
            active_req := 1;
        END_IF;
        main_state := 1;
    ELSE
        // All done - go to completion state
        main_state := 20;
    END_IF;
    
100: (* CANCELLED - RETRIEVE *)
    Y40 := TRUE;
    
    // Move shuttle to the station of cancelled request
    IF active_req = 0 THEN
        IF req0_location = 1 THEN
            D2000 := STN1_POS;
        ELSE
            D2000 := STN2_POS;
        END_IF;
    ELSE
        IF req1_location = 1 THEN
            D2000 := STN1_POS;
        ELSE
            D2000 := STN2_POS;
        END_IF;
    END_IF;
    
    D2001 := DRIVE_RATE;
    
    // Shuttle at station
    IF ABS(shuttle_pos - DINT_TO_REAL(D2000) / 100.0) < 1.0 THEN
        IF ABS(shuttle_vel) < 5.0 THEN
            main_state := 101;
        END_IF;
    END_IF;
    
101: (* LOWER LIFT FOR CANCELLED *)
    Y40 := TRUE;
    Y42 := TRUE;
    Y43 := TRUE;
    D2008 := LIFT_HOME;
    D2012 := LIFT_HOME;
    D2009 := DRIVE_RATE;
    D2013 := DRIVE_RATE;
    
    IF (ABS(liftA_pos - 400.0) < 1.0) AND (ABS(liftB_pos - 400.0) < 1.0) THEN
        // Acknowledge cancellation
        IF active_req = 0 THEN
            D300 := req0_id;
            D301 := 2; (* cancellation retrieval *)
            req0_state := 5;
        ELSE
            D302 := req0_id;
            D303 := 2;
            req1_state := 5;
        END_IF;
        main_state := 102;
    END_IF;
    
102: (* CHECK FOR MORE AFTER CANCEL *)
    active_req := -1;
    IF (req0_state = 1) OR (req1_state = 1) THEN
        IF req0_state = 1 THEN
            active_req := 0;
        ELSE
            active_req := 1;
        END_IF;
        main_state := 1;
    ELSE
        main_state := 20;
    END_IF;
    
20: (* COMPLETION - return to home and wait *)
    Y2 := FALSE;
    
    // Move shuttle to 0
    D2000 := 0;
    D2001 := DRIVE_RATE;
    
    // Retract fork
    D2004 := FORK_HOME;
    D2005 := DRIVE_RATE;
    
    // Lower lifts
    D2008 := LIFT_HOME;
    D2012 := LIFT_HOME;
    
    // Return cell axes to home
    D2016 := 100000;
    D2020 := 0;
    D2024 := 0;
    D2028 := 0;
    D2032 := 0;
    
    // Enable all for return
    Y40 := TRUE;
    Y41 := TRUE;
    Y42 := TRUE;
    Y43 := TRUE;
    Y44 := TRUE;
    Y45 := TRUE;
    Y46 := TRUE;
    Y47 := TRUE;
    Y48 := TRUE;
    
    // Check all at home positions
    IF (ABS(shuttle_pos) < 1.0) AND
       (ABS(shuttle_vel) < 2.0) AND
       (ABS(fork_pos) < 0.5) AND
       (ABS(liftA_pos - 400.0) < 1.0) AND
       (ABS(liftB_pos - 400.0) < 1.0) AND
       (ABS(s3_0_pos - 1000.0) < 0.5) AND
       (ABS(s3_1_pos) < 0.5) AND
       (ABS(s3_2_pos) < 0.5) AND
       (ABS(s4_0_pos) < 0.5) AND
       (ABS(s4_1_pos) < 0.5) AND
       (ABS(s3_0_vel) < 2.0) AND
       (ABS(s3_1_vel) < 2.0) AND
       (ABS(s3_2_vel) < 2.0) AND
       (ABS(s4_0_vel) < 2.0) AND
       (ABS(s4_1_vel) < 2.0) THEN
        completion_active := TRUE;
    END_IF;
    
    // Start completion timer when stable
    IF completion_active THEN
        completion_timer(IN := TRUE, PT := T#100ms);
        IF completion_timer.Q THEN
            Y2 := TRUE;
        END_IF;
    END_IF;
    
END_CASE;

// Disable brake when axes are enabled and moving
IF Y40 OR Y41 OR Y42 OR Y43 OR Y44 OR Y45 OR Y46 OR Y47 OR Y48 THEN
    Y30 := FALSE;
ELSE
    Y30 := TRUE;
END_IF;

END_PROGRAM
```