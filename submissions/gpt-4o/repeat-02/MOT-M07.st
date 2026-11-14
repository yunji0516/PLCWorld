PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    (* Internal variables *)
    state : INT := 0;
    firstComplete : BOOL := FALSE;
    secondComplete : BOOL := FALSE;
    timer : TIME := T#0ms;
END_VAR

// Define function to check if position and velocity are within tolerance
FUNCTION WithinTolerance(expectedPos: DINT, actualPos: DINT, actualVel: DINT) : BOOL
VAR
    posTolerance : BOOL;
    velTolerance : BOOL;
END_VAR
    posTolerance := ABS(expectedPos - actualPos) <= 20; // ±0.2 * 100
    velTolerance := ABS(actualVel) <= 100; // <=1 * 100
    WithinTolerance := posTolerance AND velTolerance;
END_FUNCTION

// Main control logic
IF X0 THEN
    CASE state OF
        0: // Initial state, wait for X0
            IF NOT Y20 THEN
                Y20 := TRUE;
                Y21 := TRUE;
                Y22 := TRUE;
            END_IF;
            state := 1;

        1: // Move to first port: A=first, B=0, C=0
            D20 := D101;
            D24 := 0;
            D28 := 0;
            D21 := 1000;
            D25 := 1000;
            D29 := 1000;
            
            IF WithinTolerance(D101, D10, D11) AND WithinTolerance(0, D12, D13) AND WithinTolerance(0, D14, D15) THEN
                firstComplete := TRUE;
                IF secondComplete THEN
                    state := 3; // Both actions complete
                ELSE
                    state := 2; // Move to second port
                END_IF;
            END_IF;

        2: // Move to second port: A=second, B=depth, C=reach
            D20 := D102;
            D24 := D103;
            D28 := D104;
            D21 := 1000;
            D25 := 1000;
            D29 := 1000;
            
            IF WithinTolerance(D102, D10, D11) AND WithinTolerance(D103, D12, D13) AND WithinTolerance(D104, D14, D15) THEN
                secondComplete := TRUE;
                IF firstComplete THEN
                    state := 3; // Both actions complete
                ELSE
                    state := 1; // Move to first port
                END_IF;
            END_IF;

        3: // Return to initial: A=B=C=0
            D20 := 0;
            D24 := 0;
            D28 := 0;
            D21 := 1000;
            D25 := 1000;
            D29 := 1000;
            
            IF WithinTolerance(0, D10, D11) AND WithinTolerance(0, D12, D13) AND WithinTolerance(0, D14, D15) THEN
                Y2 := TRUE; // Assert completion
                Y20 := FALSE;
                Y21 := FALSE;
                Y22 := FALSE;
                timer := timer + T#10ms;
                IF timer >= T#100ms THEN
                    Y2 := FALSE;
                    state := 4; // Completed operation
                END_IF;
            END_IF;

        4: // Completed, do nothing
            // Wait here indefinitely
            // All outputs already set
    ELSE
        // Handle any safety or reset conditions if X0 is false in any state
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        state := 0;
        timer := T#0ms;
        firstComplete := FALSE;
        secondComplete := FALSE;
ENDIF;

END_PROGRAM