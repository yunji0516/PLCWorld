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
    a_check : BOOL := FALSE;
    b_check : BOOL := FALSE;
    c_check : BOOL := FALSE;
    entry_time : TIME := T#0ms;
    current_time : TIME := T#0ms;
    check_complete : BOOL := FALSE;
END_VAR

current_time := current_time + T#10ms;

IF X0 THEN
    CASE state OF
        0:  // Initialize states/reset
            Y20 := FALSE; // a_extend
            Y21 := FALSE; // a_retract
            Y22 := FALSE; // b_extend
            Y23 := FALSE; // b_retract
            Y24 := FALSE; // c_enable
            Y25 := FALSE; // d_enable
            a_check := FALSE;
            b_check := FALSE;
            c_check := FALSE;
            state := 1;
            entry_time := current_time;
            
        1:  // Move A cylinder to 40 mm and B to 180 mm
            IF NOT a_check THEN
                Y20 := TRUE; // Extend A
                Y21 := FALSE;
                IF X2 THEN
                    Y20 := FALSE;
                    a_check := TRUE;
                END_IF
            END_IF
            IF NOT b_check THEN
                Y22 := TRUE; // Extend B
                Y23 := FALSE;
                IF X4 THEN
                    Y22 := FALSE;
                    b_check := TRUE;
                END_IF
            END_IF
            IF a_check AND b_check THEN
                state := 2;
                entry_time := current_time;
            END_IF
            
        2:  // Move C to 50 mm and D to 100 mm
            IF NOT c_check THEN
                D20 := 5000; // C to 50 mm
                D21 := 1000; // Max rate
                Y24 := TRUE; // Enable C
                D24 := 10000; // D to 100 mm
                D25 := 1000; // Max rate
                Y25 := TRUE; // Enable D
                IF ABS(D10 - 5000) <= 20 AND ABS(D11) <= 100 THEN // Check C position
                    IF ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN // Check D position
                        c_check := TRUE;
                        Y24 := FALSE;
                        Y25 := FALSE;
                    END_IF
                END_IF
            END_IF
            IF c_check THEN
                state := 3;
                entry_time := current_time;
            END_IF
            
        3:  // Return A, B, C, and D to origin
            Y21 := TRUE; // Retract A
            Y20 := FALSE;
            IF X1 THEN
                Y21 := FALSE;
            END_IF
            
            Y23 := TRUE; // Retract B
            Y22 := FALSE;
            IF X3 THEN
                Y23 := FALSE;
            END_IF
            
            D20 := 0; // C to 0 mm
            Y24 := TRUE;
            D24 := 0; // D to 0 mm
            Y25 := TRUE;
            IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
                Y24 := FALSE;
                Y25 := FALSE;
                state := 4;
                entry_time := current_time;
            END_IF
            
        4:  // Check completion
            IF current_time - entry_time >= T#100ms THEN
                Y2 := TRUE;
                check_complete := TRUE;
            END_IF
            
    END_CASE
END_IF

END_PROGRAM