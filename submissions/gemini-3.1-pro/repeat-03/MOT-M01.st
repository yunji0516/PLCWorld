PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D20 : DINT;
    Y20 : BOOL;
    D21 : DINT;
    Y21 : BOOL;
    D22 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    target_A_s : DINT := 0;
    target_B_u : DINT := 0;
    hold_A_s : DINT := 0;
    hold_B_u : DINT := 0;
    
    t_settle : TON;
    
    s_ok : BOOL;
    u_ok : BOOL;
    v_ok : BOOL;
END_VAR

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y2 := FALSE;

CASE state OF
    0:
        IF X10 THEN
            target_A_s := D10;
            target_B_u := D13;
            hold_A_s := D11;
            hold_B_u := D14;
            state := 1;
        END_IF;

    1:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := hold_A_s;
        D21 := hold_B_u;
        D22 := 40000;
        
        v_ok := (ABS(D16 - 40000) <= 20) AND (ABS(D17) <= 100);
        t_settle(IN := v_ok, PT := T#30ms);
        IF t_settle.Q THEN
            t_settle(IN := FALSE, PT := T#30ms);
            state := 2;
        END_IF;

    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := target_A_s;
        D21 := target_B_u;
        D22 := 40000;
        
        s_ok := (ABS(D11 - target_A_s) <= 20) AND (ABS(D12) <= 100);
        u_ok := (ABS(D14 - target_B_u) <= 20) AND (ABS(D15) <= 100);
        t_settle(IN := s_ok AND u_ok, PT := T#30ms);
        IF t_settle.Q THEN
            t_settle(IN := FALSE, PT := T#30ms);
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := target_A_s;
        D21 := target_B_u;
        D22 := 0;
        
        v_ok := (ABS(D16) <= 20) AND (ABS(D17) <= 100);
        t_settle(IN := v_ok, PT := T#30ms);
        IF t_settle.Q THEN
            t_settle(IN := FALSE, PT := T#30ms);
            state := 4;
        END_IF;

    4:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := target_A_s;
        D21 := target_B_u;
        D22 := 0;
        
        s_ok := (ABS(D11 - target_A_s) <= 20) AND (ABS(D12) <= 100);
        u_ok := (ABS(D14 - target_B_u) <= 20) AND (ABS(D15) <= 100);
        v_ok := (ABS(D16) <= 20) AND (ABS(D17) <= 100);
        
        IF s_ok AND u_ok AND v_ok THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM