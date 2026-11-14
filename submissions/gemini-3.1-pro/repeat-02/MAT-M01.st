PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;

    state : INT := 0;
    target_len : INT := 0;
    x10_prev : BOOL := FALSE;
END_VAR

// Detect rising edge on start request X10
IF X10 AND NOT x10_prev THEN
    IF state = 0 THEN
        target_len := D10;
        state := 10;
    END_IF
END_IF
x10_prev := X10;

CASE state OF
    0:
        // Idle state, ensure all commands and claims are OFF
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
        Y2 := FALSE;

    10:
        // Unwind to ensure buffer is sufficient for the maximum potential extraction (up to 400mm).
        // Maintaining buffer >= 600mm ensures we never drop below the 80mm limit during extraction.
        // It also guarantees we stay well below the 900mm maximum limit.
        IF D20 < 600 THEN
            Y26 := TRUE;
        ELSE
            Y26 := FALSE;
            state := 20;
        END_IF

    20:
        // Verify feed grip is fully closed before forward movement
        IF X22 THEN
            Y22 := FALSE;
            state := 30;
        ELSE
            Y22 := TRUE;
            Y23 := FALSE;
        END_IF

    30:
        // Move carriage forward to extract requested web length
        IF D21 >= target_len THEN
            Y20 := FALSE;
            state := 40;
        ELSE
            Y20 := TRUE;
        END_IF

    40:
        // Wait for carriage to come to a complete rest
        IF X21 THEN
            state := 50;
        END_IF

    50:
        // Assert receiver close. Permitted only at rest and at the correct extracted length.
        Y24 := TRUE;
        Y25 := FALSE;
        IF X24 THEN
            Y24 := FALSE; // Receiver clamp maintains position when neither command is asserted
            state := 60;
        END_IF

    60:
        // Open feed grip to allow carriage return. Web remains held by receiver.
        Y23 := TRUE;
        Y22 := FALSE;
        IF X23 THEN
            Y23 := FALSE;
            state := 70;
        END_IF

    70:
        // Return carriage with feed grip fully open
        Y21 := TRUE;
        Y20 := FALSE;
        IF X20 THEN
            Y21 := FALSE;
            state := 80;
        END_IF

    80:
        // Wait for carriage to come to a complete rest at home position
        IF X21 THEN
            state := 90;
        END_IF

    90:
        // Extraction complete, all conditions met, actuators OFF. Maintain terminal result.
        Y2 := TRUE;

END_CASE

END_PROGRAM