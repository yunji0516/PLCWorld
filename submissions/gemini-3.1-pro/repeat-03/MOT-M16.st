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
    target_A : DINT;
    target_B : DINT;
    start_D95 : DINT;
END_VAR

IF NOT X0 THEN
    state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y30 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    D21 := 0;
    D24 := 0;
    D25 := 0;
ELSE
    IF state = 0 THEN
        target_A := D101;
        target_B := D102;
        start_D95 := D95;
        state := 1;
    END_IF;
    
    IF state >= 1 THEN
        Y20 := TRUE;
        D20 := target_A;
        D21 := 1000;
        
        Y21 := TRUE;
        D25 := 1000;
    END_IF;
    
    IF state = 1 THEN
        D24 := target_B;
        IF ABS(D10 - target_A) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - target_B) <= 20 AND ABS(D13) <= 100 AND
           NOT X34 THEN
            state := 2;
        END_IF;
        
    ELSIF state = 2 THEN
        D24 := target_B;
        Y30 := TRUE;
        IF X34 OR D95 > start_D95 OR X35 THEN
            state := 3;
        END_IF;
        
    ELSIF state = 3 THEN
        D24 := target_B;
        Y30 := FALSE;
        IF (D95 > start_D95 OR X35) AND NOT X34 THEN
            state := 4;
        END_IF;
        
    ELSIF state = 4 THEN
        D24 := 0;
        Y30 := FALSE;
        IF ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
            state := 5;
        END_IF;
        
    ELSIF state = 5 THEN
        D24 := 0;
        Y30 := FALSE;
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM