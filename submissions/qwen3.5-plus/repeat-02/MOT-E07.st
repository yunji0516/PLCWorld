PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D10 : DINT;
    D17 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    sync_req : BOOL;
    y2_latched : BOOL;
    stab_timer : TON;
    req_edge : R_TRIG;
END_VAR

req_edge(CLK := X10);

IF (req_edge.Q OR (X10 AND NOT Y20)) AND NOT sync_req THEN
    Y20 := TRUE;
    D20 := D10;
    sync_req := TRUE;
END_IF;

IF Y20 THEN
    stab_timer(IN := (ABS(D17) <= 30) AND (ABS(D12 - ((D10 * D14) / 1000)) <= 200), PT := T#30ms);
    
    IF stab_timer.Q THEN
        y2_latched := TRUE;
    END_IF;
    
    Y2 := y2_latched;
ELSE
    Y2 := FALSE;
    y2_latched := FALSE;
    stab_timer(IN := FALSE);
END_IF;

END_PROGRAM