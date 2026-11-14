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
    
    step : INT := 0;
    timer : TON;
END_VAR

// Maintain timer for Y2 duration
timer(IN := (step = 4), PT := T#150ms);

// Sequence State Machine
CASE step OF
    0:
        IF X0 THEN
            step := 1;
        END_IF;
        
    1: // Move A to 120, B to request_angle, D to request_receive
        IF ABS(D10 - 12000) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - D101) <= 20 AND ABS(D13) <= 100 AND
           ABS(D16 - D103) <= 20 AND ABS(D17) <= 100 THEN
            step := 2;
        END_IF;
        
    2: // Move C to request_target through the fixed aperture
        IF ABS(D14 - D102) <= 20 AND ABS(D15) <= 100 THEN
            step := 3;
        END_IF;
        
    3: // Lower A to 100 to dock
        IF ABS(D10 - 10000) <= 20 AND ABS(D11) <= 100 THEN
            step := 4;
        END_IF;
        
    4: // Docking achieved, assert Y2 for 150ms
        IF timer.Q THEN
            step := 5;
        END_IF;
        
    5: // Raise A back to 120 to leave the support
        IF ABS(D10 - 12000) <= 20 AND ABS(D11) <= 100 THEN
            step := 6;
        END_IF;
        
    6: // Retrieve C to 0
        IF ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            step := 7;
        END_IF;
        
    7: // End with all axes 0
        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 AND
           ABS(D16) <= 20 AND ABS(D17) <= 100 THEN
            step := 8;
        END_IF;
        
    8: // Sequence Done
        ;
END_CASE;

// Map targets and enables based on current step
IF step = 0 THEN
    D20 := 0; D21 := 0; Y20 := FALSE;
    D24 := 0; D25 := 0; Y21 := FALSE;
    D28 := 0; D29 := 0; Y22 := FALSE;
    D32 := 0; D33 := 0; Y23 := FALSE;
    Y2 := FALSE;
ELSE
    // Base Rates
    D21 := 1000; 
    D25 := 1000; 
    D29 := 1000; 
    D33 := 1000;
    
    // Default Enables for A, B, D
    Y20 := TRUE; 
    Y21 := TRUE; 
    Y23 := TRUE;
    
    // A Axis Target
    IF step < 3 THEN
        D20 := 12000;
    ELSIF step = 3 OR step = 4 THEN
        D20 := 10000;
    ELSIF step = 5 OR step = 6 THEN
        D20 := 12000;
    ELSE
        D20 := 0;
    END_IF;
    
    // B Axis Target
    IF step < 7 THEN
        D24 := D101;
    ELSE
        D24 := 0;
    END_IF;
    
    // D Axis Target
    IF step < 7 THEN
        D32 := D103;
    ELSE
        D32 := 0;
    END_IF;
    
    // C Axis Enable and Target
    IF step >= 2 THEN
        Y22 := TRUE;
        IF step < 6 THEN
            D28 := D102;
        ELSE
            D28 := 0;
        END_IF;
    ELSE
        Y22 := FALSE;
        D28 := 0;
    END_IF;
    
    // Output Completion
    Y2 := (step = 4);
END_IF;

END_PROGRAM