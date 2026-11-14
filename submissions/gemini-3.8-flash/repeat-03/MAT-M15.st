PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;

    r_trig_start : R_TRIG;
    ton_inter : TON;
    ton_settle : TON;

    started : BOOL := FALSE;
    req_count : INT := 0;
    net_count : INT := 0;
    trk_state : INT := 0;
    main_state : INT := 0;
    feed_stage : INT := 0;
    b_seen : BOOL := FALSE;
    inter_in : BOOL := FALSE;
    settle_in : BOOL := FALSE;
END_VAR

// Edge detection for start command
r_trig_start(CLK := X10);
IF r_trig_start.Q AND NOT started THEN
    started := TRUE;
    req_count := D10;
    main_state := 10;
    feed_stage := 0;
    b_seen := FALSE;
END_IF;

// Passage tracking state machine
CASE trk_state OF
    0: // Clear transfer zone
        IF X20 AND NOT X21 THEN
            trk_state := 1;
        ELSIF X21 AND NOT X20 THEN
            trk_state := 11;
        END_IF;

    1: // Forward: A covered
        IF X20 AND X21 THEN
            trk_state := 2;
        ELSIF NOT X20 AND NOT X21 THEN
            trk_state := 0; // Partial entry retreat
        END_IF;

    2: // Forward: A and B covered
        IF NOT X20 AND X21 THEN
            trk_state := 3;
        ELSIF NOT X20 AND NOT X21 THEN
            trk_state := 0;
        END_IF;

    3: // Forward: B covered
        IF NOT X20 AND NOT X21 THEN
            net_count := net_count + 1;
            trk_state := 0;
        END_IF;

    11: // Reverse: B covered
        IF X20 AND X21 THEN
            trk_state := 12;
        ELSIF NOT X20 AND NOT X21 THEN
            trk_state := 0;
        END_IF;

    12: // Reverse: B and A covered
        IF X20 AND NOT X21 THEN
            trk_state := 13;
        ELSIF NOT X20 AND NOT X21 THEN
            trk_state := 0;
        END_IF;

    13: // Reverse: A covered
        IF NOT X20 AND NOT X21 THEN
            net_count := net_count - 1;
            trk_state := 0;
        END_IF;
END_CASE;

// Main process state machine
IF started THEN
    CASE main_state OF
        10: // Accumulating batch
            CASE feed_stage OF
                0: // Check if ready to feed next product
                    IF net_count >= req_count THEN
                        main_state := 20; // All requested products passed
                    ELSIF X23 AND NOT X20 AND NOT X21 AND (trk_state = 0) THEN
                        b_seen := FALSE;
                        feed_stage := 1;
                    END_IF;

                1: // Turn feed ON, wait for product to enter photoeye A
                    IF X20 THEN
                        b_seen := FALSE;
                        feed_stage := 2;
                    END_IF;

                2: // Product advancing through transfer module
                    IF X21 THEN
                        b_seen := TRUE;
                    END_IF;

                    IF (trk_state = 0) AND b_seen THEN
                        // Forward passage completed
                        IF X22 THEN
                            feed_stage := 3; // Keep feed ON until reverse starts
                        ELSE
                            feed_stage := 6; // Transfer complete, wait exit
                        END_IF;
                    ELSIF NOT X20 AND NOT X21 AND NOT b_seen THEN
                        // Partial entry retreated before B
                        feed_stage := 5;
                    END_IF;

                3: // Full-return disturbance pending: advance to x=360mm trigger
                    IF X21 THEN
                        // Reverse motion reached B
                        feed_stage := 4;
                    ELSIF NOT X22 THEN
                        feed_stage := 4;
                    END_IF;

                4: // Disturbance returning product upstream with feed OFF
                    IF NOT X22 AND X23 AND (trk_state = 0) THEN
                        b_seen := FALSE;
                        feed_stage := 0;
                    END_IF;

                5: // Partial retreat disturbance clearing upstream with feed OFF
                    IF NOT X22 AND X23 AND (trk_state = 0) THEN
                        b_seen := FALSE;
                        feed_stage := 0;
                    END_IF;

                6: // Inter-product spacing wait
                    IF ton_inter.Q THEN
                        b_seen := FALSE;
                        feed_stage := 0;
                    END_IF;
            END_CASE;

        20: // Settle batch on receiving tray
            IF ton_settle.Q THEN
                main_state := 30;
            END_IF;

        30: // Dispatch tray
            IF X25 THEN
                main_state := 40;
            END_IF;

        40: // Complete
            // Hold result
    END_CASE;
END_IF;

// Timers
inter_in := (main_state = 10) AND (feed_stage = 6) AND X23;
ton_inter(IN := inter_in, PT := T#500ms);

settle_in := (main_state = 20) AND X23 AND X24 AND NOT X22 AND (net_count = req_count);
ton_settle(IN := settle_in, PT := T#4000ms);

// Output assignments
IF started THEN
    CASE main_state OF
        10:
            IF (feed_stage = 1) OR (feed_stage = 2) OR (feed_stage = 3) THEN
                Y20 := TRUE;
            ELSE
                Y20 := FALSE;
            END_IF;
            Y21 := FALSE;
            Y2 := FALSE;

        20:
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := FALSE;

        30:
            Y20 := FALSE;
            Y21 := TRUE;
            Y2 := FALSE;

        40:
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := TRUE;

        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := FALSE;
    END_CASE;
ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
END_IF;

END_PROGRAM