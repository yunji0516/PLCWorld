```pascal
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
    D18 : DINT;
    D19 : DINT;
    D101 : DINT;
    D102 : DINT;
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
    D36 : DINT;
    D37 : DINT;
    Y24 : BOOL;
    Y2 : BOOL;
    
    step : INT := 0;
    ton_timer : TON;
    e_timer : TON;
    e_completed : BOOL := FALSE;
END_VAR

// Control Logic
ton_timer(IN := FALSE, PT := T#0ms);
e_timer(IN := FALSE, PT := T#0ms);
    
CASE step OF
    0: 
        // Wait for start signal
        IF X0 THEN
            step := 1;
        END_IF;

    1: 
        // Open A/B plates
        D20 := 0; // a_target to 0
        D21 := 1000; // a_rate 100%
        Y20 := TRUE; // Enable A

        D24 := 0; // b_target to 0
        D25 := 1000; // b_rate 100%
        Y21 := TRUE; // Enable B

        IF ABS(D10) <= 20 AND ABS(D12) <= 20 THEN
            Y20 := FALSE; // Disable A
            Y21 := FALSE; // Disable B
            step := 2;                
        END_IF;

    2: 
        // Move C to target
        D28 := D101; // c_target to request_target
        D29 := 1000; // c_rate 100%
        Y22 := TRUE; // Enable C

        // Move D to 70
        D32 := 7000; // d_target to 70
        D33 := 1000; // d_rate 100%
        Y23 := TRUE; // Enable D

        IF ABS(D14 - D101) <= 20 AND ABS(D16 - 7000) <= 20 THEN
            Y22 := FALSE; // Disable C
            Y23 := FALSE; // Disable D
            step := 3;
        END_IF;
        
    3: 
        // Lower E, then retract
        IF NOT e_completed THEN
            D36 := D102; // e_target to stroke
            D37 := 1000; // e_rate 100%
            Y24 := TRUE; // Enable E
            
            IF D18 / 100 >= 167.5 THEN
                e_completed := TRUE;
            END_IF;
        ELSE
            D36 := 0; // e_target to 0
            IF D18 / 100 <= 0 THEN
                Y24 := FALSE; // Disable E
                e_completed := FALSE;
                step := 4;
            END_IF;
        END_IF;

    4: 
        // Return C and D to 0
        D28 := 0; // c_target to 0
        D29 := 1000; // c_rate 100%
        Y22 := TRUE; // Enable C

        D32 := 0; // d_target to 0
        D33 := 1000; // d_rate 100%
        Y23 := TRUE; // Enable D

        IF ABS(D14) <= 20 AND ABS(D16) <= 20 THEN
            Y22 := FALSE; // Disable C
            Y23 := FALSE; // Disable D
            step := 5;
        END_IF;

    5: 
        // Signal completion
        Y2 := TRUE;
        ton_timer(IN := TRUE, PT := T#100ms);
      
        // Check for 100ms completion time
        IF ton_timer.Q THEN
            Y2 := FALSE;
            step := 0; // Reset to initial state
        END_IF;
        
END_CASE

END_PROGRAM
```