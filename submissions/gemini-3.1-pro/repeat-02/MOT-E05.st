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
    timer : TON;
END_VAR

IF NOT X10 THEN
    state := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    D20 := 0;
    timer(IN := FALSE, PT := T#200ms);
ELSE
    IF state = 2 THEN
        timer(IN := TRUE, PT := T#200ms);
    ELSE
        timer(IN := FALSE, PT := T#200ms);
    END_IF;
    
    CASE state OF
        0:
            state := 1;
            Y20 := TRUE;
            
        1:
            Y20 := TRUE;
            IF X11 THEN
                D20 := D14;
                Y21 := TRUE;
                state := 2;
                timer(IN := TRUE, PT := T#200ms);
            END_IF;
            
        2:
            Y20 := TRUE;
            Y21 := TRUE;
            IF timer.ET >= T#30ms THEN
                Y2 := TRUE;
            END_IF;
    END_CASE;
END_IF;

END_PROGRAM