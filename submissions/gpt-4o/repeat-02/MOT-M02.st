PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;

    // Internal variables
    state : INT := 0;
    engageLatch : BOOL := FALSE;
    releaseLatch : BOOL := FALSE;
    transferRate : DINT := 800; // Example rate for the transfer
    responseAB : REAL;
    timer : TON;
    completeTime : TIME := T#0ms;

END_VAR

// Timer instance
timer : TON;

(* Main control logic *)
IF X0 THEN
    CASE state OF
        0: // Initial state: Engage latch
            IF NOT X2 AND NOT X3 THEN
                Y30 := TRUE; // Engage latch
                Y31 := FALSE;
                engageLatch := TRUE;
            ELSE
                Y30 := FALSE;
                Y31 := FALSE;
            END_IF
            
            IF X2 THEN
                state := 1; // Move to the next state
            END_IF
        
        1: // Move cart to park position
            IF engageLatch THEN
                D28 := D102 * 100; // Target park position
                D29 := DINT(transferRate); // Command rate
                Y22 := TRUE; // Enable C axis
                IF ABS(D14 - D28) <= 20 AND ABS(D15) <= 10 THEN
                    // Park position reached
                    Y22 := FALSE; // Stop C axis
                    state := 2; // Move to the next state
                END_IF
            END_IF

        2: // Release latch
            IF X2 THEN
                Y31 := TRUE; // Release latch
                Y30 := FALSE;
                releaseLatch := TRUE;
            ELSE
                Y31 := FALSE;
                Y30 := FALSE;
            END_IF
            
            IF NOT X2 THEN
                state := 3; // Move to the next state
            END_IF

        3: // Move beam back to origin
            IF releaseLatch THEN
                D20 := 0; // Target origin for A
                D24 := 0; // Target origin for B
                responseAB := (0.65 + 1.15) / 2; // Example average response
                D21 := DINT(responseAB * 1000); // Adjusted rate for A
                D25 := DINT(responseAB * 1000); // Adjusted rate for B
                Y20 := TRUE; // Enable A axis
                Y21 := TRUE; // Enable B axis
                
                IF ABS(D10) <= 20 AND ABS(D11) <= 10 AND ABS(D12) <= 20 AND ABS(D13) <= 10 THEN
                    // Beam is back to origin
                    Y20 := FALSE; // Stop A axis
                    Y21 := FALSE; // Stop B axis
                    state := 4; // Move to final state
                END_IF
            END_IF
        
        4: // Completion
            IF completeTime = T#0ms THEN
                timer(IN := TRUE, PT := T#100ms); // Start the completion hold timer
            END_IF
            
            IF timer.Q THEN
                Y2 := TRUE; // Indicate completion
            END_IF
    ELSE
        // Operation not started or interrupted
        Y30 := FALSE; 
        Y31 := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
    END_IF;

    // Safety and State Reset Logic
    IF ABS(D10 - D12) > 1200 THEN
        // Safety condition: Deviation of beams exceeds bounds
        Y20 := FALSE; 
        Y21 := FALSE;
        Y22 := FALSE;
    END_IF

    IF D90 <> 0 THEN
        // There is an interlock: Stop all actions
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
    END_IF

END_PROGRAM