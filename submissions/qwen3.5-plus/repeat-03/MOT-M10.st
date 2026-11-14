PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y2 : BOOL;
    
    state : INT;
    edge_detect : R_TRIG;
    a_target_val : DINT;
    b_target_val : DINT;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        edge_detect(CLK := X0);
        IF edge_detect.Q THEN
            state := 1;
            a_target_val := 50000;
            b_target_val := 0;
            D20 := a_target_val;
            D21 := 800;
            D24 := b_target_val;
            D25 := 0;
            Y20 := TRUE;
            Y21 := TRUE;
        END_IF;
        
    1:
        IF ABS(D10 - a_target_val) <= 20 AND ABS(D11) <= 100 THEN
            state := 2;
            b_target_val := 9000;
            D24 := b_target_val;
            D25 := 800;
        END_IF;
        
    2:
        IF ABS(D12 - b_target_val) <= 20 AND ABS(D13) <= 100 THEN
            state := 3;
            a_target_val := D101;
            D20 := a_target_val;
            D21 := 800;
            D25 := 0;
        END_IF;
        
    3:
        IF ABS(D10 - a_target_val) <= 20 AND ABS(D11) <= 100 THEN
            state := 4;
            a_target_val := 50000;
            D20 := a_target_val;
            D21 := 800;
        END_IF;
        
    4:
        IF ABS(D10 - a_target_val) <= 20 AND ABS(D11) <= 100 THEN
            state := 5;
            b_target_val := 0;
            D24 := b_target_val;
            D25 := 800;
        END_IF;
        
    5:
        IF ABS(D12 - b_target_val) <= 20 AND ABS(D13) <= 100 THEN
            state := 6;
            a_target_val := 20000;
            D20 := a_target_val;
            D21 := 800;
            D25 := 0;
        END_IF;
        
    6:
        IF ABS(D10 - a_target_val) <= 20 AND ABS(D11) <= 100 THEN
            state := 7;
            Y2 := TRUE;
        END_IF;
        
    7:
        Y2 := TRUE;
END_CASE;

END_PROGRAM