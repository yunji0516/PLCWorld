PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT; // a_position
    D11 : DINT; // a_velocity
    D12 : DINT; // b_position
    D13 : DINT; // b_velocity
    D14 : DINT; // c_position
    D15 : DINT; // c_velocity
    D16 : DINT; // d_position
    D17 : DINT; // d_velocity
    D101 : DINT; // request_depth
    D20 : DINT; // a_target
    D21 : DINT; // a_rate
    Y20 : BOOL; // a_enable
    D24 : DINT; // b_target
    D25 : DINT; // b_rate
    Y21 : BOOL; // b_enable
    D28 : DINT; // c_target
    D29 : DINT; // c_rate
    Y22 : BOOL; // c_enable
    D32 : DINT; // d_target
    D33 : DINT; // d_rate
    Y23 : BOOL; // d_enable
    Y2 : BOOL; // completion

    // Internal Variables
    state : INT := 0;
    initializationDone : BOOL := FALSE;
    allAxesAtZero : BOOL := FALSE;

    // Constants
    aLockedPosition : DINT := 10000; // 100 mm scaled by 100
    bC_LockedPosition : DINT := 6000; // 60 mm scaled by 100
    maxBC_Position : DINT := 7000; // 70 mm scaled by 100
    zeroPosition : DINT := 0;
    maxRate : DINT := 1000;
END_VAR

// Main control program
IF NOT X0 THEN
    // Ensure outputs are disabled until start condition
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    state := 0;
    initializationDone := FALSE;
    allAxesAtZero := FALSE;
ELSE
    CASE state OF
        // Initial state: Setup target positions and enable axes
        0:
            IF NOT initializationDone THEN
                // Pre-set the targets without enabling
                D20 := aLockedPosition;
                D24 := bC_LockedPosition;
                D28 := bC_LockedPosition;
                D32 := D101 * 100;
                D21 := maxRate;
                D25 := maxRate;
                D29 := maxRate;
                D33 := maxRate;
                initializationDone := TRUE;
            END_IF;

            // Enable the axes
            Y20 := TRUE;
            Y21 := TRUE;
            Y22 := TRUE;
            Y23 := TRUE;

            // Move to locked positions
            IF ABS(D10 - aLockedPosition) <= 20 THEN
                IF ABS(D12 - bC_LockedPosition) <= 20 THEN
                    IF ABS(D14 - bC_LockedPosition) <= 20 THEN
                        state := 1;
                    END_IF;
                END_IF;
            END_IF;

        // Maintain locked position and perform internal access
        1:
            IF ABS(D16 - D32) <= 20 AND D11 <= 1 AND D13 <= 1 AND D15 <= 1 THEN
                // Stop at D = request_depth
                Y23 := FALSE; // Disable D axis
                state := 2;
            END_IF;

        // Retrieve to zero position
        2:
            D20 := zeroPosition;
            D24 := zeroPosition;
            D28 := zeroPosition;

            // Enable the axes if not already
            IF NOT Y20 OR NOT Y21 OR NOT Y22 THEN
                Y20 := TRUE;
                Y21 := TRUE;
                Y22 := TRUE;
            END_IF;

            // Check if all axes are back at zero
            IF ABS(D10) <= 20 AND ABS(D12) <= 20 AND ABS(D14) <= 20 THEN
                allAxesAtZero := TRUE;
            END_IF;

            IF allAxesAtZero THEN
                state := 3;
            END_IF;

        // Completion state
        3:
            IF allAxesAtZero THEN
                Y20 := FALSE;
                Y21 := FALSE;
                Y22 := FALSE;
                Y2 := TRUE; // Declare completion
            END_IF;
    END_CASE;
END_IF;
END_PROGRAM