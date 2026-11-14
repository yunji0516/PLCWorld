PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    
    start_edge : R_TRIG;
    timer : TON;
    state : INT := 0;
    req_id : INT := 0;
END_VAR

start_edge(CLK := X10);
timer(IN := (state = 3), PT := T#100ms);

CASE state OF
    0:
        IF start_edge.Q THEN
            req_id := D10;
            state := 1;
        END_IF
        
    1:
        IF D20 = req_id THEN
            state := 3;
        ELSE
            state := 2;
        END_IF
        
    2:
        Y21 := FALSE;
        Y20 := X20;
        
        IF D20 = req_id THEN
            Y20 := FALSE;
            state := 3;
        END_IF
        
    3:
        Y21 := FALSE;
        Y20 := FALSE;
        IF timer.Q THEN
            state := 4;
        END_IF
        
    4:
        Y21 := TRUE;
        Y20 := FALSE;
        IF X21 THEN
            state := 5;
        END_IF
        
    5:
        Y21 := TRUE;
        Y20 := X21;
        
        IF X22 THEN
            Y20 := FALSE;
            state := 6;
        END_IF
        
    6:
        Y20 := FALSE;
        Y21 := TRUE;
        Y2 := TRUE;
        
END_CASE

END_PROGRAM