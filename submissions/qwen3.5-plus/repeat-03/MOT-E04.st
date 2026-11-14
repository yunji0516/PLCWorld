PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    req_edge : R_TRIG;
    stable_timer : TON;
    hold_timer : TON;
    
    request_accepted : BOOL;
END_VAR

req_edge(CLK := X10);

IF req_edge.Q THEN
    request_accepted := TRUE;
END_IF;

IF request_accepted THEN
    Y20 := TRUE;
    D20 := D10;
    
    stable_timer(IN := ABS(D12 - D10) <= 200, PT := T#30ms);
    
    IF stable_timer.Q THEN
        Y2 := TRUE;
    END_IF;
    
    IF Y2 THEN
        hold_timer(IN := TRUE, PT := T#250ms);
    ELSE
        hold_timer(IN := FALSE, PT := T#250ms);
    END_IF;
END_IF;

END_PROGRAM