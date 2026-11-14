PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y24 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y25 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    c_response : REAL := 1.0;
    d_response : REAL := 1.0;

    c_position_ok : BOOL := FALSE;
    d_position_ok : BOOL := FALSE;
    positions_checked : BOOL := FALSE;
    start_time : TIME := T#0s;
END_VAR

// Control logic for axis movements and position checks
IF X0 THEN
    CASE state OF
        0: // Initialize & wait for start
            IF NOT X1 AND NOT X3 THEN // Ensure all axes start at origin
                state := 10; // Move to first reach position
                start_time := TIME(); // Record the start time
            END_IF

        10: // Move A and B to reach position
            Y20 := NOT X2; // Extend A
            Y21 := NOT Y20;
            Y22 := NOT X4; // Extend B
            Y23 := NOT Y22;

            IF X2 AND X4 THEN // Both extend positions reached
                Y20 := FALSE;
                Y21 := FALSE;
                Y22 := FALSE;
                Y23 := FALSE;
                state := 20; // Next state: Test jig approach
            END_IF

        20: // Test jig approach
            D24 := 100; // D target position
            D25 := INT(d_response * 1000); // Max rate for D
            Y25 := TRUE; // Enable D

            D20 := 50; // C target position
            D21 := INT(c_response * 1000); // Max rate for C
            Y24 := TRUE; // Enable C

            IF ABS(D12 - D24) <= 20 AND ABS(D10 - D20) <= 20 THEN
                d_position_ok := TRUE;
                c_position_ok := TRUE;
            END_IF

            IF c_position_ok AND d_position_ok THEN
                Y24 := FALSE; // Disable C after reaching the target
                Y25 := FALSE; // Disable D after reaching the target

                state := 30; // Next state: Return to origin
            END_IF

        30: // Return all axes to origin
            Y21 := NOT X1; // Retract A
            Y20 := NOT Y21;
            Y23 := NOT X3; // Retract B
            Y22 := NOT Y23;

            D20 := 0; // C to origin
            D21 := INT(c_response * 1000);
            Y24 := TRUE;

            D24 := 0; // D to origin
            D25 := INT(d_response * 1000);
            Y25 := TRUE;

            IF X1 AND X3 AND D10 = 0 AND D12 = 0 THEN
                Y24 := FALSE; // Disable C
                Y25 := FALSE; // Disable D

                IF NOT positions_checked THEN
                    positions_checked := TRUE;
                    start_time := TIME(); // Record completion time
                END_IF

                state := 40; // Move to completion state
            END_IF

        40: // Completion and result output
            IF TIME() - start_time >= T#100ms THEN
                Y2 := TRUE; // Output result success
            END_IF

        ELSE
            // Idle state
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y25 := FALSE;
            Y2 := FALSE;
    END_CASE
ELSE
    // Reset logic
    state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y2 := FALSE;
    c_position_ok := FALSE;
    d_position_ok := FALSE;
    positions_checked := FALSE;
END_IF

END_PROGRAM