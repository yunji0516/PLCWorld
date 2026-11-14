PROGRAM Main
VAR
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D20 : DINT;
    D21 : DINT;
    D100 : DINT;
    X30 : BOOL;
    X32 : BOOL;
    D104 : DINT;
    D103 : DINT;
    D110 : DINT;
    X31 : BOOL;
    X33 : BOOL;
    D114 : DINT;
    D113 : DINT;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    D93 : DINT;
    D94 : DINT;
    D95 : DINT;
    D96 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    X54 : BOOL;
    X55 : BOOL;
    X56 : BOOL;
    X57 : BOOL;
    D150 : DINT;
    D151 : DINT;
    D200 : DINT;
    D201 : DINT;
    Y20 : BOOL;
    D204 : DINT;
    D205 : DINT;
    Y21 : BOOL;
    D208 : DINT;
    D209 : DINT;
    Y22 : BOOL;
    D212 : DINT;
    D213 : DINT;
    Y23 : BOOL;
    D216 : DINT;
    D217 : DINT;
    Y24 : BOOL;
    D220 : DINT;
    D221 : DINT;
    Y25 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y2 : BOOL;

    step : INT;
    cur_req : INT;
    active_id : DINT;
    active_lane : DINT;
    next_seq : DINT;
    settle_timer : TON;
    final_timer : TON;
    approach_timer : TON;
END_VAR

// Enable all drives by default with standard rate
Y20 := TRUE;
D201 := 1000;
Y21 := TRUE;
D205 := 1000;
Y22 := TRUE;
D209 := 1000;
Y23 := TRUE;
D213 := 1000;
Y24 := TRUE;
D217 := 1000;
Y25 := TRUE;
D221 := 1000;

IF next_seq = 0 THEN
    next_seq := 1;
END_IF;

