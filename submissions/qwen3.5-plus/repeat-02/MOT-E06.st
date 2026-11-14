PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;
    
    request_edge : R_TRIG;
    maint_timer : TON;
    obs_timer : TON;
    state : INT := 0;
    initial_pos : DINT := 0;
END_VAR

request_edge(CLK := X10);

CASE state OF
    0:
        IF request_edge.Q THEN
            initial_pos := D11;
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        maint_timer(IN := (ABS(D11 - initial_pos) <= 20), PT := T#30ms);
        IF X11 AND NOT X12 AND maint_timer.Q THEN
            Y2 := TRUE;
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        Y2 := TRUE;
        obs_timer(IN := TRUE, PT := T#100ms);
        IF obs_timer.Q THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM