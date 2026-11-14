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
    
    init : BOOL;
    req_mem : BOOL;
    state : INT;
    A_setpoint : DINT;
    target_A : DINT;
    B_setpoint_real : REAL;
    A_setpoint_rad : REAL;
    at_target : BOOL;
    stopped : BOOL;
    A_err : DINT;
    B_err : DINT;
    B_target_final : DINT;
    
    complete_cond : BOOL;
    complete_timer : TON;
END_VAR

IF NOT init THEN
    init := TRUE;
    A_setpoint := D11;
END_IF;

IF X10 AND NOT req_mem THEN
    req_mem := TRUE;
    state := 1;
END_IF;

IF NOT req_mem THEN
    D20 := A_setpoint;
    A_setpoint_rad := REAL(A_setpoint) * 3.1415926535 / 18000.0;
    B_setpoint_real := -45000.0 * SIN(A_setpoint_rad);
    D21 := DINT(B_setpoint_real);
    D22 := 0;
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y2 := FALSE;
ELSE
    IF state = 1 THEN
        target_A := D10;
        
        IF A_setpoint < target_A THEN
            A_setpoint := A_setpoint + 50;
            IF A_setpoint > target_A THEN
                A_setpoint := target_A;
            END_IF;
        ELSIF A_setpoint > target_A THEN
            A_setpoint := A_setpoint - 50;
            IF A_setpoint < target_A THEN
                A_setpoint := target_A;
            END_IF;
        END_IF;
        
        IF A_setpoint = target_A THEN
            state := 2;
        END_IF;
    END_IF;

    A_setpoint_rad := REAL(A_setpoint) * 3.1415926535 / 18000.0;
    B_setpoint_real := -45000.0 * SIN(A_setpoint_rad);
    
    D20 := A_setpoint;
    D21 := DINT(B_setpoint_real);
    D22 := 0;

    B_target_final := DINT(-45000.0 * SIN(REAL(target_A) * 3.1415926535 / 18000.0));
    A_err := ABS(D11 - target_A);
    B_err := ABS(D13 - B_target_final);
    
    at_target := (A_err <= 20) AND (B_err <= 20);
    stopped := (ABS(D12) <= 100) AND (ABS(D14) <= 100);

    IF state = 2 THEN
        IF at_target AND stopped THEN
            state := 3;
        END_IF;
    END_IF;
    
    IF state = 3 THEN
        IF X11 THEN
            state := 4;
        END_IF;
    END_IF;

    Y21 := TRUE;
    
    IF state < 3 THEN
        Y20 := TRUE;
        Y22 := FALSE;
    ELSIF state = 3 THEN
        Y20 := TRUE;
        Y22 := TRUE;
    ELSE
        Y20 := FALSE;
        Y22 := TRUE;
    END_IF;

    complete_cond := (state = 4) AND 
                     at_target AND 
                     stopped AND 
                     X11 AND NOT Y20;
                     
    complete_timer(IN := complete_cond, PT := T#30ms);
    
    IF complete_timer.Q THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM