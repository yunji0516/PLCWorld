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
    result_timer : TON;
    hold_timer : TON;
END_VAR

CASE state OF
    0:
        IF X10 THEN
            Y20 := TRUE;
            state := 1;
        END_IF;
        
    1:
        IF X11 THEN
            D20 := D14;
            IF D20 < -200000 THEN
                D20 := -200000;
            END_IF;
            IF D20 > 200000 THEN
                D20 := 200000;
            END_IF;
            Y21 := TRUE;
            state := 2;
            result_timer(IN := TRUE, PT := T#30ms);
        END_IF;
        
    2:
        result_timer(IN := TRUE, PT := T#30ms);
        IF result_timer.Q THEN
            Y2 := TRUE;
            state := 3;
            hold_timer(IN := TRUE, PT := T#100ms);
        END_IF;
        
    3:
        hold_timer(IN := TRUE, PT := T#100ms);
        IF hold_timer.Q THEN
            state := 4;
        END_IF;
        
    4:
        ;
        
END_CASE;

END_PROGRAM