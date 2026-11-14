PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    state : INT := 0;
    stable_timer : TON;
    observe_timer : TON;
END_VAR

CASE state OF
    0: (* Wait for request *)
        Y20 := FALSE;
        Y2 := FALSE;
        D20 := 0;
        stable_timer(IN := FALSE);
        observe_timer(IN := FALSE);
        IF X10 THEN
            state := 1;
        END_IF;
        
    1: (* Activate and command *)
        Y20 := TRUE;
        D20 := D10;
        stable_timer(IN := FALSE);
        observe_timer(IN := FALSE);
        
        IF ABS(D11 - D10) <= 20 AND ABS(D12) <= 100 THEN
            state := 2;
        END_IF;
        
    2: (* Waiting for stability duration *)
        Y20 := TRUE;
        D20 := D10;
        observe_timer(IN := FALSE);
        
        stable_timer(IN := TRUE, PT := T#30ms);
        IF stable_timer.Q THEN
            state := 3;
            Y2 := TRUE;
        END_IF;
        
        IF ABS(D11 - D10) > 20 OR ABS(D12) > 100 THEN
            state := 1;
        END_IF;
        
    3: (* Result retention and observation *)
        Y20 := TRUE;
        D20 := D10;
        Y2 := TRUE;
        stable_timer(IN := FALSE);
        
        observe_timer(IN := TRUE, PT := T#100ms);
        
END_CASE;

END_PROGRAM