PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    state : INT;
    mark_edge : R_TRIG;
    hold_timer : TON;
    observe_timer : TON;
END_VAR

mark_edge(CLK := X12);

CASE state OF
    0: (* IDLE - wait for X10 request acceptance *)
        IF X10 THEN
            state := 1;
        END_IF;
        
    1: (* WAIT FOR MARK - arm Y20 on rising edge of X12 to trigger hardware capture *)
        IF mark_edge.Q THEN
            Y20 := TRUE;
            state := 2;
        END_IF;
        
    2: (* WAIT FOR X11 valid capture indication, then read D14 *)
        IF X11 THEN
            D20 := D14;
            Y21 := TRUE;
            state := 3;
        END_IF;
        
    3: (* MAINTAIN RESULT - start observation timers, Y2 goes TRUE after 30ms, complete after 100ms *)
        observe_timer(IN := TRUE, PT := T#100ms);
        hold_timer(IN := TRUE, PT := T#30ms);
        IF hold_timer.Q THEN
            Y2 := TRUE;
        END_IF;
        IF observe_timer.Q THEN
            state := 4;
        END_IF;
        
    4: (* COMPLETE - maintain Y2, Y21, and D20 *)
        
END_CASE;
END_PROGRAM