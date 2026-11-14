PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    X20 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    start_request : BOOL := FALSE;
    start_edge : INT := 0;
    requested_length : INT := 0;
    edge_drift : REAL := 0.0;
    feed_enabled : BOOL := FALSE;
    secured : BOOL := FALSE;
    r_trig_x10 : R_TRIG;
END_VAR

r_trig_x10(CLK := X10);

// Detect start request
IF r_trig_x10.Q THEN
    start_request := TRUE;
    requested_length := D10;
    start_edge := D20;
    edge_drift := 0.0;
END_IF

// Allow feeding only after start request
IF start_request THEN
    IF NOT X20 THEN
        Y23 := FALSE; // Ensure clamp is open before feeding
    ELSE
        IF (D21 < requested_length - 3 OR D21 > requested_length + 3) THEN
            // Check edge position to ensure it stays within ±12 mm
            edge_drift := REAL(D21) * (0.06 + 0.01 * (D21 MOD 2)); // Example drift calculation
            IF D20 + edge_drift < -12 THEN
                Y20 := TRUE;  // Command left steering
                Y21 := FALSE; // Ensure not commanding right steering
            ELSIF D20 + edge_drift > 12 THEN
                Y20 := FALSE; // Ensure not commanding left steering
                Y21 := TRUE;  // Command right steering
            ELSE
                Y20 := FALSE;
                Y21 := FALSE;
            END_IF

            // Enable feeding if clamp is open and within edge corridor
            IF D20 + edge_drift >= -12 AND D20 + edge_drift <= 12 THEN
                Y22 := TRUE;
            ELSE
                Y22 := FALSE;
            END_IF
        ELSE
            // Requested length is within ±3 mm of the actual length
            Y22 := FALSE;
            feed_enabled := FALSE;
            Y23 := TRUE; // Command clamp to close
        END_IF
    END_IF

    // Check if the material is secured with the clamp closed
    IF Y23 AND X20 THEN
        secured := TRUE;
    END_IF

    // Completion condition
    IF secured THEN
        Y2 := TRUE;  // Set completion claim
        Y20 := FALSE; // Ensure no steering command active
        Y21 := FALSE;
        Y22 := FALSE; // Ensure feed command is off
    END_IF
END_IF

END_PROGRAM