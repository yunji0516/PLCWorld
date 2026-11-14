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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;

    step : INT := 0;
    rolls_completed : INT := 0;
    web_a_accepted : BOOL := FALSE;
    web_b_accepted : BOOL := FALSE;
    trim_finished : BOOL := FALSE;

    timer_step : TON;
    timer_cut : TON;
    comp_timer : TON;
    pulse_done : BOOL := FALSE;
END_VAR

// Clear single-scan pulse outputs
Y10 := FALSE;
Y11 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y20 := FALSE;
Y21 := FALSE;
Y25 := FALSE;
Y27 := FALSE;
Y28 := FALSE;

IF NOT X0 AND step = 0 THEN
    RETURN;
END_IF;

CASE step OF
    0: // Start web acceptance
        IF X10 AND NOT web_a_accepted THEN
            Y10 := TRUE;
            web_a_accepted := TRUE;
        END_IF;
        IF X11 AND NOT web_b_accepted THEN
            Y11 := TRUE;
            web_b_accepted := TRUE;
        END_IF;
        IF web_a_accepted AND web_b_accepted AND X24 THEN
            step := 10;
        END_IF;

    10: // Jog B to origin_b
        IF D2 < D0 THEN
            Y14 := TRUE;
        ELSE
            Y14 := FALSE;
            Y13 := TRUE; // Hold B
            step := 11;
        END_IF;

    11: // Wait for hold_b contact
        IF X15 THEN
            Y15 := TRUE; // Trim B
            step := 12;
        END_IF;

    12: // Wait for trim received
        IF X17 THEN
            Y16 := TRUE; // Ack trim
            trim_finished := TRUE;
            Y13 := FALSE; // Release hold_b
            step := 13;
        END_IF;

    13: // Wait for hold_b release
        IF X25 OR X24 THEN
            step := 20; // Ready for core preparation
        END_IF;

    // --- CORE PREPARATION & LOADING ---
    20: // Close stop jaw
        Y24 := TRUE;
        IF X2E THEN
            step := 21;
        END_IF;

    21: // Feed core to seat
        Y23 := TRUE;
        IF X2D THEN
            Y23 := FALSE;
            step := 22;
        END_IF;

    22: // Accept roll to transfer core to mandrel position
        IF X1D AND NOT X1A THEN
            Y17 := TRUE;
            step := 23;
        END_IF;

    23: // Extend mandrel into core
        Y1F := TRUE;
        Y1E := FALSE;
        IF X1E THEN
            step := 24;
        END_IF;

    // --- TAPE PREPARATION (parallel or serial before wind) ---
    24: // Prepare tape 80mm
        IF NOT X32 THEN
            Y25 := TRUE;
            step := 25;
        END_IF;

    25: // Wait for tape ready, then hold
        IF X2F THEN
            Y26 := TRUE;
            IF X30 THEN
                step := 26;
            END_IF;
        END_IF;

    26: // Cut tape
        Y27 := TRUE;
        step := 27;

    27: // Wait for tape cut
        IF X31 THEN
            step := 30; // Ready to wind
        END_IF;

    // --- WINDING ---
    30: // Close nips
        Y18 := TRUE;
        Y19 := TRUE;
        IF X1B AND X1C AND X24 THEN
            step := 31;
        END_IF;

    31: // Wind roll to target
        Y1A := TRUE;
        IF D5 >= D4 THEN
            Y1A := FALSE;
            Y12 := TRUE; // Hold A
            Y13 := TRUE; // Hold B
            step := 32;
        END_IF;

    32: // Wait for both holders engaged
        IF X14 AND X15 THEN
            Y1C := TRUE; // Cut A
            Y1D := TRUE; // Cut B
            pulse_done := FALSE;
            step := 33;
        END_IF;

    33: // Wait for cuts done and cutters clear
        IF X27 AND X28 THEN
            step := 34;
        END_IF;

    34: // Wind separated tail
        Y1A := TRUE;
        IF X26 OR D7 <= 0 THEN
            Y1A := FALSE;
            Y18 := FALSE;
            Y19 := FALSE;
            step := 35;
        END_IF;

    35: // Outer diameter cradle support
        Y1B := TRUE;
        IF X1F THEN
            step := 36;
        END_IF;

    // --- TAPE APPLY ---
    36: // Apply tape
        IF X2A AND NOT X32 THEN
            Y28 := TRUE;
            step := 37;
        END_IF;

    37: // Wait for tail taped
        IF X33 THEN
            step := 38;
        END_IF;

    // --- MANDREL RETRACT & EJECT ---
    38: // Retract mandrel
        Y1F := FALSE;
        Y1E := TRUE;
        IF X1D THEN
            Y1E := FALSE;
            step := 39;
        END_IF;

    39: // Eject roll to receiving roller
        IF NOT X21 THEN
            Y20 := TRUE;
            step := 40;
        END_IF;

    40: // Wait for exit clear and receiver ready
        IF X34 AND X35 THEN
            Y29 := TRUE; // Release exit to external section
            step := 41;
        END_IF;

    41: // Wait for exit received
        IF X22 THEN
            Y21 := TRUE; // Ack exit
            Y29 := FALSE;
            Y1B := FALSE; // Release support
            rolls_completed := rolls_completed + 1;
            step := 42;
        END_IF;

    42: // Wait for cradle clear
        IF X20 THEN
            IF rolls_completed >= 3 OR X23 THEN
                step := 90; // All done
            ELSE
                step := 20; // Prepare next roll
            END_IF;
        END_IF;

    90: // Final completion
        Y22 := TRUE;
END_CASE;

// Maintain completion claim
comp_timer(IN := (step = 90), PT := T#100ms);
IF comp_timer.Q THEN
    Y22 := TRUE;
END_IF;

END_PROGRAM