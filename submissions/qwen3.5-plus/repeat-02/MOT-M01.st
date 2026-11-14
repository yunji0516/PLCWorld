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
    
    state : INT;
    req_edge : R_TRIG;
    t_raise : TON;
    t_move : TON;
    t_lower : TON;
    t_complete : TON;
    target_a : DINT;
    target_b : DINT;
    pos_tol : DINT := 20;
    speed_tol : DINT := 100;
END_VAR

req_edge(CLK := X10);

CASE state OF
    0:
        IF req_edge.Q THEN
            state := 1;
            target_a := D10;
            target_b := D13;
            Y2 := FALSE;
        END_IF;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        
    1:
        D20 := 0;
        D21 := 0;
        D22 := 40000;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := TRUE;
        t_raise(IN := (ABS(D16 - 40000) <= pos_tol) AND (ABS(D17) <= speed_tol), PT := T#30ms);
        IF t_raise.Q THEN
            state := 2;
        END_IF;
        
    2:
        D20 := target_a;
        D21 := target_b;
        D22 := 40000;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        t_move(IN := (ABS(D11 - target_a) <= pos_tol) AND (ABS(D12) <= speed_tol) AND
               (ABS(D14 - target_b) <= pos_tol) AND (ABS(D15) <= speed_tol) AND
               (ABS(D16 - 40000) <= pos_tol) AND (ABS(D17) <= speed_tol), PT := T#30ms);
        IF t_move.Q THEN
            state := 3;
        END_IF;
        
    3:
        D20 := target_a;
        D21 := target_b;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        t_lower(IN := (ABS(D11 - target_a) <= pos_tol) AND (ABS(D12) <= speed_tol) AND
                (ABS(D14 - target_b) <= pos_tol) AND (ABS(D15) <= speed_tol) AND
                (ABS(D16) <= pos_tol) AND (ABS(D17) <= speed_tol), PT := T#30ms);
        IF t_lower.Q THEN
            state := 4;
        END_IF;
        
    4:
        D20 := target_a;
        D21 := target_b;
        D22 := 0;
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        t_complete(IN := (ABS(D11 - target_a) <= pos_tol) AND (ABS(D12) <= speed_tol) AND
                   (ABS(D14 - target_b) <= pos_tol) AND (ABS(D15) <= speed_tol) AND
                   (ABS(D16) <= pos_tol) AND (ABS(D17) <= speed_tol), PT := T#30ms);
        IF t_complete.Q THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM