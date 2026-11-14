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
    
    state : INT := 0;
    timer_30 : TON;
    timer_100 : TON;
END_VAR

CASE state OF
    0:
        IF X10 THEN
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        IF X11 THEN
            D20 := D14;
            Y21 := TRUE;
            state := 2;
            timer_30(IN := TRUE, PT := T#30ms);
        END_IF;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        timer_30(IN := TRUE, PT := T#30ms);
        IF timer_30.Q THEN
            state := 3;
            Y2 := TRUE;
            timer_100(IN := TRUE, PT := T#100ms);
        END_IF;
        
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
        timer_100(IN := TRUE, PT := T#100ms);
        IF timer_100.Q THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM