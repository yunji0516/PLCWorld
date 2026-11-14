```iec
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
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
    Y19 : BOOL := FALSE;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D200 : INT := 0;
    D201 : INT := 0;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL := FALSE;

    // Internal Variables
    current_state : INT := 0;
    extract_timer : TIME := T#0s;
    extraction_cycle : BOOL := FALSE;
    swap_timer : TIME := T#0s;
    swap_cycle : BOOL := FALSE;
    complete_held : BOOL := FALSE;
    complete_timer : TIME := T#0s;
    extraction_triggered : BOOL := FALSE;
    request_sequence : INT := 1;
    
    extract_timer_started : BOOL := FALSE;
    swap_conditions_met : BOOL := FALSE;
    swap_trigger : BOOL := FALSE;

END_VAR

// State Definitions
// 0: Idle
// 1: Lower ON, Wait for Shuttle Home
// 2: Extracting
// 3: Awaiting Clear Extraction
// 4: Swap Magazine

// Main state machine
CASE current_state OF
    0: // Idle
        IF X0 AND X16 AND X11 AND X12 THEN
            Y10 := FALSE; // Ensure lower support is OFF
            Y11 := TRUE;  // Ensure upper is ON
            current_state := 1;
        END_IF

    1: // Lower ON, Wait for Shuttle Home
        IF X16 AND X14 THEN
            Y10 := TRUE;  // Lower support ON
            current_state := 2;
        END_IF
    
    2: // Extracting
        IF X17 THEN
            Y12 := TRUE;  // Extract ON
            IF NOT extract_timer_started THEN
                extract_timer := extract_timer + T#10ms;
                IF extract_timer >= T#0.65s THEN
                    Y12 := FALSE; // Extract OFF after distance covered
                    extract_timer_started := TRUE;
                    current_state := 3;
                END_IF
            END_IF
        END_IF

    3: // Awaiting Clear Extraction
        IF X18 THEN
            Y10 := FALSE; // Lower OFF
            Y11 := FALSE; // Upper OFF
            current_state := 4;
        END_IF

    4: // Swap Magazine
        IF NOT swap_conditions_met THEN
            IF X18 AND X14 AND X13 AND X1A AND NOT X19 THEN
                swap_conditions_met := TRUE;
            END_IF
        ELSE
            IF swap_conditions_met AND NOT swap_cycle AND NOT swap_trigger THEN
                Y14 := TRUE;  // Swap ON
                swap_cycle := TRUE;
            END_IF
        END_IF

        IF swap_cycle AND swap_timer < T#500ms THEN
            swap_timer := swap_timer + T#10ms;
        ELSE
            Y14 := FALSE; // Swap OFF
            current_state := 0; // Reset to Idle
            extract_timer_started := FALSE;
            swap_conditions_met := FALSE;
            swap_cycle := FALSE;
            swap_trigger := FALSE;
            swap_timer := T#0s;
        END_IF
END_CASE

// Completion declaration
IF (X1D OR (X1E AND X24 AND NOT Y1A)) AND NOT complete_held THEN
    Y1A := TRUE;
    complete_timer := T#0s;
    complete_held := TRUE;
ELSIF complete_held THEN
    complete_timer := complete_timer + T#10ms;
    
    IF complete_timer >= T#500ms THEN
        Y1A := FALSE;
    END_IF
END_IF

END_PROGRAM
```