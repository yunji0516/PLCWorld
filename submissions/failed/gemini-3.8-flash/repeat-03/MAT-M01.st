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

    start_trig : R_TRIG;
    started : BOOL := FALSE;
    state : INT := 0;
    req_length : INT := 0;
    target_buffer : INT := 0;
END_VAR

start_trig(CLK := X10);

IF NOT started THEN
    IF start_trig.Q THEN
        started := TRUE;
        req_length := D10;
        target_buffer := req_length + 180;
        state := 10;
    END_IF;
END_IF;

IF NOT started THEN
    Y2 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y26 := FALSE;
ELSE
    CASE state OF
        10: // Check buffer inventory
            IF D20 < target_buffer THEN
                Y26 := TRUE;
                state := 11;
            ELSE
                Y26 := FALSE;
                state := 20;
            END_IF;

        11: // Unwinding buffer
            IF D20 >= target_buffer THEN
                Y26 := FALSE;
                state := 20;
            ELSE
                Y26 := TRUE;
            END_IF;

        20: // Verify feed grip closed
            IF X22 THEN
                state := 30;
            ELSE
                Y22 := TRUE;
                state := 21;
            END_IF;

        21: // Wait for feed grip to close
            IF X22 THEN
                Y22 := FALSE;
                state := 30;
            ELSE
                Y22 := TRUE;
            END_IF;

        30: // Forward carriage movement (extract web)
            IF D21 >= req_length THEN
                Y20 := FALSE;
                state := 40;
            ELSE
                Y20 := TRUE;
            END_IF;

        40: // Wait for carriage to stop at extraction length
            Y20 := FALSE;
            IF X21 AND (ABS(D21 - req_length) <= 3) THEN
                Y24 := TRUE;
                state := 50;
            END_IF;

        50: // Close receiver clamp
            IF X24 THEN
                Y24 := FALSE;
                Y23 := TRUE;
                state := 60;
            ELSE
                Y24 := TRUE;
            END_IF;

        60: // Open feed grip
            IF X23 THEN
                Y23 := FALSE;
                state := 70;
            ELSE
                Y23 := TRUE;
            END_IF;

        70: // Reverse carriage home
            IF X20 THEN
                Y21 := FALSE;
                state := 80;
            ELSE
                Y21 := TRUE;
            END_IF;

        80: // Wait for carriage stopped at home
            Y21 := FALSE;
            IF X20 AND X21 THEN
                state := 90;
            END_IF;

        90: // Completion state
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y25 := FALSE;
            Y26 := FALSE;
            IF (ABS(D21 - req_length) <= 3) AND X24 AND X23 AND X20 AND X21 THEN
                Y2 := TRUE;
            END_IF;
    END_CASE;

    // Safety Interlocks
    IF Y20 AND NOT X22 THEN
        Y20 := FALSE;
    END_IF;

    IF Y21 AND NOT X23 THEN
        Y21 := FALSE;
    END_IF;

    IF (X24 OR NOT X25) AND Y20 THEN
        Y20 := FALSE;
    END_IF;

    IF (NOT X21 OR Y20 OR Y21) AND Y24 THEN
        Y24 := FALSE;
    END_IF;

    IF Y24 AND NOT (X21 AND (ABS(D21 - req_length) <= 3)) THEN
        Y24 := FALSE;
    END_IF;

    IF (D20 >= 880) AND Y26 THEN
        Y26 := FALSE;
    END_IF;

    IF (D20 <= 85) AND Y20 THEN
        Y20 := FALSE;
    END_IF;

    IF Y20 AND Y21 THEN
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;

    IF Y22 AND Y23 THEN
        Y22 := FALSE;
        Y23 := FALSE;
    END_IF;

    IF Y24 AND Y25 THEN
        Y24 := FALSE;
        Y25 := FALSE;
    END_IF;

    IF Y2 THEN
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y26 := FALSE;
    END_IF;
END_IF;

END_PROGRAM