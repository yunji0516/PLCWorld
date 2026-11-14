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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;

    step : INT := 0;
    swap_step : INT := 0;
    take_step : INT := 0;

    target_side : INT := 0;
    req_a_cnt : INT := 0;
    req_b_cnt : INT := 0;
    sent_total : INT := 0;

    prev_a_done : BOOL;
    prev_b_done : BOOL;

    pulse_send : BOOL;
    pulse_swap : BOOL;
    pulse_take : BOOL;
    pulse_asm_a : BOOL;
    pulse_asm_b : BOOL;
    pulse_rel_a : BOOL;
    pulse_rel_b : BOOL;

    t_complete : TON;
    complete_latched : BOOL;
    init_done : BOOL;
END_VAR

IF NOT init_done THEN
    Y10 := TRUE;
    Y11 := FALSE;
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
    Y1A := FALSE;
    init_done := TRUE;
END_IF;

pulse_send := FALSE;
pulse_swap := FALSE;
pulse_take := FALSE;
pulse_asm_a := FALSE;
pulse_asm_b := FALSE;
pulse_rel_a := FALSE;
pulse_rel_b := FALSE;

// Swap control
CASE swap_step OF
    0:
        IF sent_total = 4 AND X18 AND X14 AND X13 AND X1A AND NOT X19 THEN
            pulse_swap := TRUE;
            swap_step := 1;
        END_IF;
    1:
        IF NOT X19 AND X10 AND D0 = 202 THEN
            swap_step := 2;
        END_IF;
    2:
        // Swapped and ready
END_CASE;

// Take empty control
CASE take_step OF
    0:
        IF swap_step >= 1 AND X1B THEN
            pulse_take := TRUE;
            take_step := 1;
        END_IF;
    1:
        IF X1C THEN
            take_step := 2;
        END_IF;
END_CASE;

// Extraction and shuttle sequence
CASE step OF
    0:
        IF X0 THEN
            step := 1;
        END_IF;
    1:
        IF sent_total < 7 THEN
            IF sent_total = 4 AND (swap_step < 2 OR NOT X11) THEN
                // Waiting for magazine swap to finish and stack ready
            ELSIF X16 AND X11 AND NOT X17 THEN
                // Determine destination
                IF req_a_cnt < 3 THEN
                    target_side := 1;
                ELSE
                    target_side := 2;
                END_IF;

                // Close upper support first
                Y11 := TRUE;
                step := 2;
            END_IF;
        ELSE
            step := 10;
        END_IF;

    2:
        IF X12 THEN
            // Upper closed, now open lower support to drop item
            Y10 := FALSE;
            step := 3;
        END_IF;

    3:
        IF X17 THEN
            // Shuttle loaded, start extraction
            Y12 := TRUE;
            step := 4;
        END_IF;

    4:
        IF X18 THEN
            // Extractor clear of magazine, restore lower support
            Y10 := TRUE;
            step := 5;
        END_IF;

    5:
        IF X14 THEN
            // Lower closed, release upper support
            Y11 := FALSE;
            step := 6;
        END_IF;

    6:
        IF X13 THEN
            // Upper open, now send item to consumption cell
            D200 := target_side;
            IF target_side = 1 THEN
                req_a_cnt := req_a_cnt + 1;
                D201 := req_a_cnt;
            ELSE
                req_b_cnt := req_b_cnt + 1;
                D201 := req_b_cnt;
            END_IF;
            pulse_send := TRUE;
            sent_total := sent_total + 1;
            Y12 := FALSE;
            step := 7;
        END_IF;

    7:
        // Wait for shuttle to return home
        IF X16 THEN
            step := 1;
        END_IF;

    10:
        // All 7 items extracted and sent
        Y12 := FALSE;
        Y10 := TRUE;
        Y11 := FALSE;
END_CASE;

// Cell A assembly and release
IF X1F AND X20 AND NOT X21 AND NOT X22 THEN
    pulse_asm_a := TRUE;
END_IF;

IF X22 AND NOT prev_a_done THEN
    // rising edge of done
END_IF;
prev_a_done := X22;

IF X22 AND X23 THEN
    pulse_rel_a := TRUE;
END_IF;

// Cell B assembly and release
IF X25 AND X26 AND NOT X27 AND NOT X28 THEN
    pulse_asm_b := TRUE;
END_IF;

IF X28 AND NOT prev_b_done THEN
    // rising edge of done
END_IF;
prev_b_done := X28;

IF X28 AND X29 THEN
    pulse_rel_b := TRUE;
END_IF;

// Outputs assignment
Y13 := pulse_send;
Y14 := pulse_swap;
Y15 := pulse_take;
Y16 := pulse_asm_a;
Y17 := pulse_asm_b;
Y18 := pulse_rel_a;
Y19 := pulse_rel_b;

// Completion logic
IF D3 >= 3 AND D4 >= 4 AND X1D AND X1C AND (D0 = 202) AND (D1 = 1) AND X16 AND X14 AND X13 AND NOT Y12 AND (step >= 10) THEN
    complete_latched := TRUE;
END_IF;

t_complete(IN := complete_latched, PT := T#500ms);

IF complete_latched THEN
    Y1A := TRUE;
END_IF;

END_PROGRAM
