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
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;
    start_trigger : R_TRIG;
    state : INT := 0;
    seated_complete : BOOL := FALSE;
END_VAR

start_trigger(CLK := X10);

IF start_trigger.Q AND (D10 = 1) THEN
    state := 1; // Start processing request
END_IF

CASE state OF
    1: // Initial state, ensure everything is reset and ready
        IF NOT X20 THEN Y20 := TRUE; END_IF
        IF NOT X21 THEN Y21 := TRUE; END_IF
        IF X20 AND X21 THEN
            state := 2;
            Y20 := FALSE;
            Y21 := FALSE;
        END_IF

    2: // Open axis to accommodate insertion
        IF NOT X22 THEN Y22 := TRUE; END_IF
        IF (X22 AND (D20 >= 160)) OR
           ((-530 + 900 * REAL(D21) / 1000 > -200 OR -770 + 900 * REAL(D21) / 1000 > -200) AND (D20 >= 150)) THEN
            state := 3;
            Y22 := FALSE;
        END_IF

    3: // Insert content
        IF X23 THEN Y24 := TRUE; END_IF
        IF X24 THEN
            state := 4;
            Y24 := FALSE;
        END_IF

    4: // Wait for content to seat
        IF X25 THEN
            seated_complete := TRUE;
            state := 5;
        END_IF

    5: // Retract insertion slide
        IF NOT X23 THEN Y25 := TRUE; END_IF
        IF X23 THEN
            state := 6;
            Y25 := FALSE;
        END_IF

    6: // Release vacuums and verify system position
        IF X20 THEN Y20 := FALSE; END_IF
        IF X21 THEN Y21 := FALSE; END_IF
        IF (NOT X20 AND NOT X21 AND X22 AND X23) THEN
            Y2 := TRUE;
            state := 7;
        END_IF

    7: // Maintain terminal state
        Y2 := TRUE;  // Keep asserting valid completion
        // All other actuators remain OFF
END_CASE

END_PROGRAM