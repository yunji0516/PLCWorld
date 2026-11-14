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

    current_state : INT := 0;
    inspect_requested : BOOL := FALSE;
    timer_complete : TON;
    timer_ack_exit : TON;
END_VAR

// States
// 0 - Idle
// 1 - Loading Product
// 2 - Inspection
// 3 - Product Extraction
// 4 - Return Jig
// 5 - Completion

(* Control Logic *)
CASE current_state OF
    0: // Idle
        IF X0 THEN
            current_state := 1; // Start process, go to loading product
        END_IF

    1: // Loading Product
        IF X10 AND NOT X12 THEN
            Y10 := TRUE; // Admit product
            D200 := 101; // Load onto jig 101
            D201 := 1; // Move to position 1
            Y13 := TRUE; // Move command
            current_state := 2;
        END_IF

    2: // Inspection
        Y10 := FALSE; // Stop admit
        IF X11 AND NOT X12 AND NOT X14 THEN
            // Move jig to inspection
            D200 := 101;
            D201 := 2;
            Y13 := TRUE;
        END_IF

        IF X17 AND NOT X14 THEN
            // Inspect the product
            IF NOT inspect_requested THEN
                Y11 := TRUE;
                D202 := D8; // Set inspect_generation
                inspect_requested := TRUE;
            ELSIF D10 = D202 THEN
                Y11 := FALSE; // Stop inspection
                inspect_requested := FALSE;
                current_state := 3;
            END_IF
        END_IF

    3: // Product Extraction
        IF X15 AND NOT X13 THEN
            Y12 := TRUE; // Detach product
            D200 := 102; // Target jig 102
            D201 := 4;   // Move to position 4
            Y13 := TRUE; // Move command
        END_IF

        IF X11 THEN
            Y12 := FALSE; // Stop detach
            IF X16 THEN
                Y18 := TRUE; // Acknowledge exit
                timer_ack_exit(IN := TRUE, PT := T#500ms);
            END_IF
        END_IF

        IF timer_ack_exit.Q THEN
            Y18 := FALSE; // Stop acknowledge exit
            current_state := 4;
            timer_ack_exit(IN := FALSE);
        END_IF

    4: // Return Jig
        IF X13 THEN
            D200 := 102;
            D201 := 0; // Move jig 102 to initial position
            Y13 := TRUE;
        ELSE
            current_state := 5;
        END_IF

    5: // Completion
        IF D12 = 6 AND X20 THEN
            timer_complete(IN := TRUE, PT := T#500ms);
        ELSE
            timer_complete(IN := FALSE);
        END_IF

        IF timer_complete.Q THEN
            Y19 := TRUE; // Process complete
            current_state := 0; // Reset to idle after completion
        END_IF

END_CASE

END_PROGRAM