PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    last_reference_sensor : BOOL := FALSE;
    latched_reference : BOOL := FALSE;
    position_within_window : BOOL := FALSE;
    a_target_position : DINT;
    b_target_position : DINT;
    request_counter : DINT := 0;
    configured_now : BOOL := FALSE;
    timer : TON;

END_VAR

// Implement control logic here
latched_reference := NOT last_reference_sensor AND X34;
position_within_window := (D10 >= (D90 * 100)) AND (D10 <= ((D90 + 10) * 100)) AND (ABS(D11) <= 100);

IF X0 THEN
    // Handle register reference position
    IF latched_reference AND position_within_window THEN
        configured_now := TRUE;
        request_counter := request_counter + 1; // Assuming the first shelf as the starting point
        b_target_position := D103; // reach
    END_IF

    // Control for axis A
    a_target_position := D90 + D102 * D101; // Calculate target position based on pitch and index
    D20 := a_target_position * 100; // Scale to output units
    D21 := 1000; // Full speed
    Y20 := TRUE; // Enable axis A

    // Control for axis B
    D24 := b_target_position * 100; // Scale to output units
    IF b_target_position > 0 THEN
        D25 := 1000; // Full speed forward
    ELSE
        D25 := 0; // Retract speed
    END_IF

    Y21 := TRUE; // Enable axis B

    // Issue configure signal
    Y30 := configured_now;
    configured_now := FALSE; // Reset configured_now

    // Completion logic
    IF (ABS(D12) <= 20 AND ABS(D13) <= 100) AND (ABS(D24) <= 2000 AND D25 = 0) THEN
        Y2 := TRUE; // Mark completion
        timer(IN := TRUE, PT := T#100ms);
    ELSE
        Y2 := FALSE;
        timer(IN := FALSE);
    END_IF
ELSE
    // Stop and disable axes when not requested
    Y20 := FALSE;
    Y21 := FALSE;
    Y30 := FALSE;
    Y2 := FALSE;
END_IF

last_reference_sensor := X34; // Update last sensor state for edge detection

END_PROGRAM