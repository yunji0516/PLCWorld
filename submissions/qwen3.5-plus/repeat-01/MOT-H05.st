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

    ph : INT := 0;
    cur_req : INT := -1;
    req_id : DINT := 0;
    req_loc : DINT := 0;
    is_cancelled : BOOL := FALSE;
    ack0_done : BOOL := FALSE;
    ack1_done : BOOL := FALSE;
    seq_cnt : DINT := 1;
    arr_timer : TON;
    t100ms : TON;
    dock_pos : DINT;
    lift_cmd : DINT;
    phase_reached : BOOL;
END_VAR

// Default safe outputs
D2000 := D1000; D2001 := 0; D2002 := 0; Y40 := FALSE;
D2004 := D1004; D2005 := 0; D2006 := 0; Y41 := FALSE;
D2008 := D1008; D2009 := 0; D2010 := 0; Y42 := FALSE;
D2012 := D1012; D2013 := 0; D2014 := 0; Y43 := FALSE;
D2016 := D1016; D2017 := 0; D2018 := 0; Y44 := FALSE;
D2020 := D1020; D2021 := 0; D2022 := 0; Y45 := FALSE;
D2024 := D1024; D2025 := 0; D2026 := 0; Y46 := FALSE;
D2028 := D1028; D2029 := 0; D2030 := 0; Y47 := FALSE;
D2032 := D1032; D2033 := 0; D2034 := 0; Y48 := FALSE;
Y70 := FALSE; Y71 := FALSE; D700 := 0; D701 := 0; D702 := 0;
Y75 := FALSE; Y76 := FALSE; D710 := 0; D711 := 0; D712 := 0;
D80 := 0; D81 := 0; D82 := 0;
Y30 := FALSE;
D300 := 0; D301 := 0; D302 := 0; D303 := 0;
Y2 := FALSE;

// Request selection
IF cur_req = -1 THEN
    IF NOT ack0_done AND D100 > 0 THEN cur_req := 0;
    ELSIF NOT ack1_done AND D120 > 0 THEN cur_req := 1;
    END_IF;
END_IF;

IF cur_req >= 0 THEN
    IF cur_req = 0 THEN
        req_id := D100;
        req_loc := D101;
        is_cancelled := X31;
    ELSE
        req_id := D120;
        req_loc := D121;
        is_cancelled := X35;
    END_IF;

    // Force cancellation recovery
    IF is_cancelled AND ph < 15 AND ph > 0 THEN
        ph := 15;
    END_IF;
END_IF;

// State Machine
CASE ph OF
    0: // Idle / Wait for request
        IF cur_req >= 0 THEN
            dock_pos := IF req_loc = 1 THEN -360000 ELSE -230000;
            ph := 1;
        END_IF;

    1: // Move A to Lift Dock
        D2000 := dock_pos; D2001 := 800; D2002 := 0; Y40 := TRUE;
        phase_reached := (ABS(D1000 - dock_pos) < 20) AND (ABS(D1001) < 100);
        arr_timer(IN := phase_reached, PT := T#30ms);
        IF arr_timer.Q THEN ph := 2; END_IF;

    2: // Move B to Connect (180mm)
        D2004 := 18000; D2005 := 800; D2006 := 0; Y41 := TRUE;
        phase_reached := (ABS(D1004 - 18000) < 20) AND (ABS(D1005) < 100);
        arr_timer(IN := phase_reached, PT := T#30ms);
        IF arr_timer.Q THEN ph := 3; END_IF;

    3: // Move C/D to Dock Height
        lift_cmd := 73250;
        IF req_loc = 1 THEN
            D2008 := lift_cmd; D2009 := 800; D2010 := 0; Y42 := TRUE;
            phase_reached := (ABS(D1008 - lift_cmd) < 20) AND (ABS(D1009) < 100);
        ELSE
            D2012 := lift_cmd; D2013 := 800; D2014 := 0; Y43 := TRUE;
            phase_reached := (ABS(D1012 - lift_cmd) < 20) AND (ABS(D1013) < 100);
        END_IF;
        arr_timer(IN := phase_reached, PT := T#30ms);
        IF arr_timer.Q THEN ph := 4; END_IF;

    4: // Connection & Sequence
        D80 := 1;
        D81 := req_loc;
        D82 := seq_cnt;
        seq_cnt := seq_cnt + 1;
        // Wait for physical handshake
        IF (req_loc = 1 AND X61) OR (req_loc = 2 AND X62) THEN
            ph := 5;
        END_IF;

    5: // Move A to Cell 3
        D2000 := 230000; D2001 := 800; D2002 := 0; Y40 := TRUE;
        phase_reached := (ABS(D1000 - 230000) < 20) AND (ABS(D1001) < 100);
        arr_timer(IN := phase_reached, PT := T#30ms);
        IF arr_timer.Q THEN ph := 6; END_IF;

    6: // Configure Cell 3
        Y70 := TRUE;
        D700 := req_id;
        Y71 := TRUE;
        D702 := 6000;
        ph := 7;

    7: // Wait Cell 3 Served
        IF X70 OR X72 THEN ph := 8; END_IF;

    8: // Move A to Cell 4
        D2000 := 990000; D2001 := 800; D2002 := 0; Y40 := TRUE;
        phase_reached := (ABS(D1000 - 990000) < 20) AND (ABS(D1001) < 100);
        arr_timer(IN := phase_reached, PT := T#30ms);
        IF arr_timer.Q THEN ph := 9; END_IF;

    9: // Configure Cell 4
        Y75 := TRUE;
        D710 := req_id;
        Y76 := TRUE;
        D712 := 6000;
        ph := 10;

    10: // Wait Cell 4 Served
        IF X75 OR X77 THEN ph := 11; END_IF;

    11: // Return A to Lift Dock
        D2000 := dock_pos; D2001 := 800; D2002 := 0; Y40 := TRUE;
        phase_reached := (ABS(D1000 - dock_pos) < 20) AND (ABS(D1001) < 100);
        arr_timer(IN := phase_reached, PT := T#30ms);
        IF arr_timer.Q THEN ph := 12; END_IF;

    12: // Return C/D to Home
        lift_cmd := 15000;
        IF req_loc = 1 THEN
            D2008 := lift_cmd; D2009 := 800; D2010 := 0; Y42 := TRUE;
            phase_reached := (ABS(D1008 - lift_cmd) < 20) AND (ABS(D1009) < 100);
        ELSE
            D2012 := lift_cmd; D2013 := 800; D2014 := 0; Y43 := TRUE;
            phase_reached := (ABS(D1012 - lift_cmd) < 20) AND (ABS(D1013) < 100);
        END_IF;
        arr_timer(IN := phase_reached, PT := T#30ms);
        IF arr_timer.Q THEN ph := 13; END_IF;

    13: // Retract B
        D2004 := 0; D2005 := 800; D2006 := 0; Y41 := TRUE;
        phase_reached := (ABS(D1004) < 20) AND (ABS(D1005) < 100);
        arr_timer(IN := phase_reached, PT := T#30ms);
        IF arr_timer.Q THEN ph := 14; END_IF;

    14: // Final Stability Wait
        arr_timer(IN := TRUE, PT := T#30ms);
        IF arr_timer.Q THEN ph := 15; END_IF;

    15: // Acknowledge & Return
        D80 := 2;
        D81 := req_loc;
        D82 := seq_cnt;
        IF cur_req = 0 THEN
            D300 := req_id;
            D301 := IF is_cancelled THEN 2 ELSE 1; END_IF;
            ack0_done := TRUE;
        ELSE
            D302 := req_id;
            D303 := IF is_cancelled THEN 2 ELSE 1; END_IF;
            ack1_done := TRUE;
        END_IF;
        ph := 16;

    16: // Cleanup
        cur_req := -1;
        ph := 0;
END_CASE;

// Completion Observation
t100ms(IN := (ack0_done AND ack1_done) AND 
              (ABS(D1000) < 20) AND 
              (ABS(D1004) < 20) AND 
              (ABS(D1008 - 15000) < 20) AND 
              (ABS(D1012 - 15000) < 20) AND
              (ABS(D1016 - (-60000)) < 20) AND 
              (ABS(D1020 - (-60000)) < 20) AND
              (ABS(D1024) < 20) AND 
              (ABS(D1028) < 20) AND 
              (ABS(D1032) < 20),
       PT := T#100ms);
Y2 := t100ms.Q;

END_PROGRAM