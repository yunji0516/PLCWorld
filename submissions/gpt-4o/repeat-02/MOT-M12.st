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
    a_reached : BOOL := FALSE;
    b_reached : BOOL := FALSE;
    c_reached : BOOL := FALSE;
    d_reached : BOOL := FALSE;
    startTime : TIME;
    curTime : TIME;
    elapsedTime : TIME;
END_VAR

IF X0 THEN
    CASE state OF
        0:  // Initialize and start sequence
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y25 := FALSE;
            D20 := 0;
            D21 := 0;
            D24 := 0;
            D25 := 0;
            a_reached := FALSE;
            b_reached := FALSE;
            c_reached := FALSE;
            d_reached := FALSE;
            startTime := TIME();
            state := 1;

        1:  // Extend cylinder A
            IF NOT a_reached THEN
                Y20 := TRUE;
                Y21 := FALSE;
                IF X2 THEN
                    Y20 := FALSE;
                    a_reached := TRUE;
                END_IF
            END_IF

            IF a_reached THEN
                state := 2;
            END_IF

        2:  // Extend cylinder B
            IF NOT b_reached THEN
                Y22 := TRUE;
                Y23 := FALSE;
                IF X4 THEN
                    Y22 := FALSE;
                    b_reached := TRUE;
                END_IF
            END_IF

            IF b_reached THEN
                state := 3;
            END_IF

        3:  // Move C and D to check jig
            Y24 := TRUE;
            Y25 := TRUE;
            D20 := 5000; // target for C = 50 mm
            D21 := 1000; // rate for C
            D24 := 10000; // target for D = 100 mm
            D25 := 1000; // rate for D

            IF ABS(REAL(D10) / 100 - 50.0) <= 0.2 AND ABS(REAL(D11) / 100) <= 1 THEN
                c_reached := TRUE;
            END_IF

            IF ABS(REAL(D12) / 100 - 100.0) <= 0.2 AND ABS(REAL(D13) / 100) <= 1 THEN
                d_reached := TRUE;
            END_IF

            IF c_reached AND d_reached AND X5 THEN
                Y24 := FALSE;
                Y25 := FALSE;
                state := 4;
            END_IF

        4:  // Retract to origin
            Y21 := TRUE;
            Y23 := TRUE;
            D20 := 0;
            D21 := 1000;
            D24 := 0;
            D25 := 1000;
            Y24 := TRUE;
            Y25 := TRUE;

            IF X1 AND X3 AND 
               ABS(REAL(D10) / 100) <= 0.2 AND ABS(REAL(D11) / 100) <= 1 AND
               ABS(REAL(D12) / 100) <= 0.2 AND ABS(REAL(D13) / 100) <= 1 THEN
                state := 5;
                Y24 := FALSE;
                Y25 := FALSE;
                Y21 := FALSE;
                Y23 := FALSE;
            END_IF

        5:  // All axes at origin, check completion
            curTime := TIME();
            elapsedTime := curTime - startTime;
            IF NOT Y2 AND ABS(REAL(elapsedTime)/1000.0) <= 25.0 THEN
                Y2 := TRUE;
            END_IF
    END_CASE
ELSE
    // Reset on stop command
    state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    D20 := 0;
    D21 := 0;
    D24 := 0;
    D25 := 0;
    a_reached := FALSE;
    b_reached := FALSE;
    c_reached := FALSE;
    d_reached := FALSE;
    Y2 := FALSE;
END_IF
END_PROGRAM