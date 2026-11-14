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
    
    request_latched : BOOL;
    step : INT := 0;
    timer_completion : TON;
    trigger_request : R_TRIG;
    target_a : DINT;
    target_b : DINT;
    a_pos : REAL;
    b_pos : REAL;
    m_moment : REAL;
    completion_met : BOOL;
    deg_to_rad : REAL := 0.01745329251994;
END_VAR

trigger_request(CLK := X10);

IF trigger_request.Q AND NOT request_latched THEN
    request_latched := TRUE;
    step := 1;
    target_a := D10;
    target_b := DINT(ROUND(-450.0 * SIN(DINT_TO_REAL(D10) / 100.0 * deg_to_rad) * 100.0));
END_IF;

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        D22 := 0;
        
    1:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        D20 := target_a;
        D21 := target_b;
        D22 := 0;
        
        IF ABS(D11 - target_a) <= 20 AND ABS(D12) <= 100 THEN
            step := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := target_a;
        D21 := target_b;
        D22 := 0;
        
        IF X11 THEN
            step := 3;
        END_IF;
        
    3:
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        D20 := target_a;
        D21 := target_b;
        D22 := 0;
        
        a_pos := DINT_TO_REAL(D11) / 100.0;
        b_pos := DINT_TO_REAL(D13) / 100.0;
        m_moment := 88.29 * SIN(a_pos * deg_to_rad) + 0.1962 * b_pos;
        
        completion_met := 
            ABS(m_moment) <= 1.0 AND
            ABS(D11 - target_a) <= 20 AND
            ABS(D13 - target_b) <= 20 AND
            ABS(D12) <= 100 AND
            ABS(D14) <= 100 AND
            X11;
        
        timer_completion(IN := completion_met, PT := T#30ms);
        IF timer_completion.Q THEN
            Y2 := TRUE;
        END_IF;
END_CASE;

END_PROGRAM