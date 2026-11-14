PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    start_dir : INT := 0;
    latched_A : DINT := 0;
    x34_edge : R_TRIG;
END_VAR

// Continuously monitor the reference sensor for a FALSE-to-TRUE edge
x34_edge(CLK := X34);

IF NOT X0 THEN
    state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y2 := FALSE;
ELSE
    CASE state OF
        0:
            state := 1;
            
        1: // Retract B completely to 0 mm to clear upper jaw
            IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
                state := 2;
            END_IF;
            
        2: // Raise C to 100 mm to clear guards and align for search
            IF ABS(D14 - 10000) <= 20 AND ABS(D15) <= 100 THEN
                state := 3;
                // Determine direction based on starting position (20mm or 160mm)
                IF D10 < 6000 THEN
                    start_dir := 1;
                ELSE
                    start_dir := -1;
                END_IF;
            END_IF;
            
        3: // Move A at low speed to find the reference sensor
            IF x34_edge.Q THEN
                latched_A := D10;
                state := 4;
            END_IF;
            
        4: // Disable Enable to brake and stop securely within 10 mm
            IF ABS(D11) <= 100 THEN
                IF ABS(D10 - latched_A) <= 1000 THEN
                    state := 5;
                END_IF;
            END_IF;
            
        5: // Configure the new origin
            IF X35 THEN
                state := 6;
            END_IF;
            
        6: // Re-enable A and move to D90-relative park position
            IF ABS(D10 - (D90 + D101)) <= 20 AND ABS(D11) <= 100 THEN
                IF ABS(D12) <= 20 AND ABS(D14 - 10000) <= 20 THEN
                    state := 7;
                END_IF;
            END_IF;
            
        7: // Maintain final states and signal completion
            ;
    END_CASE;

    // Apply Output States
    IF state >= 1 THEN
        Y21 := TRUE;
        D24 := 0;
        D25 := 1000;
    END_IF;
    
    IF state >= 2 THEN
        Y22 := TRUE;
        D28 := 10000;
        D29 := 1000;
    END_IF;
    
    IF state = 3 THEN
        Y20 := TRUE;
        IF start_dir = 1 THEN
            D20 := 35000;
        ELSE
            D20 := 0;
        END_IF;
        D21 := 200; // Drive at 20% rate (100 mm/s) to ensure strict stopping limits
    ELSIF state = 4 OR state = 5 THEN
        Y20 := FALSE; // Drop enable to trigger braking
    ELSIF state >= 6 THEN
        Y20 := TRUE;
        D20 := D90 + D101;
        D21 := 1000;
    END_IF;
    
    IF state = 5 THEN
        Y30 := TRUE;
    ELSE
        Y30 := FALSE;
    END_IF;
    
    IF state = 7 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
    
END_IF;

END_PROGRAM