CASE step OF
    0: // Idle / Arbitrate request
        D204 := 0; // Fork retracted
        D216 := 0; // Table at 0 deg
        D220 := 5000; // Slide retracted to 50 mm
        D208 := D150; // Lift A at home
        D212 := D151; // Lift B at home

        IF (D301 = 0) AND (D100 > 0) THEN
            cur_req := 0;
            active_id := D100;
            active_lane := 1;
            step := 10;
        ELSIF (D303 = 0) AND (D110 > 0) THEN
            cur_req := 1;
            active_id := D110;
            active_lane := 2;
            step := 10;
        ELSIF (D301 = 1) AND (D303 = 1) AND X51 THEN
            step := 900;
        END_IF;

    10: // Move Lift and Shuttle to source station
        D204 := 0;
        D216 := 0;
        D220 := 5000;
        IF active_lane = 1 THEN
            D200 := -90000;
            D208 := 73250;
            D212 := D151;
            IF X54 AND (ABS(D10 - (-90000)) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12) <= 20) THEN
                step := 20;
            END_IF;
        ELSE
            D200 := -35000;
            D212 := 73250;
            D208 := D150;
            IF X55 AND (ABS(D10 - (-35000)) <= 20) AND (ABS(D11) <= 100) AND (ABS(D12) <= 20) THEN
                step := 20;
            END_IF;
        END_IF;

    20: // Extend fork to source lift
        D204 := 18000;
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 1; // extraction
            D81 := active_lane;
            D82 := next_seq;
            step := 30;
        END_IF;

    30: // Wait for extraction confirmation
        IF (D96 = D82) AND (D90 = active_id) THEN
            next_seq := next_seq + 1;
            step := 40;
        END_IF;

    40: // Retract fork
        D204 := 0;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            step := 50;
        END_IF;

    50: // Shuttle to Table station (850 mm)
        D200 := 85000;
        IF active_lane = 1 THEN
            D208 := 73250;
        ELSE
            D212 := 73250;
        END_IF;
        IF (ABS(D10 - 85000) <= 20) AND (ABS(D11) <= 100) AND X56 THEN
            step := 60;
        END_IF;

    60: // Extend fork to table
        D204 := 18000;
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 2; // placement
            D81 := 4; // table
            D82 := next_seq;
            step := 70;
        END_IF;

    70: // Wait for table placement confirmation
        IF (D96 = D82) AND (D91 = active_id) THEN
            next_seq := next_seq + 1;
            step := 80;
        END_IF;

    80: // Retract fork from table
        D204 := 0;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            step := 90;
        END_IF;

    90: // Move shuttle to buffer/safe section (150 mm) to allow rotation
        D200 := 15000;
        IF (ABS(D10 - 15000) <= 20) AND (ABS(D11) <= 100) THEN
            step := 100;
        END_IF;

    100: // Rotate table to target posture
        IF D94 <> 0 THEN
            D216 := D94;
        ELSE
            D216 := 9000;
        END_IF;
        IF X53 THEN
            step := 110;
        END_IF;

    110: // Precision approach slide
        IF D95 <> 0 THEN
            D220 := D95;
        ELSE
            D220 := 70000;
        END_IF;
        IF X52 OR ((cur_req = 0) AND X30) OR ((cur_req = 1) AND X31) THEN
            step := 120;
        END_IF;

    120: // Retract slide to 50 mm
        D220 := 5000;
        IF (ABS(D20 - 5000) <= 20) AND (ABS(D21) <= 100) THEN
            step := 130;
        END_IF;

    130: // Rotate table back to 0 deg
        D216 := 0;
        IF X56 AND (ABS(D18) <= 20) AND (ABS(D19) <= 100) THEN
            step := 140;
        END_IF;

    140: // Shuttle moves to table station (850 mm)
        D200 := 85000;
        IF (ABS(D10 - 85000) <= 20) AND (ABS(D11) <= 100) AND X56 THEN
            step := 150;
        END_IF;

    150: // Extend fork to table
        D204 := 18000;
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 1; // extraction
            D81 := 4; // table
            D82 := next_seq;
            step := 160;
        END_IF;

    160: // Wait for table extraction confirmation
        IF (D96 = D82) AND (D90 = active_id) THEN
            next_seq := next_seq + 1;
            step := 170;
        END_IF;

    170: // Retract fork
        D204 := 0;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            step := 180;
        END_IF;

    180: // Move shuttle to original lift
        IF active_lane = 1 THEN
            D200 := -90000;
            D208 := 73250;
            IF X54 AND (ABS(D10 - (-90000)) <= 20) AND (ABS(D11) <= 100) THEN
                step := 190;
            END_IF;
        ELSE
            D200 := -35000;
            D212 := 73250;
            IF X55 AND (ABS(D10 - (-35000)) <= 20) AND (ABS(D11) <= 100) THEN
                step := 190;
            END_IF;
        END_IF;

    190: // Extend fork to lift
        D204 := 18000;
        IF (ABS(D12 - 18000) <= 20) AND (ABS(D13) <= 100) THEN
            D80 := 2; // placement
            D81 := active_lane;
            D82 := next_seq;
            step := 200;
        END_IF;

    200: // Wait for placement confirmation
        IF (D96 = D82) AND (D90 = 0) THEN
            next_seq := next_seq + 1;
            step := 210;
        END_IF;

    210: // Retract fork
        D204 := 0;
        IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
            step := 220;
        END_IF;

    220: // Lower lift to home height
        IF active_lane = 1 THEN
            D208 := D150;
            IF X32 AND (ABS(D14 - D150) <= 20) AND (ABS(D15) <= 100) THEN
                D300 := active_id;
                D301 := 1;
                step := 0;
            END_IF;
        ELSE
            D212 := D151;
            IF X33 AND (ABS(D16 - D151) <= 20) AND (ABS(D17) <= 100) THEN
                D302 := active_id;
                D303 := 1;
                step := 0;
            END_IF;
        END_IF;

    900: // Return all to home positions and confirm empty
        D200 := 0;
        D204 := 0;
        D208 := D150;
        D212 := D151;
        D216 := 0;
        D220 := 5000;

        IF (ABS(D10) <= 20) AND (ABS(D11) <= 100)
           AND (ABS(D12) <= 20) AND (ABS(D13) <= 100)
           AND (ABS(D14 - D150) <= 20) AND (ABS(D15) <= 100)
           AND (ABS(D16 - D151) <= 20) AND (ABS(D17) <= 100)
           AND (ABS(D18) <= 20) AND (ABS(D19) <= 100)
           AND (ABS(D20 - 5000) <= 20) AND (ABS(D21) <= 100)
           AND (D90 = 0) AND (D91 = 0) AND (D92 = 0) THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM