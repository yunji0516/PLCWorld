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
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
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
    D13 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    step : INT := 0;
    prev_step : INT := -1;
    step_timer : TON;
    step_time_in : BOOL;
    target_width : INT := 160;
    target_tool : INT := 1;
    prod_counter : INT := 0;
    final_timer : TON;
    final_hold : BOOL := FALSE;
END_VAR

// Manage timer for steps
IF step <> prev_step THEN
    prev_step := step;
    step_time_in := FALSE;
ELSE
    step_time_in := TRUE;
END_IF;
step_timer(IN := step_time_in, PT := T#600s);

// Default pulse outputs
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y1A := FALSE;
Y1B := FALSE;
Y1F := FALSE;

// Main state machine
CASE step OF
    0: // Wait for start
        IF X0 THEN
            step := 1;
        END_IF;

    1: // Check target product type and width
        IF prod_counter >= 4 OR X21 THEN
            step := 90; // All done
        ELSIF X10 THEN
            IF D10 = 2 THEN
                target_width := 120;
                target_tool := 2;
            ELSE
                target_width := 160;
                target_tool := 1;
            END_IF;
            D201 := target_width;
            D202 := target_width;
            step := 2;
        END_IF;

    2: // Ensure cradle is at 0 degrees before receiving product
        IF X1A THEN
            IF NOT X1B THEN
                Y15 := TRUE; // rotate back to 0
                step := 3;
            END_IF;
        ELSE
            step := 4;
        END_IF;

    3: // Wait cradle rotation to 0
        IF NOT X1A AND NOT X1B THEN
            step := 4;
        END_IF;

    4: // Check tool matching
        IF D8 = target_tool THEN
            step := 12; // Tool is already correct, proceed to fixture A adjustment
        ELSIF D8 = 0 THEN
            // No tool attached, dock to target tool
            step := 8;
        ELSE
            // Current tool needs to be returned
            step := 5;
        END_IF;

    5: // Dock current tool to rack
        IF NOT X11 AND NOT X29 THEN
            D200 := D8;
            Y1F := TRUE;
            step := 6;
        END_IF;

    6: // Wait tool at rack
        IF X2A AND NOT X29 THEN
            Y20 := TRUE; // tool_unlock
            step := 7;
        END_IF;

    7: // Wait unlatched and return head
        IF NOT X2B AND NOT X29 THEN
            // Move empty head to target tool
            step := 8;
        END_IF;

    8: // Dock to target tool
        IF NOT X11 AND NOT X29 THEN
            D200 := target_tool;
            Y1F := TRUE;
            step := 9;
        END_IF;

    9: // Wait at rack for target tool
        IF X2A AND NOT X29 THEN
            Y21 := TRUE; // tool_lock
            step := 10;
        END_IF;

    10: // Wait tool latched
        IF X2B AND NOT X29 THEN
            Y22 := TRUE; // tool_return
            step := 11;
        END_IF;

    11: // Wait tool return complete
        IF NOT X11 AND NOT X29 AND (D8 = target_tool) AND NOT X2A THEN
            step := 12;
        END_IF;

    12: // Adjust Jig A width
        D201 := target_width;
        IF X28 THEN
            Y23 := FALSE;
            step := 13;
        ELSE
            Y23 := TRUE;
        END_IF;

    13: // Admit product to A
        IF NOT X11 AND X10 AND X28 THEN
            Y10 := TRUE;
            step := 14;
        END_IF;

    14: // Wait arrival at A and head return
        IF X14 AND NOT X11 AND X13 AND NOT X12 THEN
            step := 15;
        END_IF;

    15: // Request A-side work
        IF X2C AND NOT X16 AND NOT X15 THEN
            Y11 := TRUE;
            step := 16;
        ELSIF X15 THEN
            step := 17;
        END_IF;

    16: // Wait A-side work complete
        IF X15 AND NOT X16 THEN
            step := 17;
        END_IF;

    17: // Transfer completed A product to cradle
        IF NOT X11 AND NOT X17 AND NOT X1B THEN
            Y12 := TRUE;
            step := 18;
        END_IF;

    18: // Wait product at cradle and cradle lock
        IF X17 AND NOT X11 THEN
            Y13 := TRUE; // cradle_lock
            step := 19;
        END_IF;

    19: // Wait cradle locked
        IF X18 THEN
            step_timer(IN := FALSE, PT := T#600s);
            step := 20;
        END_IF;

    20: // Release head from cradle product
        IF step_timer.ET >= T#250ms THEN
            Y14 := TRUE; // head_release
            step := 21;
        END_IF;

    21: // Wait head clear from cradle
        IF X13 AND NOT X12 AND NOT X11 THEN
            Y15 := TRUE; // rotate cradle
            step := 22;
        END_IF;

    22: // Wait cradle flipped
        IF X1A AND NOT X1B THEN
            Y16 := TRUE; // head_grip
            step := 23;
        END_IF;

    23: // Wait head gripped
        IF X12 AND NOT X11 THEN
            Y17 := TRUE; // cradle_unlock
            step := 24;
        END_IF;

    24: // Wait cradle unlock and clear
        IF NOT X18 AND X19 THEN
            step := 25;
        END_IF;

    25: // Adjust Jig B width before transfer
        D202 := target_width;
        IF X24 AND (NOT X1C) THEN
            // B fixture is open and empty, adjust width
            Y24 := TRUE;
        END_IF;
        // Proceed to transfer when ready
        IF NOT X11 THEN
            Y18 := TRUE; // to_b
            step := 26;
        END_IF;

    26: // Wait transfer to B complete
        IF X1C AND NOT X11 AND X27 THEN
            Y24 := FALSE; // stop adjust_b
            step := 27;
        END_IF;

    27: // Ensure B fixture ready and engage clamp
        IF NOT X2D THEN
            Y24 := TRUE;
        ELSE
            Y24 := FALSE;
            Y1D := TRUE; // b_clamp level
            IF X23 THEN
                step := 28;
            END_IF;
        END_IF;

    28: // Open B keeper support
        Y1D := TRUE;
        Y1E := TRUE; // b_keeper_open level
        IF X25 AND X26 AND X22 AND NOT X1E THEN
            Y19 := TRUE; // work_b
            step := 29;
        END_IF;

    29: // Wait B-side work complete
        Y1D := TRUE;
        Y1E := TRUE;
        IF X1D AND NOT X1E THEN
            step := 30;
        END_IF;

    30: // Release corner clamp and keeper before product release
        Y1D := FALSE;
        Y1E := FALSE;
        IF X24 AND (NOT X25) THEN
            IF X1F THEN
                Y1A := TRUE; // release to exit
                step := 31;
            END_IF;
        END_IF;

    31: // Wait exit received
        IF X20 THEN
            Y1B := TRUE; // ack_exit
            prod_counter := prod_counter + 1;
            step := 32;
        END_IF;

    32: // Wait exit clear after ack
        IF NOT X20 THEN
            step := 1; // Process next product
        END_IF;

    90: // All products finished
        final_hold := TRUE;
        step := 91;

    91: // Maintain completion
        // Keep final_hold
        ;
END_CASE;

// Handle completion timing
final_timer(IN := final_hold, PT := T#500ms);
IF final_hold THEN
    Y1C := TRUE;
END_IF;

END_PROGRAM
