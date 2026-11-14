PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    state : DINT := 0;
    current_A : DINT := 0;
    req_A : DINT := 0;
    final_B : DINT := 0;
    request_active : BOOL := FALSE;
    initialized : BOOL := FALSE;
    rad_A : REAL;
    M_val : REAL;
    comp_cond : BOOL;
    timer : TON;
END_VAR

IF NOT initialized THEN
    current_A := D11;
    initialized := TRUE;
END_IF;

IF X10 THEN
    request_active := TRUE;
END_IF;

CASE state OF
    0:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        D20 := current_A;
        rad_A := REAL(current_A) * 0.0001745329252;
        D21 := DINT(-45000.0 * SIN(rad_A));
        D22 := 0;
        
        IF request_active THEN
            req_A := D10;
            final_B := D17;
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        
        IF current_A < req_A THEN
            current_A := current_A + 40;
            IF current_A > req_A THEN 
                current_A := req_A; 
            END_IF;
        ELSIF current_A > req_A THEN
            current_A := current_A - 40;
            IF current_A < req_A THEN 
                current_A := req_A; 
            END_IF;
        END_IF;
        
        D20 := current_A;
        
        IF current_A = req_A THEN
            D21 := final_B;
            state := 2;
        ELSE
            rad_A := REAL(current_A) * 0.0001745329252;
            D21 := DINT(-45000.0 * SIN(rad_A));
        END_IF;
        D22 := 0;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        D20 := req_A;
        D21 := final_B;
        D22 := 0;
        
        IF ABS(D11 - req_A) <= 20 AND ABS(D12) <= 50 AND ABS(D13 - final_B) <= 20 AND ABS(D14) <= 50 THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := req_A;
        D21 := final_B;
        D22 := 0;
        
        IF X11 THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := req_A;
        D21 := final_B;
        D22 := 0;
END_CASE;

M_val := 88.29 * SIN(REAL(D11) * 0.0001745329252) + 0.1962 * (REAL(D13) / 100.0);

comp_cond := (state = 4) AND 
             (ABS(D11 - req_A) <= 20) AND 
             (ABS(D12) <= 100) AND 
             (ABS(D13 - final_B) <= 20) AND 
             (ABS(D14) <= 100) AND 
             X11 AND 
             (ABS(M_val) <= 1.0);

timer(IN := comp_cond, PT := T#30ms);

IF timer.Q THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM