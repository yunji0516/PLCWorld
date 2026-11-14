PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D94 : DINT;
    D95 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    req_target : DINT := 0;
    req_depth : DINT := 0;
END_VAR

CASE state OF
    0: // Wait for start signal X0
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;
        
        IF X0 THEN
            req_target := D101;
            req_depth := D102;
            state := 1;
        END_IF;
        
    1: // Move axis A to target and axis B to depth
        D20 := req_target;
        D24 := req_depth;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := FALSE;
        
        // Check arrival: position tolerance 0.2mm = 20 in x100, speed tolerance 1mm/s = 100 in x100
        IF (ABS(D10 - req_target) <= 20) AND (ABS(D11) <= 100) AND
           (ABS(D12 - req_depth) <= 20) AND (ABS(D13) <= 100) THEN
            state := 2;
        END_IF;
        
    2: // At access pose, wait for module idle then pulse request
        D20 := req_target;
        D24 := req_depth;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := FALSE;
        
        // Request module only when idle (X34 = FALSE)
        IF NOT X34 THEN
            Y30 := TRUE;
            state := 3;
        END_IF;
        
    3: // Pulse Y30 rising edge for one scan
        Y30 := FALSE;
        state := 4;
        
    4: // Hold alignment pose during module round trip, wait for completion
        D20 := req_target;
        D24 := req_depth;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := FALSE;
        
        IF X35 THEN
            state := 5;
        END_IF;
        
    5: // Retract axis B to 0 while maintaining A at target
        D20 := req_target;
        D24 := 0;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := FALSE;
        
        // Check B arrival at zero
        IF (ABS(D12 - 0) <= 20) AND (ABS(D13) <= 100) THEN
            state := 6;
        END_IF;
        
    6: // Final state: A at target, B at 0, assert completion
        D20 := req_target;
        D24 := 0;
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := FALSE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM