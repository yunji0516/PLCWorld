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
    
    state : INT := 0;
    side_val : DINT;
    target_val : DINT;
    stroke_val : DINT;
    tol_pos : DINT := 20;
    tol_vel : DINT := 100;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        D28 := 0;
        D29 := 0;
        D32 := 0;
        D33 := 0;
        Y2 := FALSE;
        IF X0 THEN
            state := 1;
        END_IF;
        
    1:
        side_val := D101;
        target_val := D102;
        stroke_val := D103;
        
        IF side_val = 100 THEN
            D20 := 6000;
            D24 := 0;
        ELSIF side_val = 200 THEN
            D20 := 0;
            D24 := 6000;
        ELSE
            D20 := 0;
            D24 := 0;
        END_IF;
        
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        state := 2;
        
    2:
        IF (ABS(D10 - D20) <= tol_pos) AND (ABS(D11) <= tol_vel) AND
           (ABS(D12 - D24) <= tol_pos) AND (ABS(D13) <= tol_vel) THEN
            D28 := target_val;
            D29 := 1000;
            Y22 := TRUE;
            state := 3;
        END_IF;
        
    3:
        IF (ABS(D14 - D28) <= tol_pos) AND (ABS(D15) <= tol_vel) THEN
            D32 := stroke_val;
            D33 := 1000;
            Y23 := TRUE;
            state := 4;
        END_IF;
        
    4:
        IF (ABS(D16 - D32) <= tol_pos) AND (ABS(D17) <= tol_vel) THEN
            D32 := 0;
            D33 := 1000;
            state := 5;
        END_IF;
        
    5:
        IF (ABS(D16 - D32) <= tol_pos) AND (ABS(D17) <= tol_vel) THEN
            D28 := 0;
            D29 := 1000;
            state := 6;
        END_IF;
        
    6:
        IF (ABS(D14 - D28) <= tol_pos) AND (ABS(D15) <= tol_vel) THEN
            D20 := 0;
            D24 := 0;
            state := 7;
        END_IF;
        
    7:
        IF (ABS(D10 - D20) <= tol_pos) AND (ABS(D11) <= tol_vel) AND
           (ABS(D12 - D24) <= tol_pos) AND (ABS(D13) <= tol_vel) THEN
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            D21 := 0;
            D25 := 0;
            D29 := 0;
            D33 := 0;
            state := 8;
        END_IF;
        
    8:
        Y2 := TRUE;
END_CASE;

END_PROGRAM