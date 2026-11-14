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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    // Internal variables
    edge_trigger : R_TRIG;
    edge_cut_done : R_TRIG;
    edge_recovery_done : R_TRIG;
    edge_exit_received : R_TRIG;
    pitch_counter : INT := 0;
    recovery_counter : INT := 0;
    completion_declared : BOOL := FALSE;
    completion_time_elapsed : TIME := T#0ms;

    timer_clamp : TON;
    timer_edge_hold : TON;
    timer_completion : TON;

END_VAR

// Edge detection for rising edges
edge_trigger(CLK := X18);
edge_cut_done(CLK := X14);
edge_recovery_done(CLK := X1D);
edge_exit_received(CLK := X1A);

// Timer handling
timer_clamp(IN := Y12, PT := T#500ms);
timer_edge_hold(IN := Y1C, PT := T#300ms);
timer_completion(IN := completion_declared, PT := T#500ms);

// Reset outputs
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
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

// Logic for task sequence
IF X0 THEN
    // Accept new pitch if available and conditions are met
    IF X10 AND NOT X11 AND NOT X18 AND NOT X1F THEN
        Y10 := TRUE;
        Y11 := TRUE;
    END_IF;

    // Handling cutting process
    IF NOT X13 AND NOT X23 THEN
        Y12 := TRUE; // Clamp
        IF X15 AND NOT X13 THEN
            D200 := D1; // Load cut mask
            Y13 := TRUE; // Cut
        END_IF;
        IF X23 THEN
            Y1D := TRUE; // Cut left
            Y1E := TRUE; // Cut right
            IF edge_cut_done.Q THEN
                Y12 := FALSE; // Unclamp
            END_IF;
        END_IF;
    END_IF;

    // Product transfer logic
    IF X23 AND NOT X19 THEN
        Y14 := TRUE; // Pickup
        IF X16 AND X12 THEN
            Y15 := TRUE; // Release bed
        END_IF;
    ELSE
        Y14 := FALSE; // Reset pickup
        Y15 := FALSE; // Reset release bed
    END_IF;

    // Exit operation logic
    IF X19 AND X1A THEN
        Y16 := TRUE; // Transfer
        IF edge_exit_received.Q THEN
            Y1A := TRUE; // Acknowledge exit
        END_IF;
    END_IF;

    // Recovery operation logic
    IF X1B AND NOT X24 AND NOT X21 THEN
        Y17 := TRUE; // Accept recovery
        Y18 := TRUE; // Start recovery
        IF X1C THEN
            recovery_counter := recovery_counter + 1;
            IF recovery_counter >= 4 THEN
                Y19 := TRUE; // Acknowledge recovery
                Y18 := FALSE; // Stop recovery
            END_IF;
        END_IF;
    END_IF;

    // Completion check
    IF X1F AND recovery_counter = 4 AND pitch_counter = 6 THEN
        IF NOT completion_declared THEN
            completion_declared := TRUE;
            completion_time_elapsed := T#0ms;
        ELSE
            completion_time_elapsed := completion_time_elapsed + T#10ms;
            IF completion_time_elapsed >= T#500ms THEN
                Y1B := TRUE; // Assert complete
            END_IF;
        END_IF;
    END_IF;
END_IF;

END_PROGRAM