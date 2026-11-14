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
    D14 : INT;
    D15 : INT;
    D16 : INT;
    D200 : INT;
    D201 : INT;
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
    current_generation : INT := 0;
    kit_slot_filled : ARRAY[0..1] OF BOOL := [FALSE, FALSE];
    is_loading : BOOL := FALSE;
    is_unloading : BOOL := FALSE;
    timer_ack : TON;
    timer_complete : TON;
    system_complete : BOOL := FALSE;
    
END_VAR

// Accept current generation
IF X13 AND NOT X15 THEN
    current_generation := D9;
    Y13 := TRUE;
ELSIF X14 AND NOT X16 THEN
    current_generation := D10;
    Y14 := TRUE;
ELSE
    Y13 := FALSE;
    Y14 := FALSE;
END_IF;

// Handle loading logic
IF X10 AND NOT X11 AND NOT is_loading THEN
    CASE current_generation OF
        1: // [R,B] order logic
            IF D2 = 1 AND D1 <> D11 THEN
                D200 := 4; // Position A for R
            ELSIF D2 = 2 AND D1 <> D11 THEN
                D200 := 5; // Position B for B
            END_IF;
            
            IF D1 = D11 THEN
                is_loading := TRUE;
                Y11 := TRUE;
            ELSE
                Y11 := FALSE;
            END_IF;
        2: // [B,R] order logic
            IF D2 = 2 AND D1 <> D12 THEN
                D200 := 5; // Position B for B
            ELSIF D2 = 1 AND D1 <> D12 THEN
                D200 := 4; // Position A for R
            END_IF;
            
            IF D1 = D12 THEN
                is_loading := TRUE;
                Y11 := TRUE;
            ELSE
                Y11 := FALSE;
            END_IF;
    ELSE
        Y11 := FALSE;
    END_CASE;
ELSIF is_loading AND X12 THEN
    Y11 := FALSE;
    is_loading := FALSE;
END_IF;

// Handle unloading logic
IF NOT is_unloading THEN
    IF X15 AND D1 = D11 AND current_generation = D9 THEN
        is_unloading := TRUE;
        Y12 := TRUE;
    ELSIF X16 AND D1 = D12 AND current_generation = D10 THEN
        is_unloading := TRUE;
        Y12 := TRUE;
    END_IF;
ELSIF is_unloading AND NOT X11 THEN
    Y12 := FALSE;
    is_unloading := FALSE;
END_IF;

// Confirm acquisition
IF X17 AND NOT Y19 THEN
    Y19 := TRUE;
    timer_ack(IN := TRUE, PT := T#500ms);
ELSIF timer_ack.Q THEN
    Y19 := FALSE;
    timer_ack(IN := FALSE);
ENDIF;

IF X18 AND NOT Y1A THEN
    Y1A := TRUE;
    timer_ack(IN := TRUE, PT := T#500ms);
ELSIF timer_ack.Q THEN
    Y1A := FALSE;
    timer_ack(IN := FALSE);
ENDIF;

// Packing and dispatching logic
IF X19 AND X22 THEN
    Y17 := TRUE;
ENDIF;

IF X1A AND X23 THEN
    Y18 := TRUE;
ENDIF;

IF X24 AND X25 THEN
    Y17 := FALSE;
    Y18 := FALSE;
    Y20 := TRUE;
ELSE
    Y20 := FALSE;
ENDIF;

// Complete condition
IF X21 AND X15 AND X16 THEN
    system_complete := TRUE;
    timer_complete(IN := TRUE, PT := T#500ms);
ELSE
    system_complete := FALSE;
    timer_complete(IN := FALSE);
ENDIF;

IF system_complete AND timer_complete.Q THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
ENDIF;

END_PROGRAM