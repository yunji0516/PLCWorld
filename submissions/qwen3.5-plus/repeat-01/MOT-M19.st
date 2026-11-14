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
    
    state : INT;
    c_target_cmd : DINT;
    d_target_cmd : DINT;
    a_target_cmd : DINT;
    b_target_cmd : DINT;
    c_arrived : BOOL;
    d_arrived : BOOL;
    a_arrived : BOOL;
    b_arrived : BOOL;
    comp_timer : TON;
    start_edge : R_TRIG;
    pos_tol : DINT := 20;
    spd_tol : DINT := 100;
    rate_max : DINT := 1000;
END_VAR

c_arrived := (ABS(D14 - c_target_cmd) <= pos_tol) AND (ABS(D15) <= spd_tol);
d_arrived := (ABS(D16 - d_target_cmd) <= pos_tol) AND (ABS(D17) <= spd_tol);
a_arrived := (ABS(D10 - a_target_cmd) <= pos_tol) AND (ABS(D11) <= spd_tol);
b_arrived := (ABS(D12 - b_target_cmd) <= pos_tol) AND (ABS(D13) <= spd_tol);

CASE state OF
    0:
        start_edge(CLK := X0);
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1:
        c_target_cmd := 0;
        d_target_cmd := D103;
        a_target_cmd := D10;
        b_target_cmd := D12;
        
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y23 := TRUE;
        D20 := a_target_cmd;
        D21 := rate_max;
        D24 := b_target_cmd;
        D25 := rate_max;
        D28 := c_target_cmd;
        D29 := rate_max;
        D32 := d_target_cmd;
        D33 := rate_max;
        
        IF c_arrived AND d_arrived THEN
            state := 2;
        END_IF;
        
    2:
        a_target_cmd := D101;
        b_target_cmd := 7000;
        
        D20 := a_target_cmd;
        D21 := rate_max;
        D24 := b_target_cmd;
        D25 := rate_max;
        
        IF (D12 < 6000) OR (D12 > 7500) OR (ABS(D14) > pos_tol) OR (ABS(D16 - D103) > pos_tol) THEN
            state := 1;
        ELSIF a_arrived AND b_arrived THEN
            state := 3;
        END_IF;
        
    3:
        a_target_cmd := D102;
        
        D20 := a_target_cmd;
        D21 := rate_max;
        
        IF (D12 < 6000) OR (D12 > 7500) OR (ABS(D14) > pos_tol) OR (ABS(D16 - D103) > pos_tol) THEN
            state := 1;
        ELSIF a_arrived THEN
            state := 4;
        END_IF;
        
    4:
        Y2 := TRUE;
        comp_timer(IN := TRUE, PT := T#100ms);
        
        IF (D12 < 6000) OR (D12 > 7500) OR (ABS(D14) > pos_tol) OR (ABS(D16 - D103) > pos_tol) THEN
            state := 1;
        ELSIF comp_timer.Q THEN
            state := 5;
        END_IF;
        
    5:
        Y2 := FALSE;
        a_target_cmd := 6000;
        b_target_cmd := 0;
        c_target_cmd := 8000;
        d_target_cmd := 0;
        
        D20 := a_target_cmd;
        D21 := rate_max;
        D24 := b_target_cmd;
        D25 := rate_max;
        D28 := c_target_cmd;
        D29 := rate_max;
        D32 := d_target_cmd;
        D33 := rate_max;
        
        IF c_arrived AND d_arrived AND a_arrived AND b_arrived THEN
            state := 6;
        END_IF;
        
    6:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2 := FALSE;
END_CASE;

END_PROGRAM