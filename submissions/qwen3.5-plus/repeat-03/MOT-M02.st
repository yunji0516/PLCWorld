PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;
    
    state : INT := 0;
    edge_X0 : R_TRIG;
    timer_engage : TON;
    timer_release : TON;
    rate_val : DINT := 500;
END_VAR

edge_X0(CLK := X0);

CASE state OF
    0: (* WAIT_START *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        Y2 := FALSE;
        timer_engage(IN := FALSE);
        timer_release(IN := FALSE);
        
        IF edge_X0.Q THEN
            state := 1;
        END_IF;
        
    1: (* MOVE_TO_DOCK *)
        D20 := D101;
        D21 := rate_val;
        D24 := D101;
        D25 := rate_val;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := FALSE;
        Y31 := FALSE;
        timer_engage(IN := FALSE);
        timer_release(IN := FALSE);
        
        IF ABS(D10 - D101) <= 20 AND ABS(D11) <= 100 AND ABS(D12 - D101) <= 20 AND ABS(D13) <= 100 THEN
            state := 2;
        END_IF;
        
    2: (* ENGAGE_LATCH *)
        Y30 := TRUE;
        Y31 := FALSE;
        timer_engage(IN := TRUE, PT := T#250ms);
        timer_release(IN := FALSE);
        
        IF timer_engage.Q AND X2 THEN
            state := 3;
        END_IF;
        
    3: (* MOVE_CART *)
        Y30 := TRUE;
        Y31 := FALSE;
        D28 := D102;
        D29 := rate_val;
        Y22 := TRUE;
        timer_engage(IN := FALSE);
        timer_release(IN := FALSE);
        
        IF ABS(D14 - D102) <= 20 AND ABS(D15) <= 100 THEN
            state := 4;
        END_IF;
        
    4: (* WAIT_PARK *)
        Y30 := TRUE;
        Y31 := FALSE;
        timer_engage(IN := FALSE);
        timer_release(IN := FALSE);
        
        IF X5 THEN
            state := 5;
        END_IF;
        
    5: (* RELEASE_LATCH *)
        Y31 := TRUE;
        Y30 := FALSE;
        timer_release(IN := TRUE, PT := T#250ms);
        timer_engage(IN := FALSE);
        
        IF timer_release.Q AND X1 THEN
            state := 6;
        END_IF;
        
    6: (* RETURN_BEAM *)
        D20 := 0;
        D24 := 0;
        Y30 := FALSE;
        Y31 := FALSE;
        timer_engage(IN := FALSE);
        timer_release(IN := FALSE);
        
        IF ABS(D10 - 0) <= 20 AND ABS(D11) <= 100 AND ABS(D12 - 0) <= 20 AND ABS(D13) <= 100 THEN
            state := 7;
        END_IF;
        
    7: (* DONE *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y31 := FALSE;
        timer_engage(IN := FALSE);
        timer_release(IN := FALSE);
END_CASE;

END_PROGRAM