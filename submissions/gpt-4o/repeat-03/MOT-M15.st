```iec
PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    // Internal variables
    side : DINT;
    target : DINT;
    stroke : DINT;
    target_a : DINT;
    target_b : DINT;
    c_position_at_target : BOOL;
    d_position_at_stroke : BOOL;
    c_retracted : BOOL;
    x0_edge : R_TRIG;
    timer : TON;
END_VAR

// Edge detector for X0
x0_edge(CLK := X0);

// Ensure Enable is only active after start signal
IF x0_edge.Q THEN
    side := D101 / 100;
    target := D102 / 100;
    stroke := D103 / 100;
    
    // Determine target A & B based on side
    CASE side OF
        1: 
            target_a := 6000; // 60 (scaled by 100)
            target_b := 0;
        2: 
            target_a := 0;
            target_b := 6000; // 60 (scaled by 100)
    ELSE
        target_a := 0;
        target_b := 0;
    END_CASE;
    
    // Enable axes for movement
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := TRUE;
    
    // Set targets for A, B, and C
    D20 := target_a;
    D21 := 1000; // Full speed
    D24 := target_b;
    D25 := 1000; // Full speed
    D28 := target * 100; // Target for C
    D29 := 1000; // Full speed for C
    D32 := stroke * 100; // Target for D at stroke position
    D33 := 1000; // Full speed for D
    
    // Conditions to detect if C is at target
    c_position_at_target := (ABS(D14 - (target * 100)) <= 20) AND (ABS(D15) <= 100);
    
    // If C at target, check D position
    IF c_position_at_target THEN
        d_position_at_stroke := (ABS(D16 - (stroke * 100)) <= 20) AND (ABS(D17) <= 100);
        
        // If D is at stroke position, retract after checking C position again
        IF d_position_at_stroke THEN
            D32 := 0; // Retract D 
            c_retracted := FALSE;

            IF c_retracted THEN
                D28 := 0; // Retract C
                D29 := 1000; // Full speed for retracting C 

                // Check if fully retracted
                IF (ABS(D14) <= 500) AND (ABS(D15) <= 100) THEN
                    c_retracted := TRUE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
    
    // Completion condition
    IF c_retracted AND (ABS(D14 - (target * 100)) <= 20) AND (ABS(D15) <= 100) THEN
        Y2 := TRUE;
        timer(IN := TRUE, PT := T#100ms);
    END_IF;
ELSE
    // Disable all axes when start is not active
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    timer(IN := FALSE);
END_IF;

// Maintain completion output for 100 ms
IF timer.Q THEN
    Y2 := FALSE;
END_IF;

END_PROGRAM
```