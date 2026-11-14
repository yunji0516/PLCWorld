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
    products_done : INT := 0;
    active_jig : INT := 0;
    last_exit_rec : BOOL := FALSE;
    cmd_pulse : BOOL := FALSE;
    wait_timer : TON;
    wait_start : BOOL := FALSE;
    comp_timer : TON;
    comp_latched : BOOL := FALSE;
END_VAR

// Reset one-scan command pulses
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;

// Handle external exit acknowledgment
IF X16 AND NOT last_exit_rec THEN
    Y18 := TRUE;
    products_done := products_done + 1;
ELSIF NOT X16 THEN
    Y18 := FALSE;
END_IF;
last_exit_rec := X16;

// Sequential cycle state machine
CASE step OF
    0: // Idle / Start check
        IF X0 THEN
            step := 1;
        END_IF;

    1: // Check if all 6 products completed
        IF products_done >= 6 THEN
            step := 200; // Finish sequence
        ELSE
            // Ready to process next product on jig at pos 0 (left lift)
            // Left lift must be upper, not busy, and source ready
            IF X17 AND NOT X1B AND X10 AND NOT X12 AND (D0 > 0) AND (D5 = 0) THEN
                Y10 := TRUE; // Admit product
                step := 2;
            END_IF;
        END_IF;

    2: // Wait for product loading to complete
        IF NOT X12 AND (D5 > 0) THEN
            step := 3;
        END_IF;

    3: // Transfer jig from pos 0 to pos 1 (upper inspection)
        IF NOT X11 AND (D1 = 0) AND X17 AND NOT X1B THEN
            D200 := D0;
            D201 := 1;
            Y13 := TRUE; // move
            step := 4;
        END_IF;

    4: // Wait for move to pos 1 to start and finish
        IF NOT X11 AND (D1 > 0) AND (D0 = 0) THEN
            step := 5;
        END_IF;

    5: // Start inspection at pos 1
        IF NOT X14 AND (D6 > 0) THEN
            D202 := D8; // Current inspect generation
            Y11 := TRUE; // inspect pulse
            step := 6;
        END_IF;

    6: // Wait for inspection completion
        IF NOT X14 AND (D9 = D6) AND (D10 = D202) THEN
            step := 7;
        END_IF;

    7: // Transfer jig from pos 1 to pos 2 (product extraction)
        IF NOT X11 AND (D2 = 0) THEN
            D200 := D1;
            D201 := 2;
            Y13 := TRUE;
            step := 8;
        END_IF;

    8: // Wait for move to pos 2 to complete
        IF NOT X11 AND (D2 > 0) AND (D1 = 0) THEN
            step := 9;
        END_IF;

    9: // Extract product at pos 2
        IF X15 AND NOT X13 AND (D7 > 0) THEN
            Y12 := TRUE; // detach pulse
            step := 10;
        END_IF;

    10: // Wait for unload to complete (unload_busy FALSE and jig emptied)
        IF NOT X13 AND (D7 = 0) THEN
            step := 11;
        END_IF;

    11: // Ensure right lift is at upper position (pos 3) before moving jig to it
        IF X19 AND NOT X1C THEN
            step := 12;
        ELSIF NOT X19 AND NOT X1C AND (D3 = 0) THEN
            Y16 := TRUE; // right_up
            step := 11;
        END_IF;

    12: // Move empty jig from pos 2 to pos 3 (right lift)
        IF NOT X11 AND (D3 = 0) AND X19 AND NOT X1C THEN
            D200 := D2;
            D201 := 3;
            Y13 := TRUE;
            step := 13;
        END_IF;

    13: // Wait for jig to fully enter right lift
        IF NOT X11 AND X1E AND (D3 > 0) AND (D2 = 0) THEN
            step := 14;
        END_IF;

    14: // Lower right lift to lower level
        IF NOT X1C AND X1E THEN
            Y17 := TRUE; // right_down
            step := 15;
        END_IF;

    15: // Wait until right lift is lower
        IF X1A AND NOT X1C THEN
            step := 16;
        END_IF;

    16: // Move empty jig from pos 3 to pos 4 (lower center)
        IF NOT X11 AND (D4 = 0) AND X1A AND NOT X1C THEN
            D200 := D3;
            D201 := 4;
            Y13 := TRUE;
            step := 17;
        END_IF;

    17: // Wait for move to pos 4 to complete
        IF NOT X11 AND (D4 > 0) AND (D3 = 0) THEN
            step := 18;
        END_IF;

    18: // Ensure left lift is at lower level before moving jig from pos 4 to pos 0
        IF X18 AND NOT X1B THEN
            step := 19;
        ELSIF NOT X18 AND NOT X1B AND (D0 = 0) THEN
            Y15 := TRUE; // left_down
            step := 18;
        END_IF;

    19: // Move empty jig from pos 4 to pos 0 (left lift)
        IF NOT X11 AND (D0 = 0) AND X18 AND NOT X1B THEN
            D200 := D4;
            D201 := 0;
            Y13 := TRUE;
            step := 20;
        END_IF;

    20: // Wait for jig to fully enter left lift
        IF NOT X11 AND X1F AND (D0 > 0) AND (D4 = 0) THEN
            step := 21;
        END_IF;

    21: // Raise left lift to upper level
        IF NOT X1B AND X1F THEN
            Y14 := TRUE; // left_up
            step := 22;
        END_IF;

    22: // Wait until left lift reaches upper level
        IF X17 AND NOT X1B THEN
            // One full jig cycle completed for this workpiece
            step := 1;
        END_IF;

    200: // Finalization: ensure jig 101/102 are at upper entrance (D0) and lower center (D4)
        // Check if lower jig is present, lifts stationary, everything stopped
        IF (D0 > 0) AND (D4 > 0) AND NOT X11 AND NOT X12 AND NOT X13 AND NOT X14 AND NOT X1B AND NOT X1C THEN
            comp_latched := TRUE;
        ELSIF (D0 > 0) AND (D4 = 0) AND (D3 > 0) THEN
            // If jig is still on right lift, lower it and send to lower center
            IF NOT X1A AND NOT X1C THEN
                Y17 := TRUE; // right_down
            ELSIF X1A AND NOT X1C AND NOT X11 THEN
                D200 := D3;
                D201 := 4;
                Y13 := TRUE;
            END_IF;
        END_IF;
END_CASE;

// Maintain completion output for at least 0.5s
IF comp_latched THEN
    Y19 := TRUE;
END_IF;

END_PROGRAM
