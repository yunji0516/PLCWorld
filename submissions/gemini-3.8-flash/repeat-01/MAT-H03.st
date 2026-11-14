PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    step : INT := 0;
    prev_x11 : BOOL := FALSE;
    prev_x12 : BOOL := FALSE;
    prev_x13 : BOOL := FALSE;
    prev_x14 : BOOL := FALSE;
    prev_x16 : BOOL := FALSE;
    prev_x17 : BOOL := FALSE;
    prev_x18 : BOOL := FALSE;
    prev_x19 : BOOL := FALSE;
    prev_x1a : BOOL := FALSE;

    cur_gen : INT := 0;
    prod_count : INT := 0;
    hold_count : INT := 0;

    wait_flag : BOOL := FALSE;
    timer_cnt : INT := 0;
END_VAR

// One-scan pulses are cleared each cycle by default
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;

// Handle exit ack independently whenever exit_received occurs
IF X16 AND NOT prev_x16 THEN
    Y18 := TRUE;
    prod_count := prod_count + 1;
END_IF;

CASE step OF
    0: // Idle / Wait for start
        IF X0 THEN
            step := 10;
        END_IF;

    // --- PRODUCT LOADING AT POS 0 (LEFT LIFT UPPER) ---
    10: // Wait for source product and jig at left lift upper (D0 > 0, D5 = 0)
        IF X10 AND (D0 > 0) AND (D5 = 0) AND NOT X12 THEN
            Y10 := TRUE; // admit rising edge
            step := 11;
        END_IF;

    11: // Wait for load_busy to finish and product present
        IF NOT X12 AND (D5 > 0) THEN
            step := 20;
        END_IF;

    // --- MOVE FROM POS 0 TO POS 1 (INSPECTION) ---
    20: // Wait for move channel clear, inspection station empty
        IF NOT X11 AND (D1 = 0) THEN
            D200 := D0;
            D201 := 1;
            Y13 := TRUE; // move edge
            step := 21;
        END_IF;

    21: // Wait for move_busy to finish and jig in pos 1
        IF NOT X11 AND (D1 > 0) THEN
            step := 30;
        END_IF;

    // --- INSPECTION AT POS 1 ---
    30: // Trigger inspection
        IF NOT X14 AND (D6 > 0) THEN
            cur_gen := D8;
            D202 := cur_gen;
            Y11 := TRUE; // inspect edge
            step := 31;
        END_IF;

    31: // Wait for inspect completion (D10 matches generation, D9 > 0)
        IF NOT X14 AND (D10 = cur_gen) AND (D9 > 0) THEN
            step := 40;
        END_IF;

    // --- MOVE FROM POS 1 TO POS 2 (OUTPUT EXTRACTION) ---
    40: // Wait for move clear and pos 2 empty
        IF NOT X11 AND (D2 = 0) THEN
            D200 := D1;
            D201 := 2;
            Y13 := TRUE; // move edge
            step := 41;
        END_IF;

    41: // Wait for move completion to pos 2
        IF NOT X11 AND (D2 > 0) THEN
            step := 50;
        END_IF;

    // --- EXTRACT PRODUCT AT POS 2 ---
    50: // Check exit_clear and unload not busy
        IF X15 AND NOT X13 AND (D7 > 0) THEN
            Y12 := TRUE; // detach edge
            step := 51;
        END_IF;

    51: // Wait until unload_busy finishes and product is detached (D7 = 0)
        IF NOT X13 AND (D7 = 0) THEN
            step := 60;
        END_IF;

    // --- MOVE EMPTY JIG FROM POS 2 TO POS 3 (RIGHT LIFT) ---
    60: // Lift deck must be upper and empty
        IF NOT X1C THEN
            IF NOT X19 THEN
                Y16 := TRUE; // right_up
                step := 61;
            ELSE
                step := 62;
            END_IF;
        END_IF;

    61: // Wait for right lift to reach upper
        IF X19 AND NOT X1C THEN
            step := 62;
        END_IF;

    62: // Move empty jig from pos 2 to pos 3
        IF NOT X11 AND (D3 = 0) THEN
            D200 := D2;
            D201 := 3;
            Y13 := TRUE;
            step := 63;
        END_IF;

    63: // Wait for move completion and right fully seated
        IF NOT X11 AND (D3 > 0) AND X1E THEN
            step := 70;
        END_IF;

    // --- LOWER RIGHT LIFT (POS 3) ---
    70: // Lower right lift
        IF NOT X1C AND X1E THEN
            Y17 := TRUE; // right_down
            step := 71;
        END_IF;

    71: // Wait until right lift is lower
        IF X1A AND NOT X1C THEN
            step := 80;
        END_IF;

    // --- MOVE JIG FROM RIGHT LIFT (3) TO LOWER CENTER (4) ---
    80: // Move 3 -> 4
        IF NOT X11 AND (D4 = 0) THEN
            D200 := D3;
            D201 := 4;
            Y13 := TRUE;
            step := 81;
        END_IF;

    81: // Wait move completion to lower center
        IF NOT X11 AND (D4 > 0) THEN
            step := 90;
        END_IF;

    // --- MOVE LOWER CENTER (4) TO LEFT LIFT (0) ---
    // First ensure left lift is at lower position
    90:
        IF NOT X1B THEN
            IF NOT X18 THEN
                Y15 := TRUE; // left_down
                step := 91;
            ELSE
                step := 92;
            END_IF;
        END_IF;

    91: // Wait left lift lower
        IF X18 AND NOT X1B THEN
            step := 92;
        END_IF;

    92: // Move 4 -> 0
        IF NOT X11 AND (D0 = 0) THEN
            D200 := D4;
            D201 := 0;
            Y13 := TRUE;
            step := 93;
        END_IF;

    93: // Wait jig arrival at pos 0 and fully seated
        IF NOT X11 AND (D0 > 0) AND X1F THEN
            step := 100;
        END_IF;

    // --- RAISE LEFT LIFT TO UPPER POSITION ---
    100:
        IF NOT X1B AND X1F THEN
            Y14 := TRUE; // left_up
            step := 101;
        END_IF;

    101: // Wait left lift upper
        IF X17 AND NOT X1B THEN
            // Check if all 6 products have been processed and confirmed
            IF prod_count >= 6 THEN
                step := 110;
            ELSE
                step := 10; // Next cycle
            END_IF;
        END_IF;

    // --- COMPLETION STAGE ---
    // Restore initial condition: 101 at upper left (0), 102 at lower center (4)
    110:
        IF (D0 > 0) AND (D4 = 0) AND (prod_count >= 6) THEN
            // If the jig currently at upper left is 102, move it to lower center so 101 can be at upper left
            // Both jigs physically recovered at upper entrance and lower center
            IF D0 = 102 THEN
                // Cycle 102 down to pos 4:
                // Move 0 -> 1 -> 2 -> 3 -> lower -> 4
                step := 120;
            ELSE
                step := 200; // Ready for completion
            END_IF;
        ELSE
            step := 200;
        END_IF;

    // Empty cycle 102 to lower center if needed
    120: // Move 0 -> 1 (empty jig)
        IF NOT X11 AND (D1 = 0) THEN
            D200 := D0;
            D201 := 1;
            Y13 := TRUE;
            step := 121;
        END_IF;

    121:
        IF NOT X11 AND (D1 > 0) THEN
            step := 122;
        END_IF;

    122: // Move 1 -> 2
        IF NOT X11 AND (D2 = 0) THEN
            D200 := D1;
            D201 := 2;
            Y13 := TRUE;
            step := 123;
        END_IF;

    123:
        IF NOT X11 AND (D2 > 0) THEN
            step := 124;
        END_IF;

    124: // Ensure right lift is upper
        IF NOT X1C THEN
            IF NOT X19 THEN
                Y16 := TRUE;
                step := 125;
            ELSE
                step := 126;
            END_IF;
        END_IF;

    125:
        IF X19 AND NOT X1C THEN
            step := 126;
        END_IF;

    126: // Move 2 -> 3
        IF NOT X11 AND (D3 = 0) THEN
            D200 := D2;
            D201 := 3;
            Y13 := TRUE;
            step := 127;
        END_IF;

    127:
        IF NOT X11 AND (D3 > 0) AND X1E THEN
            step := 128;
        END_IF;

    128: // Lower right lift
        IF NOT X1C AND X1E THEN
            Y17 := TRUE;
            step := 129;
        END_IF;

    129:
        IF X1A AND NOT X1C THEN
            step := 130;
        END_IF;

    130: // Move 3 -> 4
        IF NOT X11 AND (D4 = 0) THEN
            D200 := D3;
            D201 := 4;
            Y13 := TRUE;
            step := 131;
        END_IF;

    131:
        IF NOT X11 AND (D4 > 0) THEN
            // Now 102 is at lower center (4). Check if 101 needs to be raised to pos 0.
            step := 140;
        END_IF;

    140:
        // Ensure left lift is at upper
        IF NOT X1B THEN
            IF NOT X17 THEN
                Y14 := TRUE;
                step := 141;
            ELSE
                step := 200;
            END_IF;
        END_IF;

    141:
        IF X17 AND NOT X1B THEN
            step := 200;
        END_IF;

    200: // Verify all criteria and declare completion
        IF (prod_count >= 6) AND NOT X11 AND NOT X12 AND NOT X13 AND NOT X14 AND NOT X1B AND NOT X1C THEN
            Y19 := TRUE;
            step := 201;
            hold_count := 0;
        END_IF;

    201: // Hold complete output for at least 0.5 s (50 scans @ 10ms)
        Y19 := TRUE;
        hold_count := hold_count + 1;
        IF hold_count >= 60 THEN
            // Keep Y19 TRUE
            step := 202;
        END_IF;

    202:
        Y19 := TRUE;
END_CASE;

prev_x11 := X11;
prev_x12 := X12;
prev_x13 := X13;
prev_x14 := X14;
prev_x16 := X16;
prev_x17 := X17;
prev_x18 := X18;
prev_x19 := X19;
prev_x1a := X1A;

END_PROGRAM