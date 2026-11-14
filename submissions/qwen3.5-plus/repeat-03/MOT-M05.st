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
    
    req_edge : R_TRIG;
    settle_timer : TON;
    phase : INT := 0;
    target_a : DINT;
    target_b : DINT;
    PI : REAL := 3.14159265358979;
    completion_ok : BOOL;
END_VAR

req_edge(CLK := X10);

CASE phase OF
    0: (* IDLE - wait for work request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        D21 := 0;
        
        IF req_edge.Q THEN
            target_a := D10;
            target_b := DINT(-45000.0 * SIN(REAL(D10) / 100.0 * PI / 180.0));
            phase := 1;
        END_IF;
        
    1: (* MOVING - move head and counterweight to targets *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := FALSE;
        Y2 := FALSE;
        D20 := target_a;
        D21 := target_b;
        
        IF ABS(D11 - target_a) <= 20 AND ABS(D12) <= 1 THEN
            phase := 2;
        END_IF;
        
    2: (* BRAKING - engage brake after head is stopped *)
        Y20 := TRUE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := FALSE;
        
        IF X11 THEN
            phase := 3;
        END_IF;
        
    3: (* RELEASING - release head torque, verify completion *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := FALSE;
        
        completion_ok := ABS(D11 - target_a) <= 20 AND 
                         ABS(D13 - target_b) <= 20 AND 
                         ABS(D12) <= 1 AND 
                         ABS(D14) <= 1 AND
                         ABS(88.29 * SIN(REAL(D11) / 100.0 * PI / 180.0) + 0.001962 * REAL(D13)) <= 1.0;
        
        settle_timer(IN := completion_ok, PT := T#30ms);
        
        IF settle_timer.Q THEN
            phase := 4;
        END_IF;
        
    4: (* DONE - maintain completion state *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := TRUE;
        Y2 := TRUE;
        
END_CASE;

D22 := 0;

END_PROGRAM